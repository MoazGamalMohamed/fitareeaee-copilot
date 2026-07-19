import {getFirestore, Timestamp, Transaction} from "firebase-admin/firestore";
import * as functions from "firebase-functions/v1";
import {redactContactDetails} from "./copilot";
import {driverVerificationComplete} from "./trip";

interface TripProposalInput {
  schemaVersion: 1;
  tripId: string;
  proposedUnitPrice: number;
  message: string | null;
}

function object(value: unknown): Record<string, unknown> {
  if (value === null || typeof value !== "object" || Array.isArray(value)) {
    throw new functions.https.HttpsError("invalid-argument", "Proposal details are required.");
  }
  return value as Record<string, unknown>;
}

function validId(value: unknown): value is string {
  return typeof value === "string" && value.length > 0 &&
    value.length <= 128 && !value.includes("/");
}

function parseProposalAction(value: unknown): string {
  const data = object(value);
  if (data.schemaVersion !== undefined && data.schemaVersion !== 1) {
    throw new functions.https.HttpsError("invalid-argument", "Unsupported proposal version.");
  }
  if (!validId(data.bookingId)) {
    throw new functions.https.HttpsError("invalid-argument", "Proposal is invalid.");
  }
  return data.bookingId;
}

export function parseTripProposal(value: unknown): TripProposalInput {
  const data = object(value);
  if (data.schemaVersion !== undefined && data.schemaVersion !== 1) {
    throw new functions.https.HttpsError("invalid-argument", "Unsupported proposal version.");
  }
  if (!validId(data.tripId)) {
    throw new functions.https.HttpsError("invalid-argument", "Trip is invalid.");
  }
  if (typeof data.proposedUnitPrice !== "number" ||
      !Number.isFinite(data.proposedUnitPrice) || data.proposedUnitPrice < 0 ||
      data.proposedUnitPrice > 100_000) {
    throw new functions.https.HttpsError("invalid-argument", "Proposed price is invalid.");
  }
  const rawMessage = data.message === null || data.message === undefined ?
    null : data.message;
  if (rawMessage !== null && (typeof rawMessage !== "string" ||
      rawMessage.trim().length > 300)) {
    throw new functions.https.HttpsError("invalid-argument", "Proposal note is invalid.");
  }
  const message = typeof rawMessage === "string" && rawMessage.trim() ?
    redactContactDetails(rawMessage.trim()) : null;
  return {
    schemaVersion: 1,
    tripId: data.tripId,
    proposedUnitPrice: data.proposedUnitPrice,
    message,
  };
}

function hasRiderVerification(data: Record<string, unknown>): boolean {
  return data.identityVerified === true && data.selfieWithIdVerified === true;
}

function departureIsFuture(value: unknown): boolean {
  if (value instanceof Timestamp) return value.toMillis() > Date.now();
  if (value instanceof Date) return value.getTime() > Date.now();
  if (typeof value === "string") {
    const parsed = new Date(value);
    return !Number.isNaN(parsed.getTime()) && parsed.getTime() > Date.now();
  }
  return false;
}

function proposalId(tripId: string, driverId: string): string {
  return `${tripId}_${driverId}`;
}

export const proposeForTripRequest = functions.https.onCall(async (rawData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in before responding.");
  }
  const input = parseTripProposal(rawData);
  const db = getFirestore();
  const tripRef = db.collection("trips").doc(input.tripId);
  const driverId = context.auth.uid;
  const bookingRef = db.collection("bookings").doc(proposalId(input.tripId, driverId));

  return db.runTransaction(async (transaction: Transaction) => {
    const tripSnapshot = await transaction.get(tripRef);
    if (!tripSnapshot.exists) {
      throw new functions.https.HttpsError("not-found", "Trip request not found.");
    }
    const trip = tripSnapshot.data() ?? {};
    const passengerId = typeof trip.driverId === "string" ? trip.driverId : "";
    if (trip.role !== "request" || trip.status !== "pending" || !passengerId ||
        !departureIsFuture(trip.departure_time)) {
      throw new functions.https.HttpsError(
        "failed-precondition", "This request is not accepting driver proposals."
      );
    }
    if (passengerId === driverId) {
      throw new functions.https.HttpsError("failed-precondition", "You cannot respond to your own request.");
    }
    if (trip.selectedBookingId) {
      throw new functions.https.HttpsError("failed-precondition", "The rider already selected a driver.");
    }
    const seats = Number(trip.total_seats);
    const budget = Number(trip.price_per_seat);
    if (!Number.isInteger(seats) || seats < 1 || seats > 8 ||
        !Number.isFinite(budget) || input.proposedUnitPrice > budget) {
      throw new functions.https.HttpsError(
        "failed-precondition", "The proposal exceeds the rider's budget or has invalid seats."
      );
    }
    const [driverVerification, riderVerification, existing] = await Promise.all([
      transaction.get(db.collection("verifications").doc(driverId)),
      transaction.get(db.collection("verifications").doc(passengerId)),
      transaction.get(bookingRef),
    ]);
    if (!driverVerification.exists ||
        !driverVerificationComplete(driverVerification.data() ?? {})) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Complete ID, selfie, driver-license, and vehicle verification before responding."
      );
    }
    if (!riderVerification.exists ||
        !hasRiderVerification(riderVerification.data() ?? {})) {
      throw new functions.https.HttpsError(
        "failed-precondition", "The rider must complete identity verification first."
      );
    }
    if (existing.exists) {
      const existingData = existing.data() ?? {};
      if (existingData.status === "potential") {
        return {
          schemaVersion: 1,
          bookingId: bookingRef.id,
          status: "potential",
          paymentStatus: "awaiting_passenger",
          created: false,
        };
      }
      throw new functions.https.HttpsError("already-exists", "A proposal already exists.");
    }
    const now = Timestamp.now();
    transaction.create(bookingRef, {
      id: bookingRef.id,
      schemaVersion: 1,
      tripId: input.tripId,
      passengerId,
      driverId,
      seatsBooked: seats,
      proposedUnitPrice: input.proposedUnitPrice,
      totalPrice: Math.round(input.proposedUnitPrice * seats * 100) / 100,
      negotiationMessage: input.message,
      status: "potential",
      paymentStatus: "awaiting_passenger",
      conversationId: null,
      pickupLocation: trip.origin_address ?? null,
      dropoffLocation: trip.destination_address ?? null,
      pickupTime: trip.departure_time,
      dropoffTime: null,
      createdAt: now,
      updatedAt: now,
    });
    return {
      schemaVersion: 1,
      bookingId: bookingRef.id,
      status: "potential",
      paymentStatus: "awaiting_passenger",
      created: true,
    };
  });
});

export const selectTripProposal = functions.https.onCall(async (rawData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in before selecting a driver.");
  }
  const bookingId = parseProposalAction(rawData);
  const db = getFirestore();
  const bookingRef = db.collection("bookings").doc(bookingId);
  return db.runTransaction(async (transaction: Transaction) => {
    const bookingSnapshot = await transaction.get(bookingRef);
    if (!bookingSnapshot.exists) {
      throw new functions.https.HttpsError("not-found", "Proposal not found.");
    }
    const booking = bookingSnapshot.data() ?? {};
    if (booking.passengerId !== context.auth!.uid) {
      throw new functions.https.HttpsError("permission-denied", "Only the rider can select a driver.");
    }
    if (booking.status === "pending_payment" && booking.paymentStatus === "required") {
      return {schemaVersion: 1, bookingId, status: "pending_payment", paymentStatus: "required"};
    }
    if (booking.status !== "potential" || booking.paymentStatus !== "awaiting_passenger" ||
        !validId(booking.tripId)) {
      throw new functions.https.HttpsError("failed-precondition", "This proposal cannot be selected.");
    }
    const tripRef = db.collection("trips").doc(booking.tripId);
    const tripSnapshot = await transaction.get(tripRef);
    const trip = tripSnapshot.data() ?? {};
    if (!tripSnapshot.exists || trip.role !== "request" || trip.status !== "pending" ||
        trip.driverId !== context.auth!.uid ||
        (trip.selectedBookingId && trip.selectedBookingId !== bookingId)) {
      throw new functions.https.HttpsError("failed-precondition", "This trip request cannot select the proposal.");
    }
    const now = Timestamp.now();
    transaction.update(bookingRef, {
      status: "pending_payment",
      paymentStatus: "required",
      selectedAt: now,
      updatedAt: now,
    });
    transaction.update(tripRef, {selectedBookingId: bookingId, updated_at: now});
    return {schemaVersion: 1, bookingId, status: "pending_payment", paymentStatus: "required"};
  });
});

export const withdrawTripProposal = functions.https.onCall(async (rawData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in before withdrawing.");
  }
  const bookingId = parseProposalAction(rawData);
  const db = getFirestore();
  const ref = db.collection("bookings").doc(bookingId);
  return db.runTransaction(async (transaction: Transaction) => {
    const snapshot = await transaction.get(ref);
    const booking = snapshot.data() ?? {};
    if (!snapshot.exists || booking.driverId !== context.auth!.uid) {
      throw new functions.https.HttpsError(
        "permission-denied", "Only the proposing driver can withdraw."
      );
    }
    if (booking.status !== "potential" ||
        booking.paymentStatus !== "awaiting_passenger") {
      throw new functions.https.HttpsError(
        "failed-precondition", "This proposal can no longer be withdrawn."
      );
    }
    transaction.update(ref, {status: "cancelled", updatedAt: Timestamp.now()});
    return {schemaVersion: 1, bookingId, status: "cancelled"};
  });
});

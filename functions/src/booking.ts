import {
  DocumentSnapshot,
  getFirestore,
  Timestamp,
  Transaction,
} from "firebase-admin/firestore";
import * as functions from "firebase-functions/v1";
import {conversationDocumentId} from "./conversation";

export interface BookingRequest {
  schemaVersion: 1;
  tripId: string;
  seats: number;
}

export function parseBookingRequest(value: unknown): BookingRequest {
  if (value === null || typeof value !== "object") {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "A booking request is required."
    );
  }

  const data = value as Record<string, unknown>;
  const tripId = typeof data.tripId === "string" ? data.tripId.trim() : "";
  const seats = data.seats === undefined ? 1 : data.seats;

  if (data.schemaVersion !== undefined && data.schemaVersion !== 1) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Unsupported booking request version."
    );
  }
  if (!tripId || tripId.length > 128 || tripId.includes("/")) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "A valid tripId is required."
    );
  }
  if (!Number.isInteger(seats) || (seats as number) < 1 || (seats as number) > 8) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Seats must be an integer from 1 to 8."
    );
  }

  return {schemaVersion: 1, tripId, seats: seats as number};
}

export function bookingDocumentId(tripId: string, passengerId: string): string {
  return `${tripId}_${passengerId}`;
}

export function validatedUnitPrice(value: unknown): number {
  if (typeof value !== "number" || !Number.isFinite(value) || value < 0 || value > 100_000) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "This trip has an invalid price."
    );
  }
  return value;
}

function departureDate(value: unknown): Date | null {
  if (value instanceof Timestamp) return value.toDate();
  if (typeof value === "string") {
    const parsed = new Date(value);
    return Number.isNaN(parsed.getTime()) ? null : parsed;
  }
  if (value instanceof Date) return value;
  return null;
}

export function canSelfCancelBeforeDeparture(
  departure: Date | null,
  nowMs: number
): boolean {
  return departure !== null && departure.getTime() > nowMs;
}

function hasRequiredVerification(
  snapshot: DocumentSnapshot
): boolean {
  if (!snapshot.exists) return false;
  const data = snapshot.data();
  return data?.identityVerified === true && data?.selfieWithIdVerified === true;
}

function rethrowCallableError(error: unknown, fallback: string): never {
  if (error instanceof functions.https.HttpsError) throw error;
  functions.logger.error(fallback, {errorType: typeof error});
  throw new functions.https.HttpsError("internal", fallback);
}

export const createBooking = functions.https.onCall(async (rawData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "Sign in before booking a trip."
    );
  }

  const request = parseBookingRequest(rawData);
  const passengerId = context.auth.uid;
  const db = getFirestore();
  const tripRef = db.collection("trips").doc(request.tripId);
  const bookingRef = db
    .collection("bookings")
    .doc(bookingDocumentId(request.tripId, passengerId));

  try {
    return await db.runTransaction(async (transaction: Transaction) => {
      const [tripSnapshot, existingBooking] = await Promise.all([
        transaction.get(tripRef),
        transaction.get(bookingRef),
      ]);
      if (!tripSnapshot.exists) {
        throw new functions.https.HttpsError("not-found", "Trip not found.");
      }

      const trip = tripSnapshot.data()!;
      const driverId = typeof trip.driverId === "string" ? trip.driverId : "";
      if (!driverId) {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "This trip cannot be booked."
        );
      }
      if (driverId === passengerId) {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "You cannot book your own trip."
        );
      }
      if (trip.role !== "offer" || trip.status !== "pending") {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "This trip is not accepting bookings."
        );
      }

      const departure = departureDate(trip.departure_time);
      if (!departure || departure.getTime() <= Date.now()) {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "This trip has already departed."
        );
      }

      const availableSeats = Number(trip.available_seats);
      const conversationId = conversationDocumentId(
        request.tripId,
        passengerId,
        driverId
      );
      const conversationRef = db
        .collection("conversation_authorizations")
        .doc(conversationId);
      if (existingBooking.exists) {
        const existing = existingBooking.data();
        if (existing?.status === "confirmed") {
          transaction.set(conversationRef, {
            id: conversationId,
            participant_ids: [passengerId, driverId].sort(),
            source: "booking",
            tripId: request.tripId,
            active: true,
            createdAt: existing.createdAt ?? Timestamp.now(),
            updatedAt: Timestamp.now(),
          }, {merge: true});
          return {
            schemaVersion: 1,
            bookingId: bookingRef.id,
            status: "confirmed",
            seatsBooked: existing.seatsBooked ?? request.seats,
            totalPrice: existing.totalPrice ?? 0,
            availableSeats,
            conversationId,
            created: false,
          };
        }
        throw new functions.https.HttpsError(
          "already-exists",
          "A booking already exists for this trip."
        );
      }

      if (!Number.isInteger(availableSeats) || availableSeats < request.seats) {
        throw new functions.https.HttpsError(
          "resource-exhausted",
          "Not enough seats are available."
        );
      }

      const riderVerificationRef = db
        .collection("verifications")
        .doc(passengerId);
      const driverVerificationRef = db.collection("verifications").doc(driverId);
      const [riderVerification, driverVerification] = await Promise.all([
        transaction.get(riderVerificationRef),
        transaction.get(driverVerificationRef),
      ]);

      if (
        !hasRequiredVerification(riderVerification) ||
        !hasRequiredVerification(driverVerification)
      ) {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "Both participants must complete ID and selfie verification."
        );
      }

      const now = Timestamp.now();
      const unitPrice = validatedUnitPrice(trip.price_per_seat);
      const totalPrice = unitPrice * request.seats;
      transaction.create(bookingRef, {
        id: bookingRef.id,
        schemaVersion: 1,
        tripId: request.tripId,
        passengerId,
        driverId,
        seatsBooked: request.seats,
        totalPrice,
        status: "confirmed",
        paymentStatus: "disabled",
        conversationId,
        pickupLocation: trip.origin_address ?? null,
        dropoffLocation: trip.destination_address ?? null,
        pickupTime: trip.departure_time,
        dropoffTime: null,
        createdAt: now,
        updatedAt: now,
      });
      transaction.update(tripRef, {
        available_seats: availableSeats - request.seats,
        updated_at: now,
      });
      transaction.set(conversationRef, {
        id: conversationId,
        participant_ids: [passengerId, driverId].sort(),
        source: "booking",
        tripId: request.tripId,
        active: true,
        createdAt: now,
        updatedAt: now,
      }, {merge: true});

      return {
        schemaVersion: 1,
        bookingId: bookingRef.id,
        status: "confirmed",
        seatsBooked: request.seats,
        totalPrice,
        availableSeats: availableSeats - request.seats,
        conversationId,
        created: true,
      };
    });
  } catch (error) {
    return rethrowCallableError(error, "Booking could not be completed.");
  }
});

export const cancelBooking = functions.https.onCall(async (rawData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "Sign in before cancelling a booking."
    );
  }

  const request = parseBookingRequest(rawData);
  const passengerId = context.auth.uid;
  const db = getFirestore();
  const tripRef = db.collection("trips").doc(request.tripId);
  const bookingRef = db
    .collection("bookings")
    .doc(bookingDocumentId(request.tripId, passengerId));

  try {
    return await db.runTransaction(async (transaction: Transaction) => {
      const [bookingSnapshot, tripSnapshot] = await Promise.all([
        transaction.get(bookingRef),
        transaction.get(tripRef),
      ]);
      if (!bookingSnapshot.exists) {
        throw new functions.https.HttpsError("not-found", "Booking not found.");
      }
      const booking = bookingSnapshot.data()!;
      if (booking.passengerId !== passengerId) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "You cannot cancel this booking."
        );
      }
      if (booking.status === "cancelled") {
        return {schemaVersion: 1, bookingId: bookingRef.id, status: "cancelled"};
      }
      if (booking.status !== "confirmed" || !tripSnapshot.exists) {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "This booking cannot be cancelled."
        );
      }

      const trip = tripSnapshot.data()!;
      if (!canSelfCancelBeforeDeparture(
        departureDate(trip.departure_time),
        Date.now()
      )) {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "Self-service cancellation closes at the scheduled departure time."
        );
      }
      const totalSeats = Number(trip.total_seats) || 0;
      const availableSeats = Number(trip.available_seats) || 0;
      const bookedSeats = Number(booking.seatsBooked) || 1;
      const now = Timestamp.now();
      const conversationId = typeof booking.conversationId === "string" ?
        booking.conversationId :
        conversationDocumentId(request.tripId, passengerId, booking.driverId);
      const conversationRef = db
        .collection("conversation_authorizations")
        .doc(conversationId);

      transaction.update(bookingRef, {status: "cancelled", updatedAt: now});
      transaction.update(tripRef, {
        available_seats: Math.min(totalSeats, availableSeats + bookedSeats),
        updated_at: now,
      });
      transaction.set(conversationRef, {
        active: false,
        status: "cancelled",
        updatedAt: now,
      }, {merge: true});
      return {schemaVersion: 1, bookingId: bookingRef.id, status: "cancelled"};
    });
  } catch (error) {
    return rethrowCallableError(error, "Booking could not be cancelled.");
  }
});

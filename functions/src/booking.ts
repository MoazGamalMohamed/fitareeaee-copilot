import {
  DocumentSnapshot,
  getFirestore,
  Timestamp,
  Transaction,
} from "firebase-admin/firestore";
import * as functions from "firebase-functions/v1";

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

function departureDate(value: unknown): Date | null {
  if (value instanceof Timestamp) return value.toDate();
  if (typeof value === "string") {
    const parsed = new Date(value);
    return Number.isNaN(parsed.getTime()) ? null : parsed;
  }
  if (value instanceof Date) return value;
  return null;
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
      const tripSnapshot = await transaction.get(tripRef);
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
      const [existingBooking, riderVerification, driverVerification] =
        await Promise.all([
          transaction.get(bookingRef),
          transaction.get(riderVerificationRef),
          transaction.get(driverVerificationRef),
        ]);

      if (existingBooking.exists) {
        const existing = existingBooking.data();
        if (existing?.status === "confirmed") {
          return {
            schemaVersion: 1,
            bookingId: bookingRef.id,
            status: "confirmed",
            seatsBooked: existing.seatsBooked ?? request.seats,
            totalPrice: existing.totalPrice ?? 0,
            availableSeats,
            created: false,
          };
        }
        throw new functions.https.HttpsError(
          "already-exists",
          "A booking already exists for this trip."
        );
      }

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
      const unitPrice = Number(trip.price_per_seat) || 0;
      const totalPrice = Math.max(0, unitPrice * request.seats);
      const passengerIds = Array.isArray(trip.passenger_ids)
        ? trip.passenger_ids.filter((id: unknown) => typeof id === "string")
        : [];
      if (passengerIds.includes(passengerId)) {
        throw new functions.https.HttpsError(
          "already-exists",
          "You already joined this trip."
        );
      }

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
        pickupLocation: trip.origin_address ?? null,
        dropoffLocation: trip.destination_address ?? null,
        pickupTime: trip.departure_time,
        dropoffTime: null,
        createdAt: now,
        updatedAt: now,
      });
      transaction.update(tripRef, {
        available_seats: availableSeats - request.seats,
        passenger_ids: [...passengerIds, passengerId],
        updated_at: now,
      });

      return {
        schemaVersion: 1,
        bookingId: bookingRef.id,
        status: "confirmed",
        seatsBooked: request.seats,
        totalPrice,
        availableSeats: availableSeats - request.seats,
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
      const totalSeats = Number(trip.total_seats) || 0;
      const availableSeats = Number(trip.available_seats) || 0;
      const bookedSeats = Number(booking.seatsBooked) || 1;
      const passengerIds = Array.isArray(trip.passenger_ids)
        ? trip.passenger_ids.filter(
          (id: unknown) => typeof id === "string" && id !== passengerId
        )
        : [];
      const now = Timestamp.now();

      transaction.update(bookingRef, {status: "cancelled", updatedAt: now});
      transaction.update(tripRef, {
        available_seats: Math.min(totalSeats, availableSeats + bookedSeats),
        passenger_ids: passengerIds,
        updated_at: now,
      });
      return {schemaVersion: 1, bookingId: bookingRef.id, status: "cancelled"};
    });
  } catch (error) {
    return rethrowCallableError(error, "Booking could not be cancelled.");
  }
});

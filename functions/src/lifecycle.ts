import {getFirestore, Timestamp} from "firebase-admin/firestore";
import * as functions from "firebase-functions/v1";

interface BookingLifecycleRequest {
  schemaVersion: 1;
  bookingId: string;
}

function parseLifecycleRequest(value: unknown): BookingLifecycleRequest {
  if (value === null || typeof value !== "object") {
    throw new functions.https.HttpsError("invalid-argument", "A booking is required.");
  }
  const data = value as Record<string, unknown>;
  const bookingId = typeof data.bookingId === "string" ? data.bookingId.trim() : "";
  if ((data.schemaVersion !== undefined && data.schemaVersion !== 1) ||
      !bookingId || bookingId.length > 256 || bookingId.includes("/")) {
    throw new functions.https.HttpsError("invalid-argument", "A valid booking is required.");
  }
  return {schemaVersion: 1, bookingId};
}

function callableError(error: unknown, fallback: string): never {
  if (error instanceof functions.https.HttpsError) throw error;
  functions.logger.error(fallback, {errorType: typeof error});
  throw new functions.https.HttpsError("internal", fallback);
}

function isPaidActiveBooking(data: Record<string, unknown>): boolean {
  return data.paymentStatus === "paid" &&
    (data.status === "confirmed" || data.status === "in_progress");
}

/** Starts a paid trip. Only the assigned driver/courier may perform this action. */
export const startTrip = functions.https.onCall(async (rawData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in before starting a trip.");
  }
  const request = parseLifecycleRequest(rawData);
  const db = getFirestore();
  const bookingRef = db.collection("bookings").doc(request.bookingId);

  try {
    return await db.runTransaction(async (transaction) => {
      const bookingSnapshot = await transaction.get(bookingRef);
      if (!bookingSnapshot.exists) {
        throw new functions.https.HttpsError("not-found", "Booking not found.");
      }
      const booking = bookingSnapshot.data()!;
      if (booking.driverId !== context.auth!.uid) {
        throw new functions.https.HttpsError(
          "permission-denied", "Only the assigned driver can start this trip."
        );
      }
      if (booking.paymentStatus !== "paid" || booking.status !== "confirmed") {
        throw new functions.https.HttpsError(
          "failed-precondition", "Payment and confirmation are required before departure."
        );
      }
      const tripId = typeof booking.tripId === "string" ? booking.tripId : "";
      const tripRef = db.collection("trips").doc(tripId);
      const relatedQuery = db.collection("bookings").where("tripId", "==", tripId);
      const [tripSnapshot, relatedBookings] = await Promise.all([
        transaction.get(tripRef),
        transaction.get(relatedQuery),
      ]);
      if (!tripSnapshot.exists) {
        throw new functions.https.HttpsError("not-found", "Trip not found.");
      }
      const trip = tripSnapshot.data()!;
      if (trip.status === "completed" || trip.status === "cancelled") {
        throw new functions.https.HttpsError("failed-precondition", "This trip is already closed.");
      }
      const now = Timestamp.now();
      transaction.update(tripRef, {
        status: "in_progress",
        started_at: now,
        updated_at: now,
      });
      for (const document of relatedBookings.docs) {
        const related = document.data();
        if (related.driverId === context.auth!.uid &&
            related.paymentStatus === "paid" && related.status === "confirmed") {
          transaction.update(document.ref, {status: "in_progress", updatedAt: now});
        }
      }
      return {schemaVersion: 1, tripId, status: "in_progress"};
    });
  } catch (error) {
    return callableError(error, "Trip could not be started.");
  }
});

/** Completes the trip and closes every associated participant conversation. */
export const completeTrip = functions.https.onCall(async (rawData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in before completing a trip.");
  }
  const request = parseLifecycleRequest(rawData);
  const db = getFirestore();
  const bookingRef = db.collection("bookings").doc(request.bookingId);

  try {
    return await db.runTransaction(async (transaction) => {
      const bookingSnapshot = await transaction.get(bookingRef);
      if (!bookingSnapshot.exists) {
        throw new functions.https.HttpsError("not-found", "Booking not found.");
      }
      const booking = bookingSnapshot.data()!;
      if (booking.driverId !== context.auth!.uid) {
        throw new functions.https.HttpsError(
          "permission-denied", "Only the assigned driver can complete this trip."
        );
      }
      if (booking.paymentStatus !== "paid" || booking.status !== "in_progress") {
        throw new functions.https.HttpsError(
          "failed-precondition", "Start the paid, confirmed trip before completing it."
        );
      }
      const tripId = typeof booking.tripId === "string" ? booking.tripId : "";
      const tripRef = db.collection("trips").doc(tripId);
      const relatedQuery = db.collection("bookings").where("tripId", "==", tripId);
      const [tripSnapshot, relatedBookings] = await Promise.all([
        transaction.get(tripRef),
        transaction.get(relatedQuery),
      ]);
      if (!tripSnapshot.exists || tripSnapshot.data()?.status !== "in_progress") {
        throw new functions.https.HttpsError("failed-precondition", "This trip is not in progress.");
      }
      const now = Timestamp.now();
      transaction.update(tripRef, {
        status: "completed",
        completed_at: now,
        updated_at: now,
      });
      for (const document of relatedBookings.docs) {
        const related = document.data();
        if (related.driverId !== context.auth!.uid || !isPaidActiveBooking(related)) continue;
        transaction.update(document.ref, {
          status: "completed",
          dropoffTime: now,
          updatedAt: now,
        });
        const conversationId = typeof related.conversationId === "string" ?
          related.conversationId : "";
        if (conversationId) {
          transaction.set(
            db.collection("conversation_authorizations").doc(conversationId),
            {active: false, status: "completed", updatedAt: now},
            {merge: true}
          );
        }
      }
      return {schemaVersion: 1, tripId, status: "completed"};
    });
  } catch (error) {
    return callableError(error, "Trip could not be completed.");
  }
});

/** Driver emergency cancellation. Refunds remain pending for staff/payment-provider review. */
export const cancelTrip = functions.https.onCall(async (rawData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in before cancelling a trip.");
  }
  const request = parseLifecycleRequest(rawData);
  const db = getFirestore();
  const bookingRef = db.collection("bookings").doc(request.bookingId);

  try {
    return await db.runTransaction(async (transaction) => {
      const bookingSnapshot = await transaction.get(bookingRef);
      if (!bookingSnapshot.exists) {
        throw new functions.https.HttpsError("not-found", "Booking not found.");
      }
      const booking = bookingSnapshot.data()!;
      if (booking.driverId !== context.auth!.uid) {
        throw new functions.https.HttpsError(
          "permission-denied", "Only the assigned driver can cancel this trip."
        );
      }
      const tripId = typeof booking.tripId === "string" ? booking.tripId : "";
      const tripRef = db.collection("trips").doc(tripId);
      const relatedQuery = db.collection("bookings").where("tripId", "==", tripId);
      const [tripSnapshot, relatedBookings] = await Promise.all([
        transaction.get(tripRef),
        transaction.get(relatedQuery),
      ]);
      if (!tripSnapshot.exists ||
          tripSnapshot.data()?.status === "completed" ||
          tripSnapshot.data()?.status === "cancelled") {
        throw new functions.https.HttpsError("failed-precondition", "This trip is already closed.");
      }
      const now = Timestamp.now();
      transaction.update(tripRef, {status: "cancelled", cancelled_at: now, updated_at: now});
      for (const document of relatedBookings.docs) {
        const related = document.data();
        if (related.driverId !== context.auth!.uid || related.status === "completed" ||
            related.status === "cancelled") continue;
        transaction.update(document.ref, {
          status: "cancelled",
          paymentStatus: related.paymentStatus === "paid" ? "refund_pending" : related.paymentStatus,
          updatedAt: now,
        });
        const conversationId = typeof related.conversationId === "string" ?
          related.conversationId : "";
        if (conversationId) {
          transaction.set(
            db.collection("conversation_authorizations").doc(conversationId),
            {active: false, status: "cancelled", updatedAt: now},
            {merge: true}
          );
        }
      }
      const eventRef = db.collection("admin_events").doc();
      transaction.create(eventRef, {
        id: eventRef.id,
        type: "emergency_trip_cancellation",
        priority: "urgent",
        tripId,
        bookingId: request.bookingId,
        actorId: context.auth!.uid,
        status: "open",
        createdAt: now,
        updatedAt: now,
      });
      return {schemaVersion: 1, tripId, status: "cancelled", refundStatus: "staff_review"};
    });
  } catch (error) {
    return callableError(error, "Trip could not be cancelled.");
  }
});

interface RatingRequest extends BookingLifecycleRequest {
  rating: number;
  review: string | null;
  tags: string[];
}

function parseRatingRequest(value: unknown): RatingRequest {
  const base = parseLifecycleRequest(value);
  const data = value as Record<string, unknown>;
  const rating = data.rating;
  if (!Number.isInteger(rating) || (rating as number) < 1 || (rating as number) > 5) {
    throw new functions.https.HttpsError("invalid-argument", "Rating must be from 1 to 5.");
  }
  const review = data.review === null || data.review === undefined || data.review === "" ?
    null : data.review;
  if (review !== null && (typeof review !== "string" || review.trim().length > 1000)) {
    throw new functions.https.HttpsError("invalid-argument", "Review is too long.");
  }
  const tags = Array.isArray(data.tags) ? data.tags : [];
  if (tags.length > 8 || tags.some((tag) => typeof tag !== "string" || tag.length > 40)) {
    throw new functions.https.HttpsError("invalid-argument", "Rating tags are invalid.");
  }
  return {
    ...base,
    rating: rating as number,
    review: review === null ? null : (review as string).trim(),
    tags: tags as string[],
  };
}

/** Creates exactly one rating per participant per completed booking. */
export const submitTripRating = functions.https.onCall(async (rawData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in before rating a trip.");
  }
  const request = parseRatingRequest(rawData);
  const db = getFirestore();
  const bookingRef = db.collection("bookings").doc(request.bookingId);
  const ratingRef = db.collection("ratings").doc(`${request.bookingId}_${context.auth.uid}`);

  try {
    return await db.runTransaction(async (transaction) => {
      const [bookingSnapshot, existingRating] = await Promise.all([
        transaction.get(bookingRef),
        transaction.get(ratingRef),
      ]);
      if (!bookingSnapshot.exists) {
        throw new functions.https.HttpsError("not-found", "Booking not found.");
      }
      const booking = bookingSnapshot.data()!;
      if (booking.status !== "completed") {
        throw new functions.https.HttpsError(
          "failed-precondition", "Ratings open only after the trip is completed."
        );
      }
      const uid = context.auth!.uid;
      const passengerId = typeof booking.passengerId === "string" ? booking.passengerId : "";
      const driverId = typeof booking.driverId === "string" ? booking.driverId : "";
      if (uid !== passengerId && uid !== driverId) {
        throw new functions.https.HttpsError("permission-denied", "You were not part of this trip.");
      }
      if (existingRating.exists) {
        throw new functions.https.HttpsError("already-exists", "You already rated this trip.");
      }
      const ratedUserId = uid === passengerId ? driverId : passengerId;
      const userRef = db.collection("users").doc(ratedUserId);
      const userSnapshot = await transaction.get(userRef);
      const current = userSnapshot.data() ?? {};
      const count = Number.isInteger(current.totalRatings) ? Number(current.totalRatings) : 0;
      const average = typeof current.rating === "number" && Number.isFinite(current.rating) ?
        current.rating : 5;
      const nextAverage = count === 0 ? request.rating :
        ((average * count) + request.rating) / (count + 1);
      const now = Timestamp.now();
      transaction.create(ratingRef, {
        id: ratingRef.id,
        bookingId: request.bookingId,
        tripId: booking.tripId,
        ratedByUserId: uid,
        ratedUserId,
        rating: request.rating,
        review: request.review,
        tags: request.tags,
        createdAt: now,
      });
      if (userSnapshot.exists) {
        transaction.update(userRef, {
          rating: nextAverage,
          totalRatings: count + 1,
          updatedAt: now,
        });
      }
      return {schemaVersion: 1, ratingId: ratingRef.id, ratedUserId};
    });
  } catch (error) {
    return callableError(error, "Rating could not be submitted.");
  }
});

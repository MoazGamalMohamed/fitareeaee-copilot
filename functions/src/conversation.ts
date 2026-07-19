import {getFirestore, Timestamp} from "firebase-admin/firestore";
import * as functions from "firebase-functions/v1";

export function conversationDocumentId(
  tripId: string,
  firstUid: string,
  secondUid: string
): string {
  return `${tripId}__${[firstUid, secondUid].sort().join("_")}`;
}

function validId(value: unknown): value is string {
  return typeof value === "string" && value.length >= 1 &&
    value.length <= 128 && !value.includes("/");
}

/** Authorizes a verified driver to contact the owner of a live ride request. */
export const authorizeTripConversation = functions.https.onCall(
  async (rawData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Sign in before messaging.");
    }
    const data = rawData as Record<string, unknown> | null;
    const recipientId = data?.recipientId;
    const tripId = data?.tripId;
    if (!validId(recipientId) || !validId(tripId) || recipientId === context.auth.uid) {
      throw new functions.https.HttpsError("invalid-argument", "A valid request trip is required.");
    }

    const db = getFirestore();
    const [trip, verification] = await Promise.all([
      db.collection("trips").doc(tripId).get(),
      db.collection("verifications").doc(context.auth.uid).get(),
    ]);
    const tripData = trip.data();
    const departure = tripData?.departure_time?.toDate?.();
    if (!trip.exists || tripData?.driverId !== recipientId ||
        tripData?.role !== "request" || tripData?.status !== "pending" ||
        !(departure instanceof Date) || departure.getTime() <= Date.now()) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "This ride request is no longer available for contact."
      );
    }
    if (verification.data()?.identityVerified !== true ||
        verification.data()?.selfieWithIdVerified !== true) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Complete manual identity verification before contacting a requester."
      );
    }

    const participants = [context.auth.uid, recipientId].sort();
    const id = conversationDocumentId(tripId, participants[0], participants[1]);
    await db.collection("conversation_authorizations").doc(id).set({
      id,
      participant_ids: participants,
      source: "trip_request",
      tripId,
      active: true,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    }, {merge: true});
    return {schemaVersion: 1, conversationId: id};
  }
);

/** Authorizes either participant to open chat for an active confirmed booking. */
export const authorizeBookingConversation = functions.https.onCall(
  async (rawData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Sign in before messaging.");
    }
    const data = rawData as Record<string, unknown> | null;
    const bookingId = data?.bookingId;
    if (!validId(bookingId)) {
      throw new functions.https.HttpsError("invalid-argument", "A valid booking is required.");
    }

    const db = getFirestore();
    const bookingRef = db.collection("bookings").doc(bookingId);
    const bookingSnapshot = await bookingRef.get();
    if (!bookingSnapshot.exists) {
      throw new functions.https.HttpsError("not-found", "Booking not found.");
    }

    const booking = bookingSnapshot.data() ?? {};
    const passengerId = typeof booking.passengerId === "string" ? booking.passengerId : "";
    const driverId = typeof booking.driverId === "string" ? booking.driverId : "";
    const tripId = typeof booking.tripId === "string" ? booking.tripId : "";
    const status = typeof booking.status === "string" ? booking.status : "";
    const requesterId = context.auth.uid;
    if (!passengerId || !driverId || !tripId ||
        (requesterId !== passengerId && requesterId !== driverId)) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "You cannot open this conversation."
      );
    }

    const conversationId = typeof booking.conversationId === "string" &&
      booking.conversationId.length > 0 ?
      booking.conversationId :
      conversationDocumentId(tripId, passengerId, driverId);
    const conversationRef = db
      .collection("conversation_authorizations")
      .doc(conversationId);
    const recipientId = requesterId === passengerId ? driverId : passengerId;

    const tripSnapshot = await db.collection("trips").doc(tripId).get();
    const tripStatus = tripSnapshot.data()?.status;
    if (status === "completed" || status === "cancelled" ||
        tripStatus === "completed" || tripStatus === "cancelled") {
      await conversationRef.set({
        active: false,
        status: "closed",
        updatedAt: Timestamp.now(),
      }, {merge: true});
      throw new functions.https.HttpsError(
        "failed-precondition",
        "This trip chat is closed."
      );
    }

    if (status !== "confirmed" && status !== "paid") {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Chat opens only after the booking is confirmed."
      );
    }

    const participants = [passengerId, driverId].sort();
    await Promise.all([
      conversationRef.set({
        id: conversationId,
        participant_ids: participants,
        source: "booking",
        bookingId,
        tripId,
        active: true,
        updatedAt: Timestamp.now(),
      }, {merge: true}),
      booking.conversationId === conversationId ?
        Promise.resolve() :
        bookingRef.set({conversationId, updatedAt: Timestamp.now()}, {merge: true}),
    ]);
    return {
      schemaVersion: 1,
      conversationId,
      recipientId,
      active: true,
    };
  }
);

import {getFirestore, Timestamp} from "firebase-admin/firestore";
import * as functions from "firebase-functions/v1";
import {bookingHasActivePaidTrip} from "./booking";

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

/** Legacy entry point retained as a deny-only boundary for older clients. */
export const authorizeTripConversation = functions.https.onCall(
  async (_rawData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Sign in before messaging.");
    }
    throw new functions.https.HttpsError(
      "failed-precondition",
      "Direct user chat opens only after a paid, confirmed booking."
    );
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
    if (booking.status === "completed" || booking.status === "cancelled" ||
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

    if (!bookingHasActivePaidTrip(booking)) {
      await conversationRef.set({
        active: false,
        status: "payment_required",
        updatedAt: Timestamp.now(),
      }, {merge: true});
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Chat opens only after payment is verified and the booking is confirmed."
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
        paymentStatus: "paid",
        status: "confirmed",
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

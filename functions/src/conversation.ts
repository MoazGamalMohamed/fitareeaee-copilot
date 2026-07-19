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

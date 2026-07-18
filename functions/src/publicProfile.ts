import {getFirestore, Timestamp} from "firebase-admin/firestore";
import * as functions from "firebase-functions/v1";

function stringOrNull(value: unknown, max: number): string | null {
  return typeof value === "string" && value.trim().length > 0 ?
    value.trim().slice(0, max) : null;
}

function safePhotoUrl(value: unknown, uid: string): string | null {
  const candidate = stringOrNull(value, 2048);
  if (!candidate) return null;
  try {
    const url = new URL(candidate);
    const expectedPrefix = `/v0/b/fitareeaee.firebasestorage.app/o/avatars%2F${encodeURIComponent(uid)}%2F`;
    return url.protocol === "https:" &&
      url.hostname === "firebasestorage.googleapis.com" &&
      url.pathname.startsWith(expectedPrefix) ? candidate : null;
  } catch (_) {
    return null;
  }
}

/** Maintains a PII-minimized projection for participant cards and chat. */
export const syncPublicProfile = functions.firestore
  .document("users/{uid}")
  .onWrite(async (change, context) => {
    const target = getFirestore().collection("public_profiles").doc(context.params.uid);
    if (!change.after.exists) {
      await target.delete();
      return;
    }
    const data = change.after.data() ?? {};
    const roles = Array.isArray(data.roles) ?
      data.roles.filter((role: unknown) => typeof role === "string" && role !== "admin").slice(0, 4) : [];
    await target.set({
      id: context.params.uid,
      name: stringOrNull(data.name, 80),
      photoUrl: safePhotoUrl(data.photoUrl, context.params.uid),
      roles,
      rating: Number.isFinite(data.rating) ? data.rating : 0,
      totalRatings: Number.isInteger(data.totalRatings) ? data.totalRatings : 0,
      totalTrips: Number.isInteger(data.totalTrips) ? data.totalTrips : 0,
      createdAt: data.createdAt ?? data.created_at ?? Timestamp.now(),
      updatedAt: Timestamp.now(),
    }, {merge: false});
  });

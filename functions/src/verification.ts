import {getAuth} from "firebase-admin/auth";
import {FieldValue, getFirestore, Timestamp} from "firebase-admin/firestore";
import {getStorage} from "firebase-admin/storage";
import * as functions from "firebase-functions/v1";

const STORAGE_BUCKET = "fitareeaee.firebasestorage.app";

const documentTypes = [
  "identity",
  "driverLicense",
  "vehicle",
  "selfieWithId",
] as const;

type DocumentType = (typeof documentTypes)[number];

const verificationFields: Record<DocumentType, {
  verified: string;
  verifiedAt: string;
  url: string;
  rejection: string;
}> = {
  identity: {
    verified: "identityVerified",
    verifiedAt: "identityVerifiedAt",
    url: "identityDocumentUrl",
    rejection: "identityRejectionReason",
  },
  driverLicense: {
    verified: "driverLicenseVerified",
    verifiedAt: "driverLicenseVerifiedAt",
    url: "driverLicenseUrl",
    rejection: "licenseRejectionReason",
  },
  vehicle: {
    verified: "vehicleVerified",
    verifiedAt: "vehicleVerifiedAt",
    url: "vehicleRegistrationUrl",
    rejection: "vehicleRejectionReason",
  },
  selfieWithId: {
    verified: "selfieWithIdVerified",
    verifiedAt: "selfieWithIdVerifiedAt",
    url: "selfieWithIdUrl",
    rejection: "selfieRejectionReason",
  },
};

function record(value: unknown): Record<string, unknown> {
  if (value === null || typeof value !== "object") {
    throw new functions.https.HttpsError("invalid-argument", "Request data is required.");
  }
  return value as Record<string, unknown>;
}

export function parseDocumentType(value: unknown): DocumentType {
  if (typeof value !== "string" || !documentTypes.includes(value as DocumentType)) {
    throw new functions.https.HttpsError("invalid-argument", "Unsupported verification type.");
  }
  return value as DocumentType;
}

export function validateDocumentUrl(
  value: unknown,
  uid: string,
  type: DocumentType
): string {
  if (typeof value !== "string" || value.length > 512) {
    throw new functions.https.HttpsError("invalid-argument", "A valid document upload is required.");
  }
  const expectedPath = `verification_documents/${uid}/${type}.jpg`;
  if (value !== expectedPath) {
    throw new functions.https.HttpsError("permission-denied", "The upload does not belong to this user.");
  }
  return value;
}

async function verifyStoredDocument(objectPath: string): Promise<void> {
  try {
    const [metadata] = await getStorage().bucket(STORAGE_BUCKET).file(objectPath).getMetadata();
    const size = Number(metadata.size);
    const contentType = metadata.contentType ?? "";
    if (!Number.isFinite(size) || size <= 0 || size >= 5 * 1024 * 1024 ||
        !contentType.startsWith("image/")) {
      throw new Error("Invalid verification object metadata");
    }
  } catch (_) {
    throw new functions.https.HttpsError("invalid-argument", "The verification upload could not be validated.");
  }
}

async function requireAdmin(uid: string): Promise<void> {
  const snapshot = await getFirestore().collection("admins").doc(uid).get();
  const data = snapshot.data();
  if (!snapshot.exists || (data?.role !== "admin" && data?.isAdmin !== true)) {
    throw new functions.https.HttpsError("permission-denied", "Administrator access is required.");
  }
}

export const submitVerification = functions.https.onCall(async (rawData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in before submitting verification.");
  }
  const data = record(rawData);
  const uid = context.auth.uid;
  const type = parseDocumentType(data.type);
  const documentUrl = validateDocumentUrl(data.documentUrl, uid, type);
  await verifyStoredDocument(documentUrl);
  const fields = verificationFields[type];
  const db = getFirestore();
  const requestRef = db.collection("verification_requests").doc();
  const summaryRef = db.collection("verifications").doc(uid);
  const now = Timestamp.now();

  await db.runTransaction(async (transaction) => {
    const existing = await transaction.get(summaryRef);
    transaction.create(requestRef, {
      id: requestRef.id,
      userId: uid,
      type,
      status: "pending",
      documentUrl,
      createdAt: now,
      updatedAt: now,
    });
    transaction.set(summaryRef, {
      userId: uid,
      emailVerified: existing.data()?.emailVerified === true,
      phoneVerified: existing.data()?.phoneVerified === true,
      identityVerified: existing.data()?.identityVerified === true,
      driverLicenseVerified: existing.data()?.driverLicenseVerified === true,
      vehicleVerified: existing.data()?.vehicleVerified === true,
      selfieWithIdVerified: existing.data()?.selfieWithIdVerified === true,
      [fields.url]: documentUrl,
      [fields.verified]: false,
      [fields.rejection]: FieldValue.delete(),
      [`${type}RequestId`]: requestRef.id,
      createdAt: existing.data()?.createdAt ?? now,
      updatedAt: now,
    }, {merge: true});
  });

  return {schemaVersion: 1, requestId: requestRef.id, status: "pending"};
});

export const reviewVerification = functions.https.onCall(async (rawData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in before reviewing verification.");
  }
  await requireAdmin(context.auth.uid);
  const data = record(rawData);
  const userId = typeof data.userId === "string" ? data.userId.trim() : "";
  if (!userId || userId.length > 128 || userId.includes("/")) {
    throw new functions.https.HttpsError("invalid-argument", "A valid userId is required.");
  }
  const type = parseDocumentType(data.type);
  if (typeof data.approved !== "boolean") {
    throw new functions.https.HttpsError("invalid-argument", "An approval decision is required.");
  }
  const approved = data.approved;
  const reason = typeof data.reason === "string" ? data.reason.trim().slice(0, 300) : "";
  if (!approved && !reason) {
    throw new functions.https.HttpsError("invalid-argument", "A rejection reason is required.");
  }
  const fields = verificationFields[type];
  const now = Timestamp.now();
  const db = getFirestore();
  const summaryRef = db.collection("verifications").doc(userId);
  const summary = await summaryRef.get();
  const requestId = summary.data()?.[`${type}RequestId`];
  const objectPath = summary.data()?.[fields.url];
  const batch = db.batch();
  batch.set(summaryRef, {
    [fields.verified]: approved,
    [fields.verifiedAt]: approved ? now : FieldValue.delete(),
    [fields.rejection]: approved ? FieldValue.delete() : reason,
    [fields.url]: FieldValue.delete(),
    updatedAt: now,
    reviewedBy: context.auth.uid,
  }, {merge: true});
  if (typeof requestId === "string" && requestId.length <= 128 && !requestId.includes("/")) {
    batch.set(db.collection("verification_requests").doc(requestId), {
      status: approved ? "approved" : "rejected",
      rejectionReason: approved ? FieldValue.delete() : reason,
      verifiedAt: now,
      verifiedBy: context.auth.uid,
      documentUrl: FieldValue.delete(),
      documentNumber: FieldValue.delete(),
      updatedAt: now,
    }, {merge: true});
  }
  await batch.commit();
  if (typeof objectPath === "string" &&
      objectPath.startsWith(`verification_documents/${userId}/`)) {
    try {
      await getStorage().bucket(STORAGE_BUCKET).file(objectPath).delete({ignoreNotFound: true});
    } catch (_) {
      functions.logger.warn("Reviewed verification object cleanup failed");
    }
  }
  return {schemaVersion: 1, status: approved ? "approved" : "rejected"};
});

export const syncContactVerification = functions.https.onCall(async (_data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in before syncing verification.");
  }
  const user = await getAuth().getUser(context.auth.uid);
  const now = Timestamp.now();
  await getFirestore().collection("verifications").doc(context.auth.uid).set({
    userId: context.auth.uid,
    emailVerified: user.emailVerified,
    phoneVerified: typeof user.phoneNumber === "string" && user.phoneNumber.length > 0,
    updatedAt: now,
    createdAt: now,
  }, {merge: true});
  return {
    schemaVersion: 1,
    emailVerified: user.emailVerified,
    phoneVerified: typeof user.phoneNumber === "string" && user.phoneNumber.length > 0,
  };
});

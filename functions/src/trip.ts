import {getFirestore, Timestamp} from "firebase-admin/firestore";
import * as functions from "firebase-functions/v1";

const MAX_TEXT = 500;

export interface CreateTripRequest {
  schemaVersion: 1;
  role: "offer" | "request";
  type: "person" | "package" | "both";
  originAddress: string;
  destinationAddress: string;
  originLat: number;
  originLng: number;
  destinationLat: number;
  destinationLng: number;
  departureTime: Date;
  pricePerSeat: number;
  seats: number;
  description: string | null;
  allowPets: boolean;
  allowSmoking: boolean;
  includesPerson: boolean;
  includesPackage: boolean;
  packageWeight: number | null;
  packageDescription: string | null;
}

function object(value: unknown): Record<string, unknown> {
  if (value === null || typeof value !== "object" || Array.isArray(value)) {
    throw new functions.https.HttpsError("invalid-argument", "Trip details are required.");
  }
  return value as Record<string, unknown>;
}

function text(
  value: unknown,
  label: string,
  max = 160,
  optional = false
): string | null {
  if (optional && (value === null || value === undefined || value === "")) return null;
  if (typeof value !== "string") {
    throw new functions.https.HttpsError("invalid-argument", `${label} is required.`);
  }
  const normalized = value.trim();
  if (normalized.length < 2 || normalized.length > max) {
    throw new functions.https.HttpsError("invalid-argument", `${label} is invalid.`);
  }
  return normalized;
}

function coordinate(value: unknown, minimum: number, maximum: number): number {
  if (value === null || value === undefined) return 0;
  if (typeof value !== "number" || !Number.isFinite(value) ||
      value < minimum || value > maximum) {
    throw new functions.https.HttpsError("invalid-argument", "Location coordinates are invalid.");
  }
  return value;
}

export function parseCreateTripRequest(
  value: unknown,
  nowMs = Date.now()
): CreateTripRequest {
  const data = object(value);
  if (data.schemaVersion !== undefined && data.schemaVersion !== 1) {
    throw new functions.https.HttpsError("invalid-argument", "Unsupported trip version.");
  }
  const role = data.role;
  const type = data.type;
  if (role !== "offer" && role !== "request") {
    throw new functions.https.HttpsError("invalid-argument", "Choose offer or request.");
  }
  if (type !== "person" && type !== "package" && type !== "both") {
    throw new functions.https.HttpsError("invalid-argument", "Choose ride, package, or both.");
  }
  const rawDeparture = typeof data.departureTime === "string" ?
    data.departureTime : "";
  const departureTime = new Date(rawDeparture);
  const latest = nowMs + 366 * 24 * 60 * 60 * 1000;
  if (!rawDeparture || Number.isNaN(departureTime.getTime()) ||
      departureTime.getTime() <= nowMs || departureTime.getTime() > latest) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Departure must be a valid future date within one year."
    );
  }
  const seats = data.seats;
  if (!Number.isInteger(seats) || (seats as number) < 1 || (seats as number) > 8) {
    throw new functions.https.HttpsError("invalid-argument", "Seats must be from 1 to 8.");
  }
  const price = data.pricePerSeat;
  if (typeof price !== "number" || !Number.isFinite(price) || price < 0 || price > 100_000) {
    throw new functions.https.HttpsError("invalid-argument", "Price or budget is invalid.");
  }
  const includesPerson = type !== "package";
  const includesPackage = type !== "person";
  const packageWeight = data.packageWeight === null || data.packageWeight === undefined ?
    null : data.packageWeight;
  if (includesPackage &&
      (typeof packageWeight !== "number" || !Number.isFinite(packageWeight) ||
       packageWeight <= 0 || packageWeight > 1_000)) {
    throw new functions.https.HttpsError("invalid-argument", "Package weight is invalid.");
  }

  return {
    schemaVersion: 1,
    role,
    type,
    originAddress: text(data.originAddress, "Origin")!,
    destinationAddress: text(data.destinationAddress, "Destination")!,
    originLat: coordinate(data.originLat, -90, 90),
    originLng: coordinate(data.originLng, -180, 180),
    destinationLat: coordinate(data.destinationLat, -90, 90),
    destinationLng: coordinate(data.destinationLng, -180, 180),
    departureTime,
    pricePerSeat: price,
    seats: seats as number,
    description: text(data.description, "Description", MAX_TEXT, true),
    allowPets: data.allowPets === true,
    allowSmoking: data.allowSmoking === true,
    includesPerson,
    includesPackage,
    packageWeight: includesPackage ? packageWeight as number : null,
    packageDescription: includesPackage ?
      text(data.packageDescription, "Package description", MAX_TEXT) : null,
  };
}

export function driverVerificationComplete(data: Record<string, unknown>): boolean {
  return data.identityVerified === true &&
    data.selfieWithIdVerified === true &&
    data.driverLicenseVerified === true &&
    data.vehicleVerified === true;
}

export function routeDistanceKm(
  originLat: number,
  originLng: number,
  destinationLat: number,
  destinationLng: number
): number {
  const radians = (degrees: number) => degrees * Math.PI / 180;
  const earthRadiusKm = 6371;
  const latitudeDelta = radians(destinationLat - originLat);
  const longitudeDelta = radians(destinationLng - originLng);
  const a = Math.sin(latitudeDelta / 2) ** 2 +
    Math.cos(radians(originLat)) * Math.cos(radians(destinationLat)) *
    Math.sin(longitudeDelta / 2) ** 2;
  return earthRadiusKm * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

/** Creates a canonical offer or request without granting clients trip write access. */
export const createTrip = functions.https.onCall(async (rawData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in to create a trip.");
  }
  const request = parseCreateTripRequest(rawData);
  const db = getFirestore();
  if (request.role === "offer") {
    const verification = await db
      .collection("verifications")
      .doc(context.auth.uid)
      .get();
    if (!verification.exists || !driverVerificationComplete(verification.data() ?? {})) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Complete ID, selfie, driver-license, and vehicle verification before offering a ride."
      );
    }
  }

  const ref = db.collection("trips").doc();
  const now = Timestamp.now();
  const distance = routeDistanceKm(
    request.originLat,
    request.originLng,
    request.destinationLat,
    request.destinationLng
  );
  await ref.create({
    id: ref.id,
    schemaVersion: 1,
    type: request.type,
    role: request.role,
    driverId: context.auth.uid,
    ownerRole: request.role === "offer" ? "driver" : "rider",
    passengerId: null,
    origin_address: request.originAddress,
    destination_address: request.destinationAddress,
    origin_lat: request.originLat,
    origin_lng: request.originLng,
    destination_lat: request.destinationLat,
    destination_lng: request.destinationLng,
    departure_time: Timestamp.fromDate(request.departureTime),
    distance,
    estimated_duration: Math.max(1, Math.round((distance / 80) * 60)),
    price_per_seat: request.pricePerSeat,
    total_seats: request.seats,
    available_seats: request.seats,
    passenger_ids: [],
    status: "pending",
    description: request.description,
    allowPets: request.allowPets,
    allowSmoking: request.allowSmoking,
    amenities: [],
    metadata: {},
    created_at: now,
    updated_at: now,
    includes_person: request.includesPerson,
    includes_package: request.includesPackage,
    package_weight: request.packageWeight,
    package_description: request.packageDescription,
    package_photo_urls: [],
  });
  return {schemaVersion: 1, tripId: ref.id, status: "pending"};
});

import {getFirestore} from "firebase-admin/firestore";
import {onDocumentWritten} from "firebase-functions/v2/firestore";

export function publicTripData(
  data: Record<string, unknown>,
  tripId: string
): Record<string, unknown> {
  const now = new Date();
  const departureTime = data.departure_time ?? now;
  const createdAt = data.created_at ?? departureTime;
  const type = data.type === "package" || data.type === "both" ?
    data.type : "person";
  const roundedCoordinate = (value: unknown): number =>
    typeof value === "number" && Number.isFinite(value) ?
      Math.round(value * 100) / 100 : 0;

  return {
    id: tripId,
    type,
    role: data.role === "request" ? "request" : "offer",
    driverId: typeof data.driverId === "string" ? data.driverId : "",
    passengerId: null,
    origin_address: typeof data.origin_address === "string" ?
      data.origin_address : "Unknown",
    destination_address: typeof data.destination_address === "string" ?
      data.destination_address : "Unknown",
    // Approximate route coordinates support useful matching without exposing
    // an exact pickup or drop-off pin in the signed-in marketplace projection.
    origin_lat: roundedCoordinate(data.origin_lat),
    origin_lng: roundedCoordinate(data.origin_lng),
    destination_lat: roundedCoordinate(data.destination_lat),
    destination_lng: roundedCoordinate(data.destination_lng),
    departure_time: departureTime,
    distance: Number.isFinite(data.distance) ? data.distance : 0,
    estimated_duration: Number.isInteger(data.estimated_duration) ?
      data.estimated_duration : 0,
    price_per_seat: Number.isFinite(data.price_per_seat) ? data.price_per_seat : 0,
    total_seats: Number.isInteger(data.total_seats) ? data.total_seats : 0,
    available_seats: Number.isInteger(data.available_seats) ? data.available_seats : 0,
    passenger_ids: [],
    status: typeof data.status === "string" ? data.status : "pending",
    description: null,
    allowPets: data.allowPets === true,
    allowSmoking: data.allowSmoking === true,
    amenities: [],
    metadata: {},
    created_at: createdAt,
    updated_at: data.updated_at ?? createdAt,
    includes_person: data.includes_person !== false,
    includes_package: data.includes_package === true,
    package_weight: Number.isFinite(data.package_weight) ? data.package_weight : null,
    package_description: null,
    package_photo_urls: [],
  };
}

/**
 * Maintains the signed-in marketplace projection. Precise coordinates,
 * passenger identifiers, package photos, and arbitrary metadata stay private.
 */
export const syncPublicTrip = onDocumentWritten({
  document: "trips/{tripId}",
  region: "europe-west1",
}, async (event) => {
    const change = event.data;
    if (!change) return;

    const target = getFirestore()
      .collection("public_trips")
      .doc(event.params.tripId);
    if (!change.after.exists) {
      await target.delete();
      return;
    }

    const data = change.after.data() ?? {};
    await target.set(publicTripData(data, event.params.tripId), {merge: false});
});

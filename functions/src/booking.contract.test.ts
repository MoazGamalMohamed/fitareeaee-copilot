import assert from "node:assert/strict";
import test from "node:test";
import {
  bookingDocumentId,
  canSelfCancelBeforeDeparture,
  parseBookingRequest,
  validatedUnitPrice,
} from "./booking";
import {conversationDocumentId} from "./conversation";
import {publicTripData} from "./publicTrip";

test("booking requests default to one seat", () => {
  assert.deepEqual(parseBookingRequest({tripId: "trip-1"}), {
    schemaVersion: 1,
    tripId: "trip-1",
    seats: 1,
  });
});

test("booking requests reject invalid seat counts", () => {
  assert.throws(() => parseBookingRequest({tripId: "trip-1", seats: 0}));
  assert.throws(() => parseBookingRequest({tripId: "trip-1", seats: 1.5}));
  assert.throws(() => parseBookingRequest({tripId: "trip-1", seats: 9}));
});

test("booking requests reject unsafe trip identifiers", () => {
  assert.throws(() => parseBookingRequest({tripId: ""}));
  assert.throws(() => parseBookingRequest({tripId: "trips/other"}));
});

test("booking IDs are deterministic for idempotent retries", () => {
  assert.equal(bookingDocumentId("trip-1", "user-1"), "trip-1_user-1");
});

test("booking prices must be finite, nonnegative canonical numbers", () => {
  assert.equal(validatedUnitPrice(18), 18);
  assert.throws(() => validatedUnitPrice("18"));
  assert.throws(() => validatedUnitPrice(-1));
  assert.throws(() => validatedUnitPrice(Number.NaN));
  assert.throws(() => validatedUnitPrice(Number.POSITIVE_INFINITY));
});

test("self-service cancellation closes at scheduled departure", () => {
  const now = Date.UTC(2026, 6, 18, 12);
  assert.equal(
    canSelfCancelBeforeDeparture(new Date(now + 60_000), now),
    true
  );
  assert.equal(canSelfCancelBeforeDeparture(new Date(now), now), false);
  assert.equal(canSelfCancelBeforeDeparture(new Date(now - 1), now), false);
  assert.equal(canSelfCancelBeforeDeparture(null, now), false);
});

test("conversation authorization IDs are deterministic and order independent", () => {
  assert.equal(
    conversationDocumentId("trip-1", "rider", "driver"),
    "trip-1__driver_rider"
  );
  assert.equal(
    conversationDocumentId("trip-1", "driver", "rider"),
    "trip-1__driver_rider"
  );
  assert.notEqual(
    conversationDocumentId("trip-1", "driver", "rider"),
    conversationDocumentId("trip-2", "driver", "rider")
  );
});

test("public trip projection removes coordinates, passengers, photos, and metadata", () => {
  const projected = publicTripData({
    driverId: "driver",
    origin_lat: 32.7,
    passenger_ids: ["private-rider"],
    package_photo_urls: ["private.jpg"],
    metadata: {private: true},
  }, "trip-1");
  assert.equal(projected.origin_lat, 0);
  assert.deepEqual(projected.passenger_ids, []);
  assert.deepEqual(projected.package_photo_urls, []);
  assert.deepEqual(projected.metadata, {});
});

test("public trip projection emits no undefined values for legacy sparse trips", () => {
  const projected = publicTripData({driverId: "driver"}, "legacy-trip");
  assert.equal(projected.type, "person");
  assert.equal(projected.role, "offer");
  assert.equal(projected.origin_address, "Unknown");
  assert.equal(projected.destination_address, "Unknown");
  assert.ok(projected.departure_time instanceof Date);
  assert.equal(Object.values(projected).includes(undefined), false);
});

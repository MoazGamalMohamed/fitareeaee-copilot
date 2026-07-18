import assert from "node:assert/strict";
import test from "node:test";
import {bookingDocumentId, parseBookingRequest} from "./booking";

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

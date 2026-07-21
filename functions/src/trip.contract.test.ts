import assert from "node:assert/strict";
import test from "node:test";
import {
  accountCanCreateRole,
  driverVerificationComplete,
  parseCreateTripRequest,
  participantVerificationComplete,
  routeDistanceKm,
} from "./trip";
import {parseTripWithdrawalRequest, tripCanBeWithdrawn} from "./lifecycle";

const now = Date.UTC(2026, 6, 19, 12);

test("trip creation accepts canonical rider requests", () => {
  const request = parseCreateTripRequest({
    schemaVersion: 1,
    role: "request",
    type: "person",
    originAddress: "Dallas",
    destinationAddress: "Austin",
    departureTime: "2026-07-20T14:00:00.000Z",
    pricePerSeat: 40,
    seats: 2,
    allowPets: true,
  }, now);
  assert.equal(request.role, "request");
  assert.equal(request.seats, 2);
  assert.equal(request.includesPerson, true);
  assert.equal(request.includesPackage, false);
});

test("trip creation validates package details and future departure", () => {
  assert.throws(() => parseCreateTripRequest({
    role: "offer",
    type: "package",
    originAddress: "Dallas",
    destinationAddress: "Austin",
    departureTime: "2026-07-20T14:00:00.000Z",
    pricePerSeat: 20,
    seats: 1,
    packageDescription: "Box",
  }, now));
  assert.throws(() => parseCreateTripRequest({
    role: "request",
    type: "person",
    originAddress: "Dallas",
    destinationAddress: "Austin",
    departureTime: "2026-07-18T14:00:00.000Z",
    pricePerSeat: 20,
    seats: 1,
  }, now));
});

test("driver offers require every manual driver and vehicle check", () => {
  assert.equal(driverVerificationComplete({
    emailVerified: true,
    phoneVerified: true,
    identityVerified: true,
    selfieWithIdVerified: true,
    driverLicenseVerified: true,
    vehicleVerified: true,
  }), true);
  assert.equal(driverVerificationComplete({
    emailVerified: true,
    phoneVerified: true,
    identityVerified: true,
    selfieWithIdVerified: true,
    driverLicenseVerified: true,
    vehicleVerified: false,
  }), false);
});

test("rider requests require contact, identity, and selfie checks", () => {
  assert.equal(participantVerificationComplete({
    emailVerified: true,
    phoneVerified: true,
    identityVerified: true,
    selfieWithIdVerified: true,
  }), true);
  assert.equal(participantVerificationComplete({
    emailVerified: true,
    phoneVerified: false,
    identityVerified: true,
    selfieWithIdVerified: true,
  }), false);
});

test("signup path cannot be flipped by callable input", () => {
  assert.equal(accountCanCreateRole({roles: ["rider", "sender"]}, "request"), true);
  assert.equal(accountCanCreateRole({roles: ["rider", "sender"]}, "offer"), false);
  assert.equal(accountCanCreateRole({roles: ["driver", "courier"]}, "offer"), true);
  assert.equal(accountCanCreateRole({roles: ["driver", "courier"]}, "request"), false);
  assert.equal(accountCanCreateRole({roles: ["rider", "driver"]}, "request"), false);
});

test("map coordinates produce a realistic route distance", () => {
  const dallasToAustin = routeDistanceKm(32.7767, -96.797, 30.2672, -97.7431);
  assert.ok(dallasToAustin > 280);
  assert.ok(dallasToAustin < 310);
});

test("only an owner can withdraw an open unconfirmed trip", () => {
  assert.deepEqual(
    parseTripWithdrawalRequest({schemaVersion: 1, tripId: "trip-123"}),
    {schemaVersion: 1, tripId: "trip-123"}
  );
  assert.throws(() => parseTripWithdrawalRequest({tripId: "bad/id"}));
  assert.equal(tripCanBeWithdrawn({driverId: "owner", status: "pending"}, "owner"), true);
  assert.equal(tripCanBeWithdrawn({driverId: "other", status: "pending"}, "owner"), false);
  assert.equal(tripCanBeWithdrawn({driverId: "owner", status: "confirmed"}, "owner"), false);
  assert.equal(tripCanBeWithdrawn({driverId: "owner", status: "cancelled"}, "owner"), false);
});

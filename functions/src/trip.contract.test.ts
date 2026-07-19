import assert from "node:assert/strict";
import test from "node:test";
import {driverVerificationComplete, parseCreateTripRequest} from "./trip";

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
    identityVerified: true,
    selfieWithIdVerified: true,
    driverLicenseVerified: true,
    vehicleVerified: true,
  }), true);
  assert.equal(driverVerificationComplete({
    identityVerified: true,
    selfieWithIdVerified: true,
    driverLicenseVerified: true,
    vehicleVerified: false,
  }), false);
});

/* Idempotent Build Week judge-data seeder; never accepts passwords. */
const {getApps, initializeApp} = require("firebase-admin/app");
const {getFirestore, Timestamp} = require("firebase-admin/firestore");

const EXPECTED_PROJECT = "fitareeaee";
const projectId = process.env.GOOGLE_CLOUD_PROJECT || process.env.GCLOUD_PROJECT;
const driverUid = process.env.JUDGE_DRIVER_UID;
const riderUid = process.env.JUDGE_RIDER_UID;
const offsetMinutes = Number(process.env.JUDGE_UTC_OFFSET_MINUTES || "-300");

function fail(message) {
  process.stderr.write(`Judge seed refused: ${message}\n`);
  process.exit(1);
}

if (projectId !== EXPECTED_PROJECT) {
  fail(`GOOGLE_CLOUD_PROJECT must equal ${EXPECTED_PROJECT}.`);
}
if (!driverUid || !riderUid || driverUid === riderUid) {
  fail("set distinct JUDGE_DRIVER_UID and JUDGE_RIDER_UID values.");
}
for (const [name, uid] of [["JUDGE_DRIVER_UID", driverUid], ["JUDGE_RIDER_UID", riderUid]]) {
  if (!/^[A-Za-z0-9_-]{6,128}$/.test(uid)) fail(`${name} is not a valid Firebase Auth UID.`);
}
if (!Number.isInteger(offsetMinutes) || offsetMinutes < -720 || offsetMinutes > 840) {
  fail("JUDGE_UTC_OFFSET_MINUTES must be an integer from -720 to 840.");
}

if (getApps().length === 0) initializeApp({projectId: EXPECTED_PROJECT});
const db = getFirestore();

function localFuture(days, hour, minute = 0) {
  const shiftedNow = new Date(Date.now() + offsetMinutes * 60_000);
  const localUtc = Date.UTC(
    shiftedNow.getUTCFullYear(),
    shiftedNow.getUTCMonth(),
    shiftedNow.getUTCDate() + days,
    hour,
    minute,
  );
  return new Date(localUtc - offsetMinutes * 60_000);
}

function trip({id, owner, type, role = "offer", origin, destination, departure,
  price, seats, allowPets = false, allowSmoking = false,
  packageWeight = null, description}) {
  const now = Timestamp.now();
  return {
    id, type, role, driverId: owner, passengerId: null,
    origin_address: origin, destination_address: destination,
    origin_lat: 0, origin_lng: 0, destination_lat: 0, destination_lng: 0,
    departure_time: Timestamp.fromDate(departure), distance: 0,
    estimated_duration: 180, price_per_seat: price,
    total_seats: seats, available_seats: seats, passenger_ids: [],
    status: "pending", description, allowPets, allowSmoking,
    amenities: ["air conditioning"],
    metadata: {buildWeekJudgeFixture: true},
    created_at: now, updated_at: now,
    includes_person: type !== "package", includes_package: type === "package",
    package_weight: packageWeight,
    package_description: type === "package" ? description : null,
    package_photo_urls: [],
  };
}

function publicTrip(fixture) {
  return {
    ...fixture,
    passengerId: null,
    origin_lat: 0,
    origin_lng: 0,
    destination_lat: 0,
    destination_lng: 0,
    passenger_ids: [],
    description: null,
    amenities: [],
    metadata: {},
    package_description: null,
    package_photo_urls: [],
  };
}

async function main() {
  const fixtures = [
    trip({id: "build_week_judge_dallas_austin_0900", owner: driverUid,
      type: "person", origin: "Dallas, Texas", destination: "Austin, Texas",
      departure: localFuture(1, 9), price: 18, seats: 3, allowSmoking: false,
      description: "Judge fixture: morning non-smoking ride."}),
    trip({id: "build_week_judge_dallas_austin_1200", owner: driverUid,
      type: "person", origin: "Downtown Dallas, Texas",
      destination: "Central Austin, Texas", departure: localFuture(1, 12),
      price: 24, seats: 2, allowPets: true,
      description: "Judge fixture: later pet-friendly ride."}),
    trip({id: "build_week_judge_chicago_milwaukee_package", owner: driverUid,
      type: "package", origin: "Chicago, Illinois",
      destination: "Milwaukee, Wisconsin", departure: localFuture(2, 10),
      price: 12, seats: 1, packageWeight: 10,
      description: "Judge fixture: package capacity up to 10 kg."}),
    trip({id: "build_week_judge_dallas_houston_request", owner: riderUid,
      type: "person", role: "request", origin: "Dallas, Texas",
      destination: "Houston, Texas", departure: localFuture(1, 18),
      price: 30, seats: 2, allowSmoking: false,
      description: "Judge fixture: evening ride request."}),
  ];

  const batch = db.batch();
  for (const fixture of fixtures) {
    batch.set(db.collection("trips").doc(fixture.id), fixture, {merge: true});
    batch.set(db.collection("public_trips").doc(fixture.id), publicTrip(fixture),
      {merge: false});
  }
  const verified = {identityVerified: true, selfieWithIdVerified: true,
    emailVerified: true, buildWeekJudgeFixture: true, updatedAt: Timestamp.now()};
  batch.set(db.collection("verifications").doc(driverUid), {...verified,
    userId: driverUid, driverLicenseVerified: true, vehicleVerified: true},
  {merge: true});
  batch.set(db.collection("verifications").doc(riderUid),
    {...verified, userId: riderUid}, {merge: true});
  const publicBase = {photoUrl: null, roles: [], rating: 5,
    totalRatings: 0, totalTrips: 0, createdAt: Timestamp.now(), updatedAt: Timestamp.now()};
  batch.set(db.collection("public_profiles").doc(driverUid),
    {...publicBase, id: driverUid, name: "Judge Driver", roles: ["driver"]},
    {merge: true});
  batch.set(db.collection("public_profiles").doc(riderUid),
    {...publicBase, id: riderUid, name: "Judge Rider", roles: ["rider"]},
    {merge: true});
  await batch.commit();
  process.stdout.write(`Upserted ${fixtures.length} private/public trip fixtures, two fictional verification summaries, and two public profiles in ${EXPECTED_PROJECT}.\n`);
}

main().catch((error) => {
  process.stderr.write(`Judge seed failed (${error?.name || "Error"}). No credentials were logged.\n`);
  process.exitCode = 1;
});

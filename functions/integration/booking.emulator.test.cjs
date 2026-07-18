const assert = require("node:assert/strict");
const {after, before, test} = require("node:test");
const {deleteApp: deleteAdminApp, getApps, initializeApp: initializeAdmin} = require("firebase-admin/app");
const {getFirestore, Timestamp} = require("firebase-admin/firestore");
const {deleteApp, initializeApp} = require("firebase/app");
const {connectAuthEmulator, createUserWithEmailAndPassword, getAuth} = require("firebase/auth");

const projectId = "fitareeaee";
const functionsHost = process.env.FUNCTIONS_EMULATOR_HOST || "127.0.0.1:5001";
const authHost = process.env.FIREBASE_AUTH_EMULATOR_HOST;
if (!process.env.FIRESTORE_EMULATOR_HOST || !functionsHost || !authHost) {
  throw new Error("Run through Firebase emulators:exec with auth,functions,firestore.");
}

if (getApps().length === 0) initializeAdmin({projectId});
const db = getFirestore();
const clientApps = [];
let driver;
let riderA;
let riderB;
let unverified;

async function account(label) {
  const app = initializeApp({apiKey: "emulator-only", projectId}, `${label}-${Date.now()}`);
  clientApps.push(app);
  const auth = getAuth(app);
  connectAuthEmulator(auth, `http://${authHost}`, {disableWarnings: true});
  const credential = await createUserWithEmailAndPassword(
    auth,
    `${label}-${Date.now()}@example.test`,
    "emulator-only-password",
  );
  return {uid: credential.user.uid, token: await credential.user.getIdToken()};
}

async function callable(name, token, data) {
  const response = await fetch(
    `http://${functionsHost}/${projectId}/us-central1/${name}`,
    {
      method: "POST",
      headers: {"content-type": "application/json", authorization: `Bearer ${token}`},
      body: JSON.stringify({data}),
    },
  );
  return {ok: response.ok, status: response.status, body: await response.json()};
}

async function seedVerified(uid) {
  await db.collection("verifications").doc(uid).set({
    userId: uid,
    identityVerified: true,
    selfieWithIdVerified: true,
  });
}

async function seedTrip(id, seats = 1) {
  await db.collection("trips").doc(id).set({
    id,
    driverId: driver.uid,
    role: "offer",
    status: "pending",
    departure_time: Timestamp.fromDate(new Date(Date.now() + 86_400_000)),
    available_seats: seats,
    total_seats: seats,
    passenger_ids: [],
    price_per_seat: 10,
    origin_address: "Dallas",
    destination_address: "Austin",
  });
}

before(async () => {
  [driver, riderA, riderB, unverified] = await Promise.all([
    account("driver"), account("rider-a"), account("rider-b"), account("unverified"),
  ]);
  await Promise.all([seedVerified(driver.uid), seedVerified(riderA.uid), seedVerified(riderB.uid)]);
});

after(async () => {
  await Promise.all(clientApps.map((app) => deleteApp(app)));
  await Promise.all(getApps().map((app) => deleteAdminApp(app)));
});

test("concurrent final-seat requests create exactly one booking", async () => {
  const tripId = `integration-final-seat-${Date.now()}`;
  await seedTrip(tripId, 1);
  const [first, second] = await Promise.all([
    callable("createBooking", riderA.token, {schemaVersion: 1, tripId, seats: 1}),
    callable("createBooking", riderB.token, {schemaVersion: 1, tripId, seats: 1}),
  ]);
  assert.equal([first, second].filter((result) => result.ok).length, 1);
  assert.equal([first, second].filter((result) => !result.ok).length, 1);
  const trip = await db.collection("trips").doc(tripId).get();
  assert.equal(trip.data().available_seats, 0);
  const bookings = await db.collection("bookings").where("tripId", "==", tripId).get();
  assert.equal(bookings.size, 1);
  const authorizations = await db.collection("conversation_authorizations")
    .where("tripId", "==", tripId).get();
  assert.equal(authorizations.size, 1);
  assert.deepEqual(
    authorizations.docs[0].data().participant_ids,
    [driver.uid, bookings.docs[0].data().passengerId].sort(),
  );
});

test("duplicate booking is idempotent and cancellation restores inventory", async () => {
  const tripId = `integration-duplicate-${Date.now()}`;
  await seedTrip(tripId, 1);
  const first = await callable("createBooking", riderA.token, {schemaVersion: 1, tripId, seats: 1});
  const duplicate = await callable("createBooking", riderA.token, {schemaVersion: 1, tripId, seats: 1});
  assert.equal(first.ok, true);
  assert.equal(first.body.result.created, true);
  assert.equal(duplicate.ok, true);
  assert.equal(duplicate.body.result.created, false);
  const cancelled = await callable("cancelBooking", riderA.token, {schemaVersion: 1, tripId, seats: 1});
  assert.equal(cancelled.ok, true);
  const trip = await db.collection("trips").doc(tripId).get();
  assert.equal(trip.data().available_seats, 1);
  const bookingId = `${tripId}_${riderA.uid}`;
  const booking = await db.collection("bookings").doc(bookingId).get();
  assert.equal(booking.data().status, "cancelled");
});

test("unverified rider is rejected without changing inventory", async () => {
  const tripId = `integration-unverified-${Date.now()}`;
  await seedTrip(tripId, 1);
  const result = await callable("createBooking", unverified.token, {
    schemaVersion: 1,
    tripId,
    seats: 1,
  });
  assert.equal(result.ok, false);
  const trip = await db.collection("trips").doc(tripId).get();
  assert.equal(trip.data().available_seats, 1);
});

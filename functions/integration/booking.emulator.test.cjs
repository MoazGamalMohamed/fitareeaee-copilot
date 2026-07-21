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

async function seedVerified(uid, isDriver = false) {
  await db.collection("verifications").doc(uid).set({
    userId: uid,
    emailVerified: true,
    phoneVerified: true,
    identityVerified: true,
    selfieWithIdVerified: true,
    driverLicenseVerified: isDriver,
    vehicleVerified: isDriver,
  });
}

async function seedAccount(uid, roles) {
  await db.collection("users").doc(uid).set({
    id: uid,
    roles,
  });
}

function createTripPayload(role = "request") {
  return {
    schemaVersion: 1,
    role,
    type: "person",
    originAddress: "Dallas",
    destinationAddress: "Austin",
    originLat: 32.7767,
    originLng: -96.797,
    destinationLat: 30.2672,
    destinationLng: -97.7431,
    departureTime: new Date(Date.now() + 86_400_000).toISOString(),
    pricePerSeat: 40,
    seats: 1,
    description: "Integration lifecycle request",
    allowPets: false,
    allowSmoking: false,
  };
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

async function seedRequest(id, seats = 2) {
  await db.collection("trips").doc(id).set({
    id,
    driverId: riderA.uid,
    role: "request",
    status: "pending",
    departure_time: Timestamp.fromDate(new Date(Date.now() + 86_400_000)),
    available_seats: seats,
    total_seats: seats,
    passenger_ids: [],
    price_per_seat: 30,
    origin_address: "Dallas",
    destination_address: "Austin",
  });
}

before(async () => {
  [driver, riderA, riderB, unverified] = await Promise.all([
    account("driver"), account("rider-a"), account("rider-b"), account("unverified"),
  ]);
  await Promise.all([
    seedVerified(driver.uid, true),
    seedVerified(riderA.uid),
    seedVerified(riderB.uid),
    seedAccount(driver.uid, ["driver", "courier"]),
    seedAccount(riderA.uid, ["rider", "sender"]),
    seedAccount(riderB.uid, ["rider", "sender"]),
    seedAccount(unverified.uid, ["rider", "sender"]),
  ]);
});

after(async () => {
  await Promise.all(clientApps.map((app) => deleteApp(app)));
  await Promise.all(getApps().map((app) => deleteAdminApp(app)));
});

test("verified rider can publish only a request", async () => {
  const published = await callable(
    "createTrip",
    riderA.token,
    createTripPayload("request"),
  );
  assert.equal(published.ok, true);
  assert.equal(published.body.result.status, "pending");

  const flipped = await callable(
    "createTrip",
    riderA.token,
    createTripPayload("offer"),
  );
  assert.equal(flipped.ok, false);
});

test("unverified rider cannot publish a request", async () => {
  const result = await callable(
    "createTrip",
    unverified.token,
    createTripPayload("request"),
  );
  assert.equal(result.ok, false);
});

test("owner withdrawal cancels unpaid interest but rejects paid trips", async () => {
  const openTripId = `withdraw-open-${Date.now()}`;
  await seedTrip(openTripId, 2);
  const pending = await callable("createBooking", riderA.token, {
    schemaVersion: 1,
    tripId: openTripId,
    seats: 1,
  });
  assert.equal(pending.ok, true);
  const unauthorized = await callable("withdrawTrip", riderA.token, {
    schemaVersion: 1,
    tripId: openTripId,
  });
  assert.equal(unauthorized.ok, false);

  const withdrawn = await callable("withdrawTrip", driver.token, {
    schemaVersion: 1,
    tripId: openTripId,
  });
  assert.equal(withdrawn.ok, true);
  assert.equal(withdrawn.body.result.status, "cancelled");
  assert.equal((await db.collection("trips").doc(openTripId).get()).data().status, "cancelled");
  const openBookings = await db.collection("bookings").where("tripId", "==", openTripId).get();
  assert.equal(openBookings.docs.length, 1);
  assert.equal(openBookings.docs[0].data().status, "cancelled");

  const paidTripId = `withdraw-paid-${Date.now()}`;
  await seedTrip(paidTripId, 1);
  const paidPending = await callable("createBooking", riderB.token, {
    schemaVersion: 1,
    tripId: paidTripId,
    seats: 1,
  });
  assert.equal(paidPending.ok, true);
  await db.collection("bookings").doc(paidPending.body.result.bookingId).update({
    status: "confirmed",
    paymentStatus: "paid",
  });
  const paidWithdrawal = await callable("withdrawTrip", driver.token, {
    schemaVersion: 1,
    tripId: paidTripId,
  });
  assert.equal(paidWithdrawal.ok, false);
  assert.equal((await db.collection("trips").doc(paidTripId).get()).data().status, "pending");
});

test("potential requests do not reserve inventory or authorize chat", async () => {
  const tripId = `integration-final-seat-${Date.now()}`;
  await seedTrip(tripId, 1);
  const [first, second] = await Promise.all([
    callable("createBooking", riderA.token, {schemaVersion: 1, tripId, seats: 1}),
    callable("createBooking", riderB.token, {schemaVersion: 1, tripId, seats: 1}),
  ]);
  assert.equal([first, second].filter((result) => result.ok).length, 2);
  const trip = await db.collection("trips").doc(tripId).get();
  assert.equal(trip.data().available_seats, 1);
  const bookings = await db.collection("bookings").where("tripId", "==", tripId).get();
  assert.equal(bookings.size, 2);
  for (const booking of bookings.docs) {
    assert.equal(booking.data().status, "pending_payment");
    assert.equal(booking.data().paymentStatus, "required");
    assert.equal(booking.data().conversationId, null);
  }
  const authorizations = await db.collection("conversation_authorizations")
    .where("tripId", "==", tripId).get();
  assert.equal(authorizations.size, 0);
});

test("duplicate booking is idempotent and pending cancellation leaves inventory", async () => {
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
  assert.equal(booking.data().conversationId, null);
});

test("only a paid confirmed booking opens chat and paid cancellation restores inventory", async () => {
  const tripId = `integration-paid-chat-${Date.now()}`;
  await seedTrip(tripId, 1);
  const pending = await callable("createBooking", riderA.token, {
    schemaVersion: 1,
    tripId,
    seats: 1,
  });
  assert.equal(pending.ok, true);
  const bookingId = pending.body.result.bookingId;

  // Simulate the trusted payment-provider finalizer. No client is allowed to
  // make these writes in production.
  await Promise.all([
    db.collection("bookings").doc(bookingId).update({
      status: "confirmed",
      paymentStatus: "paid",
    }),
    db.collection("trips").doc(tripId).update({
      available_seats: 0,
      passenger_ids: [riderA.uid],
    }),
  ]);

  const authorized = await callable("authorizeBookingConversation", riderA.token, {
    bookingId,
  });
  assert.equal(authorized.ok, true);
  const conversationId = authorized.body.result.conversationId;
  const authorization = await db.collection("conversation_authorizations")
    .doc(conversationId).get();
  assert.equal(authorization.data().active, true);
  assert.equal(authorization.data().source, "booking");
  assert.equal(authorization.data().paymentStatus, "paid");

  const cancelled = await callable("cancelBooking", riderA.token, {
    schemaVersion: 1,
    tripId,
    seats: 1,
  });
  assert.equal(cancelled.ok, true);
  const [trip, closedAuthorization] = await Promise.all([
    db.collection("trips").doc(tripId).get(),
    db.collection("conversation_authorizations").doc(conversationId).get(),
  ]);
  assert.equal(trip.data().available_seats, 1);
  assert.equal(closedAuthorization.data().active, false);
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

test("driver proposal remains potential until the rider selects and pays", async () => {
  const tripId = `integration-request-proposal-${Date.now()}`;
  await seedRequest(tripId, 2);

  const proposed = await callable("proposeForTripRequest", driver.token, {
    schemaVersion: 1,
    tripId,
    proposedUnitPrice: 25,
    message: "I can drive this route. Call 555-555-1212",
  });
  assert.equal(proposed.ok, true);
  assert.equal(proposed.body.result.status, "potential");
  assert.equal(proposed.body.result.paymentStatus, "awaiting_passenger");
  const bookingId = proposed.body.result.bookingId;

  const [potentialBooking, unchangedTrip] = await Promise.all([
    db.collection("bookings").doc(bookingId).get(),
    db.collection("trips").doc(tripId).get(),
  ]);
  assert.equal(potentialBooking.data().driverId, driver.uid);
  assert.equal(potentialBooking.data().passengerId, riderA.uid);
  assert.equal(potentialBooking.data().conversationId, null);
  assert.equal(potentialBooking.data().seatsBooked, 2);
  assert.equal(potentialBooking.data().totalPrice, 50);
  assert.ok(!potentialBooking.data().negotiationMessage.includes("555-555-1212"));
  assert.equal(unchangedTrip.data().available_seats, 2);

  const chatBeforePayment = await callable(
    "authorizeBookingConversation",
    riderA.token,
    {bookingId},
  );
  assert.equal(chatBeforePayment.ok, false);

  const unauthorizedSelection = await callable(
    "selectTripProposal",
    riderB.token,
    {schemaVersion: 1, bookingId},
  );
  assert.equal(unauthorizedSelection.ok, false);

  const selected = await callable("selectTripProposal", riderA.token, {
    schemaVersion: 1,
    bookingId,
  });
  assert.equal(selected.ok, true);
  assert.equal(selected.body.result.status, "pending_payment");
  assert.equal(selected.body.result.paymentStatus, "required");

  const [selectedBooking, selectedTrip, authorizations] = await Promise.all([
    db.collection("bookings").doc(bookingId).get(),
    db.collection("trips").doc(tripId).get(),
    db.collection("conversation_authorizations").where("tripId", "==", tripId).get(),
  ]);
  assert.equal(selectedBooking.data().status, "pending_payment");
  assert.equal(selectedBooking.data().paymentStatus, "required");
  assert.equal(selectedBooking.data().conversationId, null);
  assert.equal(selectedTrip.data().selectedBookingId, bookingId);
  assert.equal(selectedTrip.data().available_seats, 2);
  assert.equal(authorizations.size, 0);
});

test("paid trip starts, keeps chat active, completes, closes chat, and allows one rating", async () => {
  const tripId = `integration-lifecycle-${Date.now()}`;
  await seedTrip(tripId, 1);
  const pending = await callable("createBooking", riderA.token, {
    schemaVersion: 1,
    tripId,
    seats: 1,
  });
  assert.equal(pending.ok, true);
  const bookingId = pending.body.result.bookingId;
  await Promise.all([
    db.collection("bookings").doc(bookingId).update({
      status: "confirmed",
      paymentStatus: "paid",
    }),
    db.collection("trips").doc(tripId).update({
      available_seats: 0,
      passenger_ids: [riderA.uid],
    }),
  ]);

  const unauthorizedStart = await callable("startTrip", riderA.token, {
    schemaVersion: 1,
    bookingId,
  });
  assert.equal(unauthorizedStart.ok, false);

  const started = await callable("startTrip", driver.token, {
    schemaVersion: 1,
    bookingId,
  });
  assert.equal(started.ok, true);
  assert.equal(started.body.result.status, "in_progress");
  const chatWhileMoving = await callable("authorizeBookingConversation", riderA.token, {
    schemaVersion: 1,
    bookingId,
  });
  assert.equal(chatWhileMoving.ok, true);
  const conversationId = chatWhileMoving.body.result.conversationId;

  const completed = await callable("completeTrip", driver.token, {
    schemaVersion: 1,
    bookingId,
  });
  assert.equal(completed.ok, true);
  const [trip, booking, authorization] = await Promise.all([
    db.collection("trips").doc(tripId).get(),
    db.collection("bookings").doc(bookingId).get(),
    db.collection("conversation_authorizations").doc(conversationId).get(),
  ]);
  assert.equal(trip.data().status, "completed");
  assert.equal(booking.data().status, "completed");
  assert.equal(authorization.data().active, false);

  const chatAfterCompletion = await callable(
    "authorizeBookingConversation",
    riderA.token,
    {schemaVersion: 1, bookingId},
  );
  assert.equal(chatAfterCompletion.ok, false);

  const rated = await callable("submitTripRating", riderA.token, {
    schemaVersion: 1,
    bookingId,
    rating: 5,
    review: "Great trip",
    tags: ["Punctual"],
  });
  assert.equal(rated.ok, true);
  const duplicateRating = await callable("submitTripRating", riderA.token, {
    schemaVersion: 1,
    bookingId,
    rating: 4,
    review: "Changed mind",
    tags: [],
  });
  assert.equal(duplicateRating.ok, false);
});

test("driver emergency cancellation closes chat and opens urgent admin review", async () => {
  const tripId = `integration-emergency-${Date.now()}`;
  await seedTrip(tripId, 1);
  const pending = await callable("createBooking", riderA.token, {
    schemaVersion: 1,
    tripId,
    seats: 1,
  });
  const bookingId = pending.body.result.bookingId;
  await db.collection("bookings").doc(bookingId).update({
    status: "confirmed",
    paymentStatus: "paid",
  });
  const chat = await callable("authorizeBookingConversation", driver.token, {bookingId});
  assert.equal(chat.ok, true);
  const cancelled = await callable("cancelTrip", driver.token, {
    schemaVersion: 1,
    bookingId,
  });
  assert.equal(cancelled.ok, true);
  assert.equal(cancelled.body.result.refundStatus, "staff_review");
  const [booking, authorization, events] = await Promise.all([
    db.collection("bookings").doc(bookingId).get(),
    db.collection("conversation_authorizations").doc(chat.body.result.conversationId).get(),
    db.collection("admin_events").where("tripId", "==", tripId).get(),
  ]);
  assert.equal(booking.data().status, "cancelled");
  assert.equal(booking.data().paymentStatus, "refund_pending");
  assert.equal(authorization.data().active, false);
  assert.equal(events.size, 1);
  assert.equal(events.docs[0].data().priority, "urgent");
});

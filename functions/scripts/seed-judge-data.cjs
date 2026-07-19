/* Idempotent Build Week judge-data seeder; never accepts passwords. */
const {getApps, initializeApp} = require("firebase-admin/app");
const {getAuth} = require("firebase-admin/auth");
const {getFirestore} = require("firebase-admin/firestore");

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
if (require.main === module && process.env.SEED_JUDGE_DATA !== EXPECTED_PROJECT) {
  fail(`SEED_JUDGE_DATA must equal ${EXPECTED_PROJECT} for standalone use.`);
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

function fixedJudgeDate(hour, minute = 0) {
  // Keep the test build useful through the conservative August 9 judging window.
  const localUtc = Date.UTC(2026, 7, 10, hour, minute);
  return new Date(localUtc - offsetMinutes * 60_000);
}

function trip({id, owner, type, role = "offer", origin, destination, departure,
  price, seats, allowPets = false, allowSmoking = false,
  packageWeight = null, description}) {
  const now = new Date();
  return {
    id, type, role, driverId: owner, passengerId: null,
    origin_address: origin, destination_address: destination,
    origin_lat: 0, origin_lng: 0, destination_lat: 0, destination_lng: 0,
    departure_time: departure, distance: 0,
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

function firestoreValue(value) {
  if (value === null) return {nullValue: null};
  if (value instanceof Date) return {timestampValue: value.toISOString()};
  if (Array.isArray(value)) {
    return {arrayValue: {values: value.map(firestoreValue)}};
  }
  if (typeof value === "boolean") return {booleanValue: value};
  if (typeof value === "number") {
    return Number.isInteger(value) ?
      {integerValue: String(value)} : {doubleValue: value};
  }
  if (typeof value === "string") return {stringValue: value};
  if (typeof value === "object") {
    return {mapValue: {fields: firestoreFields(value)}};
  }
  throw new TypeError("Unsupported judge fixture value.");
}

function firestoreFields(value) {
  return Object.fromEntries(
    Object.entries(value).map(([key, item]) => [key, firestoreValue(item)]),
  );
}

async function commitWithAccessToken(documents, accessToken) {
  const root = `projects/${EXPECTED_PROJECT}/databases/(default)/documents`;
  const writes = documents.map(({collection, id, value}) => ({
    update: {
      name: `${root}/${collection}/${encodeURIComponent(id)}`,
      fields: firestoreFields(value),
    },
  }));
  const response = await fetch(
    `https://firestore.googleapis.com/v1/${root}:commit`,
    {
      method: "POST",
      headers: {
        authorization: `Bearer ${accessToken}`,
        "content-type": "application/json",
        "x-goog-user-project": EXPECTED_PROJECT,
      },
      body: JSON.stringify({writes}),
    },
  );
  if (!response.ok) {
    throw new Error(`Firestore REST commit returned HTTP ${response.status}.`);
  }
}

async function hasJudgeBookingsWithAccessToken(tripIds, accessToken) {
  const root = `projects/${EXPECTED_PROJECT}/databases/(default)/documents`;
  const response = await fetch(
    `https://firestore.googleapis.com/v1/${root}:runQuery`,
    {
      method: "POST",
      headers: {
        authorization: `Bearer ${accessToken}`,
        "content-type": "application/json",
        "x-goog-user-project": EXPECTED_PROJECT,
      },
      body: JSON.stringify({
        structuredQuery: {
          from: [{collectionId: "bookings"}],
          where: {
            fieldFilter: {
              field: {fieldPath: "tripId"},
              op: "IN",
              value: {
                arrayValue: {
                  values: tripIds.map((tripId) => ({stringValue: tripId})),
                },
              },
            },
          },
          limit: 1,
        },
      }),
    },
  );
  if (!response.ok) {
    throw new Error(`Firestore judge-booking check returned HTTP ${response.status}.`);
  }
  const results = await response.json();
  return Array.isArray(results) && results.some((result) => result.document);
}

async function refuseDestructiveReseed(tripIds, accessToken) {
  if (process.env.RESET_JUDGE_DATA === EXPECTED_PROJECT) return;
  let hasBookings;
  if (accessToken) {
    hasBookings = await hasJudgeBookingsWithAccessToken(tripIds, accessToken);
  } else {
    if (getApps().length === 0) initializeApp({projectId: EXPECTED_PROJECT});
    const snapshot = await getFirestore()
      .collection("bookings")
      .where("tripId", "in", tripIds)
      .limit(1)
      .get();
    hasBookings = !snapshot.empty;
  }
  if (hasBookings) {
    fail(
      `judge bookings already exist; set RESET_JUDGE_DATA=${EXPECTED_PROJECT} ` +
      "only after intentionally clearing the fictional test flow."
    );
  }
}

async function main({accessToken, driverEmail, riderEmail} = {}) {
  const fixtures = [
    trip({id: "build_week_judge_dallas_austin_0900", owner: driverUid,
      type: "person", origin: "Dallas, Texas", destination: "Austin, Texas",
      departure: fixedJudgeDate(9), price: 18, seats: 3, allowSmoking: false,
      description: "Judge fixture: morning non-smoking ride."}),
    trip({id: "build_week_judge_dallas_austin_1200", owner: driverUid,
      type: "person", origin: "Downtown Dallas, Texas",
      destination: "Central Austin, Texas", departure: fixedJudgeDate(12),
      price: 24, seats: 2, allowPets: true,
      description: "Judge fixture: later pet-friendly ride."}),
    trip({id: "build_week_judge_chicago_milwaukee_package", owner: driverUid,
      type: "package", origin: "Chicago, Illinois",
      destination: "Milwaukee, Wisconsin", departure: fixedJudgeDate(10),
      price: 12, seats: 1, packageWeight: 10,
      description: "Judge fixture: package capacity up to 10 kg."}),
    trip({id: "build_week_judge_dallas_houston_request", owner: riderUid,
      type: "person", role: "request", origin: "Dallas, Texas",
      destination: "Houston, Texas", departure: fixedJudgeDate(18),
      price: 30, seats: 2, allowSmoking: false,
      description: "Judge fixture: evening ride request."}),
  ];

  await refuseDestructiveReseed(
    fixtures.map((fixture) => fixture.id),
    accessToken,
  );

  const documents = [];
  for (const fixture of fixtures) {
    documents.push({collection: "trips", id: fixture.id, value: fixture});
    documents.push({collection: "public_trips", id: fixture.id,
      value: publicTrip(fixture)});
  }
  const verified = {identityVerified: true, selfieWithIdVerified: true,
    emailVerified: true, buildWeekJudgeFixture: true, updatedAt: new Date()};
  documents.push({collection: "verifications", id: driverUid, value: {
    ...verified, userId: driverUid, driverLicenseVerified: true,
    vehicleVerified: true,
  }});
  documents.push({collection: "verifications", id: riderUid,
    value: {...verified, userId: riderUid}});
  const publicBase = {photoUrl: null, roles: [], rating: 5,
    totalRatings: 0, totalTrips: 0, createdAt: new Date(),
    updatedAt: new Date()};
  documents.push({collection: "public_profiles", id: driverUid, value: {
    ...publicBase, id: driverUid, name: "Judge Driver", roles: ["driver"],
  }});
  documents.push({collection: "public_profiles", id: riderUid, value: {
    ...publicBase, id: riderUid, name: "Judge Rider", roles: ["rider"],
  }});

  if (accessToken) {
    if (typeof driverEmail !== "string" || typeof riderEmail !== "string") {
      throw new Error("Provisioned judge account emails are required.");
    }
    const privateBase = {
      phone: null,
      photoUrl: null,
      isEmailVerified: true,
      isPhoneVerified: false,
      rating: 5,
      totalRatings: 0,
      totalTrips: 0,
      isVerified: false,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      buildWeekJudgeFixture: true,
    };
    documents.push({collection: "users", id: driverUid, value: {
      ...privateBase,
      id: driverUid,
      email: driverEmail,
      name: "Judge Driver",
      roles: ["driver"],
    }});
    documents.push({collection: "users", id: riderUid, value: {
      ...privateBase,
      id: riderUid,
      email: riderEmail,
      name: "Judge Rider",
      roles: ["rider"],
    }});
  }

  if (accessToken) {
    await commitWithAccessToken(documents, accessToken);
  } else {
    if (getApps().length === 0) initializeApp({projectId: EXPECTED_PROJECT});
    const [driver, rider] = await Promise.all([
      getAuth().getUser(driverUid),
      getAuth().getUser(riderUid),
    ]);
    if (driver.displayName !== "Judge Driver" ||
        rider.displayName !== "Judge Rider" ||
        driver.emailVerified !== true || rider.emailVerified !== true) {
      fail("standalone UIDs must identify the verified fictional judge accounts.");
    }
    const db = getFirestore();
    const batch = db.batch();
    for (const document of documents) {
      batch.set(db.collection(document.collection).doc(document.id),
        document.value, {merge: false});
    }
    await batch.commit();
  }
  process.stdout.write(`Upserted ${fixtures.length} private/public trip fixtures and the fictional judge profiles in ${EXPECTED_PROJECT}.\n`);
}

if (require.main === module) {
  main().catch((error) => {
    process.stderr.write(`Judge seed failed (${error?.name || "Error"}). No credentials were logged.\n`);
    process.exitCode = 1;
  });
}

module.exports = {seedJudgeData: main};

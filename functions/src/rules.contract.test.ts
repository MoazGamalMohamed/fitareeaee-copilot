import assert from "node:assert/strict";
import {after, before, beforeEach, test} from "node:test";
import {readFileSync} from "node:fs";
import {resolve} from "node:path";
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import {doc, getDoc, setDoc, updateDoc} from "firebase/firestore";
import {ref, uploadBytes} from "firebase/storage";

let environment: RulesTestEnvironment;

before(async () => {
  environment = await initializeTestEnvironment({
    projectId: "fitareeaee",
    firestore: {
      rules: readFileSync(resolve(process.cwd(), "../firestore.rules"), "utf8"),
    },
    storage: {
      rules: readFileSync(resolve(process.cwd(), "../storage.rules"), "utf8"),
    },
  });
});

beforeEach(async () => {
  await environment.clearFirestore();
  await environment.clearStorage();
});

after(async () => {
  await environment.cleanup();
});

async function seed(path: string, data: Record<string, unknown>): Promise<void> {
  await environment.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), path), data);
  });
}

test("users cannot write another user's profile", async () => {
  const rider = environment.authenticatedContext("rider").firestore();
  await assertSucceeds(
    setDoc(doc(rider, "users/rider"), {
      id: "rider",
      isVerified: false,
      isEmailVerified: false,
      isPhoneVerified: false,
      rating: 5,
      totalRatings: 0,
      totalTrips: 0,
      name: "Judge Rider",
    })
  );
  await assertFails(
    setDoc(doc(rider, "users/other"), {
      id: "other",
      isVerified: false,
      name: "Spoofed",
    })
  );
});

test("private profiles stay private and trust fields are server-owned", async () => {
  await seed("users/rider", {
    id: "rider",
    isVerified: false,
    isEmailVerified: false,
    isPhoneVerified: false,
    rating: 5,
    totalRatings: 0,
    totalTrips: 0,
    name: "Judge Rider",
  });
  await seed("public_profiles/rider", {
    id: "rider",
    name: "Judge Rider",
    rating: 5,
    totalRatings: 0,
    totalTrips: 0,
  });
  const rider = environment.authenticatedContext("rider").firestore();
  const outsider = environment.authenticatedContext("outsider").firestore();
  await assertSucceeds(getDoc(doc(rider, "users/rider")));
  await assertFails(getDoc(doc(outsider, "users/rider")));
  await assertSucceeds(getDoc(doc(outsider, "public_profiles/rider")));
  await assertFails(updateDoc(doc(rider, "users/rider"), {rating: 5.5}));
  await assertSucceeds(updateDoc(doc(rider, "users/rider"), {name: "Updated Rider"}));
});

test("trip owners cannot change server-owned seat inventory", async () => {
  await seed("trips/trip-1", {
    id: "trip-1",
    driverId: "driver",
    status: "pending",
    total_seats: 3,
    available_seats: 3,
    passenger_ids: [],
  });
  await seed("public_trips/trip-1", {
    id: "trip-1",
    driverId: "driver",
    status: "pending",
    available_seats: 3,
  });
  const driver = environment.authenticatedContext("driver").firestore();
  const rider = environment.authenticatedContext("rider").firestore();
  await assertSucceeds(getDoc(doc(driver, "trips/trip-1")));
  await assertFails(getDoc(doc(rider, "trips/trip-1")));
  await assertSucceeds(getDoc(doc(rider, "public_trips/trip-1")));
  await assertFails(
    updateDoc(doc(driver, "trips/trip-1"), {available_seats: 2})
  );
});

test("clients cannot create bookings, approve verification, or alter AI limits", async () => {
  const rider = environment.authenticatedContext("rider").firestore();
  await assertFails(
    setDoc(doc(rider, "bookings/forged"), {
      passengerId: "rider",
      driverId: "driver",
      tripId: "trip-1",
    })
  );
  await assertFails(
    setDoc(doc(rider, "verifications/rider"), {
      identityVerified: true,
      selfieWithIdVerified: true,
    })
  );
  await assertFails(
    setDoc(doc(rider, "copilot_rate_limits/rider"), {
      count: 0,
    })
  );
});

test("messages are participant-scoped and sender identity is enforced", async () => {
  const rider = environment.authenticatedContext("rider").firestore();
  const outsider = environment.authenticatedContext("outsider").firestore();
  const message = {
    id: "message-1",
    sender_id: "rider",
    recipient_id: "driver",
    participant_ids: ["driver", "rider"],
    conversation_id: "driver_rider",
    content: "Hello",
    attachments: [],
    created_at: new Date(),
    is_read: false,
    read_at: null,
    is_deleted: false,
  };
  await seed("conversation_authorizations/driver_rider", {
    id: "driver_rider",
    participant_ids: ["driver", "rider"],
  });
  await assertSucceeds(setDoc(doc(rider, "messages/message-1"), message));
  await assertFails(getDoc(doc(outsider, "messages/message-1")));
  await assertFails(
    setDoc(doc(rider, "messages/spoofed"), {...message, sender_id: "driver"})
  );
  await assertFails(
    setDoc(doc(rider, "messages/malformed"), {
      ...message,
      id: "malformed",
      content: 42,
    })
  );
  await assertFails(
    setDoc(doc(rider, "messages/unsolicited"), {
      ...message,
      id: "unsolicited",
      recipient_id: "outsider",
      participant_ids: ["outsider", "rider"],
      conversation_id: "outsider_rider",
    })
  );
});

test("payment and wallet writes are denied", async () => {
  const rider = environment.authenticatedContext("rider").firestore();
  await assertFails(
    setDoc(doc(rider, "payments/payment-1"), {
      payerId: "rider",
      amount: 100,
    })
  );
  await assertFails(
    setDoc(doc(rider, "wallets/rider"), {userId: "rider", balance: 100})
  );
});

test("storage limits verification uploads to the owning user and images", async () => {
  const riderStorage = environment.authenticatedContext("rider").storage();
  const otherStorage = environment.authenticatedContext("other").storage();
  const image = new Uint8Array([1, 2, 3]);
  await assertSucceeds(
    uploadBytes(
      ref(riderStorage, "verification_documents/rider/id.jpg"),
      image,
      {contentType: "image/jpeg"}
    )
  );
  await assertFails(
    uploadBytes(
      ref(otherStorage, "verification_documents/rider/other.jpg"),
      image,
      {contentType: "image/jpeg"}
    )
  );
  await assertFails(
    uploadBytes(
      ref(riderStorage, "verification_documents/rider/id.txt"),
      image,
      {contentType: "text/plain"}
    )
  );
  assert.equal(image.length, 3);
});

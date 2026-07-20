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
import {
  collection,
  doc,
  getDoc,
  getDocs,
  query,
  setDoc,
  updateDoc,
  where,
} from "firebase/firestore";
import {deleteObject, ref, uploadBytes} from "firebase/storage";

let environment: RulesTestEnvironment;

before(async () => {
  environment = await initializeTestEnvironment({
    projectId: "fitareeaee",
    firestore: {
      rules: readFileSync(resolve(__dirname, "../../firestore.rules"), "utf8"),
    },
    storage: {
      rules: readFileSync(resolve(__dirname, "../../storage.rules"), "utf8"),
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
  const mixed = environment.authenticatedContext("mixed").firestore();
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
      roles: ["rider", "sender"],
    })
  );
  await assertFails(
    setDoc(doc(mixed, "users/mixed"), {
      id: "mixed",
      isVerified: false,
      isEmailVerified: false,
      isPhoneVerified: false,
      rating: 5,
      totalRatings: 0,
      totalTrips: 0,
      name: "Mixed Role",
      roles: ["rider", "driver"],
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
  await assertSucceeds(
    updateDoc(doc(rider, "users/rider"), {
      photoUrl: "https://firebasestorage.googleapis.com/v0/b/fitareeaee.firebasestorage.app/o/avatars%2Frider%2Fprofile.jpg?alt=media&token=judge_avatar-token",
    })
  );
  await assertFails(
    updateDoc(doc(rider, "users/rider"), {
      photoUrl: "https://tracking.example/avatar.png",
    })
  );
  await assertFails(
    updateDoc(doc(rider, "users/rider"), {
      photoUrl: "https://firebasestorage.googleapis.com/v0/b/fitareeaee.firebasestorage.app/o/avatars%2Foutsider%2Fprofile.jpg?alt=media&token=other_avatar-token",
    })
  );
  await assertSucceeds(
    updateDoc(doc(rider, "users/rider"), {photoUrl: null})
  );
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
    conversation_id: "trip-1__driver_rider",
    content: "Hello",
    attachments: [],
    created_at: new Date(),
    is_read: false,
    read_at: null,
    is_deleted: false,
  };
  await seed("conversation_authorizations/trip-1__driver_rider", {
    id: "trip-1__driver_rider",
    participant_ids: ["driver", "rider"],
    tripId: "trip-1",
    bookingId: "booking-1",
    source: "booking",
    active: true,
  });
  await seed("bookings/booking-1", {
    passengerId: "rider",
    driverId: "driver",
    tripId: "trip-1",
    status: "confirmed",
    paymentStatus: "paid",
  });
  await seed("messages/legacy-mismatch", {
    ...message,
    id: "legacy-mismatch",
    recipient_id: "outsider",
    participant_ids: ["outsider", "rider"],
  });
  await assertSucceeds(setDoc(doc(rider, "messages/message-1"), message));
  const authorizations = await assertSucceeds(
    getDocs(
      query(
        collection(rider, "conversation_authorizations"),
        where("participant_ids", "array-contains", "rider")
      )
    )
  );
  assert.equal(authorizations.size, 1);
  const listedConversation = await assertSucceeds(
    getDocs(
      query(
        collection(rider, "messages"),
        where("participant_ids", "array-contains", "rider")
      )
    )
  );
  // List queries expose only documents whose participant array contains the
  // caller. The repository then cross-checks that array against the server-
  // owned authorization so legacy malformed records cannot enter a chat.
  assert.equal(listedConversation.size, 2);
  await assertFails(getDoc(doc(outsider, "messages/message-1")));
  await assertFails(getDoc(doc(rider, "messages/legacy-mismatch")));
  await assertFails(
    updateDoc(doc(rider, "messages/legacy-mismatch"), {
      is_read: true,
      read_at: new Date(),
    })
  );
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
  await seed("conversation_authorizations/trip-old__driver_rider", {
    id: "trip-old__driver_rider",
    participant_ids: ["driver", "rider"],
    tripId: "trip-old",
    active: false,
  });
  await assertFails(
    setDoc(doc(rider, "messages/inactive"), {
      ...message,
      id: "inactive",
      conversation_id: "trip-old__driver_rider",
    })
  );
  await seed("conversation_authorizations/trip-unpaid__driver_rider", {
    id: "trip-unpaid__driver_rider",
    participant_ids: ["driver", "rider"],
    tripId: "trip-unpaid",
    bookingId: "booking-unpaid",
    source: "booking",
    active: true,
  });
  await seed("bookings/booking-unpaid", {
    passengerId: "rider",
    driverId: "driver",
    tripId: "trip-unpaid",
    status: "pending_payment",
    paymentStatus: "required",
  });
  await assertFails(
    setDoc(doc(rider, "messages/unpaid"), {
      ...message,
      id: "unpaid",
      conversation_id: "trip-unpaid__driver_rider",
    })
  );
});

test("support tickets are owner-scoped and users cannot spoof staff", async () => {
  const rider = environment.authenticatedContext("rider").firestore();
  const outsider = environment.authenticatedContext("outsider").firestore();
  const ticket = {
    userId: "rider",
    tripId: null,
    category: "trip",
    status: "open",
    subject: "Chat problem",
    description: "The confirmed trip chat will not open.",
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
  await assertFails(setDoc(doc(rider, "support_tickets/forged"), ticket));
  await seed("support_tickets/ticket-1", ticket);
  await assertSucceeds(getDoc(doc(rider, "support_tickets/ticket-1")));
  await assertFails(getDoc(doc(outsider, "support_tickets/ticket-1")));
  await assertFails(
    setDoc(doc(rider, "support_tickets/ticket-1/messages/message-1"), {
      ticketId: "ticket-1",
      senderId: "rider",
      senderName: "Judge Rider",
      isStaff: false,
      message: "Please help.",
      createdAt: new Date().toISOString(),
    })
  );
  await assertFails(
    setDoc(doc(rider, "support_tickets/ticket-1/messages/staff-spoof"), {
      ticketId: "ticket-1",
      senderId: "rider",
      senderName: "Fake Staff",
      isStaff: true,
      message: "I approve this.",
      createdAt: new Date().toISOString(),
    })
  );
  await assertFails(
    setDoc(doc(rider, "support_ai_rate_limits/rider"), {count: 0})
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

test("ratings are server-owned and urgent events are admin-only", async () => {
  await seed("admins/admin", {isAdmin: true});
  await seed("ratings/booking-1_rider", {
    id: "booking-1_rider",
    bookingId: "booking-1",
    tripId: "trip-1",
    ratedByUserId: "rider",
    ratedUserId: "driver",
    rating: 5,
    createdAt: new Date(),
  });
  await seed("admin_events/event-1", {
    type: "emergency_trip_cancellation",
    tripId: "trip-1",
    status: "open",
    createdAt: new Date(),
  });
  const rider = environment.authenticatedContext("rider").firestore();
  const outsider = environment.authenticatedContext("outsider").firestore();
  const admin = environment.authenticatedContext("admin").firestore();
  await assertSucceeds(
    getDoc(doc(rider, "ratings/not-yet-rated-booking_rider"))
  );
  await assertSucceeds(getDoc(doc(rider, "ratings/booking-1_rider")));
  await assertFails(getDoc(doc(outsider, "ratings/booking-1_rider")));
  await assertFails(
    setDoc(doc(rider, "ratings/forged"), {
      ratedByUserId: "rider",
      ratedUserId: "driver",
      rating: 5,
    })
  );
  await assertSucceeds(getDocs(collection(admin, "admin_events")));
  await assertFails(getDocs(collection(rider, "admin_events")));
});

test("storage limits verification uploads to the owning user and images", async () => {
  const riderStorage = environment.authenticatedContext("rider").storage();
  const otherStorage = environment.authenticatedContext("other").storage();
  const image = new Uint8Array([1, 2, 3]);
  await assertSucceeds(
    uploadBytes(
      ref(riderStorage, "verification_documents/rider/identity.jpg"),
      image,
      {contentType: "image/jpeg"}
    )
  );
  await assertFails(
    deleteObject(ref(otherStorage, "verification_documents/rider/identity.jpg"))
  );
  await assertSucceeds(
    deleteObject(ref(riderStorage, "verification_documents/rider/identity.jpg"))
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
  await assertFails(
    uploadBytes(
      ref(riderStorage, "verification_documents/rider/random.jpg"),
      image,
      {contentType: "image/jpeg"}
    )
  );
  await assertFails(
    uploadBytes(
      ref(riderStorage, "avatars/rider/not-profile.jpg"),
      image,
      {contentType: "image/jpeg"}
    )
  );
  assert.equal(image.length, 3);
});

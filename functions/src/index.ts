import {getApps, initializeApp} from "firebase-admin/app";

if (getApps().length === 0) {
  initializeApp();
}

export {cancelBooking, createBooking} from "./booking";
export {planTripWithCopilot} from "./copilot";
export {
  reviewVerification,
  submitVerification,
  syncContactVerification,
} from "./verification";
export {syncPublicProfile} from "./publicProfile";
export {syncPublicTrip} from "./publicTrip";
export {authorizeTripConversation} from "./conversation";

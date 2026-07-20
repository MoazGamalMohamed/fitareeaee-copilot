import {getApps, initializeApp} from "firebase-admin/app";

if (getApps().length === 0) {
  initializeApp();
}

export {cancelBooking, createBooking} from "./booking";
export {planTripWithCopilot} from "./copilot";
export {createTrip} from "./trip";
export {cancelTrip, completeTrip, startTrip, submitTripRating} from "./lifecycle";
export {
  proposeForTripRequest,
  selectTripProposal,
  withdrawTripProposal,
} from "./matching";
export {
  contactSupport,
  escalateSupportTicket,
  sendSupportMessage,
} from "./support";
export {
  reviewVerification,
  submitVerification,
  syncContactVerification,
} from "./verification";
export {syncPublicProfile} from "./publicProfile";
export {syncPublicTrip} from "./publicTrip";
export {
  authorizeBookingConversation,
  authorizeTripConversation,
} from "./conversation";

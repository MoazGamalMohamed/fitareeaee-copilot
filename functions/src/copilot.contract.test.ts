import assert from "node:assert/strict";
import test from "node:test";
import {
  authenticatedUid,
  nextRateLimitState,
  parsePlanRequest,
  redactContactDetails,
  validateDraft,
} from "./copilot";

const validDraft = {
  schemaVersion: 1,
  intent: "find",
  tripType: "ride",
  origin: "Dallas",
  destination: "Austin",
  departureDate: "2026-07-20",
  departureTime: "09:00",
  passengerOrSeatCount: 2,
  packageDetails: null,
  maximumBudget: 40,
  preferences: ["no smoking"],
  assistantSummary: "Ride draft from Dallas to Austin.",
  missingInformation: [],
  clarificationQuestion: null,
  language: "en",
};

test("Copilot request enforces length and normalizes locale", () => {
  const request = parsePlanRequest({
    request: "Dallas to Austin tomorrow",
    locale: "ar",
    timezone: "-05:00",
  });
  assert.equal(request.locale, "ar");
  assert.equal(request.timezone, "-05:00");
  assert.throws(() => parsePlanRequest({request: "go"}));
  assert.throws(() => parsePlanRequest({request: "x".repeat(1201)}));
});

test("Copilot rejects unauthenticated requests before model access", () => {
  assert.throws(() => authenticatedUid(undefined));
  assert.equal(authenticatedUid({uid: "rider"}), "rider");
});

test("Copilot removes email addresses and likely phone numbers", () => {
  const redacted = redactContactDetails("Call +1 (214) 555-0199 or me@example.com");
  assert.equal(redacted.includes("214"), false);
  assert.equal(redacted.includes("example.com"), false);
  assert.equal(redactContactDetails("Use https://example.com/private"), "Use [url removed]");
  assert.equal(redactContactDetails("Call 555-0199"), "Call [number removed]");
  assert.equal(redactContactDetails("اتصل على ٠٥٥١٢٣٤٥٦٧"), "اتصل على [number removed]");
  assert.equal(redactContactDetails("اتصل على ۰۵۵۱۲۳۴۵۶۷"), "اتصل على [number removed]");
  assert.equal(redactContactDetails("Travel on 2026-07-20"), "Travel on 2026-07-20");
  assert.equal(redactContactDetails("السفر ٢٠٢٦-٠٧-٢٠"), "السفر ٢٠٢٦-٠٧-٢٠");
});

test("Copilot accepts a complete strict draft", () => {
  assert.deepEqual(validateDraft(validDraft), validDraft);
});

test("Copilot rejects malformed dates, counts, and unknown fields", () => {
  assert.throws(() => validateDraft({...validDraft, departureTime: "9 AM"}));
  assert.throws(() => validateDraft({...validDraft, departureDate: "2026-99-99"}));
  assert.throws(() => validateDraft({...validDraft, passengerOrSeatCount: 0}));
  assert.throws(() => validateDraft({...validDraft, language: "fr"}));
  assert.throws(() => validateDraft({...validDraft, userId: "private"}));
  assert.throws(() => validateDraft({...validDraft, assistantSummary: null}));
});

test("Copilot accepts Arabic clarification drafts", () => {
  const draft = validateDraft({
    ...validDraft,
    origin: null,
    language: "ar",
    assistantSummary: "مسودة رحلة تحتاج إلى نقطة الانطلاق.",
    missingInformation: ["origin"],
    clarificationQuestion: "من أين ستبدأ الرحلة؟",
  });
  assert.equal(draft.language, "ar");
  assert.equal(draft.origin, null);
});

test("Copilot throttles rapid and excessive authenticated calls", () => {
  assert.throws(() => nextRateLimitState({
    nowMs: 10_000,
    lastRequestMs: 5_000,
    windowStartedMs: 0,
    count: 1,
  }));
  assert.throws(() => nextRateLimitState({
    nowMs: 100_000,
    lastRequestMs: 0,
    windowStartedMs: 1,
    count: 12,
  }));
  assert.deepEqual(nextRateLimitState({
    nowMs: 4_000_000,
    lastRequestMs: 0,
    windowStartedMs: 1,
    count: 12,
  }), {windowStartedMs: 4_000_000, count: 1});
});

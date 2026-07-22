import assert from "node:assert/strict";
import test from "node:test";
import {parseSupportInput, validateSupportAnswer} from "./support";

test("support input keeps only bounded operational fields", () => {
  assert.deepEqual(parseSupportInput({
    schemaVersion: 1,
    category: "technical",
    subject: "Chat failure",
    message: "The conversation will not load.",
    tripId: "trip-1",
  }), {
    schemaVersion: 1,
    category: "technical",
    subject: "Chat failure",
    message: "The conversation will not load.",
    tripId: "trip-1",
  });
  assert.throws(() => parseSupportInput({
    category: "unknown",
    subject: "Help",
    message: "Please help",
  }));
});

test("support answers require a strict escalation decision", () => {
  assert.deepEqual(validateSupportAnswer({
    schemaVersion: 1,
    answer: "Retry once, then escalate if the error continues.",
    shouldEscalate: true,
    urgency: "normal",
  }), {
    schemaVersion: 1,
    answer: "Retry once, then escalate if the error continues.",
    shouldEscalate: true,
    urgency: "normal",
  });
  assert.throws(() => validateSupportAnswer({
    schemaVersion: 1,
    answer: "I approved your refund.",
    shouldEscalate: "yes",
    urgency: "normal",
  }));
});

import assert from "node:assert/strict";
import test from "node:test";
import {parseTripProposal} from "./matching";

test("driver proposal accepts a bounded quote and redacts direct contact details", () => {
  const proposal = parseTripProposal({
    schemaVersion: 1,
    tripId: "request-1",
    proposedUnitPrice: 20,
    message: "I can help. Call 555-555-1212",
  });
  assert.equal(proposal.tripId, "request-1");
  assert.equal(proposal.proposedUnitPrice, 20);
  assert.ok(!proposal.message?.includes("555-555-1212"));
});

test("driver proposal rejects unsafe IDs, prices, and oversized notes", () => {
  assert.throws(() => parseTripProposal({tripId: "bad/id", proposedUnitPrice: 1}));
  assert.throws(() => parseTripProposal({tripId: "request-1", proposedUnitPrice: -1}));
  assert.throws(() => parseTripProposal({
    tripId: "request-1",
    proposedUnitPrice: 1,
    message: "x".repeat(301),
  }));
});

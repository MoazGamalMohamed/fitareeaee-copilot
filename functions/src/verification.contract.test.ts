import assert from "node:assert/strict";
import test from "node:test";
import {parseDocumentType, validateDocumentUrl} from "./verification";

test("verification accepts the four manually reviewed document types", () => {
  assert.equal(parseDocumentType("identity"), "identity");
  assert.equal(parseDocumentType("selfieWithId"), "selfieWithId");
  assert.throws(() => parseDocumentType("email"));
});

test("verification upload must belong to the authenticated user's folder", () => {
  const valid = "verification_documents/rider/identity_1.jpg";
  assert.equal(validateDocumentUrl(valid, "rider"), valid);
  assert.throws(() => validateDocumentUrl(valid, "someone-else"));
  assert.throws(() => validateDocumentUrl("verification_documents/rider/../other.jpg", "rider"));
  assert.throws(() => validateDocumentUrl(
    "verification_documents/rider/subfolder/identity.jpg",
    "rider"
  ));
});

import assert from "node:assert/strict";
import test from "node:test";
import {parseDocumentType, validateDocumentUrl} from "./verification";

test("verification accepts the four manually reviewed document types", () => {
  assert.equal(parseDocumentType("identity"), "identity");
  assert.equal(parseDocumentType("selfieWithId"), "selfieWithId");
  assert.throws(() => parseDocumentType("email"));
});

test("verification upload must belong to the authenticated user's folder", () => {
  const valid = "verification_documents/rider/identity.jpg";
  assert.equal(validateDocumentUrl(valid, "rider", "identity"), valid);
  assert.throws(() => validateDocumentUrl(valid, "someone-else", "identity"));
  assert.throws(() => validateDocumentUrl(valid, "rider", "selfieWithId"));
  assert.throws(() => validateDocumentUrl("verification_documents/rider/../other.jpg", "rider", "identity"));
  assert.throws(() => validateDocumentUrl(
    "verification_documents/rider/subfolder/identity.jpg",
    "rider",
    "identity"
  ));
});

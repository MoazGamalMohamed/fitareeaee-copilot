import assert from "node:assert/strict";
import test from "node:test";
import {parseDocumentType, validateDocumentUrl} from "./verification";

test("verification accepts the four manually reviewed document types", () => {
  assert.equal(parseDocumentType("identity"), "identity");
  assert.equal(parseDocumentType("selfieWithId"), "selfieWithId");
  assert.throws(() => parseDocumentType("email"));
});

test("verification upload must belong to the authenticated user's folder", () => {
  const valid = "https://firebasestorage.googleapis.com/v0/b/fitareeaee.appspot.com/o/" +
    "verification_documents%2Frider%2Fidentity_1.jpg?alt=media";
  assert.equal(validateDocumentUrl(valid, "rider"), valid);
  assert.throws(() => validateDocumentUrl(valid, "someone-else"));
  assert.throws(() => validateDocumentUrl("https://example.com/file.jpg", "rider"));
});

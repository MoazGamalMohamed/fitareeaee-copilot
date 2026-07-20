# Privacy, Safety, and Product Boundaries

Fitareeaee Copilot helps a user express and review ride or package criteria. It is not a safety authority, identity verifier, emergency service, payment provider, or guarantee of availability.

## Data sent to OpenAI

The contest Copilot sends only the minimum needed to interpret the request:

- the user's natural-language ride or package request;
- locale; and
- timezone; and
- a server-generated current date used to resolve relative dates.

The request is sent from an authenticated Firebase callable Function to the official OpenAI Responses API. The Flutter client never calls OpenAI directly.

The implementation does not intentionally send:

- identity documents or images;
- email addresses or phone numbers;
- Firebase/user IDs;
- profile records;
- private chat messages;
- verification evidence;
- booking records; or
- payment details.

Email addresses, URLs, and long numeric strings typed into the request are
redacted before model access. This is a protective filter, not a guarantee that
every possible personal-data format can be detected. The UI tells users not to
include names, identifiers, documents, contact details, links, or private chat.

## Secret handling

- `OPENAI_API_KEY` belongs only in a managed Firebase/server secret.
- It must never appear in Dart, Android resources, `.env` committed to Git, screenshots, logs, tests, documentation, or the APK.
- The callable does not log raw prompts or raw model responses.
- Safe error categories are returned to the client without exposing provider details or secrets.

## AI boundaries

GPT-5.6 may interpret a request into a structured draft. It must not:

- approve or reject identity documents;
- declare a driver, rider, or sender “safe”;
- make emergency decisions;
- guarantee that a trip exists, remains available, or will match;
- create a booking or trip without confirmation;
- make payment, escrow, wallet, payout, or refund decisions; or
- replace the user's judgment about travel, packages, or another participant.

The UI labels output **AI draft — review required**. The user can edit every operational field. Confirmation starts deterministic search only; it does not save a trip or create a booking.

## Structured output and validation

The backend requests strict JSON Schema output for intent, ride/package type, route, date/time, count, package details, budget, preferences, summary, missing information, clarification, and language. It independently validates allowed values, field lengths, calendar/time formats, count/budget bounds, and unexpected keys before returning a normalized result.

Malformed output becomes a safe retry/manual-fallback state. It is never treated as an instruction to write data.

## Matching integrity

GPT-5.6 interprets language; deterministic application code controls filtering and ranking. Results come only from live Firestore trips and explain route compatibility, timing, seats, price, and preferences. If no trip qualifies, Fitareeaee displays an empty result and does not invent one.

No rank score is a declaration of personal safety or endorsement of a participant.

## Verification and booking

- Verification approval remains a manual/admin-controlled process.
- Client writes cannot approve verification status.
- Booking is an authenticated server transaction.
- The server checks trip status, ownership, departure time, participant verification, duplicate booking, and seat availability before atomically changing booking/inventory state.
- Chat data is restricted to authenticated participants.
- Marketplace cards read server-maintained `public_profiles` containing only
  name, a validated Firebase avatar URL, non-admin roles, and trust counters.
  Contact/profile PII is excluded and the collection cannot be listed.
- The app reads server-maintained `public_trips`; exact coordinates, passenger
  IDs, package photos, descriptions, and arbitrary metadata remain private.
- Manual origin/destination map pins are stored with the private trip. The public
  trip projection exposes only coarsened coordinates needed for marketplace
  proximity ordering; it does not expose the user's live device location.
- A conversation can be created only after a booking or after the server checks
  a live request trip and the offerer's manual verification.
- Verification images remain in owner/admin-scoped Firebase Storage and are
  never sent to OpenAI. Firestore stores object paths rather than public token
  URLs; after an admin review, the raw object is deleted and the path is cleared.
- The submitted verification form does not collect or store document numbers.
  An owner may delete a pending or abandoned raw upload; other users cannot.
  Pending verification metadata and its object path can remain until review or
  cleanup, so judge fixtures must use fictional evidence only.
- Message reads and updates require the authenticated user to match the exact
  participant list recorded by the server, including for older malformed data.

Users remain responsible for confirming trip details, participant identity context, lawful package contents, local regulations, and an appropriate meeting plan.

## Abuse and cost controls

- Authentication is required for Copilot calls.
- Input is limited to 1,200 characters.
- A per-user 8-second cooldown and 12-call-per-hour limit reduce automated abuse.
- Model output is capped, the SDK timeout is 30 seconds, and the Function timeout is 45 seconds.
- Provider failures map to a retry/manual-search option.

These are basic submission safeguards, not a complete production abuse-prevention system. Production scale would additionally require App Check enforcement, operational monitoring, abuse review, stronger multilingual PII detection, retention controls, and a formal incident-response process.

## Excluded prototypes and limitations

Simulated payment, escrow, wallet, payout, AI identity-verification, destructive
reset, and turn-by-turn tracking are not part of the submitted judge flow. The
interactive map is a trip-planning pin picker, not continuous live tracking. No
real payments are processed.

The current release process must still verify the deployed backend, judge accounts, retention/availability through judging, and the final APK. See [`TEST_MATRIX.md`](TEST_MATRIX.md) and [`SUBMISSION_CHECKLIST.md`](SUBMISSION_CHECKLIST.md).

## Emergency notice

Fitareeaee is not an emergency service. Users should contact local emergency services when immediate help is needed and should not rely on Copilot output for urgent safety decisions.

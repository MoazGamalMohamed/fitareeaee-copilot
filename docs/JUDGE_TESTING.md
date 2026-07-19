# Judge Testing Instructions

Fitareeaee Copilot is an Android Flutter application. Testing is free; no payment card or OpenAI account is required by a judge.

> Release status: the stable APK URL and Copilot deployment must be added here only after they are verified. The hardened booking/verification/chat backend, rules, and fictional judge fixtures are deployed, but this July 18 APK remains a tested engineering checkpoint rather than the final distributed build.

Latest local candidate: universal debug APK, 154,878,330 bytes, SHA-256 `A35BE070C1D785D85AC26A62797FFDB3581EAE895148E13E078997A431DFC414`, application source `15baa237707b3115475b09ca7a586e1c171517a7`. It clean-installed after removing the older package data, reports version code `20260718`, and rendered Login successfully on the API 36.1 emulator without fatal Flutter/Android logs.

## Final release information

- APK URL: **PENDING — add verified stable release URL**
- Build type: **PENDING — signed release if safely available; otherwise clearly labeled universal debug judge APK**
- SHA-256: **PENDING — compute from the published artifact**
- Source tag/commit: **PENDING — exact release tag and SHA**
- Minimum Android version: **Android 7.0 / API 24** (verified from the merged release-candidate manifest)
- Judge account: **READY — provide the dedicated fictional rider credentials privately in Devpost testing instructions, never in Git**

## Install

1. On an Android phone or emulator, enable installation from the browser/file manager used to download the APK.
2. Download the APK from the final URL above.
3. Optionally verify its SHA-256 before installing:

   ```powershell
   Get-FileHash .\fitareeaee-copilot.apk -Algorithm SHA256
   ```

   ```bash
   sha256sum fitareeaee-copilot.apk
   ```

4. Open the APK and approve the Android installation prompt.
5. Launch **Fitareeaee Copilot** and sign in with the dedicated judge credentials supplied privately through Devpost.

The app is sideloaded for judging and is not a Google Play release.

## Recommended five-minute test

### 1. Create an English AI draft

From Home, tap **Plan with AI** and enter:

> I need a ride from Dallas to Austin on August 10, 2026 at 9:00 AM for two people under $40, no smoking.

Tap **Create AI draft**. Verify that:

- the screen says **AI draft — review required**;
- intent/type, route, date/time, people, budget, and preferences are structured;
- every operational field is editable;
- the disclosure says GPT-5.6 does not book, verify identity, guarantee matches, or decide who is safe.

### 2. Review before searching

Edit one field, such as the budget. Tap **Confirm draft and find transparent matches**.

This confirmation starts search only. It should not create a trip or booking.

### 3. Inspect transparent matches

Verify that results are actual seeded/live Firestore trips and include understandable reasons such as route, time, seats, price, or preferences. Open a result to view trip details and verification context.

The dedicated judge accounts, trips, and verification flags are explicitly
fictional Build Week fixtures. They do not represent real people, reviewed real
identity documents, or a claim that any person or trip is safe.

If no trip matches, the expected behavior is an honest empty state with **Adjust AI draft** and manual browsing options. No synthetic trip should appear.

### 4. Continue the judge path

Using the provided seeded trip/account:

1. Open trip details.
2. Review manual verification context.
3. Book the trip.
4. Confirm the booking succeeds once and seat inventory changes consistently.
5. Open participant chat.

No real payment is requested or processed.

For an **offer** prompt, the expected result is a compatible request listing.
Opening it offers a server-authorized conversation with the requester; a request
listing is not itself booked.

### 5. Try Arabic or a package

Return to **Plan with AI** and try either:

> أحتاج رحلة من دالاس إلى أوستن في 10 أغسطس 2026 الساعة التاسعة صباحًا لشخصين وبميزانية 40 دولارًا، بدون تدخين.

or:

> I need to send a 5 kg package from Chicago to Milwaukee on August 10, 2026 at 10:00 AM under $30.

The same structured review and explicit confirmation rules should apply.

## Failure and boundary checks

- Remove a required detail: expect missing-information guidance or a clarification question.
- Enter a request with an email/likely phone number: the app should report that contact details were removed before sending to OpenAI.
- Repeatedly submit too quickly: expect a friendly throttle message.
- Use manual search after an AI/backend error: the app should remain navigable.
- Expect no AI identity approval, safety declaration, guaranteed match, or automatic booking.
- Expect no wallet, escrow, payout, or real-payment workflow in the submitted path.

## Architecture being tested

```text
Flutter Android app
  → authenticated Firebase callable Function
  → OpenAI Responses API / GPT-5.6 with strict structured output
  → server validation and normalization
  → editable user-reviewed draft
  → deterministic ranking of real Firestore trips
  → trip details → manual verification context → transactional booking → participant chat
```

## Known limitations

- The APK is distributed directly for judging, not through Google Play.
- Location/map/autocomplete and broader Arabic UI are not required for the core Copilot path.
- AI output may misunderstand language; the user must review the draft.
- Matching depends on available Firestore trips and does not guarantee a result.
- Verification is manual context, not an assurance that a person or trip is safe.
- Payments, escrow, wallet, payout, and AI identity verification are excluded prototypes.

## Troubleshooting

- **Installation blocked:** allow installs from the downloading app, then retry.
- **Sign-in fails:** confirm the exact judge credentials and network connection; report the time/error without posting the password.
- **AI unavailable:** retry once, then use manual search. This is the designed fallback.
- **No matches:** use the documented seeded prompt/account or adjust the draft; the app intentionally does not fabricate results.
- **Support contact:** **PENDING — add owner-approved public support contact before submission.**

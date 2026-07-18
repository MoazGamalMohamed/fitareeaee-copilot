# Owner Actions Before Release

This handoff contains only actions that require an account owner, a private
credential, a legal decision, or physical-device interaction. Do not paste API
keys, passwords, service-account files, signing material, or recovery codes into
Codex chat, Git, documentation, screenshots, or the APK.

## Immediate unblock bundle

### 1. Add the managed OpenAI secret version

Run from the repository root in a private terminal:

```powershell
firebase functions:secrets:set OPENAI_API_KEY --project fitareeaee
```

Paste the OpenAI API key only into Firebase CLI's hidden prompt and submit it.
The secret resource already exists but currently has zero versions. Codex will
verify only the version state, deploy only `planTripWithCopilot`, and cap live
English/package/Arabic checks below the authorized USD $5 limit.

### 2. Create two dedicated Firebase Auth judge users

In Firebase Console → project `fitareeaee` → Authentication → Users, create one
fictional driver account and one fictional rider account. Use owner-controlled
passwords that are not reused elsewhere. Send Codex only the two Firebase UIDs
and identify which is driver/rider; do not send passwords in chat. The guarded
seed script requires existing UIDs and will not create or store credentials.

Keep the eventual judge login credentials only in the private Devpost testing
field, not the public repository, video, screenshots, or progress log.

### 3. Authenticate GitHub CLI

Run:

```powershell
gh auth login --hostname github.com --git-protocol https --web
```

Complete the owner-controlled browser/device flow for the intended account
`MoazGamalMohamed`. Do not paste a GitHub token into chat. Codex will then create
the public `fitareeaee-copilot` repository and publish only the separately
sanitized clone, never the private original history.

### 4. Approve or decline inherited Function retirement

The following 36 live prototype Functions exist in project `fitareeaee`, are
absent from the submitted source and judge navigation, and may still serve an
unknown older client. Deletion is therefore intentionally blocked pending the
owner's explicit approval:

```text
adminProcessRefund
adminUnsuspendUser
cancelPayoutRequest
confirmPayment
confirmPaymentEscrow
createPaymentIntent
createPaymentMethodFromCard
createStripeCustomer
getAIVerificationStats
getPayoutStats
getPendingPayouts
onAdminAlertCreated
onBookingCreated
onBookingStatusChanged
onNotificationCreated
onRatingCreated
onRefundRequestCreated
onRefundRequestUpdated
onSupportChatCreated
onTripStatusChanged
onUserCreated
onUserSignOut
onVerificationRequestCreated
placeDetails
placesAutocomplete
processPayoutRequest
processWeeklyPayouts
refundPayment
releaseEscrowPayment
rerunAIVerification
resetAllVerifications
reverseGeocode
savePaymentMethod
scheduledCleanup
stripeWebhook
triggerManualPayoutRun
```

Reply with an explicit approval naming this exact set, or state that it must be
preserved. Codex will not infer permission and will not delete production data.

### 5. Rotate legacy credentials

Firebase CLI diagnostics exposed a legacy Stripe test credential and email app
password from old Runtime Config. No value was copied into source or evidence.
Revoke/rotate both in their provider consoles and update or remove the obsolete
Runtime Config privately. Do not share replacement values in chat.

## Later physical/legal actions

- Connect the Android phone with USB debugging enabled and approve its RSA
  prompt; Codex can then install and smoke-test the exact APK through ADB.
- Record the final deployed flow using fictional data and the 2:40 script; upload
  it as a public YouTube video with audio and no unauthorized music/material.
- Run `/feedback` in the primary Codex build thread and paste its Session ID into
  Devpost.
- Review eligibility, ownership, privacy, testing credentials, and every final
  link, then personally perform the legally binding Devpost submission action.

See [`SUBMISSION_CHECKLIST.md`](SUBMISSION_CHECKLIST.md) for the complete release
gate and [`BUILD_WEEK_PROGRESS.md`](BUILD_WEEK_PROGRESS.md) for append-only
evidence.

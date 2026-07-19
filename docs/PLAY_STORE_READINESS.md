# Google Play readiness

Last reviewed: July 19, 2026.

This Build Week deliverable is an installable, debug-signed judge APK for direct
sideloading. It is not represented as a Google Play production release.

## Already aligned

- Android package: `com.fitareeaee.app`.
- Minimum API: 24.
- Target/compile API: 36. This meets Google's announced Android 16 / API 36
  target requirement for new apps and updates beginning August 31, 2026:
  <https://support.google.com/googleplay/android-developer/answer/11926878>.
- The exact judge APK installs and cold-launches on a Motorola Moto G Play
  (2024) and installs on an API 36 emulator.
- Privacy/safety disclosures, an account-deletion path, permission handling,
  version metadata, and an application icon exist in the application/source.
- Prototype payment, payout, and escrow screens are excluded from the judge
  path; no simulated transaction is represented as real.

## Required before Google Play production

- Create and securely retain a private upload key. Build a non-debuggable,
  release-signed Android App Bundle (`.aab`) and enroll in Play App Signing.
  New Google Play apps use App Bundles and Play App Signing:
  <https://developer.android.com/studio/publish/prepare> and
  <https://developer.android.com/studio/publish/upload-bundle>.
- Test the signed release variant on target phones and tablets. The current
  contest artifact is debug-signed and is only for judging.
- Complete Play Console's Data safety form accurately for Firebase Auth,
  Firestore, Storage, Functions, notifications, location, identity documents,
  support content, and the minimized trip-planning text sent to OpenAI:
  <https://support.google.com/googleplay/android-developer/answer/10787469>.
- Publish a public privacy-policy URL and verify in-app account deletion and
  any required web deletion route against the current Google Play policies.
- Complete content rating, app-access instructions, target-audience,
  advertising, permissions, and store-listing declarations.
- If the Play developer account is a newly created personal account, follow
  the testing/production-access requirements shown in that account's Play
  Console before requesting production access.
- Rotate the legacy provider credentials exposed by Firebase CLI diagnostics,
  retire or isolate inherited prototype Functions, upgrade the deprecated
  Node 20 Functions runtime, and complete an external security/privacy review.
- Integrate payments only through an approved provider and only after legal,
  financial, refund, cancellation, payout, and marketplace compliance review.

The official Android publishing overview also requires release configuration,
signing, release-variant testing, updated assets, and production-ready remote
services: <https://developer.android.com/studio/publish/>.

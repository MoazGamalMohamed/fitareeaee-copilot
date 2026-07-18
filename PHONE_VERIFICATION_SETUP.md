# Phone Verification Setup Guide

## Why Phone Verification Doesn't Work

Phone verification requires additional Firebase configuration:

1. **SHA-1 Certificate** - Must be added to Firebase Console (for Android)
2. **Phone Provider** - Must be enabled in Firebase Authentication
3. **Real Phone Number** - SMS costs money and requires billing setup
4. **reCAPTCHA** - Required for web version

## Option 1: Test Phone Numbers (Recommended for Development)

Use Firebase test phone numbers that don't send real SMS:

### Steps:

1. Go to [Firebase Console - Authentication](https://console.firebase.google.com/project/fitareeaee/authentication/providers)

2. Click **Sign-in method** tab

3. Enable **Phone** provider (click Edit → Enable → Save)

4. Scroll to **Phone numbers for testing** section

5. Add test numbers:
   ```
   Phone Number: +1 650-555-3434
   Verification Code: 123456
   ```
   Or any other number you prefer:
   ```
   Phone Number: +201234567890
   Verification Code: 111111
   ```

6. Click **Add**

7. In your app, enter the test phone number → enter the verification code you set

**Benefits:**
- ✅ No SMS costs
- ✅ Works on emulator
- ✅ Instant verification
- ✅ No SHA-1 certificate needed for testing

## Option 2: Real Phone Verification (Production)

For real SMS verification:

### Android Setup:

1. **Get SHA-1 Certificate:**
   ```bash
   cd android
   ./gradlew signingReport
   ```
   Copy the `SHA-1` from the output

2. **Add to Firebase:**
   - Go to Firebase Console → Project Settings
   - Scroll to "Your apps" → Select Android app
   - Click "Add fingerprint"
   - Paste SHA-1 certificate
   - Save

3. **Download new google-services.json**
   - Download updated configuration file
   - Replace `android/app/google-services.json`

4. **Enable Phone Auth:**
   - Go to Authentication → Sign-in method
   - Enable Phone provider
   - Save

5. **Test on Real Device:**
   - Phone verification won't work reliably on emulator
   - Use a physical Android device
   - Enter your real phone number
   - Receive SMS code
   - Enter code to verify

### Costs:
- Phone authentication uses Firebase's identity platform
- Check [Firebase Pricing](https://firebase.google.com/pricing) for current rates
- Usually free for low volumes (10k verifications/month)

## Option 3: Simplify to Manual Verification

If phone verification is too complex, you can:

1. Remove phone verification requirement from matching
2. Make it optional
3. Let admins manually verify phone numbers in Firebase Console

The current implementation already falls back gracefully if phone auth fails.

## Current Implementation

The app currently:
- ✅ Checks if user already has verified phone (linked to Firebase Auth)
- ✅ Attempts real SMS verification
- ✅ Handles errors gracefully
- ✅ Updates Firestore when verification succeeds

To use it properly, either:
- Set up test phone numbers (easiest)
- OR configure SHA-1 and use real device

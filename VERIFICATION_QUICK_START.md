# Quick Setup: ID Verification with Face Matching

## ✅ What's Implemented

- AI-powered ID document validation (detects fake IDs)
- Face matching between selfie and ID photo
- Auto-approval for high-confidence verifications
- Manual review queue for moderate confidence
- Detailed feedback for rejected verifications

---

## 🚀 Quick Start (3 Steps)

### Step 1: Get OpenRouter API Key

1. Go to https://openrouter.ai
2. Sign up and add $5-10 credits
3. Generate an API key from dashboard

### Step 2: Add API Key to Code

Open `lib/features/verification/data/services/ai_verification_service.dart`

Find line 9:
```dart
static const String _apiKey = 'YOUR_OPENROUTER_API_KEY'; // TODO: Move to environment variable
```

Replace with your key:
```dart
static const String _apiKey = 'sk-or-v1-xxxxxxxxxxxxx';
```

**Better: Use environment variable**
```bash
flutter run --dart-define=OPENROUTER_API_KEY=sk-or-v1-xxxxxxxxxxxxx
```

### Step 3: Test the Flow

1. Run app: `flutter run`
2. Go to Settings → Verification
3. Upload ID document (watch for AI validation message)
4. Take selfie with ID (AI will verify face matches)
5. Check result dialog with confidence scores

---

## 📸 User Flow

1. **Upload ID Document**
   - Camera or gallery
   - AI validates: "ID document validated successfully!"
   - Stores ID URL for next step

2. **Take Selfie with ID**
   - Must hold ID next to face
   - AI verifies: "Verifying with AI..."
   - Shows result with confidence %

---

## ⚙️ Configuration

### Confidence Thresholds (in `ai_verification_service.dart`)

```dart
// Auto-approve if >= 80%
bool get shouldAutoApprove => success && overallConfidence >= 0.80;

// Manual review if 60-79%
bool get requiresManualReview => success && overallConfidence >= 0.60 && overallConfidence < 0.80;

// Reject if < 60%
bool get shouldReject => !success || overallConfidence < 0.60;
```

**Adjust if needed**:
- Stricter: Increase to 85%/70%/70%
- Looser: Decrease to 75%/50%/50%

---

## 🔍 What AI Checks

### ID Document Validation
- ✓ Security features (holograms, watermarks)
- ✓ Text quality and alignment
- ✓ Signs of tampering or manipulation
- ✓ Document structure matches official IDs

### Selfie with ID Verification
- ✓ Face matching (compares face vs ID photo)
- ✓ ID authenticity (re-validates ID)
- ✓ Photo quality (clear, well-lit)
- ✓ ID visibility (readable in selfie)
- ✓ Liveness detection (not a photo-of-photo)

---

## 💰 Cost

**OpenRouter GPT-4 Vision pricing**:
- ~$0.03-$0.06 per complete verification
- 1,000 verifications = $30-$60/month
- 10,000 verifications = $300-$600/month

---

## 🐛 Troubleshooting

**Error: "System error during verification"**
- Check API key is set correctly
- Ensure internet connection
- Check OpenRouter account has credits

**"ID Validation Failed" for real IDs**
- Image quality too low
- Poor lighting
- ID not fully visible
- Try retaking with better conditions

**Slow verification (>30 seconds)**
- Check internet speed
- OpenRouter API might be slow
- Consider adding timeout with retry

---

## 📊 View Results in Firestore

Verification data stored in `verifications/{userId}`:
```json
{
  "selfieWithIdVerified": true,
  "verificationConfidence": 0.92,
  "faceMatchConfidence": 0.89,
  "idValidityConfidence": 0.95,
  "verificationMethod": "AI",
  "selfieWithIdUrl": "https://...",
  "selfieWithIdVerifiedAt": "2025-12-04T..."
}
```

---

## 📝 Testing Checklist

- [ ] Set OpenRouter API key
- [ ] Upload real ID document → Check validation message
- [ ] Take selfie with ID → Check confidence scores
- [ ] Try with different person → Should reject
- [ ] Try with poor quality image → Should reject or manual review
- [ ] Check Firestore for verification data

---

## 🔐 Security Notes

**Before Production**:
- Move API key to environment variable
- Set up Firebase Storage security rules
- Implement rate limiting for verification attempts
- Add audit logging for all verifications
- Set up manual review queue for admins

---

## 📚 Full Documentation

See `ID_VERIFICATION_GUIDE.md` for:
- Complete architecture details
- API integration specifics
- Security considerations
- Monitoring and analytics
- Cost optimization strategies
- Future enhancement ideas

---

**Status**: ✅ Ready to test!

**Next Action**: Add your OpenRouter API key and test the flow.

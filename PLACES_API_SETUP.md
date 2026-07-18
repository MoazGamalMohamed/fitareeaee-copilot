# Google Places API - Production Setup

## ✅ What We've Implemented

### 1. **Backend Cloud Functions** (`functions/src/index.ts`)
Created 3 secure Cloud Functions:
- `placesAutocomplete` - Get location suggestions as user types
- `placeDetails` - Get full details (coordinates, address) for selected place
- `reverseGeocode` - Convert coordinates to address

**Benefits:**
- ✅ API key stays secure on server (never exposed to users)
- ✅ No CORS issues
- ✅ Works on all platforms (web, iOS, Android)
- ✅ Can add rate limiting and caching
- ✅ Can monitor usage and costs

### 2. **Flutter Service** (`lib/core/services/places_service.dart`)
Created `PlacesService` class to call Cloud Functions
- Clean, reusable API
- Type-safe with `PlacePrediction` and `PlaceDetails` models
- Error handling built-in

### 3. **Dependencies Added**
- Added `axios: ^1.6.0` to `functions/package.json`
- Added `cloud_functions: ^5.1.0` to `pubspec.yaml`

## 🚀 Next Steps to Deploy

### Step 1: Install Dependencies
```powershell
# Install Flutter package
flutter pub get

# Install Cloud Functions dependencies
cd functions
npm install
cd ..
```

### Step 2: Update Location Picker Widget
Update `lib/features/trips/presentation/widgets/location_picker_with_search.dart` to use `PlacesService` instead of HTTP calls.

**Replace:**
```dart
final response = await http.get(url);
```

**With:**
```dart
final placesService = PlacesService();
final predictions = await placesService.getAutocomplete(input);
```

### Step 3: Build and Deploy Cloud Functions
```powershell
cd functions
npm run build
firebase deploy --only functions
```

### Step 4: Test
1. Run your app
2. Try location search - it will call your Cloud Functions
3. Check Firebase Console > Functions to see invocations

## 🔐 Security Configuration (Optional)

Store API key as Firebase config (more secure):
```powershell
firebase functions:config:set maps.api_key="YOUR_GOOGLE_MAPS_API_KEY"
firebase deploy --only functions
```

## 📊 Monitoring

View logs in Firebase Console:
```powershell
firebase functions:log
```

## 💰 Cost Estimation

**Places API Pricing (per 1000 requests):**
- Autocomplete: $2.83
- Place Details: $17.00
- Geocoding: $5.00

**Firebase Cloud Functions (free tier):**
- 2M invocations/month
- 400K GB-seconds/month

For a small app with 1000 users doing 10 searches each per month:
- 10,000 autocomplete requests = $0.28
- 1,000 place details requests = $0.17
- Total: ~$0.50/month

## 🎯 Why This is Better Than Direct HTTP

| Feature | HTTP (Current) | Cloud Functions (New) |
|---------|---------------|---------------------|
| API Key Security | ❌ Exposed in app | ✅ Hidden on server |
| CORS Issues | ❌ Always problems | ✅ No issues |
| Platform Support | ❌ Web has issues | ✅ All platforms |
| Rate Limiting | ❌ Can't control | ✅ Can add limits |
| Caching | ❌ No caching | ✅ Can cache results |
| Monitoring | ❌ No visibility | ✅ Full logs |
| API Restrictions | ❌ Needs "None" | ✅ Can use any |

## 🚨 Current Issue Solution

**Problem:** API returns `REQUEST_DENIED` because of referer restrictions

**Quick Fix (Testing Only):**
Go to Google Cloud Console → API Credentials → Remove restrictions

**Production Fix (Recommended):**
Use the Cloud Functions we just created!


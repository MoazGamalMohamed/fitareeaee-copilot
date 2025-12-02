# Fitareeaee Backend Documentation

## Overview

Fitareeaee uses Firebase as its backend infrastructure:
- **Firebase Auth** - User authentication (Email/Password, Google, Apple Sign-In)
- **Cloud Firestore** - NoSQL database for all app data
- **Firebase Storage** - File storage for images (IDs, package photos, profile pictures)
- **Cloud Functions** - Server-side logic (payments, notifications, email)
- **Firebase Cloud Messaging (FCM)** - Push notifications

---

## Firestore Collections

### `users`
User profiles and account information.
```
users/{userId}
├── email: string
├── displayName: string
├── photoUrl: string?
├── phoneNumber: string?
├── createdAt: timestamp
├── updatedAt: timestamp
├── isVerified: boolean
├── rating: number
├── totalTrips: number
└── fcmToken: string?
```

### `trips`
All trip listings (offers and requests).
```
trips/{tripId}
├── type: 'person' | 'package' | 'both'
├── direction: 'offer' | 'request'
├── driverId: string
├── passengerId: string?
├── originAddress: string
├── destinationAddress: string
├── originLat: number
├── originLng: number
├── destinationLat: number
├── destinationLng: number
├── departureTime: timestamp
├── distance: number (km)
├── estimatedDuration: number (minutes)
├── pricePerSeat: number
├── totalSeats: number
├── availableSeats: number
├── passengerIds: string[]
├── status: 'pending' | 'accepted' | 'inProgress' | 'completed' | 'cancelled'
├── packageWeight: number?
├── packageDescription: string?
├── packagePhotoUrls: string[]
├── createdAt: timestamp
└── updatedAt: timestamp
```

### `bookings`
Trip bookings/reservations.
```
bookings/{bookingId}
├── tripId: string
├── passengerId: string
├── driverId: string
├── status: 'pending' | 'confirmed' | 'cancelled' | 'completed'
├── seatsBooked: number
├── totalPrice: number
├── paymentStatus: 'pending' | 'paid' | 'refunded'
├── paymentIntentId: string?
├── createdAt: timestamp
└── updatedAt: timestamp
```

### `wallets`
User wallet balances and transactions.
```
wallets/{userId}
├── balance: number
├── currency: string
├── updatedAt: timestamp
└── transactions: subcollection
    └── {transactionId}
        ├── type: 'deposit' | 'withdrawal' | 'payment' | 'refund' | 'payout'
        ├── amount: number
        ├── description: string
        ├── status: 'pending' | 'completed' | 'failed'
        ├── referenceId: string?
        └── createdAt: timestamp
```

### `verifications`
User verification documents and status.
```
verifications/{userId}
├── status: 'pending' | 'approved' | 'rejected'
├── idDocumentUrl: string?
├── driverLicenseUrl: string?
├── vehicleRegistrationUrl: string?
├── selfieUrl: string?
├── submittedAt: timestamp?
├── reviewedAt: timestamp?
├── reviewedBy: string?
└── rejectionReason: string?
```

### `chats`
Chat conversations between users.
```
chats/{chatId}
├── participants: string[]
├── lastMessage: string
├── lastMessageAt: timestamp
├── tripId: string?
└── messages: subcollection
    └── {messageId}
        ├── senderId: string
        ├── content: string
        ├── type: 'text' | 'image' | 'location'
        ├── readBy: string[]
        └── createdAt: timestamp
```

### `support_tickets`
Customer support tickets.
```
support_tickets/{ticketId}
├── userId: string
├── category: 'general' | 'payment' | 'trip' | 'safety' | 'technical'
├── subject: string
├── description: string
├── status: 'open' | 'inProgress' | 'resolved' | 'closed'
├── priority: 'low' | 'medium' | 'high'
├── assignedTo: string?
├── createdAt: timestamp
└── updatedAt: timestamp
```

### `tracking`
Real-time trip tracking data.
```
tracking/{tripId}
├── driverId: string
├── isActive: boolean
├── currentLat: number
├── currentLng: number
├── speed: number?
├── heading: number?
├── accuracy: number?
├── estimatedArrival: timestamp?
└── updatedAt: timestamp
```

---

## Firebase Storage Structure

```
storage/
├── users/{userId}/
│   ├── profile.jpg
│   └── documents/
│       ├── id_front.jpg
│       ├── id_back.jpg
│       ├── driver_license.jpg
│       └── vehicle_registration.jpg
├── trips/{tripId}/
│   └── packages/
│       ├── pickup_1.jpg
│       ├── pickup_2.jpg
│       ├── dropoff_1.jpg
│       └── dropoff_2.jpg
└── chats/{chatId}/
    └── images/
        └── {messageId}.jpg
```

---

## Cloud Functions

Located in `functions/src/index.ts`:

### Payment Functions
- `createPaymentIntent` - Creates Stripe PaymentIntent for trip booking
- `holdEscrowPayment` - Holds payment in escrow until trip completion
- `releaseEscrowPayment` - Releases escrow funds to driver after trip
- `refundPayment` - Processes refunds for cancelled trips

### Notification Functions
- `sendMatchNotification` - Sends email when a trip match is created
- `sendPushNotification` - Sends FCM push notification to user

---

## Environment Variables

### Flutter App (via --dart-define)
```bash
flutter run --dart-define=OPENROUTER_API_KEY=your_key
flutter build apk --dart-define=OPENROUTER_API_KEY=your_key
```

### Cloud Functions (functions/.env)
```
STRIPE_SECRET_KEY=sk_test_xxx
SENDGRID_API_KEY=SG.xxx
```

---

## Security Rules

### Firestore Rules (firestore.rules)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own profile
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }

    // Trips are readable by all authenticated users
    match /trips/{tripId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.driverId;
    }

    // Wallets are private to owner
    match /wallets/{userId} {
      allow read, write: if request.auth.uid == userId;
    }

    // Verifications are private
    match /verifications/{userId} {
      allow read: if request.auth.uid == userId;
      allow write: if request.auth.uid == userId;
    }
  }
}
```

### Storage Rules (storage.rules)
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    match /trips/{tripId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

---

## Setup Instructions

### 1. Firebase Project Setup
1. Create a new Firebase project at https://console.firebase.google.com
2. Enable Authentication (Email/Password, Google, Apple)
3. Create Firestore database
4. Enable Storage
5. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

### 2. Deploy Cloud Functions
```bash
cd functions
npm install
firebase deploy --only functions
```

### 3. Configure Stripe
1. Create Stripe account at https://stripe.com
2. Get API keys from Dashboard
3. Add `STRIPE_SECRET_KEY` to Cloud Functions config

### 4. Configure SendGrid (for emails)
1. Create SendGrid account
2. Get API key
3. Add `SENDGRID_API_KEY` to Cloud Functions config

### 5. Run the App
```bash
flutter pub get
flutter run
```

---

## API Keys Required

| Service | Purpose | Where to Get |
|---------|---------|--------------|
| Firebase | Backend | console.firebase.google.com |
| Google Maps | Maps & Location | console.cloud.google.com |
| Stripe | Payments | dashboard.stripe.com |
| SendGrid | Emails | sendgrid.com |
| OpenRouter | AI Features | openrouter.ai |


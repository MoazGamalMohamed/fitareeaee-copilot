# Getting Started with Fitareeaee

## Quick Start Guide

### Step 1: Generate Models (One-time setup)
```bash
cd "c:\Users\moaaz\New Project\fitareeaee"
dart run build_runner build --delete-conflicting-outputs
```

**What this does**: Generates `.freezed.dart` and `.g.dart` files for all models
**Time**: ~30-60 seconds

### Step 2: Get Latest Dependencies
```bash
flutter pub get
```

### Step 3: Run the App
```bash
flutter run
```

**Note**: This will launch the app with placeholder screens. You'll see:
- HomeScreen (empty placeholder)
- LoginScreen (empty placeholder)  
- ProfileScreen (empty placeholder)

---

## Development Workflow

### During Active Development

**Option 1: Watch Mode** (Auto-regenerate code on changes)
```bash
dart run build_runner watch
```
Keep this running in a separate terminal while developing. Models update automatically.

**Option 2: Format Code** (Keep code consistent)
```bash
dart format lib/
```

**Option 3: Analyze** (Check for issues)
```bash
dart analyze
```

---

## Project Overview

### What's Already Done ✅
- Firebase setup (Auth, Firestore, Storage)
- 40+ dependencies installed
- Material 3 theme system
- Routing configuration
- 6 models defined
- Service locator configured
- Environment variables setup

### What Needs Implementation 📋
1. Authentication feature (login, signup)
2. User profiles and management
3. Trip creation and management
4. Trip matching algorithm
5. Chat system
6. Booking system
7. Payment integration
8. Rating system
9. Settings screens

---

## Important Configuration Files

### `.env` (Environment Variables)
Located at project root. Contains:
- Firebase API key & project ID
- Auth domain & storage bucket
- Messaging sender ID & app ID
- App version and name
- API endpoints (maps, payments, etc.)

**⚠️ Keep this file secure!** Don't commit credentials to version control.

### `lib/core/config/environment.dart`
Provides type-safe access to all environment variables:
```dart
// Example usage in your code
final apiKey = Environment.firebaseApiKey;
final projectId = Environment.firebaseProjectId;
```

### `lib/core/config/firebase_config.dart`
Initialize Firebase in main.dart:
```dart
await FirebaseConfig.initialize();
```

---

## Understanding the Structure

### Core Module (`lib/core/`)
Contains shared, app-wide utilities:
```
core/
├── config/          → Firebase, environment setup
├── constants/       → App constants
├── theme/          → Colors, typography
├── routing/        → go_router setup
├── localization/   → i18n strings
├── utils/          → Extensions, helpers
├── services/       → DI container
└── widgets/        → Shared UI components
```

### Features Module (`lib/features/`)
Each feature is independent with 3 layers:
```
features/
├── [feature_name]/
│   ├── data/          → Firestore, repositories, data sources
│   ├── domain/        → Models, use cases, interfaces
│   └── presentation/  → UI screens, widgets, state management
```

**Example**: `features/auth/`
```
auth/
├── data/
│   └── repositories/
│       └── auth_repository.dart  ← Firebase Auth logic
├── domain/
│   ├── models/
│   │   └── user_model.dart       ← User data model
│   └── entities/                 ← Domain entities
└── presentation/
    ├── pages/
    │   └── login_screen.dart     ← UI screen
    ├── widgets/                  ← Reusable widgets
    └── providers/                ← Riverpod providers
```

---

## Next Steps

### For Tomorrow (Phase 2: Authentication)

1. **Implement AuthRepository**
   - Create `lib/features/auth/data/repositories/auth_repository_impl.dart`
   - Add Firebase sign-up logic
   - Add Firebase sign-in logic
   - Add Firebase sign-out logic
   - Add password reset logic

2. **Create Riverpod Providers**
   - Create `lib/features/auth/presentation/providers/auth_provider.dart`
   - Setup user state stream
   - Setup auth state controller

3. **Build Login & Sign-up Screens**
   - Implement `LoginScreen` (email/password input, validation)
   - Implement `SignUpScreen` (registration form)
   - Add form validation
   - Add error handling

4. **Update Routing**
   - Define `/login` route
   - Define `/register` route
   - Add auth-based redirection

---

## Working with Models

### Creating a New Model

1. **Define the model** using Freezed:
```dart
// lib/features/[feature]/domain/models/my_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) => 
    _$MyModelFromJson(json);
}
```

2. **Generate code**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

3. **Use in repository**:
```dart
class MyRepository {
  Future<MyModel> getModel(String id) async {
    // Return MyModel instance
  }
}
```

---

## Working with Firestore

### Basic Pattern

```dart
// In repository (data layer)
Future<UserModel> createUser(UserModel user) async {
  final docRef = FirebaseFirestore.instance
    .collection('users')
    .doc(user.id);
  
  await docRef.set(user.toJson());
  return user;
}

Future<UserModel?> getUser(String userId) async {
  final doc = await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .get();
  
  if (!doc.exists) return null;
  return UserModel.fromJson(doc.data()!);
}

Future<void> updateUser(UserModel user) async {
  await FirebaseFirestore.instance
    .collection('users')
    .doc(user.id)
    .update(user.toJson());
}

Future<void> deleteUser(String userId) async {
  await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .delete();
}
```

### Using in Riverpod Provider

```dart
// In presentation/providers/
final userProvider = FutureProvider<UserModel>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getUser(userId);
});

final userStreamProvider = StreamProvider<UserModel>((ref) {
  return FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .snapshots()
    .map((doc) => UserModel.fromJson(doc.data()!));
});
```

---

## Common Development Tasks

### Add a New Dependency
```bash
flutter pub add package_name
# or for dev dependencies
flutter pub add --dev package_name
```

### Update Dependencies
```bash
flutter pub upgrade
```

### Run Tests
```bash
flutter test
```

### Clean & Rebuild
```bash
flutter clean
flutter pub get
flutter run
```

---

## Troubleshooting

### Build Runner Issues
```bash
# If build_runner hangs, kill it
Get-Process | Where-Object { $_.Name -like "*dart*" } | Stop-Process -Force

# Clean and try again
dart run build_runner clean
dart run build_runner build
```

### Import Errors
```bash
# Get dependencies
flutter pub get

# Regenerate code
dart run build_runner build --delete-conflicting-outputs
```

### Firebase Not Initializing
- Check `.env` file has correct credentials
- Verify `google-services.json` in `android/app/`
- Ensure Firebase project is active in console

### Hot Reload Issues
```bash
# Use hot restart instead (full app restart)
# In terminal where app is running, press 'R'

# Or restart from scratch
flutter run
```

---

## Code Quality Tips

### Before Pushing Code
```bash
# Format code
dart format lib/

# Analyze
dart analyze

# Run tests (when available)
flutter test
```

### Best Practices
- Keep repositories database-agnostic
- Don't import UI in business logic
- Use Riverpod for all state management
- Keep models immutable (use Freezed)
- Always handle errors in UI
- Document complex logic
- Use meaningful variable names

---

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Setup for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Riverpod Documentation](https://riverpod.dev)
- [go_router Guide](https://github.com/google/app-toolkit/tree/master/packages/go_router/example)
- [Clean Architecture](https://resocoder.com/flutter-clean-architecture)
- [Freezed Package](https://pub.dev/packages/freezed)

---

## Support

If you encounter issues:
1. Check the [PROJECT_SETUP.md](./PROJECT_SETUP.md) for detailed setup info
2. Review [SETUP_CHECKLIST.md](./SETUP_CHECKLIST.md) for progress tracking
3. Check terminal output for specific error messages
4. Verify all configuration files are in place

---

**Happy Coding!** 🎉

Start with authentication (Task 8) and build from there. Each feature builds on the foundation we've established.

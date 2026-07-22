import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/app_user.dart';
import '../../../../core/exceptions/auth_exception.dart';
import '../services/firebase_user_service.dart';

/// Authentication repository implementation
class AuthRepositoryImpl {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseUserService _userService;

  AuthRepositoryImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required FirebaseUserService userService,
  }) : _firebaseAuth = firebaseAuth,
       _userService = userService;

  /// Sign up with email and password
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required List<String> roles,
  }) async {
    try {
      // Validate inputs
      if (email.isEmpty || !email.contains('@')) {
        throw AuthException(message: 'Invalid email format');
      }
      if (password.length < 6) {
        throw WeakPasswordException(
          message: 'Password must be at least 6 characters',
        );
      }

      // Create user in Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw AuthException(message: 'Failed to create user');
      }

      // Update display name
      await firebaseUser.updateDisplayName(name);

      // Create app user
      final appUser = AppUser(
        id: firebaseUser.uid,
        email: email.trim(),
        name: name,
        phone: phone,
        roles: roles,
        isEmailVerified: false,
        isPhoneVerified: false,
        rating: 5.0,
        totalRatings: 0,
        totalTrips: 0,
        isVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await _userService.createUser(
        userId: firebaseUser.uid,
        userData: appUser.toJson(),
      );

      // Account creation must remain successful if the email provider is
      // temporarily unavailable. Verification Center provides a safe retry.
      try {
        await firebaseUser.sendEmailVerification();
      } on firebase_auth.FirebaseAuthException {
        // Best effort only; publishing remains protected by the complete
        // role-specific verification gate.
      }

      return appUser;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || !email.contains('@')) {
        throw AuthException(message: 'Invalid email format');
      }
      if (password.isEmpty) {
        throw AuthException(message: 'Password cannot be empty');
      }

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw AuthException(message: 'Failed to sign in');
      }

      // Get user data from Firestore
      final userDoc = await _userService.getUserById(firebaseUser.uid);
      if (userDoc == null) {
        throw UserNotFoundException();
      }

      return AppUser.fromJson(userDoc.data()!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(message: 'Failed to sign out');
    }
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      if (email.isEmpty || !email.contains('@')) {
        throw AuthException(message: 'Invalid email format');
      }

      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user
  Future<AppUser?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      final userDoc = await _userService.getUserById(firebaseUser.uid);
      if (userDoc == null) return null;

      return AppUser.fromJson(userDoc.data()!);
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _firebaseAuth.currentUser != null;
  }

  /// Get current user stream
  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      // Auth may emit immediately before signup finishes writing users/{uid}.
      // Retry the owner read briefly, then rely on dedicated profile providers
      // for live edits. Keeping a global Firestore listener alive through
      // sign-out causes a native permission warning before cancellation wins.
      for (var attempt = 0; attempt < 6; attempt++) {
        final userDoc = await _userService.getUserById(firebaseUser.uid);
        if (userDoc != null && userDoc.data() != null) {
          try {
            return AppUser.fromJson(userDoc.data()!);
          } catch (_) {
            return null;
          }
        }
        if (attempt < 5) {
          await Future<void>.delayed(const Duration(milliseconds: 200));
        }
      }
      return null;
    });
  }

  /// Verify email
  Future<void> verifyEmail() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthException(message: 'No authenticated user');
      }
      await user.sendEmailVerification();
    } catch (e) {
      rethrow;
    }
  }

  /// Update user email
  Future<void> updateEmail({required String newEmail}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthException(message: 'No authenticated user');
      }
      await user.verifyBeforeUpdateEmail(newEmail);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  /// Update user password
  Future<void> updatePassword({required String newPassword}) async {
    try {
      if (newPassword.length < 6) {
        throw WeakPasswordException();
      }

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthException(message: 'No authenticated user');
      }

      await user.updatePassword(newPassword);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with Google
  /// Note: Google Sign-In v7.x requires platform-specific setup.
  /// For now, this is a placeholder that uses Firebase Auth directly.
  Future<AppUser> signInWithGoogle() async {
    try {
      // For web, use Firebase Auth's Google provider directly
      final googleProvider = firebase_auth.GoogleAuthProvider();
      final userCredential = await _firebaseAuth.signInWithPopup(
        googleProvider,
      );
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw AuthException(message: 'Failed to sign in with Google');
      }

      // Check if user exists in Firestore
      final userDoc = await _userService.getUserById(firebaseUser.uid);

      if (userDoc != null && userDoc.exists) {
        return AppUser.fromJson(userDoc.data()!);
      }

      // Create new user in Firestore
      final appUser = AppUser(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName ?? 'User',
        phone: firebaseUser.phoneNumber ?? '',
        photoUrl: firebaseUser.photoURL,
        roles: ['rider'], // Default role
        isEmailVerified: firebaseUser.emailVerified,
        isPhoneVerified: false,
        rating: 5.0,
        totalRatings: 0,
        totalTrips: 0,
        isVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _userService.createUser(
        userId: firebaseUser.uid,
        userData: appUser.toJson(),
      );

      return appUser;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out from Google
  Future<void> signOutFromGoogle() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(message: 'Failed to sign out from Google');
    }
  }

  /// Handle Firebase Auth exceptions
  Exception _handleFirebaseAuthException(
    firebase_auth.FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'weak-password':
        return WeakPasswordException(
          message: e.message ?? 'Password is too weak',
        );
      case 'email-already-in-use':
        return EmailAlreadyInUseException(
          message: e.message ?? 'Email already in use',
        );
      case 'invalid-email':
        return AuthException(message: 'Invalid email address', code: e.code);
      case 'user-disabled':
        return AuthException(
          message: 'User account has been disabled',
          code: e.code,
        );
      case 'user-not-found':
        return UserNotFoundException(message: e.message ?? 'User not found');
      case 'wrong-password':
        return InvalidCredentialsException(
          message: e.message ?? 'Invalid credentials',
        );
      case 'network-request-failed':
        return NetworkException(message: e.message ?? 'Network error');
      default:
        return FirebaseAuthException(
          message: e.message ?? 'Authentication error',
          code: e.code,
        );
    }
  }
}

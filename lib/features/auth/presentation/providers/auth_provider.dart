import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/firebase_user_service.dart';

// Providers
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final firebaseUserServiceProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseUserService(firestore: firestore);
});

final authRepositoryProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final userService = ref.watch(firebaseUserServiceProvider);
  return AuthRepositoryImpl(
    firebaseAuth: firebaseAuth,
    userService: userService,
  );
});

// Auth state providers
final authStateProvider = StreamProvider<AppUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges();
});

final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.getCurrentUser();
});

// Sign up state notifier
final signUpProvider = StateNotifierProvider.autoDispose<
    SignUpStateNotifier,
    AsyncValue<AppUser?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignUpStateNotifier(repo);
});

// Sign in state notifier
final signInProvider = StateNotifierProvider.autoDispose<
    SignInStateNotifier,
    AsyncValue<AppUser?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignInStateNotifier(repo);
});

// Password reset state notifier
final passwordResetProvider = StateNotifierProvider.autoDispose<
    PasswordResetStateNotifier,
    AsyncValue<void>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return PasswordResetStateNotifier(repo);
});

// Sign out provider
final signOutProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.signOut();
});

/// Sign up state notifier
class SignUpStateNotifier extends StateNotifier<AsyncValue<AppUser?>> {
  final AuthRepositoryImpl _repository;

  SignUpStateNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String phone,
    required List<String> roles,
  }) async {
    state = const AsyncValue.loading();

    try {
      if (password != confirmPassword) {
        state = AsyncValue.error('Passwords do not match', StackTrace.current);
        return;
      }

      final user = await _repository.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
        roles: roles,
      );

      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error.toString(), stackTrace);
    }
  }
}

/// Sign in state notifier
class SignInStateNotifier extends StateNotifier<AsyncValue<AppUser?>> {
  final AuthRepositoryImpl _repository;

  SignInStateNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    try {
      final user = await _repository.signIn(
        email: email,
        password: password,
      );

      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error.toString(), stackTrace);
    }
  }
}

/// Password reset state notifier
class PasswordResetStateNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRepositoryImpl _repository;

  PasswordResetStateNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> resetPassword({required String email}) async {
    state = const AsyncValue.loading();

    try {
      await _repository.resetPassword(email: email);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error.toString(), stackTrace);
    }
  }
}

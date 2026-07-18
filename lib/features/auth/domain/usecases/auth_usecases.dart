import '../entities/app_user.dart';

/// Authentication use cases
abstract class AuthUseCases {
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required List<String> roles,
  });

  Future<AppUser> signIn({required String email, required String password});

  Future<void> signOut();

  Future<void> resetPassword({required String email});

  Future<AppUser?> getCurrentUser();

  bool isAuthenticated();

  Stream<AppUser?> authStateChanges();

  Future<void> verifyEmail();

  Future<void> updatePassword({required String newPassword});
}

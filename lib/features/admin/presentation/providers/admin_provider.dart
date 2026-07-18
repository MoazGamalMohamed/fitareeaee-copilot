import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository();
});

// Stream provider that updates when auth state changes
final isAdminProvider = StreamProvider<bool>((ref) {
  final adminRepository = ref.read(adminRepositoryProvider);
  
  // Listen to auth state changes
  return FirebaseAuth.instance.authStateChanges().asyncMap((user) async {
    if (user == null) return false;
    return await adminRepository.isCurrentUserAdmin();
  });
});

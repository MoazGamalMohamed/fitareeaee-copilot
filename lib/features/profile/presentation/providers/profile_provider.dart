import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../domain/entities/user_profile.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../verification/presentation/providers/verification_provider.dart';
import '../../../verification/domain/models/verification_model.dart';

// Repository Providers
final userProfileRepositoryProvider = Provider((ref) {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  return UserProfileRepositoryImpl(
    firestore: firestore,
    storage: storage,
  );
});

// Stream Providers
// AutoDispose ensures this provider is disposed when no longer watched
final userProfileProvider = StreamProvider.autoDispose.family<UserProfile?, String>((
  ref,
  String userId,
) async* {
  // Import auth provider to watch auth state
  final authState = ref.watch(authStateProvider);
  
  // If no authenticated user, return null stream to avoid permission errors
  if (!authState.hasValue || authState.value == null) {
    yield null;
    return;
  }
  
  final repository = ref.watch(userProfileRepositoryProvider);
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  
  // Get Firebase Auth user for email verification status
  final firebaseUser = firebaseAuth.currentUser;
  
  // Listen to verification changes using ref.listen
  UserVerification? latestVerification;
  ref.listen(userVerificationProvider(userId), (previous, next) {
    next.whenData((verification) {
      latestVerification = verification;
    });
  });
  
  // Get initial verification value
  final verificationAsync = ref.read(userVerificationProvider(userId));
  verificationAsync.whenData((verification) {
    latestVerification = verification;
  });
  
  // Stream the profile and sync verification status
  await for (final profile in repository.streamUserProfile(userId)) {
    if (profile == null) {
      yield null;
      continue;
    }
    
    bool needsUpdate = false;
    var updatedProfile = profile;
    
    // Sync email verification status from Firebase Auth
    if (firebaseUser != null && profile.isEmailVerified != firebaseUser.emailVerified) {
      updatedProfile = updatedProfile.copyWith(
        isEmailVerified: firebaseUser.emailVerified,
      );
      needsUpdate = true;
    }
    
    // Sync phone verification status from verification system
    // Only mark as verified if verification document exists AND phoneVerified is true
    final shouldBePhoneVerified = latestVerification?.phoneVerified ?? false;
    if (profile.isPhoneVerified != shouldBePhoneVerified) {
      updatedProfile = updatedProfile.copyWith(
        isPhoneVerified: shouldBePhoneVerified,
      );
      needsUpdate = true;
    }
    
    if (needsUpdate) {
      // Update in Firestore
      await repository.updateUserProfile(updatedProfile);
      yield updatedProfile;
    } else {
      yield profile;
    }
  }
});

// Future Providers
final userProfileFutureProvider = FutureProvider.family<UserProfile?, String>((
  ref,
  String userId,
) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return repository.getUserProfile(userId);
});

// State Notifiers
class UpdateProfileStateNotifier
    extends StateNotifier<AsyncValue<UserProfile?>> {
  final UserProfileRepositoryImpl _repository;

  UpdateProfileStateNotifier(this._repository)
      : super(const AsyncValue.data(null));

  Future<void> updateProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateUserProfile(profile);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

class AvatarUploadStateNotifier extends StateNotifier<AsyncValue<String?>> {
  final UserProfileRepositoryImpl _repository;

  AvatarUploadStateNotifier(this._repository)
      : super(const AsyncValue.data(null));

  Future<void> uploadAvatar(String userId, File imageFile) async {
    state = const AsyncValue.loading();
    try {
      final url = await _repository.uploadAvatar(userId, imageFile);
      state = AsyncValue.data(url);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAvatar(String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteAvatar(userId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

class SearchUsersStateNotifier extends StateNotifier<AsyncValue<List<UserProfile>>> {
  final UserProfileRepositoryImpl _repository;

  SearchUsersStateNotifier(this._repository)
      : super(const AsyncValue.data([]));

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final results = await _repository.searchUsers(query);
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

// State Notifier Providers
final updateProfileProvider =
    StateNotifierProvider.autoDispose<UpdateProfileStateNotifier, AsyncValue<UserProfile?>>((
  ref,
) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return UpdateProfileStateNotifier(repository);
});

final avatarUploadProvider =
    StateNotifierProvider.autoDispose<AvatarUploadStateNotifier, AsyncValue<String?>>((
  ref,
) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return AvatarUploadStateNotifier(repository);
});

final searchUsersProvider =
    StateNotifierProvider.autoDispose<SearchUsersStateNotifier, AsyncValue<List<UserProfile>>>((
  ref,
) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return SearchUsersStateNotifier(repository);
});

// Utility Providers
final profileCompletionProvider = FutureProvider.family<int, String>((
  ref,
  String userId,
) async {
  final profile = await ref.watch(userProfileFutureProvider(userId).future);
  return profile?.completionPercentage ?? 0;
});

final isProfileCompleteProvider = FutureProvider.family<bool, String>((
  ref,
  String userId,
) async {
  final profile = await ref.watch(userProfileFutureProvider(userId).future);
  return profile?.profileCompleteCheck ?? false;
});

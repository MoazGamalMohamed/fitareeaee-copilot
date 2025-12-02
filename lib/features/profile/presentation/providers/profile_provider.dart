import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../domain/entities/user_profile.dart';
import '../../data/repositories/user_profile_repository_impl.dart';

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
final userProfileProvider = StreamProvider.family<UserProfile?, String>((
  ref,
  String userId,
) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return repository.streamUserProfile(userId);
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

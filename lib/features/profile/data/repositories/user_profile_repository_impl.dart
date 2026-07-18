import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../models/user_profile_model.dart';
import '../../../../core/utils/exceptions/app_exceptions.dart';

/// Implementation of UserProfileRepository using Firebase
class UserProfileRepositoryImpl implements UserProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  const UserProfileRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  }) : _firestore = firestore,
       _storage = storage;

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        // Create a default profile if it doesn't exist
        final auth = await _getAuthUser(userId);
        final defaultProfile = UserProfile(
          userId: userId,
          email: auth?['email'] ?? '',
          name: auth?['displayName'] ?? '',
          photoUrl: auth?['photoUrl'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await createUserProfile(defaultProfile);
        return defaultProfile;
      }

      final data = {...doc.data()!, 'userId': userId};
      final model = UserProfileModel.fromJson(data);
      return model.toEntity();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to get user profile: $e');
    }
  }

  /// Get auth user info from Firebase Auth
  Future<Map<String, String?>?> _getAuthUser(String userId) async {
    try {
      // We can't directly access other users' auth data
      // Return null and let the caller handle it
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Create a new user profile
  Future<void> createUserProfile(UserProfile profile) async {
    try {
      final model = profile.toModel();
      await _firestore
          .collection('users')
          .doc(profile.userId)
          .set(model.toFirestore());
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to create user profile: $e');
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      final model = profile.toModel();
      await _firestore
          .collection('users')
          .doc(profile.userId)
          .update(model.toEditableFirestore());
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to update user profile: $e');
    }
  }

  @override
  Future<String> uploadAvatar(String userId, File imageFile) async {
    try {
      final ref = _storage.ref('avatars/$userId/profile.jpg');
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      // Update the profile with new photo URL
      await _firestore.collection('users').doc(userId).update({
        'photoUrl': downloadUrl,
        'updated_at': DateTime.now(),
      });

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to upload avatar: $e');
    }
  }

  @override
  Future<void> deleteAvatar(String userId) async {
    try {
      await _storage.ref('avatars/$userId/profile.jpg').delete();
      await _firestore.collection('users').doc(userId).update({
        'photoUrl': null,
        'updated_at': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to delete avatar: $e');
    }
  }

  @override
  Future<List<UserProfile>> searchUsers(String query) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      // Search by name
      final nameResults = await _firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .get();

      // Search by email
      final emailResults = await _firestore
          .collection('users')
          .where('email', isGreaterThanOrEqualTo: query)
          .where('email', isLessThan: '${query}z')
          .get();

      // Combine and deduplicate results
      final combined = <String, QueryDocumentSnapshot>{};
      for (var doc in nameResults.docs) {
        combined[doc.id] = doc;
      }
      for (var doc in emailResults.docs) {
        combined[doc.id] = doc;
      }

      return combined.values
          .map(
            (doc) =>
                // ignore: unnecessary_cast
                UserProfileModel.fromJson(
                  doc.data() as Map<String, dynamic>,
                ).toEntity(),
          )
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to search users: $e');
    }
  }

  @override
  Future<UserProfile?> getUserByEmail(String email) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return null;
      }

      final model = UserProfileModel.fromJson(query.docs.first.data());
      return model.toEntity();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to get user by email: $e');
    }
  }

  @override
  Stream<UserProfile?> streamUserProfile(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      try {
        final data = {...doc.data()!, 'userId': userId};
        final model = UserProfileModel.fromJson(data);
        return model.toEntity();
      } catch (e) {
        print('❌ Error parsing profile for userId $userId: $e');
        return null;
      }
    });
  }

  @override
  Future<bool> profileExists(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to check profile existence: $e');
    }
  }

  /// Handle Firebase exceptions and convert to app-specific exceptions
  AppException _handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return AppException(message: 'Permission denied');
      case 'not-found':
        return UserNotFoundException('User profile not found');
      case 'unavailable':
        return NetworkException('Service temporarily unavailable');
      default:
        return AppException(message: 'Firebase error: ${e.message}');
    }
  }
}

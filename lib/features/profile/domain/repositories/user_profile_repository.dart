import 'dart:io';
import '../../domain/entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile> getUserProfile(String userId);
  Future<void> updateUserProfile(UserProfile profile);
  Future<String> uploadAvatar(String userId, File imageFile);
  Future<void> deleteAvatar(String userId);
  Future<List<UserProfile>> searchUsers(String query);
  Future<UserProfile?> getUserByEmail(String email);
  Stream<UserProfile?> streamUserProfile(String userId);
  Future<bool> profileExists(String userId);
}

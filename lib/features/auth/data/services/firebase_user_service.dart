import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase service for user operations
class FirebaseUserService {
  final FirebaseFirestore _firestore;

  FirebaseUserService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  /// Create a new user document in Firestore
  Future<void> createUser({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .set(userData, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  /// Get user by ID
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserById(
    String userId,
  ) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? doc : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update user data
  Future<void> updateUser({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete user document
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Check if user exists
  Future<bool> userExists(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  /// Get all users (for admin)
  Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers({
    int limit = 50,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    try {
      var query = _firestore.collection('users').limit(limit);
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }
      return query.get();
    } catch (e) {
      rethrow;
    }
  }

  /// Search users by email
  Future<QuerySnapshot<Map<String, dynamic>>> searchUsersByEmail(
    String email,
  ) async {
    try {
      return _firestore
          .collection('users')
          .where('email', isEqualTo: email.toLowerCase())
          .get();
    } catch (e) {
      rethrow;
    }
  }

  /// Get users by role
  Future<QuerySnapshot<Map<String, dynamic>>> getUsersByRole(
    String role,
  ) async {
    try {
      return _firestore
          .collection('users')
          .where('roles', arrayContains: role)
          .get();
    } catch (e) {
      rethrow;
    }
  }

  /// Stream user data
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }
}

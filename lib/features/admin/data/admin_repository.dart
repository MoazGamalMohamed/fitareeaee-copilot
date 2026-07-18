import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AdminRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Check if the current user is an admin
  Future<bool> isCurrentUserAdmin() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    try {
      final doc = await _firestore
          .collection('admins')
          .doc(currentUser.uid)
          .get();
      
      return doc.exists && (doc.data()?['isAdmin'] == true);
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

  /// Add a user as admin (by email)
  Future<void> addAdmin(String email) async {
    try {
      // Note: In production, you'd want to look up the user by email
      // For now, this requires the user ID
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Must be logged in to add admins');
      }

      // Check if current user is admin
      final isAdmin = await isCurrentUserAdmin();
      if (!isAdmin) {
        throw Exception('Only admins can add other admins');
      }

      // For now, you'll need to manually add the first admin in Firebase Console
      throw UnimplementedError('Use Firebase Console to add admin by user ID');
    } catch (e) {
      rethrow;
    }
  }

  /// Remove admin privileges
  Future<void> removeAdmin(String userId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Must be logged in');
      }

      final isAdmin = await isCurrentUserAdmin();
      if (!isAdmin) {
        throw Exception('Only admins can remove admin privileges');
      }

      await _firestore.collection('admins').doc(userId).delete();
    } catch (e) {
      rethrow;
    }
  }
}

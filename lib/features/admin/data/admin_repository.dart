import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AdminRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
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
    } catch (_) {
      return false;
    }
  }
}

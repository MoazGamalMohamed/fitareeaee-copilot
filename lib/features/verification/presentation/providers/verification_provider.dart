import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../domain/models/verification_model.dart';
import '../../../../core/utils/firestore_helpers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final firebaseStorageProvider = Provider((ref) => FirebaseStorage.instance);

/// Provider for user verification data
final userVerificationProvider =
    StreamProvider.family<UserVerification?, String>((ref, userId) {
      return FirebaseFirestore.instance
          .collection('verifications')
          .doc(userId)
          .snapshots()
          .map((doc) {
            if (!doc.exists) return null;
            final data = doc.data()!;

            // Convert Timestamp to ISO8601 strings using helper
            final processedData = FirestoreHelpers.convertTimestamps({
              ...data,
              'userId': userId,
            });

            return UserVerification.fromJson(processedData);
          });
    });

/// Alias for simpler access to verification status
final verificationStatusProvider =
    StreamProvider.family<UserVerification?, String>((ref, userId) {
      return ref
          .watch(userVerificationProvider(userId))
          .when(
            data: (data) => Stream.value(data),
            loading: () => Stream.value(null),
            error: (err, st) => Stream.value(null),
          );
    });

/// Provider for current user's verification
final currentUserVerificationProvider = FutureProvider<UserVerification?>((
  ref,
) async {
  // Watch auth state to automatically refresh when user signs in/out
  final authState = ref.watch(authStateProvider);
  final user = authState.value;
  if (user == null) return null;
  return ref.watch(userVerificationProvider(user.id).future);
});

/// Upload verification document
final uploadVerificationDocumentProvider =
    FutureProvider.family<String, UploadDocumentParams>((ref, params) async {
      final storage = ref.read(firebaseStorageProvider);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final fileName =
          '${params.type.name}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      // Use secure path that matches storage rules: verification_documents/{userId}/{fileName}
      final storageRef = storage.ref().child(
        'verification_documents/${user.uid}/$fileName',
      );

      final uploadTask = await storageRef.putFile(params.file);
      return uploadTask.ref.fullPath;
    });

/// Submit verification request
Future<void> submitVerification({
  required String userId,
  required VerificationType type,
  required String documentUrl,
}) async {
  if (FirebaseAuth.instance.currentUser?.uid != userId) {
    throw StateError(
      'Verification can only be submitted for the signed-in user.',
    );
  }
  await FirebaseFunctions.instance.httpsCallable('submitVerification').call({
    'schemaVersion': 1,
    'type': type.name,
    'documentUrl': documentUrl,
  });
}

/// Approve verification (admin only)
Future<void> approveVerification({
  required String verificationId,
  required String adminId,
}) async {
  final firestore = FirebaseFirestore.instance;

  final verificationDoc = await firestore
      .collection('verification_requests')
      .doc(verificationId)
      .get();
  if (!verificationDoc.exists) throw Exception('Verification not found');

  final data = verificationDoc.data()!;
  final userId = data['userId'] as String;
  final type = VerificationType.values.firstWhere(
    (e) => e.name == data['type'],
  );
  await FirebaseFunctions.instance.httpsCallable('reviewVerification').call({
    'schemaVersion': 1,
    'userId': userId,
    'type': type.name,
    'approved': true,
  });
}

class UploadDocumentParams {
  final File file;
  final VerificationType type;
  UploadDocumentParams({required this.file, required this.type});
}

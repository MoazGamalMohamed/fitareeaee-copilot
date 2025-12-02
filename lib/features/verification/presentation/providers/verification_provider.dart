import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/verification_model.dart';

final firebaseStorageProvider = Provider((ref) => FirebaseStorage.instance);

/// Provider for user verification data
final userVerificationProvider = StreamProvider.family<UserVerification?, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection('verifications')
      .doc(userId)
      .snapshots()
      .map((doc) {
    if (!doc.exists) return null;
    return UserVerification.fromJson({...doc.data()!, 'userId': userId});
  });
});

/// Provider for current user's verification
final currentUserVerificationProvider = FutureProvider<UserVerification?>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;
  return ref.watch(userVerificationProvider(user.uid).future);
});

/// Upload verification document
final uploadVerificationDocumentProvider = FutureProvider.family<String, UploadDocumentParams>((ref, params) async {
  final storage = ref.read(firebaseStorageProvider);
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('User not authenticated');

  final fileName = '${params.type.name}_${DateTime.now().millisecondsSinceEpoch}.jpg';
  final storageRef = storage.ref().child('verifications/${user.uid}/$fileName');
  
  final uploadTask = await storageRef.putFile(params.file);
  return await uploadTask.ref.getDownloadURL();
});

/// Submit verification request
Future<void> submitVerification({
  required String userId,
  required VerificationType type,
  required String documentUrl,
  String? documentNumber,
}) async {
  final firestore = FirebaseFirestore.instance;
  final now = DateTime.now();

  // Create verification record
  final verificationRef = firestore.collection('verification_requests').doc();
  await verificationRef.set({
    'id': verificationRef.id,
    'userId': userId,
    'type': type.name,
    'status': VerificationStatus.pending.name,
    'documentUrl': documentUrl,
    'documentNumber': documentNumber,
    'createdAt': now.toIso8601String(),
    'updatedAt': now.toIso8601String(),
  });

  // Update user verification status
  final userVerifRef = firestore.collection('verifications').doc(userId);
  final fieldMap = {
    VerificationType.identity: 'identityDocumentUrl',
    VerificationType.driverLicense: 'driverLicenseUrl',
    VerificationType.vehicle: 'vehicleRegistrationUrl',
  };

  if (fieldMap.containsKey(type)) {
    await userVerifRef.set({
      fieldMap[type]!: documentUrl,
      'updatedAt': now.toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

/// Approve verification (admin only)
Future<void> approveVerification({
  required String verificationId,
  required String adminId,
}) async {
  final firestore = FirebaseFirestore.instance;
  final now = DateTime.now();

  final verificationDoc = await firestore.collection('verification_requests').doc(verificationId).get();
  if (!verificationDoc.exists) throw Exception('Verification not found');

  final data = verificationDoc.data()!;
  final userId = data['userId'] as String;
  final type = VerificationType.values.firstWhere((e) => e.name == data['type']);

  // Update verification request
  await firestore.collection('verification_requests').doc(verificationId).update({
    'status': VerificationStatus.approved.name,
    'verifiedAt': now.toIso8601String(),
    'verifiedBy': adminId,
    'updatedAt': now.toIso8601String(),
  });

  // Update user verification document
  final fieldMap = {
    VerificationType.identity: {'identityVerified': true, 'identityVerifiedAt': now.toIso8601String()},
    VerificationType.driverLicense: {'driverLicenseVerified': true, 'driverLicenseVerifiedAt': now.toIso8601String()},
    VerificationType.vehicle: {'vehicleVerified': true, 'vehicleVerifiedAt': now.toIso8601String()},
    VerificationType.email: {'emailVerified': true},
    VerificationType.phone: {'phoneVerified': true},
  };

  if (fieldMap.containsKey(type)) {
    await firestore.collection('verifications').doc(userId).set({
      ...fieldMap[type]!,
      'updatedAt': now.toIso8601String(),
    }, SetOptions(merge: true));
  }
}

class UploadDocumentParams {
  final File file;
  final VerificationType type;
  UploadDocumentParams({required this.file, required this.type});
}


import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../domain/models/verification_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final firebaseStorageProvider = Provider((ref) => FirebaseStorage.instance);

/// Parses current and legacy verification documents without hiding otherwise
/// valid verification flags when an older document omitted audit timestamps.
UserVerification userVerificationFromFirestoreData(
  String userId,
  Map<String, dynamic> data,
) {
  DateTime? timestampAsDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    if (value is Map) {
      final seconds = value['_seconds'] ?? value['seconds'];
      final nanoseconds = value['_nanoseconds'] ?? value['nanoseconds'] ?? 0;
      if (seconds is num && nanoseconds is num) {
        return DateTime.fromMillisecondsSinceEpoch(
          seconds.toInt() * 1000 + nanoseconds.toInt() ~/ 1000000,
          isUtc: true,
        );
      }
    }
    return null;
  }

  bool flag(String field) {
    final value = data[field];
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  String? optionalText(String field) {
    final value = data[field];
    if (value is! String) return null;
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }

  final createdAt =
      timestampAsDateTime(data['createdAt']) ??
      timestampAsDateTime(data['updatedAt']) ??
      DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  final updatedAt = timestampAsDateTime(data['updatedAt']) ?? createdAt;

  // Construct the domain object explicitly instead of sending legacy Firestore
  // data through generated `as String` casts. Old documents can contain explicit
  // nulls, missing audit fields, Timestamp objects, or stale scalar types; none of
  // those should crash the verification screen.
  return UserVerification(
    userId: userId,
    emailVerified: flag('emailVerified'),
    phoneVerified: flag('phoneVerified'),
    identityVerified: flag('identityVerified'),
    driverLicenseVerified: flag('driverLicenseVerified'),
    vehicleVerified: flag('vehicleVerified'),
    selfieWithIdVerified: flag('selfieWithIdVerified'),
    identityDocumentUrl: optionalText('identityDocumentUrl'),
    driverLicenseUrl: optionalText('driverLicenseUrl'),
    vehicleRegistrationUrl: optionalText('vehicleRegistrationUrl'),
    selfieWithIdUrl: optionalText('selfieWithIdUrl'),
    vehiclePlateNumber: optionalText('vehiclePlateNumber'),
    vehicleModel: optionalText('vehicleModel'),
    vehicleColor: optionalText('vehicleColor'),
    identityVerifiedAt: timestampAsDateTime(data['identityVerifiedAt']),
    driverLicenseVerifiedAt: timestampAsDateTime(
      data['driverLicenseVerifiedAt'],
    ),
    vehicleVerifiedAt: timestampAsDateTime(data['vehicleVerifiedAt']),
    selfieWithIdVerifiedAt: timestampAsDateTime(data['selfieWithIdVerifiedAt']),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

/// Provider for user verification data
final userVerificationProvider = StreamProvider.autoDispose
    .family<UserVerification?, String>((ref, userId) {
      return FirebaseFirestore.instance
          .collection('verifications')
          .doc(userId)
          .snapshots()
          .map((doc) {
            if (!doc.exists) return null;
            final data = doc.data()!;
            return userVerificationFromFirestoreData(userId, data);
          })
          .handleError((Object error, StackTrace stackTrace) {
            if (FirebaseAuth.instance.currentUser?.uid == userId) {
              Error.throwWithStackTrace(error, stackTrace);
            }
          });
    });

/// Alias for simpler access to verification status
final verificationStatusProvider = StreamProvider.autoDispose
    .family<UserVerification?, String>((ref, userId) {
      return ref
          .watch(userVerificationProvider(userId))
          .when(
            data: (data) => Stream.value(data),
            loading: () => Stream.value(null),
            error: (err, st) => Stream.value(null),
          );
    });

/// Provider for current user's verification
final currentUserVerificationProvider =
    FutureProvider.autoDispose<UserVerification?>((ref) async {
      // Watch auth state to automatically refresh when user signs in/out
      final authState = ref.watch(authStateProvider);
      final user = authState.value;
      if (user == null) return null;
      return ref.watch(userVerificationProvider(user.id).future);
    });

/// Upload verification document
final uploadVerificationDocumentProvider = FutureProvider.autoDispose
    .family<String, UploadDocumentParams>((ref, params) async {
      final storage = ref.read(firebaseStorageProvider);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final fileName = '${params.type.name}.jpg';
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
  final userId = data['userId'] is String
      ? (data['userId'] as String).trim()
      : '';
  final typeName = data['type'] is String
      ? (data['type'] as String).trim()
      : '';
  if (userId.isEmpty || typeName.isEmpty) {
    throw const FormatException('Verification request is incomplete.');
  }
  final type = VerificationType.values.firstWhere(
    (value) => value.name == typeName,
    orElse: () => throw const FormatException(
      'Verification request has an unsupported document type.',
    ),
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

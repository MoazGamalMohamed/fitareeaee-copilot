import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import '../../domain/models/emergency_model.dart';

/// Provider for user's emergency contacts
final emergencyContactsProvider = StreamProvider<List<EmergencyContact>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('emergency_contacts')
      .where('isActive', isEqualTo: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => EmergencyContact.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

/// Provider for active emergency alerts
final activeEmergencyProvider = StreamProvider<EmergencyAlert?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('emergency_alerts')
      .where('userId', isEqualTo: user.uid)
      .where('status', isEqualTo: 'active')
      .limit(1)
      .snapshots()
      .map((snapshot) {
    if (snapshot.docs.isEmpty) return null;
    return EmergencyAlert.fromJson({...snapshot.docs.first.data(), 'id': snapshot.docs.first.id});
  });
});

/// Add emergency contact
Future<void> addEmergencyContact({
  required String name,
  required String phone,
  String? relationship,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Not authenticated');

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('emergency_contacts')
      .add({
    'userId': user.uid,
    'name': name,
    'phone': phone,
    'relationship': relationship,
    'isActive': true,
    'createdAt': DateTime.now().toIso8601String(),
  });
}

/// Remove emergency contact
Future<void> removeEmergencyContact(String contactId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Not authenticated');

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('emergency_contacts')
      .doc(contactId)
      .update({'isActive': false});
}

/// Trigger SOS alert
Future<EmergencyAlert> triggerSOS({
  String? tripId,
  required EmergencyType type,
  String? description,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Not authenticated');

  // Get current location
  final location = Location();
  final locationData = await location.getLocation();

  // Get emergency contacts
  final contactsSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('emergency_contacts')
      .where('isActive', isEqualTo: true)
      .get();

  final contactPhones = contactsSnapshot.docs
      .map((doc) => doc.data()['phone'] as String)
      .toList();

  // Create emergency alert
  final alertRef = await FirebaseFirestore.instance.collection('emergency_alerts').add({
    'userId': user.uid,
    'tripId': tripId,
    'type': type.name,
    'status': EmergencyStatus.active.name,
    'latitude': locationData.latitude ?? 0.0,
    'longitude': locationData.longitude ?? 0.0,
    'description': description,
    'emergencyContacts': contactPhones,
    'createdAt': DateTime.now().toIso8601String(),
  });

  return EmergencyAlert(
    id: alertRef.id,
    oderId: user.uid,
    tripId: tripId,
    type: type,
    status: EmergencyStatus.active,
    latitude: locationData.latitude ?? 0.0,
    longitude: locationData.longitude ?? 0.0,
    description: description,
    emergencyContacts: contactPhones,
    createdAt: DateTime.now(),
  );
}

/// Cancel SOS alert
Future<void> cancelSOS(String alertId) async {
  await FirebaseFirestore.instance
      .collection('emergency_alerts')
      .doc(alertId)
      .update({
    'status': EmergencyStatus.cancelled.name,
    'resolvedAt': DateTime.now().toIso8601String(),
  });
}

/// Resolve SOS alert (admin)
Future<void> resolveSOS({
  required String alertId,
  required String resolvedBy,
  String? notes,
}) async {
  await FirebaseFirestore.instance
      .collection('emergency_alerts')
      .doc(alertId)
      .update({
    'status': EmergencyStatus.resolved.name,
    'resolvedAt': DateTime.now().toIso8601String(),
    'resolvedBy': resolvedBy,
    'resolutionNotes': notes,
  });
}


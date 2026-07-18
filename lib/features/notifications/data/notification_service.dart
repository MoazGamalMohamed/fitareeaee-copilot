import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  /// Create a notification in Firestore
  Future<void> createNotification({
    required String userId,
    required String type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    String? actionUrl,
    String? imageUrl,
  }) async {
    final notificationId = _uuid.v4();
    await _firestore.collection('notifications').doc(notificationId).set({
      'id': notificationId,
      'userId': userId,
      'type': type,
      'title': title,
      'body': body,
      'data': data,
      'actionUrl': actionUrl,
      'imageUrl': imageUrl,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Send notification when document is approved
  Future<void> sendDocumentApprovedNotification({
    required String userId,
    required String documentType,
  }) async {
    String title = 'Document Approved ✓';
    String body = 'Your $documentType has been verified and approved!';

    await createNotification(
      userId: userId,
      type: 'verification',
      title: title,
      body: body,
      data: {
        'documentType': documentType,
        'status': 'approved',
      },
      actionUrl: '/verification',
    );
  }

  /// Send notification when document is rejected
  Future<void> sendDocumentRejectedNotification({
    required String userId,
    required String documentType,
    required String reason,
  }) async {
    String title = 'Document Rejected';
    String body = 'Your $documentType was rejected: $reason. Please resubmit.';

    await createNotification(
      userId: userId,
      type: 'verification',
      title: title,
      body: body,
      data: {
        'documentType': documentType,
        'status': 'rejected',
        'reason': reason,
      },
      actionUrl: '/verification',
    );
  }

  /// Send notification when a booking is matched
  Future<void> sendBookingMatchedNotification({
    required String userId,
    required String tripDetails,
    String? passengerName,
  }) async {
    String title = 'New Match Found!';
    String body = passengerName != null
        ? '$passengerName wants to join your trip: $tripDetails'
        : 'Someone wants to join your trip: $tripDetails';

    await createNotification(
      userId: userId,
      type: 'booking',
      title: title,
      body: body,
      data: {
        'type': 'match',
      },
      actionUrl: '/matches',
    );
  }

  /// Send notification when booking is confirmed
  Future<void> sendBookingConfirmedNotification({
    required String userId,
    required String tripDetails,
  }) async {
    String title = 'Booking Confirmed!';
    String body = 'Your seat is confirmed for: $tripDetails';

    await createNotification(
      userId: userId,
      type: 'booking',
      title: title,
      body: body,
      data: {
        'type': 'confirmed',
      },
      actionUrl: '/matches',
    );
  }

  /// Send notification when trip is about to start
  Future<void> sendTripStartingSoonNotification({
    required String userId,
    required String tripDetails,
    required int minutesUntilStart,
  }) async {
    String title = 'Trip Starting Soon';
    String body = 'Your trip starts in $minutesUntilStart minutes: $tripDetails';

    await createNotification(
      userId: userId,
      type: 'trip',
      title: title,
      body: body,
      data: {
        'minutesUntil': minutesUntilStart,
      },
      actionUrl: '/trips',
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../domain/models/notification_model.dart';

final firebaseMessagingProvider = Provider((ref) => FirebaseMessaging.instance);

/// Provider for user notifications
final notificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('notifications')
      .where('userId', isEqualTo: user.uid)
      .orderBy('createdAt', descending: true)
      .limit(50)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => NotificationModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

/// Provider for unread notification count
final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(0);

  return FirebaseFirestore.instance
      .collection('notifications')
      .where('userId', isEqualTo: user.uid)
      .where('isRead', isEqualTo: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
});

/// Mark notification as read
Future<void> markNotificationAsRead(String notificationId) async {
  await FirebaseFirestore.instance
      .collection('notifications')
      .doc(notificationId)
      .update({
    'isRead': true,
    'readAt': DateTime.now().toIso8601String(),
  });
}

/// Mark all notifications as read
Future<void> markAllNotificationsAsRead(String userId) async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();
  
  final unreadDocs = await firestore
      .collection('notifications')
      .where('userId', isEqualTo: userId)
      .where('isRead', isEqualTo: false)
      .get();

  for (final doc in unreadDocs.docs) {
    batch.update(doc.reference, {
      'isRead': true,
      'readAt': DateTime.now().toIso8601String(),
    });
  }

  await batch.commit();
}

/// Delete notification
Future<void> deleteNotification(String notificationId) async {
  await FirebaseFirestore.instance
      .collection('notifications')
      .doc(notificationId)
      .delete();
}

/// Send notification to user (creates Firestore record)
Future<void> sendNotification({
  required String userId,
  required NotificationType type,
  required String title,
  required String body,
  String? imageUrl,
  Map<String, dynamic>? data,
  String? actionUrl,
}) async {
  await FirebaseFirestore.instance.collection('notifications').add({
    'userId': userId,
    'type': type.name,
    'title': title,
    'body': body,
    'imageUrl': imageUrl,
    'data': data,
    'actionUrl': actionUrl,
    'isRead': false,
    'createdAt': DateTime.now().toIso8601String(),
  });
}

/// FCM Token management
class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token
      final token = await _messaging.getToken();
      if (token != null) {
        await _saveTokenToFirestore(token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_saveTokenToFirestore);
    }
  }

  Future<void> _saveTokenToFirestore(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fcm_tokens')
        .doc(token)
        .set({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': 'android', // or detect platform
    });
  }

  Future<void> removeToken() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await _messaging.getToken();
    
    if (user != null && token != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('fcm_tokens')
          .doc(token)
          .delete();
    }
  }
}


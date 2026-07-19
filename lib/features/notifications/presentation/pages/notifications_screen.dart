import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await markAllNotificationsAsRead(user.uid);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All notifications marked as read'),
                    ),
                  );
                }
              }
            },
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                const Text(
                  'Notifications are temporarily unavailable.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => ref.invalidate(notificationsProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (notifications) => notifications.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(notificationsProvider),
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _NotificationTile(notification: notification);
                  },
                ),
              ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => deleteNotification(notification.id),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: _getCardColor(),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getAvatarColor(),
            child: Icon(
              _getTypeIcon(notification.type),
              color: Colors.white,
              size: 20,
            ),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead
                  ? FontWeight.normal
                  : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(notification.createdAt),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          isThreeLine: true,
          onTap: () {
            if (!notification.isRead) {
              markNotificationAsRead(notification.id);
            }
            _handleNotificationTap(context, notification);
          },
        ),
      ),
    );
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Icons.calendar_today;
      case NotificationType.chat:
        return Icons.chat;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.trip:
        return Icons.directions_car;
      case NotificationType.rating:
        return Icons.star;
      case NotificationType.promo:
        return Icons.local_offer;
      case NotificationType.system:
        return Icons.info;
      case NotificationType.verification:
        return Icons.verified_user;
    }
  }

  bool _isRejectionNotification() {
    return notification.type == NotificationType.verification &&
        notification.data?['status'] == 'rejected';
  }

  Color? _getCardColor() {
    if (_isRejectionNotification()) {
      return notification.isRead ? Colors.red.shade50 : Colors.red.shade100;
    }
    return notification.isRead ? null : Colors.blue.shade50;
  }

  Color _getAvatarColor() {
    if (_isRejectionNotification()) {
      return Colors.red;
    }
    return _getTypeColor(notification.type);
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Colors.blue;
      case NotificationType.chat:
        return Colors.green;
      case NotificationType.payment:
        return Colors.orange;
      case NotificationType.trip:
        return Colors.purple;
      case NotificationType.rating:
        return Colors.amber;
      case NotificationType.promo:
        return Colors.pink;
      case NotificationType.system:
        return Colors.grey;
      case NotificationType.verification:
        return Colors.teal;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void _handleNotificationTap(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (notification.actionUrl != null) {
      // Navigate to action URL
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigate to: ${notification.actionUrl}')),
      );
    }
  }
}

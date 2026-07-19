import 'package:fitareeaee/features/notifications/domain/models/notification_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('legacy notification types fall back to a safe system notification', () {
    final notification = NotificationModel.fromJson({
      'id': 'legacy-notification',
      'userId': 'judge-user',
      'type': 'tripCancellation',
      'title': 'Trip cancelled',
      'body': 'A legacy notification remains readable.',
      'createdAt': '2026-07-18T12:00:00.000Z',
    });

    expect(notification.type, NotificationType.system);
    expect(notification.iconName, 'info');
  });
}

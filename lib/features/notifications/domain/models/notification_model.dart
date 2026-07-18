import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType {
  booking,
  chat,
  payment,
  trip,
  rating,
  promo,
  system,
  verification,
}

@freezed
class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required String id,
    required String userId,
    required NotificationType type,
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
    String? actionUrl,
    @Default(false) bool isRead,
    required DateTime createdAt,
    DateTime? readAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  /// Get icon based on notification type
  String get iconName {
    switch (type) {
      case NotificationType.booking:
        return 'calendar_today';
      case NotificationType.chat:
        return 'chat';
      case NotificationType.payment:
        return 'payment';
      case NotificationType.trip:
        return 'directions_car';
      case NotificationType.rating:
        return 'star';
      case NotificationType.promo:
        return 'local_offer';
      case NotificationType.system:
        return 'info';
      case NotificationType.verification:
        return 'verified_user';
    }
  }
}

@freezed
class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    @Default(true) bool bookingNotifications,
    @Default(true) bool chatNotifications,
    @Default(true) bool paymentNotifications,
    @Default(true) bool tripNotifications,
    @Default(true) bool ratingNotifications,
    @Default(false) bool promoNotifications,
    @Default(true) bool systemNotifications,
    @Default(true) bool verificationNotifications,
    @Default(true) bool soundEnabled,
    @Default(true) bool vibrationEnabled,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
}

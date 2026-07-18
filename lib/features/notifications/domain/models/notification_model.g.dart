// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  title: json['title'] as String,
  body: json['body'] as String,
  imageUrl: json['imageUrl'] as String?,
  data: json['data'] as Map<String, dynamic>?,
  actionUrl: json['actionUrl'] as String?,
  isRead: json['isRead'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  readAt: json['readAt'] == null
      ? null
      : DateTime.parse(json['readAt'] as String),
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'title': instance.title,
  'body': instance.body,
  'imageUrl': instance.imageUrl,
  'data': instance.data,
  'actionUrl': instance.actionUrl,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt.toIso8601String(),
  'readAt': instance.readAt?.toIso8601String(),
};

const _$NotificationTypeEnumMap = {
  NotificationType.booking: 'booking',
  NotificationType.chat: 'chat',
  NotificationType.payment: 'payment',
  NotificationType.trip: 'trip',
  NotificationType.rating: 'rating',
  NotificationType.promo: 'promo',
  NotificationType.system: 'system',
  NotificationType.verification: 'verification',
};

_$NotificationPreferencesImpl _$$NotificationPreferencesImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationPreferencesImpl(
  bookingNotifications: json['bookingNotifications'] as bool? ?? true,
  chatNotifications: json['chatNotifications'] as bool? ?? true,
  paymentNotifications: json['paymentNotifications'] as bool? ?? true,
  tripNotifications: json['tripNotifications'] as bool? ?? true,
  ratingNotifications: json['ratingNotifications'] as bool? ?? true,
  promoNotifications: json['promoNotifications'] as bool? ?? false,
  systemNotifications: json['systemNotifications'] as bool? ?? true,
  verificationNotifications: json['verificationNotifications'] as bool? ?? true,
  soundEnabled: json['soundEnabled'] as bool? ?? true,
  vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$$NotificationPreferencesImplToJson(
  _$NotificationPreferencesImpl instance,
) => <String, dynamic>{
  'bookingNotifications': instance.bookingNotifications,
  'chatNotifications': instance.chatNotifications,
  'paymentNotifications': instance.paymentNotifications,
  'tripNotifications': instance.tripNotifications,
  'ratingNotifications': instance.ratingNotifications,
  'promoNotifications': instance.promoNotifications,
  'systemNotifications': instance.systemNotifications,
  'verificationNotifications': instance.verificationNotifications,
  'soundEnabled': instance.soundEnabled,
  'vibrationEnabled': instance.vibrationEnabled,
};

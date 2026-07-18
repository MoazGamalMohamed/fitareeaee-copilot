// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      recipientId: json['recipient_id'] as String,
      content: json['content'] as String? ?? '',
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdAt: const TimestampConverter().fromJson(json['created_at']),
      isRead: json['is_read'] as bool? ?? false,
      readAt: const TimestampConverter().fromJson(json['read_at']),
      isDeleted: json['is_deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender_id': instance.senderId,
      'recipient_id': instance.recipientId,
      'content': instance.content,
      'attachments': instance.attachments,
      'created_at': const TimestampConverter().toJson(instance.createdAt),
      'is_read': instance.isRead,
      'read_at': _$JsonConverterToJson<dynamic, DateTime>(
        instance.readAt,
        const TimestampConverter().toJson,
      ),
      'is_deleted': instance.isDeleted,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/message.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

/// Converter for Firestore Timestamp to DateTime
class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    } else if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return DateTime.now();
  }

  @override
  dynamic toJson(DateTime dateTime) => dateTime.toIso8601String();
}

/// Message model for JSON serialization
@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    @JsonKey(name: 'conversation_id') required String conversationId,
    @JsonKey(name: 'sender_id') required String senderId,
    @JsonKey(name: 'recipient_id') required String recipientId,
    @Default('') String content,
    @Default(<String>[]) List<String> attachments,
    @JsonKey(name: 'created_at')
    @TimestampConverter()
    required DateTime createdAt,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'read_at') @TimestampConverter() DateTime? readAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
  }) = _MessageModel;

  const MessageModel._();

  /// Convert to domain entity
  Message toEntity() => Message(
    id: id,
    conversationId: conversationId,
    senderId: senderId,
    recipientId: recipientId,
    content: content,
    attachments: attachments,
    createdAt: createdAt,
    isRead: isRead,
    readAt: readAt,
    isDeleted: isDeleted,
  );

  /// Convert to Firestore document format
  Map<String, dynamic> toFirestore() {
    final participantIds = <String>[senderId, recipientId]..sort();
    return {
      'id': id,
      'sender_id': senderId,
      'recipient_id': recipientId,
      'conversation_id': conversationId,
      'participant_ids': participantIds,
      'content': content,
      'attachments': attachments,
      'created_at': createdAt,
      'is_read': isRead,
      'read_at': readAt,
      'is_deleted': isDeleted,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

/// Extension to convert Message to MessageModel
extension MessageToModel on Message {
  MessageModel toModel() => MessageModel(
    id: id,
    conversationId: conversationId,
    senderId: senderId,
    recipientId: recipientId,
    content: content,
    attachments: attachments,
    createdAt: createdAt,
    isRead: isRead,
    readAt: readAt,
    isDeleted: isDeleted,
  );
}

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/message.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

/// Message model for JSON serialization
@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String senderId,
    required String recipientId,
    required String content,
    @Default(<String>[]) List<String> attachments,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default(false) bool isRead,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @Default(false) bool isDeleted,
  }) = _MessageModel;

  const MessageModel._();

  /// Convert to domain entity
  Message toEntity() => Message(
        id: id,
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
    return {
      'id': id,
      'sender_id': senderId,
      'recipient_id': recipientId,
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
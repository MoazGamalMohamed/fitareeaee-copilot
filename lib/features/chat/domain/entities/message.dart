import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

/// Chat message entity
@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    @JsonKey(name: 'conversation_id') required String conversationId,
    required String senderId,
    required String recipientId,
    required String content,
    @Default(<String>[]) List<String> attachments,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default(false) bool isRead,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @Default(false) bool isDeleted,
  }) = _Message;

  const Message._();

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  /// Check if message is from current user
  bool isSentByUser(String userId) => senderId == userId;

  /// Legacy participant-pair ID helper retained only for old local fixtures.
  static String getLegacyConversationId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return ids.join('_');
  }

  /// Time since message was sent
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}

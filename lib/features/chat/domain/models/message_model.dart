import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    required MessageType messageType, // 'text', 'image', 'location'
    required bool isRead,
    required DateTime timestamp,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

enum MessageType { text, image, location }

import 'package:dartz/dartz.dart';
import 'dart:typed_data';
import '../../domain/entities/message.dart';
import '../../../../core/error/failures.dart';

/// Abstract repository for chat operations
abstract class ChatRepository {
  /// Send a message to a recipient
  Future<Either<Failure, Message>> sendMessage(Message message);

  /// Get messages in a conversation
  /// Returns messages in reverse chronological order (newest first)
  /// conversationId format: "userId1_userId2" (IDs are sorted alphabetically)
  Future<Either<Failure, List<Message>>> getConversation(String conversationId);

  /// Get all conversations for a user
  /// Each conversation is represented by the most recent message
  Future<Either<Failure, List<Message>>> getConversations(String userId);

  /// Stream messages in a conversation for real-time updates
  /// Returns messages in reverse chronological order (newest first)
  /// conversationId format: "userId1_userId2" (IDs are sorted alphabetically)
  Stream<Either<Failure, List<Message>>> streamConversation(String conversationId);

  /// Stream all conversations for a user for real-time updates
  /// Each conversation is represented by the most recent message
  Stream<Either<Failure, List<Message>>> streamConversations(String userId);

  /// Mark a message as read
  Future<Either<Failure, void>> markAsRead(String messageId);

  /// Soft delete a message (only visible to sender as deleted)
  Future<Either<Failure, void>> deleteMessage(String messageId);

  /// Upload raw bytes for an attachment and return the download URL
  Future<Either<Failure, String>> uploadAttachment(
    String conversationId,
    Uint8List bytes,
    String filename,
  );
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/message_model.dart';
import '../../../../core/error/failures.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

/// Implementation of ChatRepository using Firebase Firestore
class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firebaseFirestore;

  ChatRepositoryImpl({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  /// Reference to messages collection
  CollectionReference<Map<String, dynamic>> get _messagesCollection =>
      _firebaseFirestore.collection('messages');

  /// Upload attachment bytes to Firebase Storage and return public URL
  @override
  Future<Either<Failure, String>> uploadAttachment(
    String conversationId,
    Uint8List bytes,
    String filename,
  ) async {
    try {
      final ref = _firebaseStorage
          .ref()
          .child('chat_attachments')
          .child(conversationId)
          .child(filename);

      final uploadTask = await ref.putData(bytes);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return Right(downloadUrl);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(message: e.message ?? 'Upload failed'));
    } catch (e) {
      return Left(FirebaseFailure(message: 'Upload failed: $e'));
    }
  }

  /// Get conversation ID from two user IDs
  /// This ensures consistent conversation IDs regardless of order
  String _getConversationId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  @override
  Future<Either<Failure, Message>> sendMessage(Message message) async {
    try {
      final messageModel = message.toModel();
      await _messagesCollection.doc(message.id).set(messageModel.toFirestore());
      return Right(message);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(message: e.message ?? 'Send message failed'));
    } catch (e) {
      return Left(FirebaseFailure(message: 'Send message failed: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getConversation(
    String conversationId,
  ) async {
    try {
      // Parse conversation ID to get user IDs
      final userIds = conversationId.split('_');
      if (userIds.length != 2) {
        return Left(FirebaseFailure(message: 'Invalid conversation ID'));
      }

      final userId1 = userIds[0];
      final userId2 = userIds[1];

      // Get messages where users are sender/recipient (both directions)
      final query1 = _messagesCollection
          .where('sender_id', isEqualTo: userId1)
          .where('recipient_id', isEqualTo: userId2)
          .where('is_deleted', isEqualTo: false);

      final query2 = _messagesCollection
          .where('sender_id', isEqualTo: userId2)
          .where('recipient_id', isEqualTo: userId1)
          .where('is_deleted', isEqualTo: false);

      final snapshot1 = await query1.orderBy('created_at', descending: true).get();
      final snapshot2 = await query2.orderBy('created_at', descending: true).get();

      final allDocs = [...snapshot1.docs, ...snapshot2.docs];
      allDocs.sort((a, b) {
        final timeA = a.data()['created_at'] as Timestamp? ?? Timestamp.now();
        final timeB = b.data()['created_at'] as Timestamp? ?? Timestamp.now();
        return timeB.compareTo(timeA);
      });

      final messages = allDocs
          .map((doc) => MessageModel.fromJson({
                ...doc.data(),
                'id': doc.id,
              }).toEntity())
          .toList();

      return Right(messages);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(
        message: e.message ?? 'Failed to get conversation',
      ));
    } catch (e) {
      return Left(FirebaseFailure(message: 'Failed to get conversation: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getConversations(
    String userId,
  ) async {
    try {
      // Get all conversations where user is sender
      final sentSnapshots = await _messagesCollection
          .where('sender_id', isEqualTo: userId)
          .where('is_deleted', isEqualTo: false)
          .orderBy('created_at', descending: true)
          .get();

      // Get all conversations where user is recipient
      final receivedSnapshots = await _messagesCollection
          .where('recipient_id', isEqualTo: userId)
          .where('is_deleted', isEqualTo: false)
          .orderBy('created_at', descending: true)
          .get();

      // Combine and deduplicate by conversation ID
      final allDocs = [...sentSnapshots.docs, ...receivedSnapshots.docs];
      final conversationMap = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};

      for (final doc in allDocs) {
        final data = doc.data();
        final senderId = data['sender_id'] as String;
        final recipientId = data['recipient_id'] as String;
        final conversationId = _getConversationId(senderId, recipientId);

        if (!conversationMap.containsKey(conversationId)) {
          conversationMap[conversationId] = doc;
        }
      }

      // Convert to messages and sort by date
      final messages = conversationMap.values
          .map((doc) => MessageModel.fromJson({
                ...doc.data(),
                'id': doc.id,
              }).toEntity())
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Right(messages);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(
        message: e.message ?? 'Failed to get conversations',
      ));
    } catch (e) {
      return Left(FirebaseFailure(message: 'Failed to get conversations: $e'));
    }
  }

  @override
  Stream<Either<Failure, List<Message>>> streamConversation(
    String conversationId,
  ) {
    try {
      return _messagesCollection
          .where('conversation_id', isEqualTo: conversationId)
          .where('is_deleted', isEqualTo: false)
          .orderBy('created_at', descending: true)
          .snapshots()
          .map((snapshot) {
        final messages = snapshot.docs
            .map((doc) => MessageModel.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }).toEntity())
            .toList();
        return Right<Failure, List<Message>>(messages);
      }).handleError((error) {
        return Left<Failure, List<Message>>(
          FirebaseFailure(
            message: error is FirebaseException
                ? error.message ?? 'Failed to stream conversation'
                : 'Failed to stream conversation: $error',
          ),
        );
      });
    } catch (e) {
      return Stream.value(
        Left(FirebaseFailure(message: 'Failed to stream conversation: $e')),
      );
    }
  }

  @override
  Stream<Either<Failure, List<Message>>> streamConversations(String userId) {
    try {
      // Get real-time updates for conversations
      // Query both directions and combine
      return _messagesCollection
          .orderBy('created_at', descending: true)
          .snapshots()
          .map((snapshot) {
        final allDocs = snapshot.docs;

        // Filter to only messages involving this user
        final relevantDocs = allDocs
            .where((doc) {
              final data = doc.data();
              final senderId = data['sender_id'] as String?;
              final recipientId = data['recipient_id'] as String?;
              final isDeleted = data['is_deleted'] as bool? ?? false;
              return !isDeleted &&
                  (senderId == userId || recipientId == userId);
            })
            .toList();

        // Get most recent message per conversation
        final conversationMap = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};
        for (final doc in relevantDocs) {
          final data = doc.data();
          final senderId = data['sender_id'] as String;
          final recipientId = data['recipient_id'] as String;
          final conversationId = _getConversationId(senderId, recipientId);

          if (!conversationMap.containsKey(conversationId)) {
            conversationMap[conversationId] = doc;
          }
        }

        // Convert to messages
        final messages = conversationMap.values
            .map((doc) => MessageModel.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }).toEntity())
            .toList();

        return Right<Failure, List<Message>>(messages);
      }).handleError((error) {
        return Left<Failure, List<Message>>(
          FirebaseFailure(
            message: error is FirebaseException
                ? error.message ?? 'Failed to stream conversations'
                : 'Failed to stream conversations: $error',
          ),
        );
      });
    } catch (e) {
      return Stream.value(
        Left(FirebaseFailure(message: 'Failed to stream conversations: $e')),
      );
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String messageId) async {
    try {
      await _messagesCollection.doc(messageId).update({
        'is_read': true,
        'read_at': FieldValue.serverTimestamp(),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(
        message: e.message ?? 'Failed to mark message as read',
      ));
    } catch (e) {
      return Left(FirebaseFailure(message: 'Failed to mark message as read: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(String messageId) async {
    try {
      // Soft delete - just mark as deleted
      await _messagesCollection.doc(messageId).update({
        'is_deleted': true,
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(
        message: e.message ?? 'Failed to delete message',
      ));
    } catch (e) {
      return Left(FirebaseFailure(message: 'Failed to delete message: $e'));
    }
  }
}

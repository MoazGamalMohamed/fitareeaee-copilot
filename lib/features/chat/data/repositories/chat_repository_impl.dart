import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/firestore_helpers.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/message_model.dart';

/// Firestore chat repository with participant-scoped queries.
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required FirebaseFirestore firebaseFirestore,
    FirebaseAuth? firebaseAuth,
  }) : _firebaseFirestore = firebaseFirestore,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  CollectionReference<Map<String, dynamic>> get _messagesCollection =>
      _firebaseFirestore.collection('messages');

  String? get _currentUserId => _firebaseAuth.currentUser?.uid;

  String _getConversationId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Message _messageFromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = FirestoreHelpers.convertTimestamps({
      ...document.data(),
      'id': document.id,
    });
    return MessageModel.fromJson(data).toEntity();
  }

  FirebaseFailure _failure(Object error, String fallback) {
    return FirebaseFailure(
      message: error is FirebaseException
          ? error.message ?? fallback
          : fallback,
    );
  }

  @override
  Future<Either<Failure, String>> uploadAttachment(
    String conversationId,
    Uint8List bytes,
    String filename,
  ) async {
    return Left(
      FirebaseFailure(
        message: 'Chat attachments are unavailable in the judge build.',
      ),
    );
  }

  @override
  Future<Either<Failure, Message>> sendMessage(Message message) async {
    final userId = _currentUserId;
    if (userId == null || message.senderId != userId) {
      return Left(FirebaseFailure(message: 'Not authorized to send message'));
    }
    try {
      await _messagesCollection
          .doc(message.id)
          .set(message.toModel().toFirestore());
      return Right(message);
    } catch (error) {
      return Left(_failure(error, 'Send message failed'));
    }
  }

  Query<Map<String, dynamic>> _conversationQuery(
    String conversationId,
    String userId,
  ) {
    return _messagesCollection
        .where('conversation_id', isEqualTo: conversationId)
        .where('participant_ids', arrayContains: userId)
        .orderBy('created_at', descending: true);
  }

  Query<Map<String, dynamic>> _userMessagesQuery(String userId) {
    return _messagesCollection
        .where('participant_ids', arrayContains: userId)
        .orderBy('created_at', descending: true);
  }

  @override
  Future<Either<Failure, List<Message>>> getConversation(
    String conversationId,
  ) async {
    final userId = _currentUserId;
    if (userId == null) {
      return Left(FirebaseFailure(message: 'Sign in to view messages'));
    }
    try {
      final snapshot = await _conversationQuery(conversationId, userId).get();
      final messages = snapshot.docs
          .map(_messageFromDocument)
          .where((message) => !message.isDeleted)
          .toList();
      return Right(messages);
    } catch (error) {
      return Left(_failure(error, 'Failed to get conversation'));
    }
  }

  List<Message> _latestConversationMessages(
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> documents,
  ) {
    final latest = <String, Message>{};
    for (final document in documents) {
      final message = _messageFromDocument(document);
      if (message.isDeleted) continue;
      final conversationId = _getConversationId(
        message.senderId,
        message.recipientId,
      );
      latest.putIfAbsent(conversationId, () => message);
    }
    final messages = latest.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return messages;
  }

  @override
  Future<Either<Failure, List<Message>>> getConversations(String userId) async {
    if (_currentUserId != userId) {
      return Left(FirebaseFailure(message: 'Not authorized'));
    }
    try {
      final snapshot = await _userMessagesQuery(userId).get();
      return Right(_latestConversationMessages(snapshot.docs));
    } catch (error) {
      return Left(_failure(error, 'Failed to get conversations'));
    }
  }

  @override
  Stream<Either<Failure, List<Message>>> streamConversation(
    String conversationId,
  ) async* {
    final userId = _currentUserId;
    if (userId == null) {
      yield Left(FirebaseFailure(message: 'Sign in to view messages'));
      return;
    }
    try {
      await for (final snapshot in _conversationQuery(
        conversationId,
        userId,
      ).snapshots()) {
        final messages = snapshot.docs
            .map(_messageFromDocument)
            .where((message) => !message.isDeleted)
            .toList();
        yield Right(messages);
      }
    } catch (error) {
      yield Left(_failure(error, 'Failed to stream conversation'));
    }
  }

  @override
  Stream<Either<Failure, List<Message>>> streamConversations(
    String userId,
  ) async* {
    if (_currentUserId != userId) {
      yield Left(FirebaseFailure(message: 'Not authorized'));
      return;
    }
    try {
      await for (final snapshot in _userMessagesQuery(userId).snapshots()) {
        yield Right(_latestConversationMessages(snapshot.docs));
      }
    } catch (error) {
      yield Left(_failure(error, 'Failed to stream conversations'));
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
    } catch (error) {
      return Left(_failure(error, 'Failed to mark message as read'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(String messageId) async {
    try {
      await _messagesCollection.doc(messageId).update({'is_deleted': true});
      return const Right(null);
    } catch (error) {
      return Left(_failure(error, 'Failed to delete message'));
    }
  }
}

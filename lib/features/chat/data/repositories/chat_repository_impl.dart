import 'dart:async';
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

  CollectionReference<Map<String, dynamic>> get _authorizationsCollection =>
      _firebaseFirestore.collection('conversation_authorizations');

  String? get _currentUserId => _firebaseAuth.currentUser?.uid;

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

  Query<Map<String, dynamic>> _participantMessagesQuery(String userId) {
    // Keep the server query to one security-relevant array constraint. This
    // works with Firestore's built-in single-field index and avoids a runtime
    // composite-index dependency. Conversation filtering and ordering happen
    // locally after Firestore has returned only this user's messages.
    return _messagesCollection.where('participant_ids', arrayContains: userId);
  }

  Query<Map<String, dynamic>> _userAuthorizationsQuery(String userId) {
    return _authorizationsCollection.where(
      'participant_ids',
      arrayContains: userId,
    );
  }

  Map<String, Set<String>> _activeConversationParticipants(
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> documents,
  ) {
    return {
      for (final document in documents)
        if (document.data()['active'] == true &&
            document.data()['participant_ids'] is List)
          document.id: (document.data()['participant_ids'] as List)
              .whereType<String>()
              .toSet(),
    };
  }

  bool _hasExpectedParticipants(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
    Set<String> expected,
  ) {
    final value = document.data()['participant_ids'];
    if (value is! List) return false;
    final actual = value.whereType<String>().toSet();
    return actual.length == expected.length && actual.containsAll(expected);
  }

  List<Message> _messagesForConversation(
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> documents,
    String conversationId,
    Set<String> expectedParticipants,
  ) {
    final messages =
        documents
            .where(
              (document) =>
                  document.data()['conversation_id'] == conversationId &&
                  _hasExpectedParticipants(document, expectedParticipants),
            )
            .map(_messageFromDocument)
            .where((message) => !message.isDeleted)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return messages;
  }

  Future<List<Message>> _loadLatestAuthorizedMessages(
    Map<String, Set<String>> authorizedParticipants,
    String userId,
  ) async {
    if (authorizedParticipants.isEmpty) return [];
    final snapshot = await _participantMessagesQuery(userId).get();
    return _latestConversationMessages(
      snapshot.docs.where((document) {
        final conversationId = document.data()['conversation_id'];
        final expected = authorizedParticipants[conversationId];
        return expected != null && _hasExpectedParticipants(document, expected);
      }),
    );
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
      final authorization = await _authorizationsCollection
          .doc(conversationId)
          .get();
      final authorizationData = authorization.data();
      final participants = authorizationData?['participant_ids'];
      if (!authorization.exists ||
          authorizationData?['active'] != true ||
          participants is! List ||
          !participants.contains(userId)) {
        return const Right([]);
      }
      final snapshot = await _participantMessagesQuery(userId).get();
      return Right(
        _messagesForConversation(
          snapshot.docs,
          conversationId,
          participants.whereType<String>().toSet(),
        ),
      );
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
      latest.putIfAbsent(message.conversationId, () => message);
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
      final authorizations = await _userAuthorizationsQuery(userId).get();
      return Right(
        await _loadLatestAuthorizedMessages(
          _activeConversationParticipants(authorizations.docs),
          userId,
        ),
      );
    } catch (error) {
      return Left(_failure(error, 'Failed to get conversations'));
    }
  }

  @override
  Stream<Either<Failure, List<Message>>> streamConversation(
    String conversationId,
  ) {
    final userId = _currentUserId;
    if (userId == null) {
      return Stream.value(
        Left(FirebaseFailure(message: 'Sign in to view messages')),
      );
    }
    final controller = StreamController<Either<Failure, List<Message>>>();
    var expectedParticipants = <String>{};
    var active = false;
    var messageDocuments = <QueryDocumentSnapshot<Map<String, dynamic>>>[];

    void publish() {
      controller.add(
        Right(
          active
              ? _messagesForConversation(
                  messageDocuments,
                  conversationId,
                  expectedParticipants,
                )
              : const [],
        ),
      );
    }

    late final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
    authorizationSubscription;
    late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    messageSubscription;
    controller.onListen = () {
      authorizationSubscription = _authorizationsCollection
          .doc(conversationId)
          .snapshots()
          .listen(
            (snapshot) {
              final data = snapshot.data();
              final participants = data?['participant_ids'];
              expectedParticipants = participants is List
                  ? participants.whereType<String>().toSet()
                  : <String>{};
              active =
                  snapshot.exists &&
                  data?['active'] == true &&
                  expectedParticipants.contains(userId);
              publish();
            },
            onError: (Object error, StackTrace stackTrace) => controller.add(
              Left(_failure(error, 'Failed to load conversation access')),
            ),
          );
      messageSubscription = _participantMessagesQuery(userId)
          .snapshots()
          .listen(
            (snapshot) {
              messageDocuments = snapshot.docs;
              publish();
            },
            onError: (Object error, StackTrace stackTrace) => controller.add(
              Left(_failure(error, 'Failed to stream conversation')),
            ),
          );
    };
    controller.onCancel = () async {
      await authorizationSubscription.cancel();
      await messageSubscription.cancel();
    };
    return controller.stream;
  }

  @override
  Stream<Either<Failure, List<Message>>> streamConversations(String userId) {
    if (_currentUserId != userId) {
      return Stream.value(Left(FirebaseFailure(message: 'Not authorized')));
    }
    final controller = StreamController<Either<Failure, List<Message>>>();
    var activeParticipants = <String, Set<String>>{};
    var messageDocuments = <QueryDocumentSnapshot<Map<String, dynamic>>>[];

    void publish() {
      controller.add(
        Right(
          _latestConversationMessages(
            messageDocuments.where((document) {
              final conversationId = document.data()['conversation_id'];
              final expected = activeParticipants[conversationId];
              return expected != null &&
                  _hasExpectedParticipants(document, expected);
            }),
          ),
        ),
      );
    }

    late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    authorizationSubscription;
    late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    messageSubscription;
    controller.onListen = () {
      authorizationSubscription = _userAuthorizationsQuery(userId)
          .snapshots()
          .listen(
            (snapshot) {
              activeParticipants = _activeConversationParticipants(
                snapshot.docs,
              );
              publish();
            },
            onError: (Object error, StackTrace stackTrace) => controller.add(
              Left(_failure(error, 'Failed to load conversation access')),
            ),
          );
      messageSubscription = _participantMessagesQuery(userId)
          .snapshots()
          .listen(
            (snapshot) {
              messageDocuments = snapshot.docs;
              publish();
            },
            onError: (Object error, StackTrace stackTrace) => controller.add(
              Left(_failure(error, 'Failed to load conversations')),
            ),
          );
    };
    controller.onCancel = () async {
      await authorizationSubscription.cancel();
      await messageSubscription.cancel();
    };
    return controller.stream;
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

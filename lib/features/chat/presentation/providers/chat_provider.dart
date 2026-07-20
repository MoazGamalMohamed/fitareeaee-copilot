import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Chat repository provider (singleton)
final chatRepositoryProvider = Provider((ref) {
  return ChatRepositoryImpl(firebaseFirestore: FirebaseFirestore.instance);
});

/// Model for the chat state
class ChatState {
  final List<Message> messages;
  final bool isLoading;
  final String? error;

  ChatState({this.messages = const [], this.isLoading = false, this.error});

  ChatState copyWith({
    List<Message>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Notifier for sending messages
class SendMessageNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatRepository _chatRepository;
  final String _userId;

  SendMessageNotifier({
    required ChatRepository chatRepository,
    required String userId,
  }) : _chatRepository = chatRepository,
       _userId = userId,
       super(const AsyncValue.data(null));

  Future<void> sendMessage({
    required String conversationId,
    required String recipientId,
    required String content,
    List<String> attachments = const [],
  }) async {
    state = const AsyncValue.loading();

    final message = Message(
      id: const Uuid().v4(),
      conversationId: conversationId,
      senderId: _userId,
      recipientId: recipientId,
      content: content,
      attachments: attachments,
      createdAt: DateTime.now(),
      isRead: false,
      readAt: null,
      isDeleted: false,
    );

    final result = await _chatRepository.sendMessage(message);

    result.fold((_) {
      final error = Exception(
        'Message could not be sent. Check that this conversation is authorized and try again.',
      );
      state = AsyncValue.error(error, StackTrace.current);
      throw error;
    }, (_) => state = const AsyncValue.data(null));
  }
}

/// Provider for send message notifier
final sendMessageProvider =
    StateNotifierProvider.family<SendMessageNotifier, AsyncValue<void>, String>(
      (ref, recipientId) {
        final userId = ref
            .watch(authStateProvider)
            .maybeWhen(data: (user) => user?.id ?? '', orElse: () => '');
        final repository = ref.watch(chatRepositoryProvider);
        return SendMessageNotifier(chatRepository: repository, userId: userId);
      },
    );

/// Stream provider for a specific conversation
final conversationMessagesProvider =
    StreamProvider.family<List<Message>, String>((ref, conversationId) {
      final chatRepository = ref.watch(chatRepositoryProvider);

      // Stream messages with error handling
      return chatRepository.streamConversation(conversationId).asyncMap((
        result,
      ) {
        return result.fold(
          (failure) => throw Exception(failure.message),
          (messages) => messages,
        );
      });
    });

/// Stream provider for all conversations
final conversationsProvider = StreamProvider<List<Message>>((ref) {
  final userId = ref
      .watch(authStateProvider)
      .maybeWhen(data: (user) => user?.id ?? '', orElse: () => '');

  if (userId.isEmpty) {
    return Stream.value([]);
  }

  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.streamConversations(userId).asyncMap((result) {
    return result.fold(
      (failure) => throw Exception(failure.message),
      (messages) => messages,
    );
  });
});

/// Model for conversation with metadata
class ConversationUI {
  final String conversationId;
  final String otherUserId;
  final String otherUserName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ConversationUI({
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}

/// Notifier for managing mark as read
class MarkAsReadNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatRepository _chatRepository;

  MarkAsReadNotifier({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(const AsyncValue.data(null));

  Future<void> markAsRead(String messageId) async {
    final result = await _chatRepository.markAsRead(messageId);

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.toString(), StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }
}

/// Provider for mark as read notifier
final markAsReadProvider =
    StateNotifierProvider<MarkAsReadNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(chatRepositoryProvider);
      return MarkAsReadNotifier(chatRepository: repository);
    });

/// Notifier for managing message deletion
class DeleteMessageNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatRepository _chatRepository;

  DeleteMessageNotifier({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(const AsyncValue.data(null));

  Future<void> deleteMessage(String messageId) async {
    final result = await _chatRepository.deleteMessage(messageId);

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.toString(), StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }
}

/// Provider for delete message notifier
final deleteMessageProvider =
    StateNotifierProvider<DeleteMessageNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(chatRepositoryProvider);
      return DeleteMessageNotifier(chatRepository: repository);
    });

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/message.dart';
import '../providers/chat_provider.dart';

/// Screen displaying list of conversations
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final currentUser = ref
        .watch(authStateProvider)
        .maybeWhen(data: (user) => user, orElse: () => null);

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to access chat')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Messages'), elevation: 0),
      body: conversationsAsync.when(
        data: (messages) {
          if (messages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No conversations yet',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paid, confirmed trip conversations appear here',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final otherUserId = currentUser.id == message.senderId
                  ? message.recipientId
                  : message.senderId;

              return _ConversationTile(
                message: message,
                otherUserId: otherUserId,
                currentUserId: currentUser.id,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                'Error loading conversations',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Chat opens only for server-paid, confirmed trips. Retry if this booking is eligible.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => ref.invalidate(conversationsProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual conversation tile
class _ConversationTile extends ConsumerWidget {
  final Message message;
  final String otherUserId;
  final String currentUserId;

  const _ConversationTile({
    required this.message,
    required this.otherUserId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the other user's profile
    final otherUserProfileAsync = ref.watch(userByIdProvider(otherUserId));

    return otherUserProfileAsync.when(
      data: (profile) {
        final messagePreview = message.isDeleted
            ? '[Message deleted]'
            : message.content;
        final isRead = message.isRead || message.senderId == currentUserId;
        final unreadCount = !isRead ? 1 : 0;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: profile?.photoUrl != null
                ? NetworkImage(profile!.photoUrl!)
                : null,
            child: profile?.photoUrl == null
                ? Text(
                    profile?.name?.isNotEmpty == true
                        ? profile!.name![0].toUpperCase()
                        : 'U',
                  )
                : null,
          ),
          title: Text(
            profile?.name?.isNotEmpty == true ? profile!.name! : 'User',
            style: TextStyle(
              fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            messagePreview,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: unreadCount > 0 ? Colors.black87 : Colors.grey[600],
              fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(message.createdAt),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
              ),
              if (unreadCount > 0)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () {
            context.push(
              '/chat/$otherUserId?conversationId=${Uri.encodeQueryComponent(message.conversationId)}',
            );
          },
        );
      },
      loading: () => ListTile(
        leading: const CircleAvatar(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        title: const Text('Loading...'),
      ),
      error: (error, stack) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.error_outline)),
        title: const Text('Unknown User'),
        subtitle: Text(
          message.isDeleted ? '[Message deleted]' : message.content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          context.push(
            '/chat/$otherUserId?conversationId=${Uri.encodeQueryComponent(message.conversationId)}',
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../domain/entities/message.dart';
import '../providers/chat_provider.dart';
import 'package:flutter/services.dart';

/// Screen for a specific conversation
class ChatScreen extends ConsumerStatefulWidget {
  final String recipientId;

  const ChatScreen({super.key, required this.recipientId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  bool _shouldAutoScroll = true;
  int _previousMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();

    // Listen to manual scrolling
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        // If user scrolls away from bottom, disable auto-scroll
        final isAtBottom =
            _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100;
        if (!isAtBottom && _shouldAutoScroll) {
          setState(() => _shouldAutoScroll = false);
        } else if (isAtBottom && !_shouldAutoScroll) {
          setState(() => _shouldAutoScroll = true);
        }
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref
        .watch(authStateProvider)
        .maybeWhen(data: (user) => user, orElse: () => null);

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('Please log in')));
    }

    final conversationId = Message.getConversationId(
      currentUser.id,
      widget.recipientId,
    );

    final messagesAsync = ref.watch(
      conversationMessagesProvider(conversationId),
    );
    final typingAsync = ref.watch(
      typingStatusProvider({
        'conversationId': conversationId,
        'userId': widget.recipientId,
      }),
    );
    final otherUserAsync = ref.watch(userProfileProvider(widget.recipientId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: otherUserAsync.maybeWhen(
          data: (profile) => Text(
            (profile != null && profile.name.isNotEmpty)
                ? profile.name
                : (profile != null && profile.email.isNotEmpty)
                ? profile.email
                : 'User',
          ),
          orElse: () => const Text('Chat'),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                // Only auto-scroll if enabled and message count changed
                if (_shouldAutoScroll &&
                    messages.length != _previousMessageCount) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                  _previousMessageCount = messages.length;
                }

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
                          'No messages yet',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation!',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }
                final typingWidget = typingAsync.maybeWhen(
                  data: (isTyping) => isTyping
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Typing...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  orElse: () => const SizedBox.shrink(),
                );

                return Column(
                  children: [
                    if (messages.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${messages.length} messages',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    typingWidget,
                    Expanded(
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        thickness: 8.0,
                        radius: const Radius.circular(10),
                        child: ListView.builder(
                          controller: _scrollController,
                          reverse: false,
                          shrinkWrap: false,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            // Access messages in reverse order for newest-at-bottom display
                            final reversedIndex = messages.length - 1 - index;
                            final message = messages[reversedIndex];
                            final isSentByUser =
                                message.senderId == currentUser.id;

                            // Auto-mark as read
                            if (!message.isRead && !isSentByUser) {
                              Future.microtask(() {
                                ref
                                    .read(markAsReadProvider.notifier)
                                    .markAsRead(message.id);
                              });
                            }

                            // Get sender name - 'You' for sent, other user's name for received
                            final senderName = isSentByUser
                                ? 'You'
                                : otherUserAsync.maybeWhen(
                                    data: (profile) {
                                      if (profile != null &&
                                          profile.name.isNotEmpty) {
                                        return profile.name;
                                      } else if (profile != null &&
                                          profile.email.isNotEmpty) {
                                        return profile.email;
                                      }
                                      return 'User';
                                    },
                                    loading: () {
                                      return 'Loading...';
                                    },
                                    error: (error, stack) {
                                      print('❌ Profile error: $error');
                                      return 'User';
                                    },
                                    orElse: () => 'User',
                                  );

                            return _MessageBubble(
                              message: message,
                              isSentByUser: isSentByUser,
                              senderName: senderName,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text('Error loading messages'),
                  ],
                ),
              ),
            ),
          ),
          // Input field
          _ChatInputField(
            controller: _messageController,
            recipientId: widget.recipientId,
            onMessageSent: () {
              setState(() => _shouldAutoScroll = true);
              _scrollToBottom();
            },
          ),
        ],
      ),
    );
  }
}

/// Message bubble widget
class _MessageBubble extends ConsumerWidget {
  final Message message;
  final bool isSentByUser;
  final String senderName;

  const _MessageBubble({
    required this.message,
    required this.isSentByUser,
    required this.senderName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageText = message.isDeleted
        ? '[Message deleted]'
        : message.content;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isSentByUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isSentByUser) const SizedBox(width: 8),
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                _showMessageOptions(context, ref, message, isSentByUser);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSentByUser
                      ? Colors.blue.shade500
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: isSentByUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Sender name (always show)
                    Text(
                      senderName,
                      style: TextStyle(
                        color: isSentByUser
                            ? Colors.white70
                            : Colors.grey.shade700,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Attachments display
                    if (message.attachments.isNotEmpty)
                      Column(
                        crossAxisAlignment: isSentByUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: message.attachments.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        message.attachments[index],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    Text(
                      messageText,
                      style: TextStyle(
                        color: isSentByUser ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.createdAt),
                          style: TextStyle(
                            color: isSentByUser
                                ? Colors.white70
                                : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        if (isSentByUser) ...[
                          const SizedBox(width: 4),
                          Icon(
                            message.isRead ? Icons.done_all : Icons.done,
                            size: 12,
                            color: message.isRead
                                ? Colors.white
                                : Colors.white70,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isSentByUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showMessageOptions(
    BuildContext context,
    WidgetRef ref,
    Message message,
    bool isSentByUser,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSentByUser)
                  ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: const Text('Delete message'),
                    onTap: () {
                      final messenger = ScaffoldMessenger.of(context);
                      Navigator.pop(context);
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Deleting...')),
                      );
                      ref
                          .read(deleteMessageProvider.notifier)
                          .deleteMessage(message.id)
                          .then((_) {
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Message deleted')),
                            );
                          })
                          .catchError((e) {
                            messenger.showSnackBar(
                              SnackBar(content: Text('Delete failed: $e')),
                            );
                          });
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.content_copy),
                  title: const Text('Copy message'),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      await Clipboard.setData(
                        ClipboardData(text: message.content),
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copy failed: $e')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Chat input field
class _ChatInputField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String recipientId;
  final VoidCallback onMessageSent;

  const _ChatInputField({
    required this.controller,
    required this.recipientId,
    required this.onMessageSent,
  });

  @override
  ConsumerState<_ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<_ChatInputField> {
  bool _isUploading = false;

  Future<void> _sendMessage() async {
    final content = widget.controller.text.trim();
    if (content.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    try {
      await ref
          .read(sendMessageProvider(widget.recipientId).notifier)
          .sendMessage(
            recipientId: widget.recipientId,
            content: content,
            attachments: const [],
          );

      widget.controller.clear();
      setState(() {
        _isUploading = false;
      });
      widget.onMessageSent();
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: _isUploading ? Colors.grey : Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: _isUploading
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send),
                          color: Colors.white,
                          onPressed: _isUploading ? null : _sendMessage,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

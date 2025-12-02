import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../domain/entities/message.dart';
import '../providers/chat_provider.dart';
import 'package:flutter/services.dart';

/// Screen for a specific conversation
class ChatScreen extends ConsumerStatefulWidget {
  final String recipientId;

  const ChatScreen({
    super.key,
    required this.recipientId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
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
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authStateProvider).maybeWhen(
          data: (user) => user,
          orElse: () => null,
        );

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in'),
        ),
      );
    }

    final conversationId = Message.getConversationId(
      currentUser.id,
      widget.recipientId,
    );

    final messagesAsync = ref.watch(
      conversationMessagesProvider(conversationId),
    );
    final typingAsync = ref.watch(typingStatusProvider({
      'conversationId': conversationId,
      'userId': widget.recipientId,
    }));
    final otherUserAsync = ref.watch(userProfileProvider(widget.recipientId));

    return Scaffold(
      appBar: AppBar(
        title: otherUserAsync.maybeWhen(
          data: (profile) => Text(
            (profile != null && profile.name.isNotEmpty) ? profile.name : 'User',
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

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
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation!',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                              ),
                        ),
                      ],
                    ),
                  );
                }
                final typingWidget = typingAsync.maybeWhen(
                  data: (isTyping) => isTyping
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Typing...',
                              style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  orElse: () => const SizedBox.shrink(),
                );

                return Column(
                  children: [
                    typingWidget,
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isSentByUser = message.senderId == currentUser.id;

                          // Auto-mark as read
                          if (!message.isRead && !isSentByUser) {
                            Future.microtask(() {
                              ref
                                  .read(markAsReadProvider.notifier)
                                  .markAsRead(message.id);
                            });
                          }

                          return _MessageBubble(
                            message: message,
                            isSentByUser: isSentByUser,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
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
            onSend: (message) {
              if (message.trim().isEmpty) return;

              ref
                  .read(sendMessageProvider(widget.recipientId).notifier)
                  .sendMessage(
                    recipientId: widget.recipientId,
                    content: message.trim(),
                  );

              _messageController.clear();
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

  const _MessageBubble({
    required this.message,
    required this.isSentByUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageText = message.isDeleted ? '[Message deleted]' : message.content;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                            message.isRead
                                ? Icons.done_all
                                : Icons.done,
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
                      }).catchError((e) {
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
  final Function(String) onSend;

  const _ChatInputField({
    required this.controller,
    required this.onSend,
  });

  @override
  ConsumerState<_ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<_ChatInputField> {
  final ImagePicker _imagePicker = ImagePicker();
  final List<String> _selectedImagePaths = [];

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImagePaths.addAll(pickedFiles.map((file) => file.path));
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick images: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selected images preview
            if (_selectedImagePaths.isNotEmpty)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImagePaths.length,
                  itemBuilder: (context, index) {
                    final imagePath = _selectedImagePaths[index];
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(File(imagePath)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImagePaths.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            // Input row
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _pickImages,
                  tooltip: 'Attach images',
                ),
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
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                    onPressed: () {
                      widget.onSend(widget.controller.text);
                    },
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

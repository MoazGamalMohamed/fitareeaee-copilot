import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/support_model.dart';
import '../providers/support_provider.dart';

class HelpCenterScreen extends ConsumerWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqAsync = ref.watch(faqProvider);
    final ticketsAsync = ref.watch(userTicketsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickAction(
              context,
              Icons.support_agent,
              'Contact Support - AI first, human when needed',
              () => _showCreateTicketDialog(context),
            ),
            const SizedBox(height: 24),
            // My tickets
            _buildSectionHeader('My Tickets', onSeeAll: () {}),
            ticketsAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (tickets) => tickets.isEmpty
                  ? const Text('No support tickets')
                  : Column(
                      children: tickets
                          .take(3)
                          .map((t) => _buildTicketTile(context, t))
                          .toList(),
                    ),
            ),
            const SizedBox(height: 24),
            // FAQ
            _buildSectionHeader('Frequently Asked Questions'),
            faqAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (faqs) => faqs.isEmpty
                  ? const Text('No FAQs available')
                  : Column(
                      children: faqs.map((f) => _buildFAQTile(f, ref)).toList(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTicketDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Contact Support'),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: const Text('See All')),
      ],
    );
  }

  Widget _buildTicketTile(BuildContext context, SupportTicket ticket) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(ticket.status),
          child: Icon(
            _getCategoryIcon(ticket.category),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          ticket.subject,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('${ticket.category.name} • ${ticket.status.name}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/support/ticket/${ticket.id}'),
      ),
    );
  }

  Widget _buildFAQTile(FAQItem faq, WidgetRef ref) {
    return ExpansionTile(
      title: Text(faq.question),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(faq.answer),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Was this helpful?'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.thumb_up_outlined),
                    onPressed: () => markFAQHelpful(faq.id, true),
                  ),
                  Text('${faq.helpfulCount}'),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.thumb_down_outlined),
                    onPressed: () => markFAQHelpful(faq.id, false),
                  ),
                  Text('${faq.notHelpfulCount}'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return Colors.blue;
      case TicketStatus.inProgress:
        return Colors.orange;
      case TicketStatus.resolved:
        return Colors.green;
      case TicketStatus.closed:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(TicketCategory category) {
    switch (category) {
      case TicketCategory.payment:
        return Icons.payment;
      case TicketCategory.trip:
        return Icons.directions_car;
      case TicketCategory.account:
        return Icons.person;
      case TicketCategory.safety:
        return Icons.security;
      case TicketCategory.technical:
        return Icons.build;
      case TicketCategory.other:
        return Icons.help;
    }
  }

  void _showCreateTicketDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CreateTicketSheet(),
    );
  }
}

class SupportTicketScreen extends ConsumerStatefulWidget {
  final String ticketId;

  const SupportTicketScreen({super.key, required this.ticketId});

  @override
  ConsumerState<SupportTicketScreen> createState() =>
      _SupportTicketScreenState();
}

class _SupportTicketScreenState extends ConsumerState<SupportTicketScreen> {
  final _controller = TextEditingController();
  bool _sending = false;
  bool _escalating = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(ticketMessagesProvider(widget.ticketId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Chat'),
        actions: [
          TextButton(
            onPressed: () => _closeTicket(context),
            child: const Text('Close'),
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('support_tickets')
                .doc(widget.ticketId)
                .snapshots(),
            builder: (context, snapshot) {
              final data = snapshot.data?.data();
              return ListTile(
                leading: const Icon(Icons.confirmation_number_outlined),
                title: Text(data?['subject']?.toString() ?? 'Support ticket'),
                subtitle: Text(
                  '${data?['category'] ?? 'support'} - ${data?['status'] ?? 'open'}',
                ),
                trailing: data?['escalated'] == true
                    ? const Chip(label: Text('Human queue'))
                    : TextButton(
                        onPressed: _escalating ? null : _escalate,
                        child: _escalating
                            ? const SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Need a person?'),
                      ),
              );
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(
                child: Text('Support messages are unavailable. Please retry.'),
              ),
              data: (messages) => messages.isEmpty
                  ? const Center(child: Text('No support messages yet.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isGuidance = message.senderName
                            .toLowerCase()
                            .contains('ai support');
                        final isStaff = message.isStaff || isGuidance;
                        return Align(
                          alignment: isStaff
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            constraints: const BoxConstraints(maxWidth: 320),
                            decoration: BoxDecoration(
                              color: isStaff
                                  ? Colors.grey.shade200
                                  : Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.senderName,
                                  style: TextStyle(
                                    color: isStaff
                                        ? Colors.black54
                                        : Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  message.message,
                                  style: TextStyle(
                                    color: isStaff
                                        ? Colors.black87
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      maxLength: 1200,
                      decoration: const InputDecoration(
                        hintText: 'Ask support a question...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : () => _send(context),
                    icon: _sending
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send(BuildContext context) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    try {
      await sendTicketMessage(ticketId: widget.ticketId, message: text);
      if (!mounted) return;
      _controller.clear();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Support reply could not be sent.')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _closeTicket(BuildContext context) async {
    try {
      await closeTicket(widget.ticketId);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Support ticket closed.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket could not be closed.')),
      );
    }
  }

  Future<void> _escalate() async {
    setState(() => _escalating = true);
    try {
      await escalateTicket(widget.ticketId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sent to a human support reviewer.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket could not be escalated.')),
      );
    } finally {
      if (mounted) setState(() => _escalating = false);
    }
  }
}

class _CreateTicketSheet extends ConsumerStatefulWidget {
  const _CreateTicketSheet();

  @override
  ConsumerState<_CreateTicketSheet> createState() => _CreateTicketSheetState();
}

class _CreateTicketSheetState extends ConsumerState<_CreateTicketSheet> {
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  TicketCategory _category = TicketCategory.other;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Support',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'GPT-5.6 provides the first response. Choose “Need a person?” in the conversation whenever the answer is not enough. Do not send passwords, full IDs, or complete card details.',
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<TicketCategory>(
            initialValue: _category,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: TicketCategory.values
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text(c.name.toUpperCase()),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _category = v!),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _subjectController,
            decoration: const InputDecoration(
              labelText: 'Subject',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitTicket,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Ask Support'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitTicket() async {
    if (_subjectController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final ticket = await createTicket(
        category: _category,
        subject: _subjectController.text,
        description: _descriptionController.text,
      );
      if (mounted) {
        final router = GoRouter.of(context);
        final messenger = ScaffoldMessenger.of(context);
        // Invalidate the tickets provider to refresh the list
        ref.invalidate(userTicketsProvider);
        Navigator.pop(context);
        messenger.showSnackBar(
          const SnackBar(content: Text('Support conversation created.')),
        );
        router.push('/support/ticket/${ticket.id}');
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

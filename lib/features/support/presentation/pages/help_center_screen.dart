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
            // Quick actions
            Row(
              children: [
                Expanded(child: _buildQuickAction(context, Icons.chat, 'Contact Support', () => _showCreateTicketDialog(context))),
                const SizedBox(width: 16),
                Expanded(child: _buildQuickAction(context, Icons.smart_toy, 'AI Assistant', () => context.push('/ai-assistant'))),
              ],
            ),
            const SizedBox(height: 24),
            // My tickets
            _buildSectionHeader('My Tickets', onSeeAll: () {}),
            ticketsAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (tickets) => tickets.isEmpty
                  ? const Text('No support tickets')
                  : Column(children: tickets.take(3).map((t) => _buildTicketTile(context, t)).toList()),
            ),
            const SizedBox(height: 24),
            // FAQ
            _buildSectionHeader('Frequently Asked Questions'),
            faqAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (faqs) => faqs.isEmpty
                  ? const Text('No FAQs available')
                  : Column(children: faqs.map((f) => _buildFAQTile(f, ref)).toList()),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTicketDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Ticket'),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, VoidCallback onTap) {
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
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (onSeeAll != null) TextButton(onPressed: onSeeAll, child: const Text('See All')),
      ],
    );
  }

  Widget _buildTicketTile(BuildContext context, SupportTicket ticket) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(ticket.status),
          child: Icon(_getCategoryIcon(ticket.category), color: Colors.white, size: 20),
        ),
        title: Text(ticket.subject, maxLines: 1, overflow: TextOverflow.ellipsis),
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
                  IconButton(icon: const Icon(Icons.thumb_up_outlined), onPressed: () => markFAQHelpful(faq.id, true)),
                  Text('${faq.helpfulCount}'),
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.thumb_down_outlined), onPressed: () => markFAQHelpful(faq.id, false)),
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
      case TicketStatus.open: return Colors.blue;
      case TicketStatus.inProgress: return Colors.orange;
      case TicketStatus.resolved: return Colors.green;
      case TicketStatus.closed: return Colors.grey;
    }
  }

  IconData _getCategoryIcon(TicketCategory category) {
    switch (category) {
      case TicketCategory.payment: return Icons.payment;
      case TicketCategory.trip: return Icons.directions_car;
      case TicketCategory.account: return Icons.person;
      case TicketCategory.safety: return Icons.security;
      case TicketCategory.technical: return Icons.build;
      case TicketCategory.other: return Icons.help;
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

class _CreateTicketSheet extends StatefulWidget {
  const _CreateTicketSheet();

  @override
  State<_CreateTicketSheet> createState() => _CreateTicketSheetState();
}

class _CreateTicketSheetState extends State<_CreateTicketSheet> {
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  TicketCategory _category = TicketCategory.other;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Create Support Ticket', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DropdownButtonFormField<TicketCategory>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
            items: TicketCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name.toUpperCase()))).toList(),
            onChanged: (v) => setState(() => _category = v!),
          ),
          const SizedBox(height: 16),
          TextField(controller: _subjectController, decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 4),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: _isLoading ? null : _submitTicket, child: _isLoading ? const CircularProgressIndicator() : const Text('Submit Ticket')),
          ),
        ],
      ),
    );
  }

  Future<void> _submitTicket() async {
    if (_subjectController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await createTicket(category: _category, subject: _subjectController.text, description: _descriptionController.text);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket created successfully')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

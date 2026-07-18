import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/models/emergency_model.dart';
import '../providers/safety_provider.dart';

class SOSScreen extends ConsumerStatefulWidget {
  final String? tripId;

  const SOSScreen({super.key, this.tripId});

  @override
  ConsumerState<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends ConsumerState<SOSScreen> {
  bool _isTriggering = false;
  EmergencyType _selectedType = EmergencyType.other;

  @override
  Widget build(BuildContext context) {
    final activeAlert = ref.watch(activeEmergencyProvider);
    final contacts = ref.watch(emergencyContactsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency SOS'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: activeAlert.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (alert) => alert != null
            ? _buildActiveAlertView(alert)
            : _buildSOSView(contacts),
      ),
    );
  }

  Widget _buildActiveAlertView(EmergencyAlert alert) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            const Text(
              'SOS ACTIVE',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text('Type: ${alert.type.name.toUpperCase()}'),
            const SizedBox(height: 8),
            Text(
              'Location: ${alert.latitude.toStringAsFixed(4)}, ${alert.longitude.toStringAsFixed(4)}',
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _callEmergency(),
              icon: const Icon(Icons.phone),
              label: const Text('Call Emergency Services'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _cancelAlert(alert.id),
              child: const Text('Cancel SOS'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSOSView(AsyncValue<List<EmergencyContact>> contacts) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // SOS Button
          GestureDetector(
            onLongPress: _triggerSOS,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isTriggering ? Colors.red.shade900 : Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sos, size: 60, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      'HOLD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'for SOS',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Emergency type selector
          const Text(
            'Emergency Type:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: EmergencyType.values.map((type) {
              return ChoiceChip(
                label: Text(type.name.toUpperCase()),
                selected: _selectedType == type,
                onSelected: (selected) => setState(() => _selectedType = type),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          // Quick actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickAction(
                Icons.phone,
                'Call 911',
                () => _callEmergency(),
              ),
              _buildQuickAction(
                Icons.share_location,
                'Share Location',
                () => _shareLocation(),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Emergency contacts
          _buildEmergencyContactsSection(contacts),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: Icon(icon, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactsSection(
    AsyncValue<List<EmergencyContact>> contacts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Emergency Contacts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: _addEmergencyContact,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        contacts.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
          data: (list) => list.isEmpty
              ? const Text('No emergency contacts added')
              : Column(
                  children: list.map((c) => _buildContactTile(c)).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildContactTile(EmergencyContact contact) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(contact.name),
      subtitle: Text(contact.phone),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () => removeEmergencyContact(contact.id),
      ),
    );
  }

  Future<void> _triggerSOS() async {
    setState(() => _isTriggering = true);
    try {
      await triggerSOS(tripId: widget.tripId, type: _selectedType);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SOS Alert Triggered!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isTriggering = false);
    }
  }

  Future<void> _cancelAlert(String alertId) async {
    await cancelSOS(alertId);
    if (mounted)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('SOS Cancelled')));
  }

  Future<void> _callEmergency() async {
    final uri = Uri.parse('tel:911');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _shareLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location shared with emergency contacts')),
    );
  }

  void _addEmergencyContact() {
    showDialog(context: context, builder: (context) => _AddContactDialog());
  }
}

class _AddContactDialog extends StatefulWidget {
  @override
  State<_AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<_AddContactDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Emergency Contact'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await addEmergencyContact(
              name: _nameController.text,
              phone: _phoneController.text,
            );
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

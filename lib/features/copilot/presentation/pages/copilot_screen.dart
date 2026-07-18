import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/copilot_repository.dart';
import '../../domain/copilot_draft.dart';

typedef CopilotPlanner = Future<CopilotPlanResult> Function(String request);

class CopilotScreen extends StatefulWidget {
  final CopilotPlanner? planner;

  const CopilotScreen({super.key, this.planner});

  @override
  State<CopilotScreen> createState() => _CopilotScreenState();
}

class _CopilotScreenState extends State<CopilotScreen> {
  final _request = TextEditingController();
  final _origin = TextEditingController();
  final _destination = TextEditingController();
  final _date = TextEditingController();
  final _time = TextEditingController();
  final _count = TextEditingController();
  final _budget = TextEditingController();
  final _package = TextEditingController();
  final _preferences = TextEditingController();
  CopilotPlanResult? _result;
  String _intent = 'find';
  String _tripType = 'ride';
  bool _loading = false;
  String? _error;

  static const _examples = [
    'I need a ride from Dallas to Austin tomorrow at 9 AM for two people under \$40.',
    'I’m driving to Houston Friday evening with three seats, no smoking.',
    'I need to send a 5 kg package from Chicago to Milwaukee this weekend.',
    'أحتاج رحلة من دالاس إلى أوستن غداً الساعة ٩ صباحاً لشخصين.',
  ];

  @override
  void dispose() {
    for (final controller in [
      _request,
      _origin,
      _destination,
      _date,
      _time,
      _count,
      _budget,
      _package,
      _preferences,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _plan() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final planner = widget.planner ?? CopilotRepository().plan;
      final result = await planner(_request.text.trim());
      if (!mounted) return;
      _loadDraft(result.draft);
      setState(() => _result = result);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _loadDraft(CopilotDraft draft) {
    _intent = draft.intent;
    _tripType = draft.tripType;
    _origin.text = draft.origin ?? '';
    _destination.text = draft.destination ?? '';
    _date.text = draft.departureDate ?? '';
    _time.text = draft.departureTime ?? '';
    _count.text = draft.passengerOrSeatCount?.toString() ?? '';
    _budget.text = draft.maximumBudget?.toStringAsFixed(0) ?? '';
    _package.text = draft.packageDetails ?? '';
    _preferences.text = draft.preferences.join(', ');
  }

  CopilotDraft _editedDraft() {
    final source = _result!.draft;
    return CopilotDraft(
      schemaVersion: source.schemaVersion,
      intent: _intent,
      tripType: _tripType,
      origin: _origin.text.trim(),
      destination: _destination.text.trim(),
      departureDate: _date.text.trim(),
      departureTime: _time.text.trim().isEmpty ? null : _time.text.trim(),
      passengerOrSeatCount: int.tryParse(_count.text.trim()),
      maximumBudget: double.tryParse(_budget.text.trim()),
      packageDetails: _package.text.trim().isEmpty
          ? null
          : _package.text.trim(),
      preferences: _preferences.text
          .split(',')
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .toList(),
      assistantSummary: source.assistantSummary,
      missingInformation: source.missingInformation,
      clarificationQuestion: source.clarificationQuestion,
      language: source.language,
    );
  }

  void _confirm() {
    final draft = _editedDraft();
    final date = draft.departureDate == null
        ? null
        : DateTime.tryParse(draft.departureDate!);
    final validTime =
        draft.departureTime == null ||
        RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$').hasMatch(draft.departureTime!);
    final validCount =
        draft.passengerOrSeatCount == null ||
        (draft.passengerOrSeatCount! >= 1 && draft.passengerOrSeatCount! <= 8);
    final validBudget =
        draft.maximumBudget == null || draft.maximumBudget! >= 0;
    if (!draft.isReadyForMatching ||
        date == null ||
        !validTime ||
        !validCount ||
        !validBudget) {
      setState(() {
        _error =
            'Review the route/date, HH:mm time, 1–8 seats, and non-negative budget.';
      });
      return;
    }
    context.push('/copilot/results', extra: draft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plan with AI')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _disclosure(),
          const SizedBox(height: 20),
          TextField(
            controller: _request,
            minLines: 4,
            maxLines: 7,
            maxLength: 1200,
            textDirection: RegExp(r'[\u0600-\u06FF]').hasMatch(_request.text)
                ? TextDirection.rtl
                : TextDirection.ltr,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Describe your ride or package request',
              hintText:
                  'Where, when, how many people/seats, budget, and preferences…',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Text('Try an example', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ..._examples.map(
            (example) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: OutlinedButton(
                onPressed: _loading
                    ? null
                    : () => setState(() => _request.text = example),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                ),
                child: Text(
                  example,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _loading || _request.text.trim().length < 5
                ? null
                : _plan,
            icon: _loading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome),
            label: Text(_loading ? 'Creating a draft…' : 'Create AI draft'),
          ),
          TextButton(
            onPressed: _loading
                ? null
                : () => context.push('/trips?role=rider'),
            child: const Text('Use manual trip search'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            _messageCard(_error!, Colors.red.shade50, Icons.error_outline),
          ],
          if (_result != null) ...[
            const SizedBox(height: 24),
            _draftReview(_result!),
          ],
        ],
      ),
    );
  }

  Widget _disclosure() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'GPT-5.6 interprets your words into a draft. It does not book, verify identity, guarantee matches, or decide who is safe. You review every field first.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _draftReview(CopilotPlanResult result) {
    final draft = result.draft;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.fact_check_outlined, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'AI draft — review required',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Chip(label: Text(result.model)),
          ],
        ),
        const SizedBox(height: 8),
        Text(draft.assistantSummary),
        if (result.piiRedacted) ...[
          const SizedBox(height: 8),
          _messageCard(
            'Contact details were removed before the request was sent to OpenAI.',
            Colors.amber.shade50,
            Icons.privacy_tip_outlined,
          ),
        ],
        if (draft.clarificationQuestion != null) ...[
          const SizedBox(height: 8),
          _messageCard(
            draft.clarificationQuestion!,
            Colors.orange.shade50,
            Icons.help_outline,
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _intent,
                decoration: const InputDecoration(labelText: 'Intent'),
                items: const [
                  DropdownMenuItem(value: 'find', child: Text('Find')),
                  DropdownMenuItem(value: 'offer', child: Text('Offer')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _intent = value);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _tripType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'ride', child: Text('Ride')),
                  DropdownMenuItem(value: 'package', child: Text('Package')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _tripType = value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _field(_origin, 'Origin', Icons.trip_origin),
        _field(_destination, 'Destination', Icons.location_on_outlined),
        Row(
          children: [
            Expanded(
              child: _field(_date, 'Date (YYYY-MM-DD)', Icons.calendar_today),
            ),
            const SizedBox(width: 12),
            Expanded(child: _field(_time, 'Time (HH:mm)', Icons.schedule)),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _field(
                _count,
                'People / seats',
                Icons.people_outline,
                numeric: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _field(
                _budget,
                'Maximum budget (USD)',
                Icons.attach_money,
                numeric: true,
              ),
            ),
          ],
        ),
        if (_tripType == 'package')
          _field(_package, 'Package details', Icons.inventory_2_outlined),
        _field(_preferences, 'Preferences (comma separated)', Icons.tune),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _confirm,
          icon: const Icon(Icons.search),
          label: const Text('Confirm draft and find transparent matches'),
        ),
        const SizedBox(height: 8),
        const Text(
          'Confirmation starts a deterministic search only. It does not create a trip or booking.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool numeric = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: numeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _messageCard(String message, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

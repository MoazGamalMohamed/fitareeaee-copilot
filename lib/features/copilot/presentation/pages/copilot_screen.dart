import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../core/location/location_catalog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/assisted_text_form_field.dart';
import '../../data/copilot_repository.dart';
import '../../data/trip_prompt_template_store.dart';
import '../../domain/copilot_draft.dart';

typedef CopilotPlanner = Future<CopilotPlanResult> Function(String request);

String? copilotIntentForRole(String? role) => switch (role) {
  'driver' => 'offer',
  'rider' => 'find',
  _ => null,
};

String copilotIntentForDraft(String? role, String modelIntent) =>
    copilotIntentForRole(role) ?? modelIntent;

String copilotVoiceErrorMessage(String rawError) {
  final error = rawError.toLowerCase().replaceAll('-', '_');
  final denied =
      error.contains('permission') ||
      error.contains('not_allowed') ||
      error.contains('not allowed') ||
      error.contains('denied');
  if (denied) {
    return 'Microphone permission is off. Enable it in Android Settings > Apps > Fitareeaee > Permissions, then retry.';
  }
  final noSpeech =
      error.contains('speech_timeout') ||
      error.contains('no_match') ||
      error.contains('no match') ||
      error.contains('no speech') ||
      error.contains('timeout');
  if (noSpeech) {
    return 'No speech was heard. Tap the microphone and speak after listening starts, or type the request.';
  }
  if (error.contains('busy')) {
    return 'Android speech recognition is busy. Wait a moment, then tap the microphone again.';
  }
  return 'Voice input stopped. Tap the microphone to try again or type the request.';
}

class CopilotScreen extends StatefulWidget {
  final CopilotPlanner? planner;
  final String? role;
  final String? templateOwnerId;
  final TripPromptTemplateStore? templateStore;

  const CopilotScreen({
    super.key,
    this.planner,
    this.role,
    this.templateOwnerId,
    this.templateStore,
  });

  @override
  State<CopilotScreen> createState() => _CopilotScreenState();
}

class _CopilotScreenState extends State<CopilotScreen> {
  final _scrollController = ScrollController();
  final _requestFocus = FocusNode();
  final _request = TextEditingController();
  final _origin = TextEditingController();
  final _destination = TextEditingController();
  final _date = TextEditingController();
  final _time = TextEditingController();
  final _count = TextEditingController();
  final _budget = TextEditingController();
  final _package = TextEditingController();
  final _preferences = TextEditingController();
  final _speech = SpeechToText();
  CopilotPlanResult? _result;
  String _intent = 'find';
  String _tripType = 'ride';
  bool _loading = false;
  bool _speechReady = false;
  bool _listening = false;
  bool _startingVoice = false;
  int _voiceSecondsRemaining = 180;
  Timer? _voiceTimer;
  String _voicePrefix = '';
  String _voiceLanguage = 'auto';
  String? _error;
  List<TripPromptTemplate> _templates = const [];
  bool _templatesLoading = false;

  bool get _driverPath => widget.role == 'driver';
  bool get _requestPath => widget.role == 'rider';
  bool get _neutralPath => !_driverPath && !_requestPath;
  List<String> get _visibleExamples => _driverPath
      ? [_examples[1]]
      : (_requestPath ? [_examples[0], _examples[2], _examples[3]] : _examples);

  static const _examples = [
    'I need a ride from Dallas to Austin on August 10, 2026 at 9 AM for two people under \$40.',
    'I’m driving from Dallas to Austin on August 10, 2026 at noon with three seats, no smoking.',
    'I need to send a 5 kg package from Chicago to Milwaukee on August 10, 2026.',
    'أحتاج رحلة من دالاس إلى أوستن يوم 10 أغسطس 2026 الساعة 9 صباحاً لشخصين وبأقل من 40 دولاراً.',
  ];

  TripPromptTemplateStore get _templateStore =>
      widget.templateStore ?? TripPromptTemplateStore();

  @override
  void initState() {
    super.initState();
    unawaited(_loadTemplates());
  }

  @override
  void dispose() {
    _voiceTimer?.cancel();
    _speech.stop();
    _scrollController.dispose();
    _requestFocus.dispose();
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
    if (_listening) await _stopVoiceInput();
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      final planner = widget.planner ?? CopilotRepository().plan;
      final result = await planner(_request.text.trim());
      if (!mounted) return;
      _loadDraft(result.draft);
      setState(() => _result = result);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is CopilotException
            ? error.message
            : 'AI planning is unavailable. Retry or use manual search.';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        _revealOutcome();
      }
    }
  }

  void _revealOutcome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _loadDraft(CopilotDraft draft) {
    _intent = copilotIntentForDraft(widget.role, draft.intent);
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
      appBar: AppBar(title: const Text('GPT-5.6 Trip Planner')),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        children: [
          _disclosure(),
          const SizedBox(height: 12),
          if (!_neutralPath) ...[
            Card(
              color: _driverPath ? Colors.green.shade50 : Colors.blue.shade50,
              child: ListTile(
                leading: Icon(
                  _driverPath ? Icons.drive_eta : Icons.person_search,
                  color: _driverPath ? Colors.green.shade700 : Colors.blue,
                ),
                title: Text(_driverPath ? 'Offer mode' : 'Request mode'),
                subtitle: Text(
                  _driverPath
                      ? 'Driver and vehicle verification is required before publishing.'
                      : 'You review the request before it is published.',
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          TextField(
            controller: _request,
            focusNode: _requestFocus,
            minLines: 4,
            maxLines: 7,
            maxLength: 1200,
            textDirection: RegExp(r'[\u0600-\u06FF]').hasMatch(_request.text)
                ? TextDirection.rtl
                : TextDirection.ltr,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: _driverPath
                  ? 'Describe your ride or delivery offer'
                  : (_requestPath
                        ? 'Describe your ride or delivery request'
                        : 'Describe the ride or delivery you need or can offer'),
              hintText:
                  'Where, when, how many people/seats, budget, and preferences…',
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
            ),
          ),
          if (widget.templateOwnerId case final ownerId?
              when ownerId.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _templatePanel(),
          ],
          const SizedBox(height: 8),
          Text('Try an example', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ..._visibleExamples.map(
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
          const Text(
            'Do not include names, IDs, document numbers, email addresses, phone numbers, links, or private chat details.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Voice recognition language',
              prefixIcon: Icon(Icons.translate_outlined),
              border: OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _voiceLanguage,
                isExpanded: true,
                onChanged: _loading || _listening
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _voiceLanguage = value);
                        }
                      },
                items: const [
                  DropdownMenuItem(
                    value: 'auto',
                    child: Text('Auto / device language'),
                  ),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text('Arabic / العربية'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _loading || _startingVoice ? null : _toggleVoiceInput,
            icon: Icon(
              _startingVoice
                  ? Icons.hourglass_top
                  : _listening
                  ? Icons.stop_circle_outlined
                  : Icons.mic_outlined,
            ),
            label: Text(
              _startingVoice
                  ? 'Starting microphone…'
                  : _listening
                  ? 'Stop listening'
                  : 'Describe trip by voice',
            ),
          ),
          if (_listening) ...[
            const SizedBox(height: 8),
            Semantics(
              liveRegion: true,
              child: Text(
                'Listening • ${_formatVoiceTime(_voiceSecondsRemaining)} remaining. Speak in English or Arabic; your words appear above.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: 8),
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
            label: Text(
              _loading ? 'Creating a draft…' : 'Create GPT-5.6 draft',
            ),
          ),
          if (_neutralPath)
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: _loading
                        ? null
                        : () => context.push('/trips/create?role=rider'),
                    icon: const Icon(Icons.person_search_outlined),
                    label: const Text('Request manually'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: _loading
                        ? null
                        : () => context.push('/trips/create?role=driver'),
                    icon: const Icon(Icons.drive_eta_outlined),
                    label: const Text('Offer manually'),
                  ),
                ),
              ],
            )
          else
            TextButton(
              onPressed: _loading
                  ? null
                  : () => context.push(
                      '/trips/create?role=${_driverPath ? 'driver' : 'rider'}',
                    ),
              child: Text(
                _driverPath
                    ? 'Create an offer manually'
                    : 'Create a request manually',
              ),
            ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Semantics(
              liveRegion: true,
              child: _messageCard(
                _error!,
                Colors.red.shade50,
                Icons.error_outline,
              ),
            ),
          ],
          if (_result != null) ...[
            const SizedBox(height: 24),
            Semantics(liveRegion: true, child: _draftReview(_result!)),
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

  Widget _templatePanel() {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: _templates.isNotEmpty,
        leading: const Icon(Icons.bookmarks_outlined),
        title: const Text('Saved trip templates'),
        subtitle: const Text(
          'Editable and stored only for this account on this device',
        ),
        children: [
          if (_templatesLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(),
            )
          else if (_templates.isEmpty)
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('No saved templates yet'),
              subtitle: Text(
                'Describe a recurring trip, then save it for one-tap reuse.',
              ),
            )
          else
            ..._templates.map(
              (template) => ListTile(
                leading: const Icon(Icons.route_outlined),
                title: Text(template.name),
                subtitle: Text(
                  template.request,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => _applyTemplate(template),
                trailing: PopupMenuButton<String>(
                  tooltip: 'Manage ${template.name}',
                  onSelected: (action) {
                    if (action == 'edit') {
                      unawaited(_editTemplate(template));
                    } else if (action == 'delete') {
                      unawaited(_deleteTemplate(template));
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Save current request as template'),
            subtitle: const Text(
              'Do not save names, contact details, IDs, or payment information.',
            ),
            enabled: _request.text.trim().length >= 5,
            onTap: _request.text.trim().length < 5
                ? null
                : () => _editTemplate(null),
          ),
        ],
      ),
    );
  }

  Future<void> _loadTemplates() async {
    final ownerId = widget.templateOwnerId?.trim();
    if (ownerId == null || ownerId.isEmpty) return;
    if (mounted) setState(() => _templatesLoading = true);
    try {
      final templates = await _templateStore.load(ownerId);
      if (mounted) setState(() => _templates = templates);
    } catch (_) {
      if (mounted) setState(() => _templates = const []);
    } finally {
      if (mounted) setState(() => _templatesLoading = false);
    }
  }

  void _applyTemplate(TripPromptTemplate template) {
    setState(() {
      _request.text = template.request;
      _request.selection = TextSelection.collapsed(
        offset: template.request.length,
      );
      _error = null;
      _result = null;
    });
    _requestFocus.requestFocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${template.name} loaded for review.')),
      );
  }

  Future<void> _editTemplate(TripPromptTemplate? existing) async {
    final ownerId = widget.templateOwnerId?.trim();
    if (ownerId == null || ownerId.isEmpty) return;
    final formKey = GlobalKey<FormState>();
    var name = existing?.name ?? 'My trip';
    var request = existing?.request ?? _request.text.trim();
    final template = await showDialog<TripPromptTemplate>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(existing == null ? 'Save trip template' : 'Edit template'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: name,
                  maxLength: TripPromptTemplateStore.maxNameLength,
                  decoration: const InputDecoration(labelText: 'Template name'),
                  onChanged: (value) => name = value,
                  validator: (value) => (value?.trim().isEmpty ?? true)
                      ? 'Enter a template name.'
                      : null,
                ),
                TextFormField(
                  initialValue: request,
                  minLines: 4,
                  maxLines: 7,
                  maxLength: TripPromptTemplateStore.maxRequestLength,
                  decoration: const InputDecoration(
                    labelText: 'Reusable trip request',
                    alignLabelWithHint: true,
                  ),
                  onChanged: (value) => request = value,
                  validator: (value) => (value?.trim().length ?? 0) < 5
                      ? 'Describe the recurring trip.'
                      : null,
                ),
                const Text(
                  'Stored locally on this device. It is sent to GPT-5.6 only when you choose Create GPT-5.6 draft.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              Navigator.pop(
                dialogContext,
                TripPromptTemplate(
                  id:
                      existing?.id ??
                      DateTime.now().microsecondsSinceEpoch.toString(),
                  name: name.trim(),
                  request: request.trim(),
                  updatedAt: DateTime.now(),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (template == null || !mounted) return;
    try {
      final templates = await _templateStore.upsert(ownerId, template);
      if (!mounted) return;
      setState(() => _templates = templates);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Trip template saved.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Template could not be saved. Retry.')),
      );
    }
  }

  Future<void> _deleteTemplate(TripPromptTemplate template) async {
    final ownerId = widget.templateOwnerId?.trim();
    if (ownerId == null || ownerId.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete trip template?'),
        content: Text('Remove ${template.name} from this device?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      final templates = await _templateStore.delete(ownerId, template.id);
      if (!mounted) return;
      setState(() => _templates = templates);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Trip template deleted.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Template could not be deleted. Retry.')),
      );
    }
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
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Trip action'),
                child: Text(_driverPath ? 'Offer' : 'Request'),
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
        _locationField(_origin, 'Origin', Icons.trip_origin),
        _locationField(_destination, 'Destination', Icons.location_on_outlined),
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
          key: const ValueKey('copilot-confirm-draft'),
          onPressed: _confirm,
          icon: const Icon(Icons.search),
          label: const Text('Confirm draft and find transparent matches'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _announceDraft(draft),
          icon: const Icon(Icons.record_voice_over_outlined),
          label: const Text('Read draft summary'),
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

  Future<void> _toggleVoiceInput() async {
    if (_listening) {
      await _stopVoiceInput();
      return;
    }

    setState(() => _startingVoice = true);
    try {
      if (!await _ensureSpeechReady()) return;
      final locales = await _speech.locales();
      final inferredArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(_request.text);
      final requestedPrefix = _voiceLanguage == 'auto'
          ? (inferredArabic ? 'ar' : null)
          : _voiceLanguage;
      String? localeId;
      if (requestedPrefix != null) {
        for (final locale in locales) {
          if (locale.localeId.toLowerCase().startsWith(requestedPrefix)) {
            localeId = locale.localeId;
            break;
          }
        }
        if (localeId == null) {
          _setVoiceError(
            requestedPrefix == 'ar'
                ? 'Arabic speech recognition is not installed. Install an Arabic speech language or choose Auto.'
                : 'English speech recognition is not installed. Install an English speech language or choose Auto.',
          );
          return;
        }
      }
      if (!mounted) return;
      _voicePrefix = _request.text.trim();
      setState(() {
        _error = null;
        _listening = true;
        _voiceSecondsRemaining = 180;
      });
      _startVoiceTimer();
      await _speech.listen(
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          listenFor: const Duration(minutes: 3),
          pauseFor: const Duration(seconds: 10),
          cancelOnError: true,
          partialResults: true,
          listenMode: ListenMode.dictation,
        ),
        onResult: (result) {
          if (!mounted) return;
          final recognized = result.recognizedWords.trim();
          final combined = [
            if (_voicePrefix.isNotEmpty) _voicePrefix,
            if (recognized.isNotEmpty) recognized,
          ].join(' ');
          setState(() {
            _request.text = combined;
            _request.selection = TextSelection.collapsed(
              offset: combined.length,
            );
          });
        },
      );
    } catch (_) {
      _setVoiceError(
        'Voice recognition could not start. Check microphone permission and the device speech service, then retry.',
      );
    } finally {
      if (mounted) setState(() => _startingVoice = false);
    }
  }

  Future<bool> _ensureSpeechReady() async {
    final alreadyGranted = await _speech.hasPermission;
    if (!alreadyGranted) {
      final continueWithPermission = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(Icons.mic_outlined),
          title: const Text('Use your microphone?'),
          content: const Text(
            'Fitareeaee uses Android speech recognition to turn your words into this editable trip draft. Listening stops automatically after three minutes. Audio is not saved by Fitareeaee.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Not now'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Allow and start'),
            ),
          ],
        ),
      );
      if (continueWithPermission != true || !mounted) return false;
    }

    if (!_speechReady) {
      _speechReady = await _speech.initialize(
        onStatus: (status) {
          if (!mounted) return;
          if (status == 'done' || status == 'notListening') {
            _finishVoiceSession();
          } else if (status == 'listening' && !_listening) {
            setState(() => _listening = true);
          }
        },
        onError: (error) {
          if (!mounted) return;
          _setVoiceError(copilotVoiceErrorMessage(error.errorMsg));
        },
      );
    }
    final granted = await _speech.hasPermission;
    if (!_speechReady || !granted) {
      _setVoiceError(
        granted
            ? 'Android speech recognition is unavailable. Install or enable the device speech service, or type the request.'
            : 'Microphone permission was not granted. Enable it in Android Settings, then tap the microphone again.',
      );
      return false;
    }
    return true;
  }

  void _startVoiceTimer() {
    _voiceTimer?.cancel();
    _voiceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_listening) {
        timer.cancel();
        return;
      }
      if (_voiceSecondsRemaining <= 1) {
        timer.cancel();
        unawaited(_stopVoiceInput());
        return;
      }
      setState(() => _voiceSecondsRemaining--);
    });
  }

  Future<void> _stopVoiceInput() async {
    _voiceTimer?.cancel();
    if (_speechReady) await _speech.stop();
    _finishVoiceSession();
  }

  void _finishVoiceSession() {
    _voiceTimer?.cancel();
    if (mounted && _listening) setState(() => _listening = false);
  }

  void _setVoiceError(String message) {
    _voiceTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _listening = false;
      _error = message;
    });
  }

  String _formatVoiceTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '$minutes:${remainder.toString().padLeft(2, '0')}';
  }

  void _announceDraft(CopilotDraft draft) {
    final summary = [
      draft.assistantSummary,
      if (draft.origin != null && draft.destination != null)
        'Route from ${draft.origin} to ${draft.destination}.',
      if (draft.departureDate != null) 'Date ${draft.departureDate}.',
      if (draft.departureTime != null) 'Time ${draft.departureTime}.',
    ].join(' ');
    SemanticsService.sendAnnouncement(
      View.of(context),
      summary,
      draft.language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft summary sent to screen reader.')),
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

  Widget _locationField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AssistedTextFormField(
        controller: controller,
        label: label,
        hint: 'Start typing a city or enter your own',
        icon: icon,
        suggestions: placeSuggestions.map((place) => place.label),
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

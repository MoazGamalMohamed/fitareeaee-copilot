import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/currency/currency_formatter.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../copilot/domain/copilot_draft.dart';
import '../../../verification/domain/verification_requirements.dart';
import '../../../verification/presentation/providers/verification_provider.dart';
import '../../domain/entities/trip.dart';
import '../providers/trip_provider.dart';
import 'trip_location_picker_screen.dart';

String tripLocationLabelAfterMapPick(
  String currentLabel,
  TripLocationSelection selection,
) {
  final resolvedAddress = selection.address?.trim() ?? '';
  if (resolvedAddress.isNotEmpty) return resolvedAddress;
  final normalized = currentLabel.trim();
  if (normalized.isEmpty || normalized.startsWith('Map pin ')) {
    return 'Map pin ${selection.coordinateLabel}';
  }
  return normalized;
}

class CreateTripScreen extends ConsumerStatefulWidget {
  const CreateTripScreen({super.key, this.role, this.initialDraft});

  final String? role;
  final CopilotDraft? initialDraft;

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _origin = TextEditingController();
  final _destination = TextEditingController();
  final _price = TextEditingController();
  final _seats = TextEditingController(text: '1');
  final _notes = TextEditingController();
  final _packageWeight = TextEditingController();
  final _packageDescription = TextEditingController();

  late String _role;
  late String _type;
  DateTime? _date;
  TimeOfDay? _time;
  bool _withPets = false;
  bool _smoking = false;
  TripLocationSelection? _originLocation;
  TripLocationSelection? _destinationLocation;

  @override
  void initState() {
    super.initState();
    final draft = widget.initialDraft;
    _role = widget.role == 'driver' || draft?.intent == 'offer'
        ? 'offer'
        : 'request';
    _type = draft?.tripType == 'package' ? 'package' : 'person';
    _origin.text = draft?.origin ?? '';
    _destination.text = draft?.destination ?? '';
    final currency = ref.read(settingsProvider).currency;
    _price.text = draft?.maximumBudget == null
        ? ''
        : CurrencyFormatter.fromUsd(
            draft!.maximumBudget!,
            currency,
          ).toStringAsFixed(2);
    _seats.text = (draft?.passengerOrSeatCount ?? 1).toString();
    _packageDescription.text = draft?.packageDetails ?? '';
    final preferences = (draft?.preferences ?? const <String>[])
        .join(' ')
        .toLowerCase();
    _withPets = preferences.contains('pet');
    _smoking =
        preferences.contains('smoking') && !preferences.contains('no smoking');
    if (draft?.departureDate case final date?) {
      _date = DateTime.tryParse(date);
    }
    if (draft?.departureTime case final rawTime?) {
      final parts = rawTime.split(':').map(int.tryParse).toList();
      if (parts.length == 2 && parts[0] != null && parts[1] != null) {
        _time = TimeOfDay(hour: parts[0]!, minute: parts[1]!);
      }
    }
  }

  @override
  void dispose() {
    _origin.dispose();
    _destination.dispose();
    _price.dispose();
    _seats.dispose();
    _notes.dispose();
    _packageWeight.dispose();
    _packageDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createTripProvider);
    final settings = ref.watch(settingsProvider);
    final offering = _role == 'offer';
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final verificationAsync = userId == null
        ? const AsyncValue.data(null)
        : ref.watch(verificationStatusProvider(userId));
    final tripReady = verificationAsync.maybeWhen(
      data: (verification) => offering
          ? driverTripVerificationComplete(verification)
          : participantTripVerificationComplete(verification),
      orElse: () => false,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          offering ? 'Offer a ride or delivery' : 'Request a ride or delivery',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: offering ? Colors.green.shade50 : Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      offering ? Icons.drive_eta : Icons.person_search,
                      color: offering ? Colors.green.shade700 : Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        offering
                            ? 'You drive or deliver and receive payment after completion. Driver and vehicle verification is required.'
                            : 'You ride or send a package. Payment is required only after you choose a match.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!tripReady) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.push(
                  '/verification?role=${offering ? 'driver' : 'rider'}',
                ),
                icon: const Icon(Icons.verified_user_outlined),
                label: Text(
                  offering
                      ? 'Complete driver and vehicle verification'
                      : 'Complete email, phone, ID, and selfie verification',
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text('Trip type', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'person',
                  icon: Icon(Icons.people_outline),
                  label: Text('Ride'),
                ),
                ButtonSegment(
                  value: 'package',
                  icon: Icon(Icons.inventory_2_outlined),
                  label: Text('Package'),
                ),
                ButtonSegment(
                  value: 'both',
                  icon: Icon(Icons.all_inbox_outlined),
                  label: Text('Both'),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (value) =>
                  setState(() => _type = value.first),
            ),
            const SizedBox(height: 20),
            TripLocationInput(
              controller: _origin,
              label: 'From',
              icon: Icons.trip_origin,
              selection: _originLocation,
              onPick: () => _pickLocation(origin: true),
            ),
            TripLocationInput(
              controller: _destination,
              label: 'To',
              icon: Icons.location_on_outlined,
              selection: _destinationLocation,
              onPick: () => _pickLocation(origin: false),
            ),
            Row(
              children: [
                Expanded(child: _dateField(context)),
                const SizedBox(width: 12),
                Expanded(child: _timeField(context)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _textField(
                    controller: _seats,
                    label: offering ? 'Seats available' : 'Seats needed',
                    icon: Icons.event_seat_outlined,
                    number: true,
                    validator: _seatValidator,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _textField(
                    controller: _price,
                    label:
                        '${offering ? 'Price per seat' : 'Maximum budget'} (${settings.currency})',
                    icon: Icons.currency_exchange,
                    number: true,
                    validator: _priceValidator,
                  ),
                ),
              ],
            ),
            if (_type != 'person') ...[
              _textField(
                controller: _packageWeight,
                label: 'Package weight (kg)',
                icon: Icons.scale_outlined,
                number: true,
                validator: _packageWeightValidator,
              ),
              _textField(
                controller: _packageDescription,
                label: 'Package description',
                icon: Icons.description_outlined,
                maxLines: 3,
              ),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('With pets'),
              subtitle: const Text('Show this preference to the other party'),
              value: _withPets,
              onChanged: (value) => setState(() => _withPets = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Smoking allowed'),
              value: _smoking,
              onChanged: (value) => setState(() => _smoking = value),
            ),
            _textField(
              controller: _notes,
              label: 'Additional notes (optional)',
              icon: Icons.notes,
              maxLines: 3,
              required: false,
            ),
            if (state case AsyncError(:final error)) ...[
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_safeError(error)),
                ),
              ),
              const SizedBox(height: 12),
            ],
            FilledButton.icon(
              onPressed: state is AsyncLoading || !tripReady ? null : _submit,
              icon: state is AsyncLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_road),
              label: Text(
                offering ? 'Publish ride offer' : 'Publish trip request',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Publishing creates a potential match only. Payment and both-party confirmation happen later.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool number = false,
    int maxLines = 1,
    bool required = true,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLines > 1 ? 500 : 160,
        keyboardType: number
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator:
            validator ??
            (value) {
              if (!required) return null;
              final normalized = value?.trim() ?? '';
              return normalized.length < 2 ? '$label is required' : null;
            },
      ),
    );
  }

  Future<void> _pickLocation({required bool origin}) async {
    final current = origin ? _originLocation : _destinationLocation;
    final result = await Navigator.of(context).push<TripLocationSelection>(
      MaterialPageRoute(
        builder: (_) => TripLocationPickerScreen(
          title: origin ? 'Choose starting point' : 'Choose destination',
          initialLatitude: current?.latitude,
          initialLongitude: current?.longitude,
        ),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (origin) {
        _originLocation = result;
        _origin.text = tripLocationLabelAfterMapPick(_origin.text, result);
      } else {
        _destinationLocation = result;
        _destination.text = tripLocationLabelAfterMapPick(
          _destination.text,
          result,
        );
      }
    });
  }

  Widget _dateField(BuildContext context) => InkWell(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: _date ?? DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 366)),
      );
      if (picked != null) setState(() => _date = picked);
    },
    child: InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Date',
        prefixIcon: Icon(Icons.calendar_today_outlined),
        border: OutlineInputBorder(),
      ),
      child: Text(
        _date == null
            ? 'Choose'
            : '${_date!.month}/${_date!.day}/${_date!.year}',
      ),
    ),
  );

  Widget _timeField(BuildContext context) => InkWell(
    onTap: () async {
      final picked = await showTimePicker(
        context: context,
        initialTime: _time ?? TimeOfDay.now(),
      );
      if (picked != null) setState(() => _time = picked);
    },
    child: InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Time',
        prefixIcon: Icon(Icons.schedule_outlined),
        border: OutlineInputBorder(),
      ),
      child: Text(_time == null ? 'Choose' : _time!.format(context)),
    ),
  );

  String? _seatValidator(String? value) {
    final parsed = int.tryParse(value ?? '');
    return parsed == null || parsed < 1 || parsed > 8 ? 'Use 1-8' : null;
  }

  String? _priceValidator(String? value) {
    final parsed = double.tryParse(value ?? '');
    return parsed == null || parsed < 0 || parsed > 100000
        ? 'Invalid amount'
        : null;
  }

  String? _packageWeightValidator(String? value) {
    if (_type == 'person') return null;
    final parsed = double.tryParse(value ?? '');
    return parsed == null || parsed <= 0 || parsed > 1000
        ? 'Invalid weight'
        : null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_originLocation == null || _destinationLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pick both the starting point and destination on the map.',
          ),
        ),
      );
      return;
    }
    if (_date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a departure date and time.')),
      );
      return;
    }
    final departure = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _time!.hour,
      _time!.minute,
    );
    if (!departure.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Departure must be in the future.')),
      );
      return;
    }
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    final role = _role;
    final now = DateTime.now();
    final trip = Trip(
      id: '',
      type: _type,
      role: role,
      driverId: userId,
      originAddress: _origin.text.trim(),
      destinationAddress: _destination.text.trim(),
      originLat: _originLocation!.latitude,
      originLng: _originLocation!.longitude,
      destinationLat: _destinationLocation!.latitude,
      destinationLng: _destinationLocation!.longitude,
      departureTime: departure,
      distance: 0,
      estimatedDuration: 0,
      pricePerSeat: CurrencyFormatter.toUsd(
        double.parse(_price.text),
        ref.read(settingsProvider).currency,
      ),
      totalSeats: int.parse(_seats.text),
      availableSeats: int.parse(_seats.text),
      status: 'pending',
      description: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      allowPets: _withPets,
      allowSmoking: _smoking,
      createdAt: now,
      updatedAt: now,
      includesPerson: _type != 'package',
      includesPackage: _type != 'person',
      packageWeight: _type == 'person'
          ? null
          : double.parse(_packageWeight.text),
      packageDescription: _type == 'person'
          ? null
          : _packageDescription.text.trim(),
    );
    await ref.read(createTripProvider.notifier).createTrip(trip);
    final result = ref.read(createTripProvider);
    if (result is AsyncError || !mounted) return;
    ref.invalidate(availableTripsProvider);
    ref.invalidate(allTripsProvider);
    ref.invalidate(userTripsProvider(userId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          role == 'offer' ? 'Ride offer published.' : 'Trip request published.',
        ),
      ),
    );
    context.go('/trips?tab=my&role=${role == 'offer' ? 'driver' : 'rider'}');
  }

  String _safeError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');
    return message.length > 240 ? 'Trip could not be created.' : message;
  }
}

/// A map-first trip location input. The complete field, map icon, and explicit
/// button all launch the same picker so tapping "From" or "To" never opens a
/// keyboard-only dead end.
class TripLocationInput extends StatelessWidget {
  const TripLocationInput({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.selection,
    required this.onPick,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TripLocationSelection? selection;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            label: 'Open map for $label location',
            child: TextFormField(
              key: ValueKey('trip-location-$label'),
              controller: controller,
              readOnly: true,
              enableInteractiveSelection: false,
              onTap: onPick,
              decoration: InputDecoration(
                labelText: label,
                hintText: 'Tap to choose on map',
                helperText: 'Tap this field to open the interactive map',
                prefixIcon: Icon(icon),
                suffixIcon: IconButton(
                  tooltip: 'Pick $label on map',
                  onPressed: onPick,
                  icon: Icon(
                    selection == null ? Icons.map_outlined : Icons.location_on,
                  ),
                ),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                final normalized = value?.trim() ?? '';
                return normalized.length < 2 ? '$label is required' : null;
              },
            ),
          ),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: onPick,
            icon: Icon(
              selection == null ? Icons.map_outlined : Icons.location_on,
            ),
            label: Text(
              selection == null
                  ? 'Pick $label on map'
                  : '$label pin: ${selection!.coordinateLabel}',
            ),
          ),
        ],
      ),
    );
  }
}

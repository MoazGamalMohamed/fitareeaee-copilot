import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/trip_provider.dart';
import '../../domain/entities/trip.dart';
import '../../../../core/theme/app_colors.dart';

/// Provider for current user ID
final currentUserIdProvider = Provider<String?>((ref) {
  return FirebaseAuth.instance.currentUser?.uid;
});

/// Create Trip Screen with support for:
/// - Role context (driver/rider) from navigation
/// - Person vs Package trip types
/// - Combined person + package trips
class CreateTripScreen extends ConsumerStatefulWidget {
  /// The role passed from home screen: 'driver' (offering) or 'rider' (requesting)
  final String? role;

  const CreateTripScreen({super.key, this.role});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late TextEditingController _originController;
  late TextEditingController _destinationController;
  late TextEditingController _priceController;
  late TextEditingController _seatsController;
  late TextEditingController _descriptionController;

  // Package-specific controllers
  late TextEditingController _packageWeightController;
  late TextEditingController _packageDescriptionController;

  // Form values
  bool _includesPerson = true;  // Whether trip includes person transport
  bool _includesPackage = false; // Whether trip includes package delivery
  String _direction = 'offer'; // 'offer' or 'request' - may be preset from role
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _allowPets = false;
  bool _allowSmoking = false;

  // Role-based flow
  late bool _roleIsPreset;

  @override
  void initState() {
    super.initState();
    _originController = TextEditingController();
    _destinationController = TextEditingController();
    _priceController = TextEditingController();
    _seatsController = TextEditingController(text: '1');
    _descriptionController = TextEditingController();
    _packageWeightController = TextEditingController();
    _packageDescriptionController = TextEditingController();

    // Set direction based on role from navigation
    _roleIsPreset = widget.role != null;
    if (widget.role == 'driver') {
      _direction = 'offer';
    } else if (widget.role == 'rider') {
      _direction = 'request';
    }
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    _seatsController.dispose();
    _descriptionController.dispose();
    _packageWeightController.dispose();
    _packageDescriptionController.dispose();
    super.dispose();
  }

  String get _tripTitle {
    if (_direction == 'offer') {
      return 'Create Offer';
    }
    return 'Create Request';
  }

  @override
  Widget build(BuildContext context) {
    final createTripState = ref.watch(createTripProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_tripTitle),
        centerTitle: true,
      ),
      body: createTripState is AsyncLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Role indicator if preset
                  if (_roleIsPreset) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _direction == 'offer'
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _direction == 'offer' ? Colors.green : Colors.blue,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _direction == 'offer' ? Icons.drive_eta : Icons.search,
                            color: _direction == 'offer' ? Colors.green : Colors.blue,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _direction == 'offer'
                                ? 'You are offering a trip'
                                : 'You are requesting a trip',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _direction == 'offer' ? Colors.green : Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Trip Type Selection - Person vs Package (can select both)
                  _buildSectionTitle(context, 'What are you transporting?'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeCheckCard(
                          context,
                          'People',
                          Icons.person,
                          _includesPerson,
                          (value) => setState(() {
                            _includesPerson = value;
                            // At least one must be selected
                            if (!_includesPerson && !_includesPackage) {
                              _includesPackage = true;
                            }
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTypeCheckCard(
                          context,
                          'Packages',
                          Icons.local_shipping,
                          _includesPackage,
                          (value) => setState(() {
                            _includesPackage = value;
                            // At least one must be selected
                            if (!_includesPerson && !_includesPackage) {
                              _includesPerson = true;
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Direction Selection - only show if role NOT preset
                  if (!_roleIsPreset) ...[
                    _buildSectionTitle(context, 'I am'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDirectionCard(
                            context,
                            'Offering',
                            Icons.arrow_upward,
                            _direction == 'offer',
                            () => setState(() => _direction = 'offer'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDirectionCard(
                            context,
                            'Requesting',
                            Icons.arrow_downward,
                            _direction == 'request',
                            () => setState(() => _direction = 'request'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Location Fields
                  _buildSectionTitle(context, 'Route'),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _originController,
                    decoration: InputDecoration(
                      labelText: 'From',
                      hintText: 'Starting location',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter origin' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      labelText: 'To',
                      hintText: 'Destination',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter destination' : null,
                  ),
                  const SizedBox(height: 24),

                  // Date and Time
                  _buildSectionTitle(context, 'When'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _selectedDate == null
                                  ? 'Select date'
                                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(context),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Time',
                              prefixIcon: const Icon(Icons.schedule),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _selectedTime == null
                                  ? 'Select time'
                                  : '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Person transport details (if selected)
                  if (_includesPerson) ...[
                    _buildSectionTitle(context, 'Person Transport Details'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _seatsController,
                            decoration: InputDecoration(
                              labelText: _direction == 'offer' ? 'Available seats' : 'Seats needed',
                              hintText: '1',
                              prefixIcon: const Icon(Icons.people),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (!_includesPerson) return null;
                              return value?.isEmpty ?? true ? 'Required' : null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              labelText: 'Price per seat',
                              hintText: '0.00',
                              prefixIcon: const Icon(Icons.paid),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (!_includesPerson) return null;
                              return value?.isEmpty ?? true ? 'Required' : null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Options for person transport
                    CheckboxListTile(
                      title: const Text('Allow pets'),
                      value: _allowPets,
                      onChanged: (value) =>
                          setState(() => _allowPets = value ?? false),
                      dense: true,
                    ),
                    CheckboxListTile(
                      title: const Text('Allow smoking'),
                      value: _allowSmoking,
                      onChanged: (value) =>
                          setState(() => _allowSmoking = value ?? false),
                      dense: true,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Package delivery details (if selected)
                  if (_includesPackage) ...[
                    _buildSectionTitle(context, 'Package Details'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _packageWeightController,
                      decoration: InputDecoration(
                        labelText: 'Package weight (kg)',
                        hintText: '0.0',
                        prefixIcon: const Icon(Icons.scale),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (!_includesPackage) return null;
                        return value?.isEmpty ?? true ? 'Required' : null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _packageDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Package description',
                        hintText: 'Describe the package contents...',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (!_includesPackage) return null;
                        return value?.isEmpty ?? true ? 'Required' : null;
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Description
                  _buildSectionTitle(context, 'Additional Information'),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Notes (optional)',
                      hintText: 'Add any additional details...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),

                  // Error message if any
                  if (createTripState is AsyncError)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Error: ${(createTripState).error}',
                              style: TextStyle(color: Colors.red[700]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (createTripState is AsyncError) const SizedBox(height: 16),

                  // Submit button
                  ElevatedButton(
                    onPressed:
                        createTripState is AsyncLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: createTripState is AsyncLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_direction == 'offer' ? 'Create Offer' : 'Create Request'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  /// Checkbox-style card for selecting trip types (can select multiple)
  Widget _buildTypeCheckCard(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
    ValueChanged<bool> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: isSelected ? AppColors.primary : Colors.grey[600],
                ),
                if (isSelected)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected ? AppColors.primary : Colors.grey[600],
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionCard(BuildContext context, String label, IconData icon,
      bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected ? AppColors.primary : Colors.grey[600],
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time')),
      );
      return;
    }

    // Prepare departure time
    final departureTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // Determine trip type
    String tripType;
    if (_includesPerson && _includesPackage) {
      tripType = 'both';
    } else if (_includesPackage) {
      tripType = 'package';
    } else {
      tripType = 'person';
    }

    // Get current user ID
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to create a trip')),
      );
      return;
    }

    final now = DateTime.now();
    final trip = Trip(
      id: '', // Will be set by Firestore
      type: tripType,
      direction: _direction,
      driverId: userId,
      originAddress: _originController.text,
      destinationAddress: _destinationController.text,
      originLat: 0.0, // TODO: Get from location picker
      originLng: 0.0,
      destinationLat: 0.0,
      destinationLng: 0.0,
      departureTime: departureTime,
      distance: 0.0, // TODO: Calculate from route
      estimatedDuration: 0, // TODO: Calculate from route
      pricePerSeat: double.tryParse(_priceController.text) ?? 0.0,
      totalSeats: int.tryParse(_seatsController.text) ?? 1,
      availableSeats: int.tryParse(_seatsController.text) ?? 1,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      allowPets: _allowPets,
      allowSmoking: _allowSmoking,
      createdAt: now,
      updatedAt: now,
      includesPerson: _includesPerson,
      includesPackage: _includesPackage,
      packageWeight: _includesPackage ? double.tryParse(_packageWeightController.text) : null,
      packageDescription: _includesPackage ? _packageDescriptionController.text : null,
    );

    // Create trip via provider
    await ref.read(createTripProvider.notifier).createTrip(trip);

    // Check for errors
    final state = ref.read(createTripProvider);
    if (state is AsyncError) {
      return; // Error will be shown in UI
    }

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_direction == 'offer'
              ? 'Trip offer created successfully!'
              : 'Trip request created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }
}

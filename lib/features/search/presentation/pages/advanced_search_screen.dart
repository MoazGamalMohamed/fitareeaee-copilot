import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({Key? key}) : super(key: key);

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late TextEditingController _originController;
  late TextEditingController _destinationController;
  late TextEditingController _maxPriceController;

  // Form values
  DateTime? _selectedDate;
  String _tripType = 'person'; // 'person' or 'package'
  double _minRating = 0;
  bool _allowPets = false;
  bool _allowSmoking = false;
  List<String> _selectedAmenities = [];

  // Available amenities
  final List<String> _amenityOptions = [
    'WiFi',
    'AC',
    'Music',
    'Charger',
    'Water',
    'Snacks',
  ];

  @override
  void initState() {
    super.initState();
    _originController = TextEditingController();
    _destinationController = TextEditingController();
    _maxPriceController = TextEditingController();
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Search'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Location Section
            _buildSectionTitle(context, 'Where'),
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

            // Date Section
            _buildSectionTitle(context, 'When'),
            const SizedBox(height: 12),
            InkWell(
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
            const SizedBox(height: 24),

            // Trip Type Section
            _buildSectionTitle(context, 'Trip Type'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTypeButton('Person', _tripType == 'person', () {
                    setState(() => _tripType = 'person');
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTypeButton(
                    'Package',
                    _tripType == 'package',
                    () {
                      setState(() => _tripType = 'package');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Price Section
            _buildSectionTitle(context, 'Budget'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _maxPriceController,
              decoration: InputDecoration(
                labelText: 'Max price per seat (optional)',
                hintText: '0.00',
                prefixIcon: const Icon(Icons.paid),
                suffixText: '\$',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Rating Section
            _buildSectionTitle(context, 'Driver Rating'),
            const SizedBox(height: 12),
            Column(
              children: [
                Slider(
                  value: _minRating,
                  onChanged: (value) => setState(() => _minRating = value),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: '${_minRating.toStringAsFixed(1)} stars',
                ),
                Text(
                  'Minimum rating: ${_minRating.toStringAsFixed(1)} ⭐',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Amenities Section
            _buildSectionTitle(context, 'Amenities'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _amenityOptions.map((amenity) {
                final isSelected = _selectedAmenities.contains(amenity);
                return FilterChip(
                  label: Text(amenity),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedAmenities.add(amenity);
                      } else {
                        _selectedAmenities.remove(amenity);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Options Section
            _buildSectionTitle(context, 'Preferences'),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('Allow pets'),
              value: _allowPets,
              onChanged: (value) => setState(() => _allowPets = value ?? false),
            ),
            CheckboxListTile(
              title: const Text('Allow smoking'),
              value: _allowSmoking,
              onChanged: (value) =>
                  setState(() => _allowSmoking = value ?? false),
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: _submitSearch,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Search Trips'),
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
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTypeButton(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isSelected ? AppColors.primary : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
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

  void _submitSearch() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a date')));
      return;
    }

    // Navigate to search results with parameters
    // In a real app, would use SearchCriteria and provider
    context.pushNamed(
      'search-results',
      extra: {
        'origin': _originController.text,
        'destination': _destinationController.text,
        'departureDate': _selectedDate,
        'tripType': _tripType,
        'maxPrice': _maxPriceController.text.isEmpty
            ? null
            : double.parse(_maxPriceController.text),
        'amenities': _selectedAmenities,
        'minRating': _minRating,
        'allowPets': _allowPets,
        'allowSmoking': _allowSmoking,
      },
    );
  }
}

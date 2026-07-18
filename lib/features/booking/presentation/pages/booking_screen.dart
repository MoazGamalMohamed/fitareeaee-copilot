import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../trips/domain/entities/trip.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/booking_model.dart';
import '../providers/booking_provider.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final Trip trip;

  const BookingScreen({super.key, required this.trip});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  int _seatsToBook = 1;
  String? _pickupLocation;
  String? _dropoffLocation;
  bool _isLoading = false;

  double get _totalPrice => widget.trip.pricePerSeat * _seatsToBook;

  @override
  void initState() {
    super.initState();
    _pickupLocation = widget.trip.originAddress;
    _dropoffLocation = widget.trip.destinationAddress;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Trip'),
        centerTitle: true,
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Please log in'));
          }
          return _buildBookingForm(context, user.id);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildBookingForm(BuildContext context, String userId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip Summary Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trip Summary', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.location_on, 'From', widget.trip.originAddress),
                  _buildInfoRow(Icons.flag, 'To', widget.trip.destinationAddress),
                  _buildInfoRow(Icons.calendar_today, 'Date', _formatDate(widget.trip.departureTime)),
                  _buildInfoRow(Icons.access_time, 'Time', _formatTime(widget.trip.departureTime)),
                  _buildInfoRow(Icons.attach_money, 'Price/Seat', '\$${widget.trip.pricePerSeat.toStringAsFixed(2)}'),
                  _buildInfoRow(Icons.event_seat, 'Available', '${widget.trip.availableSeats} seats'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Seats Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Number of Seats', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _seatsToBook > 1 ? () => setState(() => _seatsToBook--) : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 32,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_seatsToBook',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      IconButton(
                        onPressed: _seatsToBook < widget.trip.availableSeats
                            ? () => setState(() => _seatsToBook++)
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 32,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Pickup/Dropoff
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pickup & Dropoff', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _pickupLocation,
                    decoration: const InputDecoration(
                      labelText: 'Pickup Location',
                      prefixIcon: Icon(Icons.my_location),
                    ),
                    onChanged: (value) => _pickupLocation = value,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _dropoffLocation,
                    decoration: const InputDecoration(
                      labelText: 'Dropoff Location',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    onChanged: (value) => _dropoffLocation = value,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Total Price
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Price', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Text(
                  '\$${_totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Book Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () => _confirmBooking(userId),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Confirm Booking'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(color: AppColors.textSecondary)),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _confirmBooking(String userId) async {
    setState(() => _isLoading = true);

    try {
      final booking = BookingModel(
        id: '',
        tripId: widget.trip.id,
        passengerId: userId,
        driverId: widget.trip.driverId, // Add driver ID from trip
        seatsBooked: _seatsToBook,
        totalPrice: _totalPrice,
        status: 'pending',
        paymentStatus: 'unpaid',
        pickupLocation: _pickupLocation,
        dropoffLocation: _dropoffLocation,
        pickupTime: widget.trip.departureTime,
        dropoffTime: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      print('🎫 Creating booking: passenger=$userId, driver=${widget.trip.driverId}, trip=${widget.trip.id}');

      await ref.read(createBookingProvider(booking).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking confirmed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}


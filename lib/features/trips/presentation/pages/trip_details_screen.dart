import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/trip_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/trip.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../booking/presentation/providers/booking_provider.dart';

class TripDetailsScreen extends ConsumerWidget {
  final String tripId;

  const TripDetailsScreen({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripDetailProvider(tripId));
    final bookingState = ref.watch(tripBookingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
        centerTitle: true,
      ),
      body: tripAsync.when(
        data: (trip) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip Header Card
              _buildHeaderCard(context, trip),
              const SizedBox(height: 24),

              // Route Information
              _buildSectionTitle(context, 'Route'),
              const SizedBox(height: 12),
              _buildRouteCard(context, trip),
              const SizedBox(height: 24),

              // Trip Details
              _buildSectionTitle(context, 'Trip Details'),
              const SizedBox(height: 12),
              _buildDetailsGrid(context, trip),
              const SizedBox(height: 24),

              // Passengers
              _buildSectionTitle(context, 'Passengers'),
              const SizedBox(height: 12),
              _buildPassengersSection(context, trip),
              const SizedBox(height: 24),

              // Driver Info Card
              _buildSectionTitle(context, 'Driver Information'),
              const SizedBox(height: 12),
              _buildDriverCard(context, ref, trip),
              const SizedBox(height: 32),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: tripAsync.when(
        data: (trip) {
          final currentUserAsync = ref.watch(authStateProvider);
          final isOwnTrip = currentUserAsync.maybeWhen(
            data: (user) => user?.id == trip.driverId,
            orElse: () => false,
          );

          // Check if user has already booked this trip
          final userId = currentUserAsync.maybeWhen(
            data: (user) => user?.id ?? '',
            orElse: () => '',
          );
          final userBookingsAsync = ref.watch(userBookingsProvider(userId));
          final hasBooked = userBookingsAsync.maybeWhen(
            data: (bookings) => bookings.any((b) => 
              b.tripId == trip.id && 
              (b.status == 'confirmed' || b.status == 'paid' || b.status == 'pending')
            ),
            orElse: () => false,
          );

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isOwnTrip)
                  ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.grey[300],
                    ),
                    child: const Text('Your Own Trip'),
                  )
                else if (hasBooked)
                  ElevatedButton(
                    onPressed: () => context.push('/chat/${trip.driverId}'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.message, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Message Driver', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  )
                else if (bookingState is AsyncLoading)
                  const SizedBox(
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (bookingState is AsyncError)
                  Column(
                    children: [
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
                                'Error occurred while booking',
                                style: TextStyle(color: Colors.red[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _bookTrip(context, trip),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Try Again'),
                      ),
                    ],
                  )
                else if (trip.availableSeats > 0)
                  ElevatedButton(
                    onPressed: () => _bookTrip(context, trip),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Book Trip'),
                  )
                else
                  ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Trip Full'),
                  ),
              ],
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, dynamic trip) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trip.directionDisplay,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trip.typeDisplay,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            trip.priceDisplay,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            trip.statusDisplay,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
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

  Widget _buildRouteCard(BuildContext context, dynamic trip) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Origin
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.originAddress,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Divider with distance
          Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(Icons.expand_more,
                    color: Colors.white, size: 16),
              ),
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: Colors.grey[300],
                ),
              ),
              Text(
                trip.distanceDisplay,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Destination
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: Colors.red, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.destinationAddress,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context, dynamic trip) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildDetailItem(context, 'Departure', trip.timeDisplay, Icons.schedule),
        _buildDetailItem(context, 'Duration', trip.durationDisplay, Icons.timer),
        _buildDetailItem(
            context, 'Seats Available', '${trip.availableSeats}/${trip.totalSeats}',
            Icons.people),
        _buildDetailItem(context, 'Per Seat', trip.priceDisplay, Icons.paid),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value,
      IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPassengersSection(BuildContext context, dynamic trip) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.people, color: AppColors.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seats Booked',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '${trip.totalSeats - trip.availableSeats}/${trip.totalSeats} passengers',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(BuildContext context, WidgetRef ref, Trip trip) {
    // Fetch driver info from users collection using proper provider
    final driverAsync = ref.watch(userByIdProvider(trip.driverId));
    
    return driverAsync.when(
      data: (driver) {
        final driverName = driver?.name ?? 'Unknown Driver';
        final rating = driver?.rating ?? 0.0;
        final totalRatings = driver?.totalRatings ?? 0;
        final totalTrips = driver?.totalTrips ?? 0;
        
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${rating.toStringAsFixed(1)} ($totalRatings ${totalRatings == 1 ? 'review' : 'reviews'})',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$totalTrips ${totalTrips == 1 ? 'trip' : 'trips'} completed',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey[500],
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {
                  // Navigate to chat
                  context.push('/chat/${trip.driverId}');
                },
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (e, st) {
        // Log error for debugging
        print('Driver card error for ${trip.driverId}: $e');
        print('Stack trace: $st');
        
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Error loading driver info',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                e.toString(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _bookTrip(BuildContext context, Trip trip) {
    context.push('/trips/${trip.id}/booking');
  }
}

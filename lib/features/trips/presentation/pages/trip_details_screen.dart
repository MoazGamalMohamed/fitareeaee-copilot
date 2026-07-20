import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../providers/trip_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/trip.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../booking/presentation/providers/booking_provider.dart';
import '../../../booking/domain/models/booking_model.dart';
import '../../../ratings/presentation/providers/rating_provider.dart';

class TripDetailsScreen extends ConsumerWidget {
  final String tripId;
  final int requestedSeats;
  final String? bookingId;

  const TripDetailsScreen({
    super.key,
    required this.tripId,
    int? requestedSeats,
    this.bookingId,
  }) : requestedSeats = requestedSeats == null
           ? 1
           : requestedSeats < 1
           ? 1
           : requestedSeats > 8
           ? 8
           : requestedSeats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripDetailProvider(tripId));
    final bookingState = ref.watch(tripBookingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trip Details'), centerTitle: true),
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

              _buildSectionTitle(context, 'Preferences'),
              const SizedBox(height: 12),
              _buildPreferencesSection(context, trip),
              const SizedBox(height: 24),

              if (trip.isPackage) ...[
                _buildSectionTitle(context, 'Package'),
                const SizedBox(height: 12),
                _buildPackageSection(context, trip),
                const SizedBox(height: 24),
              ],

              if (trip.isOffer && trip.isPerson) ...[
                _buildSectionTitle(context, 'Passengers'),
                const SizedBox(height: 12),
                _buildPassengersSection(context, trip),
                const SizedBox(height: 24),
              ],

              // Driver Info Card
              _buildSectionTitle(
                context,
                trip.isRequest ? 'Requester Information' : 'Driver Information',
              ),
              const SizedBox(height: 12),
              _buildDriverCard(context, ref, trip),
              const SizedBox(height: 32),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
              const SizedBox(height: 16),
              const Text('Trip details are unavailable. Please try again.'),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref.invalidate(tripDetailProvider(tripId)),
                child: const Text('Retry'),
              ),
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
          final participantBookingsAsync = ref.watch(
            participantBookingsProvider(userId),
          );
          final activeBooking = participantBookingsAsync.maybeWhen(
            data: (bookings) {
              final confirmed = bookings
                  .where(
                    (booking) =>
                        booking.tripId == trip.id &&
                        (booking.status == 'confirmed' ||
                            booking.status == 'in_progress') &&
                        booking.paymentStatus == 'paid',
                  )
                  .toList();
              if (bookingId != null) {
                for (final booking in confirmed) {
                  if (booking.id == bookingId) return booking;
                }
              }
              return confirmed.isEmpty ? null : confirmed.first;
            },
            orElse: () => null,
          );
          final pendingBooking = participantBookingsAsync.maybeWhen(
            data: (bookings) {
              final pending = bookings
                  .where(
                    (booking) =>
                        booking.tripId == trip.id &&
                        (booking.status == 'pending' ||
                            booking.status == 'potential' ||
                            booking.status == 'pending_payment'),
                  )
                  .toList();
              if (bookingId != null) {
                for (final booking in pending) {
                  if (booking.id == bookingId) return booking;
                }
              }
              return pending.isEmpty ? null : pending.first;
            },
            orElse: () => null,
          );
          final completedBooking = participantBookingsAsync.maybeWhen(
            data: (bookings) {
              final completed = bookings
                  .where(
                    (booking) =>
                        booking.tripId == trip.id &&
                        booking.status == 'completed',
                  )
                  .toList();
              if (bookingId != null) {
                for (final booking in completed) {
                  if (booking.id == bookingId) return booking;
                }
              }
              return completed.isEmpty ? null : completed.first;
            },
            orElse: () => null,
          );

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (activeBooking != null)
                  Column(
                    children: [
                      Card(
                        color: activeBooking.status == 'in_progress'
                            ? Colors.green.shade50
                            : Colors.blue.shade50,
                        child: ListTile(
                          leading: Icon(
                            activeBooking.status == 'in_progress'
                                ? Icons.navigation_outlined
                                : Icons.verified_outlined,
                          ),
                          title: Text(
                            activeBooking.status == 'in_progress'
                                ? 'Trip in progress'
                                : 'Paid and confirmed',
                          ),
                          subtitle: Text(
                            activeBooking.status == 'in_progress'
                                ? 'Trip chat stays open until the driver completes or cancels the trip.'
                                : 'The assigned driver can start the trip. Both participants can use chat.',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: bookingState is AsyncLoading
                            ? null
                            : () => _openBookedChat(context, activeBooking),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: AppColors.primary,
                        ),
                        icon: const Icon(Icons.message, color: Colors.white),
                        label: const Text(
                          'Open Confirmed Chat',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (activeBooking.driverId == userId) ...[
                        FilledButton.icon(
                          onPressed: bookingState is AsyncLoading
                              ? null
                              : () => _transitionTrip(
                                  context,
                                  ref,
                                  trip,
                                  activeBooking,
                                  activeBooking.status == 'in_progress'
                                      ? 'completeTrip'
                                      : 'startTrip',
                                  activeBooking.status == 'in_progress'
                                      ? 'Trip completed. Chat is now closed and ratings are available.'
                                      : 'Trip started. Live trip chat remains available.',
                                ),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          icon: Icon(
                            activeBooking.status == 'in_progress'
                                ? Icons.flag_outlined
                                : Icons.play_arrow,
                          ),
                          label: Text(
                            activeBooking.status == 'in_progress'
                                ? 'Complete trip'
                                : 'Confirm trip start',
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: bookingState is AsyncLoading
                              ? null
                              : () => _cancelDriverTrip(
                                  context,
                                  ref,
                                  trip,
                                  activeBooking,
                                ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            foregroundColor: Colors.red.shade700,
                          ),
                          icon: const Icon(Icons.emergency_outlined),
                          label: const Text('Emergency cancel and alert admin'),
                        ),
                      ] else if (activeBooking.passengerId == userId &&
                          activeBooking.status == 'confirmed')
                        OutlinedButton.icon(
                          onPressed: bookingState is AsyncLoading
                              ? null
                              : () =>
                                    _cancelBooking(context, ref, trip, userId),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text('Cancel under policy'),
                        )
                      else
                        OutlinedButton.icon(
                          onPressed: () => context.push('/support'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          icon: const Icon(Icons.support_agent_outlined),
                          label: const Text('Need help? Contact support'),
                        ),
                    ],
                  )
                else if (pendingBooking != null)
                  _buildPendingMatchActions(
                    context,
                    ref,
                    trip,
                    pendingBooking,
                    userId,
                    bookingState is AsyncLoading,
                  )
                else if (completedBooking != null)
                  _buildCompletedBookingActions(
                    context,
                    ref,
                    completedBooking,
                    userId,
                  )
                else if (trip.status == 'completed' ||
                    trip.status == 'cancelled' ||
                    trip.isPast)
                  Card(
                    child: ListTile(
                      leading: Icon(
                        trip.status == 'cancelled'
                            ? Icons.cancel_outlined
                            : Icons.flag_outlined,
                      ),
                      title: Text(
                        trip.status == 'cancelled'
                            ? 'Trip cancelled'
                            : 'Trip closed',
                      ),
                      subtitle: const Text(
                        'This trip no longer accepts bookings.',
                      ),
                      trailing: TextButton(
                        onPressed: () => context.push('/support'),
                        child: const Text('Support'),
                      ),
                    ),
                  )
                else if (isOwnTrip)
                  ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.grey[300],
                    ),
                    child: const Text('Your Own Trip'),
                  )
                else if (trip.isRequest)
                  ElevatedButton.icon(
                    onPressed: bookingState is AsyncLoading
                        ? null
                        : () => _proposeForRequest(context, ref, trip, userId),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    icon: const Icon(Icons.local_taxi_outlined),
                    label: Text(
                      trip.isPackage ? 'Offer to Deliver' : 'Offer to Drive',
                    ),
                  )
                else if (bookingState is AsyncLoading)
                  const SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()),
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
                    child: Text(trip.isPackage ? 'Book Delivery' : 'Book Trip'),
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

  Widget _buildCompletedBookingActions(
    BuildContext context,
    WidgetRef ref,
    BookingModel booking,
    String userId,
  ) {
    final ratedUserId = booking.passengerId == userId
        ? booking.driverId
        : booking.passengerId;
    final ratingExists = ref.watch(
      ratingExistsProvider((bookingId: booking.id, userId: userId)),
    );
    final ratingRoute =
        '/trips/${booking.tripId}/rate'
        '?bookingId=${Uri.encodeQueryComponent(booking.id)}'
        '&ratedUserId=${Uri.encodeQueryComponent(ratedUserId)}';

    return Column(
      children: [
        const Card(
          child: ListTile(
            leading: Icon(Icons.flag_outlined),
            title: Text('Trip completed'),
            subtitle: Text(
              'Private trip chat is closed. Each participant may submit one rating.',
            ),
          ),
        ),
        const SizedBox(height: 8),
        ratingExists.when(
          data: (exists) => FilledButton.icon(
            onPressed: exists ? null : () => context.push(ratingRoute),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            icon: Icon(exists ? Icons.check : Icons.star_outline),
            label: Text(exists ? 'Rating submitted' : 'Rate this trip'),
          ),
          loading: () => const LinearProgressIndicator(),
          error: (_, _) => OutlinedButton.icon(
            onPressed: () => context.push(ratingRoute),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            icon: const Icon(Icons.star_outline),
            label: const Text('Rate this trip'),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => context.push('/support'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          icon: const Icon(Icons.support_agent_outlined),
          label: const Text('Questions? Contact support'),
        ),
      ],
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
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
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
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
                child: const Icon(
                  Icons.expand_more,
                  color: Colors.white,
                  size: 16,
                ),
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
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
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
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
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

  Widget _buildDetailsGrid(BuildContext context, Trip trip) {
    final seatsLabel = trip.isRequest ? 'Seats Needed' : 'Seats Available';
    final seatsValue = trip.isRequest
        ? '${trip.totalSeats}'
        : '${trip.availableSeats}/${trip.totalSeats}';
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.25,
      children: [
        _buildDetailItem(
          context,
          'Departure',
          trip.timeDisplay,
          Icons.schedule,
        ),
        _buildDetailItem(
          context,
          'Duration',
          trip.durationDisplay,
          Icons.timer,
        ),
        _buildDetailItem(context, seatsLabel, seatsValue, Icons.people),
        _buildDetailItem(
          context,
          trip.isPackage ? 'Delivery Price' : 'Per Seat',
          trip.priceDisplay,
          Icons.paid,
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context, Trip trip) {
    final chips = <Widget>[
      Chip(
        avatar: const Icon(Icons.pets, size: 18),
        label: Text(trip.allowPets ? 'With pets' : 'No pets'),
      ),
      Chip(
        avatar: Icon(
          trip.allowSmoking ? Icons.smoking_rooms : Icons.smoke_free,
          size: 18,
        ),
        label: Text(trip.allowSmoking ? 'Smoking allowed' : 'No smoking'),
      ),
      ...trip.amenities.map((amenity) => Chip(label: Text(amenity))),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(spacing: 8, runSpacing: 8, children: chips),
    );
  }

  Widget _buildPackageSection(BuildContext context, Trip trip) {
    final weight = trip.packageWeight;
    final details = trip.packageDescription?.trim();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weight == null
                ? 'Weight not specified'
                : '${weight.toStringAsFixed(1)} kg',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (details != null && details.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(details),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
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
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
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
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                '${trip.totalSeats - trip.availableSeats}/${trip.totalSeats} passengers',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Colors.grey[600]),
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
      error: (_, _) {
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
                'Participant details are unavailable.',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _bookTrip(BuildContext context, Trip trip) {
    context.push('/trips/${trip.id}/booking?seats=$requestedSeats');
  }

  Widget _buildPendingMatchActions(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
    BookingModel booking,
    String userId,
    bool loading,
  ) {
    if (booking.status == 'potential') {
      final isDriver = booking.driverId == userId;
      return Column(
        children: [
          FilledButton.icon(
            onPressed: loading || isDriver
                ? null
                : () => _selectProposal(context, ref, booking, userId),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            icon: Icon(
              isDriver ? Icons.hourglass_top : Icons.person_search_outlined,
            ),
            label: Text(
              isDriver
                  ? 'Waiting for rider selection'
                  : 'Choose driver - continue to payment',
            ),
          ),
          const SizedBox(height: 8),
          if (isDriver)
            OutlinedButton.icon(
              onPressed: loading
                  ? null
                  : () => _withdrawProposal(context, ref, booking, userId),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              icon: const Icon(Icons.undo),
              label: const Text('Withdraw proposal'),
            ),
          const SizedBox(height: 6),
          Text(
            isDriver
                ? 'Drivers never pay. The rider must choose this proposal and complete payment before confirmation or chat.'
                : 'Selecting this driver creates a payment requirement only. Chat stays locked until server-verified payment.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      );
    }

    final isPassenger = booking.passengerId == userId;
    return Column(
      children: [
        FilledButton.icon(
          onPressed: isPassenger ? () => context.push('/payments') : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          icon: const Icon(Icons.payment_outlined),
          label: Text(
            isPassenger
                ? 'Payment required - not confirmed'
                : 'Waiting for rider payment',
          ),
        ),
        const SizedBox(height: 8),
        if (isPassenger)
          OutlinedButton.icon(
            onPressed: loading
                ? null
                : () => _cancelBooking(context, ref, trip, userId),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancel payment request'),
          ),
        const SizedBox(height: 6),
        const Text(
          'Seats and chat unlock only after server-verified payment.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Future<void> _proposeForRequest(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
    String userId,
  ) async {
    final priceController = TextEditingController(
      text: trip.pricePerSeat.toStringAsFixed(2),
    );
    final noteController = TextEditingController();
    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(trip.isPackage ? 'Delivery proposal' : 'Driver proposal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'The rider budget is up to \$${trip.pricePerSeat.toStringAsFixed(2)} per seat. No direct contact details or chat are shared yet.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Your price per seat',
                prefixText: '\$',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              maxLength: 300,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Short proposal note (optional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Send proposal'),
          ),
        ],
      ),
    );
    if (accepted != true || !context.mounted) return;
    final price = double.tryParse(priceController.text.trim());
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid proposal price.')),
      );
      return;
    }
    try {
      await FirebaseFunctions.instance
          .httpsCallable('proposeForTripRequest')
          .call({
            'schemaVersion': 1,
            'tripId': trip.id,
            'proposedUnitPrice': price,
            'message': noteController.text.trim(),
          });
      ref.invalidate(participantBookingsProvider(userId));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proposal sent. The rider must choose and pay next.'),
        ),
      );
    } on FirebaseFunctionsException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Proposal could not be sent.')),
      );
    }
  }

  Future<void> _selectProposal(
    BuildContext context,
    WidgetRef ref,
    BookingModel booking,
    String userId,
  ) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('selectTripProposal').call(
        {'schemaVersion': 1, 'bookingId': booking.id},
      );
      ref.invalidate(participantBookingsProvider(userId));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Driver selected. Payment is required before confirmation.',
          ),
        ),
      );
      context.push('/payments');
    } on FirebaseFunctionsException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Driver could not be selected.'),
        ),
      );
    }
  }

  Future<void> _withdrawProposal(
    BuildContext context,
    WidgetRef ref,
    BookingModel booking,
    String userId,
  ) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('withdrawTripProposal')
          .call({'schemaVersion': 1, 'bookingId': booking.id});
      ref.invalidate(participantBookingsProvider(userId));
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Proposal withdrawn.')));
    } on FirebaseFunctionsException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Proposal could not be withdrawn.'),
        ),
      );
    }
  }

  Future<void> _openBookedChat(
    BuildContext context,
    BookingModel booking,
  ) async {
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('authorizeBookingConversation')
          .call({'schemaVersion': 1, 'bookingId': booking.id});
      final data = Map<String, dynamic>.from(result.data as Map);
      final conversationId = data['conversationId'];
      final recipientId = data['recipientId'];
      if (conversationId is! String ||
          conversationId.isEmpty ||
          recipientId is! String ||
          recipientId.isEmpty) {
        throw StateError('Conversation authorization missing');
      }
      if (!context.mounted) return;
      context.push(
        '/chat/$recipientId?conversationId=${Uri.encodeQueryComponent(conversationId)}',
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat could not be opened. Try again.')),
      );
    }
  }

  Future<void> _cancelBooking(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
    String userId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: const Text(
          'Self-service cancellation is available until the scheduled departure. Seats will be returned to the trip. No payment or refund is processed in this contest build.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep booking'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref
          .read(tripBookingProvider.notifier)
          .cancelBooking(trip.id, userId);
      ref.invalidate(userBookingsProvider(userId));
      ref.invalidate(tripDetailProvider(trip.id));
      ref.invalidate(availableTripsProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking cancelled and seats restored.')),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This booking cannot be cancelled here. Contact support for help.',
          ),
        ),
      );
    }
  }

  Future<void> _transitionTrip(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
    BookingModel booking,
    String callable,
    String successMessage,
  ) async {
    try {
      await FirebaseFunctions.instance.httpsCallable(callable).call({
        'schemaVersion': 1,
        'bookingId': booking.id,
      });
      ref.invalidate(participantBookingsProvider(booking.driverId));
      ref.invalidate(tripDetailProvider(trip.id));
      ref.invalidate(userTripsProvider(trip.driverId));
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
      if (callable == 'completeTrip') context.go('/trips?tab=past');
    } on FirebaseFunctionsException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Trip status could not be updated.'),
        ),
      );
    }
  }

  Future<void> _cancelDriverTrip(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
    BookingModel booking,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Emergency trip cancellation?'),
        content: const Text(
          'This closes participant chats, alerts administrators as urgent, and marks paid bookings for refund review. It does not issue an automatic refund.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep trip'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Cancel trip'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await FirebaseFunctions.instance.httpsCallable('cancelTrip').call({
        'schemaVersion': 1,
        'bookingId': booking.id,
      });
      ref.invalidate(participantBookingsProvider(booking.driverId));
      ref.invalidate(tripDetailProvider(trip.id));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip cancelled. Admin refund review was opened.'),
        ),
      );
      context.go('/trips?tab=my');
    } on FirebaseFunctionsException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Trip could not be cancelled.'),
        ),
      );
    }
  }
}

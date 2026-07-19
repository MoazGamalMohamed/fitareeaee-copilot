import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/trip.dart';
import '../providers/trip_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../verification/presentation/providers/verification_provider.dart';
import '../../../../core/theme/app_colors.dart';

class BookingConfirmationScreen extends ConsumerWidget {
  final String tripId;
  final int requestedSeats;

  const BookingConfirmationScreen({
    super.key,
    required this.tripId,
    int? requestedSeats,
  }) : requestedSeats = requestedSeats == null
           ? 1
           : requestedSeats < 1
           ? 1
           : requestedSeats > 8
           ? 8
           : requestedSeats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(authStateProvider);
    final tripAsync = ref.watch(tripDetailProvider(tripId));
    final bookingState = ref.watch(tripBookingProvider);

    return tripAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
      data: (trip) => currentUserAsync.when(
        data: (currentUser) {
          if (currentUser == null) {
            return const Scaffold(
              body: Center(child: Text('User not authenticated')),
            );
          }

          // Fetch verification status for current user
          final userVerificationAsync = ref.watch(
            verificationStatusProvider(currentUser.id),
          );
          return Scaffold(
            appBar: AppBar(
              title: const Text('Review and Pay'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trip Summary
                  _buildTripSummary(context, trip),
                  const SizedBox(height: 24),

                  // Verification Requirement
                  _buildVerificationRequirement(
                    context,
                    'Your Identity',
                    userVerificationAsync,
                    currentUser.id,
                    ref,
                  ),
                  const SizedBox(height: 16),

                  _buildServerVerificationNotice(context),
                  const SizedBox(height: 24),

                  // Price and payment-gated confirmation summary.
                  _buildPriceSection(context, trip),
                  const SizedBox(height: 12),
                  const Card(
                    color: Color(0xFFFFF8E1),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lock_outline),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'This creates a payment-required booking request only. The trip is not confirmed, seats are not deducted, and chat stays locked until a payment provider verifies payment on the server.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Button
                  bookingState.when(
                    data: (_) {
                      return ElevatedButton(
                        onPressed: userVerificationAsync.maybeWhen(
                          data: (userVerif) {
                            final userVerified =
                                (userVerif?.identityVerified ?? false) &&
                                (userVerif?.selfieWithIdVerified ?? false);
                            final hasCapacity =
                                trip.availableSeats >= requestedSeats;
                            return userVerified && hasCapacity
                                ? () => _confirmBooking(context, ref, trip)
                                : null;
                          },
                          orElse: () => null,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: Colors.grey[300],
                        ),
                        child: const SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Continue to payment requirement',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () => ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Processing...',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    error: (error, st) => Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            border: Border.all(color: Colors.red[200]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Booking could not be completed. Review verification and availability, then try again.',
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _confirmBooking(context, ref, trip),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.grey[300],
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Try Again',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, st) => Scaffold(body: Center(child: Text('Error: $e'))),
      ),
    );
  }

  Widget _buildTripSummary(BuildContext context, Trip trip) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Details',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${trip.originAddress} → ${trip.destinationAddress}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Distance: ${trip.distance.toStringAsFixed(1)} km',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Seats: ${trip.totalSeats - trip.availableSeats}/${trip.totalSeats}',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationRequirement(
    BuildContext context,
    String label,
    AsyncValue verificationAsync,
    String userId,
    WidgetRef ref,
  ) {
    return verificationAsync.when(
      data: (verification) {
        // For display, check if identity and selfie are verified
        final isVerified =
            (verification?.identityVerified ?? false) &&
            (verification?.selfieWithIdVerified ?? false);

        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isVerified ? Colors.green[300]! : Colors.orange[300]!,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isVerified ? Colors.green[50] : Colors.orange[50],
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                isVerified ? Icons.check_circle : Icons.pending,
                color: isVerified ? Colors.green : Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isVerified ? 'Verified' : 'Pending verification',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isVerified ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isVerified)
                TextButton(
                  onPressed: () {
                    if (label == 'Your Identity') {
                      context.push('/verification');
                    }
                  },
                  child: const Text('Verify'),
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
        child: Row(
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(
              'Loading $label...',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
      error: (e, st) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red[300]!),
          borderRadius: BorderRadius.circular(12),
          color: Colors.red[50],
        ),
        padding: const EdgeInsets.all(12),
        child: Text(
          'Error loading verification',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildServerVerificationNotice(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue[200]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue[50],
      ),
      padding: const EdgeInsets.all(12),
      child: const Row(
        children: [
          Icon(Icons.verified_user_outlined, color: Colors.blue),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'The driver’s private verification status is checked securely by the server when you confirm. It is not shared with other users.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context, Trip trip) {
    final totalPrice = trip.pricePerSeat * requestedSeats;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip price',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price per seat',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '\$${trip.pricePerSeat.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Seats', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                '$requestedSeats',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmBooking(BuildContext context, WidgetRef ref, Trip trip) async {
    try {
      final userId = ref.read(authStateProvider).value?.id;
      if (userId == null) return;
      final result = await ref
          .read(tripBookingProvider.notifier)
          .bookTrip(trip.id, userId, requestedSeats);
      ref.invalidate(tripDetailProvider(trip.id));
      ref.invalidate(availableTripsProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.isConfirmedAndPaid
                ? 'Payment is verified and the booking is confirmed.'
                : 'Payment is required. This trip is not confirmed and chat remains locked.',
          ),
        ),
      );
      context.go(
        '/trips/${trip.id}?bookingId=${Uri.encodeQueryComponent(result.bookingId)}',
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Booking could not be completed. Check verification and availability, then try again.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

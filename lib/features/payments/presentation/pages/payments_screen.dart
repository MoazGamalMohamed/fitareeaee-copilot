import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../booking/domain/models/booking_model.dart';
import '../../../booking/presentation/providers/booking_provider.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref
        .watch(authStateProvider)
        .maybeWhen(data: (value) => value, orElse: () => null);
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please sign in to view payments')),
      );
    }

    final bookingsAsync = ref.watch(participantBookingsProvider(user.id));
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _error(ref, user.id),
        data: (bookings) => _content(context, user.id, bookings),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    String userId,
    List<BookingModel> bookings,
  ) {
    final payable = bookings
        .where((booking) => booking.passengerId == userId && booking.isActive)
        .fold<double>(0, (sum, booking) => sum + booking.totalPrice);
    final receivable = bookings
        .where((booking) => booking.driverId == userId && booking.isActive)
        .fold<double>(0, (sum, booking) => sum + booking.totalPrice);
    final completed = bookings
        .where((booking) => booking.status == 'completed')
        .fold<double>(0, (sum, booking) => sum + booking.totalPrice);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Colors.blue.shade50,
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Contest build: no card is charged, no escrow is held, and no payout or refund is processed. Drivers are always the receiving side; riders and senders are the paying side when real payments are added later.',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _amountCard(
                context,
                'Pending to pay',
                payable,
                Icons.credit_card,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _amountCard(
                context,
                'Pending to receive',
                receivable,
                Icons.account_balance_wallet_outlined,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _amountCard(
          context,
          'Previous completed total',
          completed,
          Icons.history,
          Colors.blueGrey,
        ),
        const SizedBox(height: 24),
        Text(
          'Payment activity',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (bookings.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No payment-related trips yet.'),
            ),
          )
        else
          ...bookings
              .take(20)
              .map(
                (booking) => Card(
                  child: ListTile(
                    leading: Icon(
                      booking.passengerId == userId
                          ? Icons.north_east
                          : Icons.south_west,
                    ),
                    title: Text(
                      booking.passengerId == userId
                          ? 'Rider/sender payment'
                          : 'Driver receivable',
                    ),
                    subtitle: Text(
                      '${booking.status} - ${booking.paymentStatus} - ${booking.seatsBooked} seat(s)',
                    ),
                    trailing: Text(
                      '\$${booking.totalPrice.toStringAsFixed(2)}',
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _amountCard(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _error(WidgetRef ref, String userId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56),
            const SizedBox(height: 12),
            const Text('Payment activity is unavailable.'),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () =>
                  ref.invalidate(participantBookingsProvider(userId)),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on BookingModel {
  bool get isActive => status == 'confirmed' || status == 'paid';
}

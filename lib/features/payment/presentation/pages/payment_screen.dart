import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../booking/domain/models/booking_model.dart';
import '../../domain/models/payment_model.dart';
import '../providers/payment_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final BookingModel booking;
  final String payeeId;

  const PaymentScreen({
    super.key,
    required this.booking,
    required this.payeeId,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final paymentMethod = ref.watch(paymentMethodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: authState.when(
        data: (user) {
          if (user == null) return const Center(child: Text('Please log in'));
          return _buildPaymentForm(context, user.id, paymentMethod);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildPaymentForm(BuildContext context, String userId, PaymentMethodState paymentMethod) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Escrow Info Banner
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.security, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your payment is protected. Funds are held securely until the trip is completed.',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),

          // Payment Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Summary', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Trip Booking', '\$${widget.booking.totalPrice.toStringAsFixed(2)}'),
                  _buildSummaryRow('Service Fee (10%)', '\$${(widget.booking.totalPrice * 0.10).toStringAsFixed(2)}'),
                  _buildSummaryRow('Processing Fee', '\$${((widget.booking.totalPrice * 0.029) + 0.30).toStringAsFixed(2)}'),
                  const Divider(),
                  _buildSummaryRow('Total', '\$${(widget.booking.totalPrice + (widget.booking.totalPrice * 0.10) + (widget.booking.totalPrice * 0.029) + 0.30).toStringAsFixed(2)}', isBold: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Payment Method Selection
          Text('Payment Method', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _buildPaymentMethodTile(PaymentMethodType.card, 'Credit/Debit Card', Icons.credit_card, paymentMethod),
          _buildPaymentMethodTile(PaymentMethodType.wallet, 'Wallet Balance', Icons.account_balance_wallet, paymentMethod),
          _buildPaymentMethodTile(PaymentMethodType.bankTransfer, 'Bank Transfer', Icons.account_balance, paymentMethod),
          const SizedBox(height: 16),

          // Card Details (if card selected)
          if (paymentMethod.selected == PaymentMethodType.card) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Card Details', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cardNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Card Number',
                        hintText: '1234 5678 9012 3456',
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiryController,
                            decoration: const InputDecoration(
                              labelText: 'Expiry',
                              hintText: 'MM/YY',
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cvvController,
                            decoration: const InputDecoration(
                              labelText: 'CVV',
                              hintText: '123',
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Pay Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () => _processPayment(userId),
              child: _isLoading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text('Pay \$${widget.booking.totalPrice.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text(value, style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? AppColors.primary : null,
          )),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethodType type, String title, IconData icon, PaymentMethodState state) {
    final isSelected = state.selected == type;
    return Card(
      color: isSelected ? AppColors.primaryLight.withValues(alpha: 0.2) : null,
      child: ListTile(
        leading: Icon(icon, color: isSelected ? AppColors.primary : null),
        title: Text(title),
        trailing: isSelected ? Icon(Icons.check_circle, color: AppColors.primary) : null,
        onTap: () => ref.read(paymentMethodProvider.notifier).selectMethod(type),
      ),
    );
  }

  Future<void> _processPayment(String userId) async {
    final paymentMethod = ref.read(paymentMethodProvider);

    setState(() => _isLoading = true);

    try {
      final payment = PaymentModel(
        id: '',
        bookingId: widget.booking.id,
        payerId: userId,
        payeeId: widget.payeeId,
        amount: widget.booking.totalPrice,
        currency: 'USD',
        paymentMethod: paymentMethod.selected.name,
        status: 'pending',
        transactionId: null,
        createdAt: DateTime.now(),
        completedAt: null,
      );

      await ref.read(processPaymentProvider(payment).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(true); // Return success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}


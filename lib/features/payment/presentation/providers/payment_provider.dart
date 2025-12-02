import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/payment_model.dart';

final _firestore = FirebaseFirestore.instance;

/// Platform fee percentage (e.g., 10%)
const double platformFeePercent = 0.10;

/// Stripe processing fee (2.9% + $0.30)
const double stripePercentFee = 0.029;
const double stripeFixedFee = 0.30;

/// Calculate fees for a payment
Map<String, double> calculateFees(double amount) {
  final processingFee = (amount * stripePercentFee) + stripeFixedFee;
  final platformFee = amount * platformFeePercent;
  final netAmount = amount - processingFee - platformFee;
  return {
    'processingFee': double.parse(processingFee.toStringAsFixed(2)),
    'platformFee': double.parse(platformFee.toStringAsFixed(2)),
    'netAmount': double.parse(netAmount.toStringAsFixed(2)),
  };
}

/// Process payment with escrow
/// Payment flow:
/// 1. Create payment intent (Stripe)
/// 2. Charge customer
/// 3. Hold funds in escrow
/// 4. Release to driver after trip completion
final processPaymentProvider = FutureProvider.family<PaymentModel, PaymentModel>((ref, payment) async {
  final docRef = _firestore.collection('payments').doc();
  final fees = calculateFees(payment.amount);

  // In production, this would call a Cloud Function to create Stripe PaymentIntent
  // For now, we simulate the payment process
  final transactionId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';
  final stripePaymentIntentId = 'pi_${DateTime.now().millisecondsSinceEpoch}';

  final paymentWithId = PaymentModel(
    id: docRef.id,
    bookingId: payment.bookingId,
    payerId: payment.payerId,
    payeeId: payment.payeeId,
    amount: payment.amount,
    currency: payment.currency,
    paymentMethod: payment.paymentMethod,
    status: 'escrow', // Funds held in escrow until trip completion
    transactionId: transactionId,
    stripePaymentIntentId: stripePaymentIntentId,
    createdAt: DateTime.now(),
    escrowStatus: 'held',
    escrowHeldAt: DateTime.now(),
    platformFee: fees['platformFee']!,
    processingFee: fees['processingFee']!,
    netAmount: fees['netAmount']!,
  );

  await docRef.set(paymentWithId.toJson());

  // Update booking payment status
  await _firestore.collection('bookings').doc(payment.bookingId).update({
    'paymentStatus': 'escrow',
    'paymentId': docRef.id,
    'updatedAt': FieldValue.serverTimestamp(),
  });

  return paymentWithId;
});

/// Release escrow payment to driver after trip completion
final releaseEscrowProvider = FutureProvider.family<PaymentModel, String>((ref, paymentId) async {
  final paymentDoc = await _firestore.collection('payments').doc(paymentId).get();
  if (!paymentDoc.exists) throw Exception('Payment not found');

  final payment = PaymentModel.fromJson({...paymentDoc.data()!, 'id': paymentId});

  if (payment.escrowStatus != 'held') {
    throw Exception('Payment is not in escrow');
  }

  // In production, this would call a Cloud Function to transfer funds via Stripe
  final stripeTransferId = 'tr_${DateTime.now().millisecondsSinceEpoch}';

  final updatedPayment = PaymentModel(
    id: payment.id,
    bookingId: payment.bookingId,
    payerId: payment.payerId,
    payeeId: payment.payeeId,
    amount: payment.amount,
    currency: payment.currency,
    paymentMethod: payment.paymentMethod,
    status: 'completed',
    transactionId: payment.transactionId,
    stripePaymentIntentId: payment.stripePaymentIntentId,
    stripeTransferId: stripeTransferId,
    createdAt: payment.createdAt,
    completedAt: DateTime.now(),
    escrowStatus: 'released',
    escrowHeldAt: payment.escrowHeldAt,
    escrowReleasedAt: DateTime.now(),
    platformFee: payment.platformFee,
    processingFee: payment.processingFee,
    netAmount: payment.netAmount,
  );

  await _firestore.collection('payments').doc(paymentId).update(updatedPayment.toJson());

  // Update booking status
  await _firestore.collection('bookings').doc(payment.bookingId).update({
    'paymentStatus': 'completed',
    'updatedAt': FieldValue.serverTimestamp(),
  });

  // Add to driver's wallet
  await _addToWallet(payment.payeeId, payment.netAmount, paymentId);

  return updatedPayment;
});

/// Refund escrow payment
final refundPaymentProvider = FutureProvider.family<PaymentModel, RefundRequest>((ref, request) async {
  final paymentDoc = await _firestore.collection('payments').doc(request.paymentId).get();
  if (!paymentDoc.exists) throw Exception('Payment not found');

  final payment = PaymentModel.fromJson({...paymentDoc.data()!, 'id': request.paymentId});

  if (payment.status == 'refunded') {
    throw Exception('Payment already refunded');
  }

  // In production, this would call a Cloud Function to refund via Stripe
  final updatedPayment = PaymentModel(
    id: payment.id,
    bookingId: payment.bookingId,
    payerId: payment.payerId,
    payeeId: payment.payeeId,
    amount: payment.amount,
    currency: payment.currency,
    paymentMethod: payment.paymentMethod,
    status: 'refunded',
    transactionId: payment.transactionId,
    stripePaymentIntentId: payment.stripePaymentIntentId,
    createdAt: payment.createdAt,
    escrowStatus: 'refunded',
    escrowHeldAt: payment.escrowHeldAt,
    platformFee: payment.platformFee,
    processingFee: payment.processingFee,
    netAmount: payment.netAmount,
    refundReason: request.reason,
    refundedAt: DateTime.now(),
  );

  await _firestore.collection('payments').doc(request.paymentId).update(updatedPayment.toJson());

  // Update booking status
  await _firestore.collection('bookings').doc(payment.bookingId).update({
    'paymentStatus': 'refunded',
    'status': 'cancelled',
    'updatedAt': FieldValue.serverTimestamp(),
  });

  return updatedPayment;
});

/// Add funds to user's wallet
Future<void> _addToWallet(String userId, double amount, String paymentId) async {
  final walletRef = _firestore.collection('wallets').doc(userId);

  await _firestore.runTransaction((transaction) async {
    final walletDoc = await transaction.get(walletRef);

    if (walletDoc.exists) {
      final currentBalance = (walletDoc.data()?['balance'] ?? 0.0) as double;
      transaction.update(walletRef, {
        'balance': currentBalance + amount,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      transaction.set(walletRef, {
        'userId': userId,
        'balance': amount,
        'currency': 'USD',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  });

  // Record transaction
  await _firestore.collection('wallet_transactions').add({
    'userId': userId,
    'type': 'credit',
    'amount': amount,
    'description': 'Trip payment received',
    'paymentId': paymentId,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

/// Refund request model
class RefundRequest {
  final String paymentId;
  final String reason;
  RefundRequest({required this.paymentId, required this.reason});
}

// Get user payments
final userPaymentsProvider = StreamProvider.family<List<PaymentModel>, String>((ref, userId) {
  return _firestore
      .collection('payments')
      .where('payerId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PaymentModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

// Get single payment
final paymentProvider = FutureProvider.family<PaymentModel?, String>((ref, paymentId) async {
  final doc = await _firestore.collection('payments').doc(paymentId).get();
  if (!doc.exists) return null;
  return PaymentModel.fromJson({...doc.data()!, 'id': doc.id});
});

// Payment method state
enum PaymentMethodType { card, wallet, bankTransfer }

class PaymentMethodState {
  final PaymentMethodType selected;
  final String? cardNumber;
  final String? expiryDate;
  final String? cvv;
  final double walletBalance;

  const PaymentMethodState({
    this.selected = PaymentMethodType.card,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.walletBalance = 0.0,
  });

  PaymentMethodState copyWith({
    PaymentMethodType? selected,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    double? walletBalance,
  }) {
    return PaymentMethodState(
      selected: selected ?? this.selected,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}

class PaymentMethodNotifier extends StateNotifier<PaymentMethodState> {
  PaymentMethodNotifier() : super(const PaymentMethodState());

  void selectMethod(PaymentMethodType method) {
    state = state.copyWith(selected: method);
  }

  void setCardDetails(String number, String expiry, String cvv) {
    state = state.copyWith(cardNumber: number, expiryDate: expiry, cvv: cvv);
  }
}

final paymentMethodProvider = StateNotifierProvider<PaymentMethodNotifier, PaymentMethodState>((ref) {
  return PaymentMethodNotifier();
});


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/payment_model.dart';

final _firestore = FirebaseFirestore.instance;

// Process payment
final processPaymentProvider = FutureProvider.family<PaymentModel, PaymentModel>((ref, payment) async {
  final docRef = _firestore.collection('payments').doc();
  final paymentWithId = PaymentModel(
    id: docRef.id,
    bookingId: payment.bookingId,
    payerId: payment.payerId,
    payeeId: payment.payeeId,
    amount: payment.amount,
    currency: payment.currency,
    paymentMethod: payment.paymentMethod,
    status: 'completed', // Simulating successful payment
    transactionId: 'TXN_${DateTime.now().millisecondsSinceEpoch}',
    createdAt: DateTime.now(),
    completedAt: DateTime.now(),
  );
  
  await docRef.set(paymentWithId.toJson());
  
  // Update booking payment status
  await _firestore.collection('bookings').doc(payment.bookingId).update({
    'paymentStatus': 'paid',
    'updatedAt': FieldValue.serverTimestamp(),
  });
  
  return paymentWithId;
});

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


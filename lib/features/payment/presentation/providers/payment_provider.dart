import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

/// Saved payment method model
class SavedPaymentMethod {
  final String id;
  final String userId;
  final String type; // 'card', 'bank_account'
  final String last4;
  final String? brand; // 'visa', 'mastercard', etc.
  final String? expiryMonth;
  final String? expiryYear;
  final String? bankName;
  final bool isDefault;
  final DateTime createdAt;

  SavedPaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    required this.last4,
    this.brand,
    this.expiryMonth,
    this.expiryYear,
    this.bankName,
    this.isDefault = false,
    required this.createdAt,
  });

  factory SavedPaymentMethod.fromJson(Map<String, dynamic> json) {
    return SavedPaymentMethod(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: json['type'] ?? 'card',
      last4: json['last4'] ?? '****',
      brand: json['brand'],
      expiryMonth: json['expiryMonth'],
      expiryYear: json['expiryYear'],
      bankName: json['bankName'],
      isDefault: json['isDefault'] ?? false,
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'type': type,
    'last4': last4,
    'brand': brand,
    'expiryMonth': expiryMonth,
    'expiryYear': expiryYear,
    'bankName': bankName,
    'isDefault': isDefault,
    'createdAt': createdAt.toIso8601String(),
  };

  String get displayName {
    if (type == 'card') {
      return '${brand?.toUpperCase() ?? 'Card'} •••• $last4';
    } else {
      return '${bankName ?? 'Bank'} •••• $last4';
    }
  }
}

/// Provider for user's saved payment methods
final savedPaymentMethodsProvider = StreamProvider<List<SavedPaymentMethod>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return _firestore
      .collection('payment_methods')
      .where('userId', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => SavedPaymentMethod.fromJson({...doc.data(), 'id': doc.id}))
          .toList())
      .handleError((error) => <SavedPaymentMethod>[]);
});

/// Check if user has any saved payment method
final hasPaymentMethodProvider = Provider<bool>((ref) {
  final methods = ref.watch(savedPaymentMethodsProvider);
  return methods.maybeWhen(
    data: (list) => list.isNotEmpty,
    orElse: () => false,
  );
});

/// Save a new payment method (card or bank account)
Future<SavedPaymentMethod> savePaymentMethod({
  String? cardNumber,
  String? expiryMonth,
  String? expiryYear,
  String? cvv,
  String? accountNumber,
  String? routingNumber,
  String? bankName,
  String? holderName,
  required String type, // 'card' or 'bank'
  bool setAsDefault = true,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Not authenticated');

  String last4;
  String? brand;

  if (type == 'card') {
    if (cardNumber == null || cardNumber.isEmpty) {
      throw Exception('Card number is required');
    }
    final cleanNumber = cardNumber.replaceAll(' ', '');
    last4 = cleanNumber.substring(cleanNumber.length - 4);
    brand = _detectCardBrand(cardNumber);
  } else {
    if (accountNumber == null || accountNumber.isEmpty) {
      throw Exception('Account number is required');
    }
    last4 = accountNumber.length >= 4
        ? accountNumber.substring(accountNumber.length - 4)
        : accountNumber;
    brand = bankName;
  }

  final docRef = _firestore.collection('payment_methods').doc();
  final method = SavedPaymentMethod(
    id: docRef.id,
    userId: user.uid,
    type: type,
    last4: last4,
    brand: brand,
    expiryMonth: expiryMonth,
    expiryYear: expiryYear,
    bankName: bankName,
    isDefault: setAsDefault,
    createdAt: DateTime.now(),
  );

  // If setting as default, unset other defaults for same type
  if (setAsDefault) {
    final existing = await _firestore
        .collection('payment_methods')
        .where('userId', isEqualTo: user.uid)
        .where('type', isEqualTo: type)
        .where('isDefault', isEqualTo: true)
        .get();

    for (final doc in existing.docs) {
      await doc.reference.update({'isDefault': false});
    }
  }

  await docRef.set(method.toJson());
  return method;
}

/// Delete a saved payment method
Future<void> deletePaymentMethod(String methodId) async {
  await _firestore.collection('payment_methods').doc(methodId).delete();
}

/// Set a payment method as default
Future<void> setDefaultPaymentMethod(String methodId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Not authenticated');

  // Unset all other defaults
  final existing = await _firestore
      .collection('payment_methods')
      .where('userId', isEqualTo: user.uid)
      .where('isDefault', isEqualTo: true)
      .get();

  for (final doc in existing.docs) {
    await doc.reference.update({'isDefault': false});
  }

  // Set new default
  await _firestore.collection('payment_methods').doc(methodId).update({
    'isDefault': true,
  });
}

/// Detect card brand from number
String _detectCardBrand(String cardNumber) {
  final number = cardNumber.replaceAll(' ', '');
  if (number.startsWith('4')) return 'visa';
  if (number.startsWith('5')) return 'mastercard';
  if (number.startsWith('34') || number.startsWith('37')) return 'amex';
  if (number.startsWith('6')) return 'discover';
  return 'card';
}


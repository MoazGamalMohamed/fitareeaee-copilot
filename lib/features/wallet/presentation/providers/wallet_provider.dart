import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/wallet_model.dart';

/// Provider for current user's wallet
final walletProvider = StreamProvider<WalletModel?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('wallets')
      .doc(user.uid)
      .snapshots()
      .map((doc) {
    if (!doc.exists) return null;
    return WalletModel.fromJson({...doc.data()!, 'userId': user.uid});
  });
});

/// Provider for wallet transactions
final walletTransactionsProvider = StreamProvider<List<WalletTransaction>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  // Simplified query without orderBy to avoid needing composite index
  return FirebaseFirestore.instance
      .collection('wallet_transactions')
      .where('userId', isEqualTo: user.uid)
      .limit(50)
      .snapshots()
      .map((snapshot) {
        final transactions = snapshot.docs
            .map((doc) => WalletTransaction.fromJson({...doc.data(), 'id': doc.id}))
            .toList();
        // Sort client-side
        transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return transactions;
      })
      .handleError((error) {
        // Return empty list on error
        return <WalletTransaction>[];
      });
});

/// Create or get wallet for user
Future<WalletModel> getOrCreateWallet(String userId) async {
  final firestore = FirebaseFirestore.instance;
  final walletRef = firestore.collection('wallets').doc(userId);
  final walletDoc = await walletRef.get();

  if (walletDoc.exists) {
    return WalletModel.fromJson({...walletDoc.data()!, 'userId': userId});
  }

  final now = DateTime.now();
  final newWallet = WalletModel(
    userId: userId,
    createdAt: now,
    updatedAt: now,
  );

  await walletRef.set({
    ...newWallet.toJson(),
    'createdAt': now.toIso8601String(),
    'updatedAt': now.toIso8601String(),
  });

  return newWallet;
}

/// Add funds to wallet (e.g., from payment)
Future<void> addFundsToWallet({
  required String userId,
  required double amount,
  required String description,
  String? tripId,
  String? bookingId,
  bool isPending = false,
}) async {
  final firestore = FirebaseFirestore.instance;
  final now = DateTime.now();

  // Create transaction record
  final transactionRef = firestore.collection('wallet_transactions').doc();
  await transactionRef.set({
    'id': transactionRef.id,
    'userId': userId,
    'type': TransactionType.deposit.name,
    'status': TransactionStatus.completed.name,
    'amount': amount,
    'currency': 'USD',
    'description': description,
    'tripId': tripId,
    'bookingId': bookingId,
    'createdAt': now.toIso8601String(),
    'completedAt': now.toIso8601String(),
  });

  // Update wallet balance
  final walletRef = firestore.collection('wallets').doc(userId);
  final field = isPending ? 'pendingBalance' : 'availableBalance';
  await walletRef.update({
    field: FieldValue.increment(amount),
    'totalEarnings': FieldValue.increment(amount),
    'updatedAt': now.toIso8601String(),
  });
}

/// Request payout
Future<void> requestPayout({
  required String userId,
  required double amount,
}) async {
  final firestore = FirebaseFirestore.instance;
  final now = DateTime.now();

  // Get wallet to check balance and payout method
  final walletDoc = await firestore.collection('wallets').doc(userId).get();
  if (!walletDoc.exists) throw Exception('Wallet not found');

  final wallet = WalletModel.fromJson({...walletDoc.data()!, 'userId': userId});
  if (!wallet.canWithdraw(amount)) throw Exception('Insufficient balance');
  if (!wallet.hasPayoutMethod) throw Exception('No payout method configured');

  // Create payout request
  final payoutRef = firestore.collection('payout_requests').doc();
  await payoutRef.set({
    'id': payoutRef.id,
    'userId': userId,
    'amount': amount,
    'currency': wallet.currency,
    'status': TransactionStatus.pending.name,
    'payoutMethod': wallet.defaultPayoutMethod ?? 'bank_transfer',
    'bankAccountNumber': wallet.bankAccountNumber,
    'bankName': wallet.bankName,
    'createdAt': now.toIso8601String(),
  });

  // Deduct from available balance and add to pending
  await firestore.collection('wallets').doc(userId).update({
    'availableBalance': FieldValue.increment(-amount),
    'pendingBalance': FieldValue.increment(amount),
    'updatedAt': now.toIso8601String(),
  });

  // Create transaction record
  final transactionRef = firestore.collection('wallet_transactions').doc();
  await transactionRef.set({
    'id': transactionRef.id,
    'userId': userId,
    'type': TransactionType.payout.name,
    'status': TransactionStatus.pending.name,
    'amount': -amount,
    'currency': wallet.currency,
    'description': 'Payout request',
    'createdAt': now.toIso8601String(),
  });
}


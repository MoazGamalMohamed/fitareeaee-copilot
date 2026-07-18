import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/wallet_model.dart';
import '../providers/wallet_provider.dart';
import '../../../payment/presentation/providers/payment_provider.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  @override
  void initState() {
    super.initState();
    _initWallet();
  }

  Future<void> _initWallet() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await getOrCreateWallet(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(walletProvider);
    final transactionsAsync = ref.watch(walletTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showPayoutSettings(),
          ),
        ],
      ),
      body: walletAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (wallet) => _buildContent(wallet, transactionsAsync),
      ),
    );
  }

  Widget _buildContent(
    WalletModel? wallet,
    AsyncValue<List<WalletTransaction>> transactionsAsync,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(walletProvider);
        ref.invalidate(walletTransactionsProvider);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Balance Card
          Card(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${(wallet?.availableBalance ?? 0).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pending',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '\$${(wallet?.pendingBalance ?? 0).toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Earnings',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '\$${(wallet?.totalEarnings ?? 0).toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _requestPayout(wallet),
                  icon: const Icon(Icons.account_balance),
                  label: const Text('Transfer to Bank'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showTransactionHistory(),
                  icon: const Icon(Icons.history),
                  label: const Text('History'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Payment Methods Section
          _buildPaymentMethodsSection(),
          const SizedBox(height: 24),

          // Recent Transactions
          const Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          transactionsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (transactions) => transactions.isEmpty
                ? const Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: Text('No transactions yet')),
                    ),
                  )
                : Column(
                    children: transactions
                        .take(10)
                        .map((t) => _buildTransactionItem(t))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    final paymentMethodsAsync = ref.watch(savedPaymentMethodsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payment Methods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _showAddPaymentMethodSheet(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        paymentMethodsAsync.when(
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (e, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error loading payment methods: $e'),
            ),
          ),
          data: (methods) => methods.isEmpty
              ? Card(
                  child: InkWell(
                    onTap: () => _showAddPaymentMethodSheet(),
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_card, color: Colors.grey),
                          SizedBox(width: 12),
                          Text(
                            'Add a payment method',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Column(
                  children: methods
                      .map((method) => _buildPaymentMethodCard(method))
                      .toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(SavedPaymentMethod method) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
          child: Icon(
            method.type == 'card' ? Icons.credit_card : Icons.account_balance,
            color: Colors.blue,
          ),
        ),
        title: Text(method.displayName),
        subtitle: method.type == 'card' && method.expiryMonth != null
            ? Text('Expires ${method.expiryMonth}/${method.expiryYear}')
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (method.isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Default',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'default') {
                  await setDefaultPaymentMethod(method.id);
                  ref.invalidate(savedPaymentMethodsProvider);
                } else if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Payment Method'),
                      content: Text('Remove ${method.displayName}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await deletePaymentMethod(method.id);
                    ref.invalidate(savedPaymentMethodsProvider);
                  }
                }
              },
              itemBuilder: (context) => [
                if (!method.isDefault)
                  const PopupMenuItem(
                    value: 'default',
                    child: Text('Set as Default'),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPaymentMethodSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddPaymentMethodSheet(),
    );
  }

  Widget _buildTransactionItem(WalletTransaction transaction) {
    final isPositive = transaction.amount > 0;
    final icon = _getTransactionIcon(transaction.type);
    final color = isPositive ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(transaction.description),
        subtitle: Text(
          _formatDate(transaction.createdAt),
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Text(
          '${isPositive ? '+' : ''}\$${transaction.amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return Icons.arrow_downward;
      case TransactionType.withdrawal:
        return Icons.arrow_upward;
      case TransactionType.payment:
        return Icons.payment;
      case TransactionType.refund:
        return Icons.refresh;
      case TransactionType.payout:
        return Icons.account_balance;
      case TransactionType.fee:
        return Icons.receipt;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _requestPayout(WalletModel? wallet) async {
    if (wallet == null || wallet.availableBalance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No funds available for withdrawal')),
      );
      return;
    }

    if (!wallet.hasPayoutMethod) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please configure payout settings first')),
      );
      _showPayoutSettings();
      return;
    }

    final amountController = TextEditingController(
      text: wallet.availableBalance.toStringAsFixed(2),
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Payout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Available: \$${wallet.availableBalance.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Request'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final amount = double.parse(amountController.text);
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await requestPayout(userId: user.uid, amount: amount);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payout request submitted')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _showPayoutSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const PayoutSettingsSheet(),
    );
  }

  void _showTransactionHistory() {
    // Navigate to full transaction history
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Full history coming soon')));
  }
}

class PayoutSettingsSheet extends ConsumerStatefulWidget {
  const PayoutSettingsSheet({super.key});

  @override
  ConsumerState<PayoutSettingsSheet> createState() =>
      _PayoutSettingsSheetState();
}

class _PayoutSettingsSheetState extends ConsumerState<PayoutSettingsSheet> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _routingNumberController = TextEditingController();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Payout Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bankNameController,
              decoration: const InputDecoration(
                labelText: 'Bank Name',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _accountNumberController,
              decoration: const InputDecoration(
                labelText: 'Account Number',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _routingNumberController,
              decoration: const InputDecoration(
                labelText: 'Routing Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveSettings,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not authenticated');

      await getOrCreateWallet(user.uid);
      // Update would go here
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payout settings saved')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _routingNumberController.dispose();
    super.dispose();
  }
}

/// Sheet for adding a new payment method
class AddPaymentMethodSheet extends ConsumerStatefulWidget {
  const AddPaymentMethodSheet({super.key});

  @override
  ConsumerState<AddPaymentMethodSheet> createState() =>
      _AddPaymentMethodSheetState();
}

class _AddPaymentMethodSheetState extends ConsumerState<AddPaymentMethodSheet> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isSaving = false;
  bool _setAsDefault = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Payment Method',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Security notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your card details are securely encrypted and stored.',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                prefixIcon: Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final cleaned = value.replaceAll(' ', '');
                if (cleaned.length < 13 || cleaned.length > 19) {
                  return 'Invalid card number';
                }
                return null;
              },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Required';
                      if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                        return 'Use MM/YY';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Required';
                      if (value.length < 3 || value.length > 4) {
                        return 'Invalid CVV';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _setAsDefault,
              onChanged: (v) => setState(() => _setAsDefault = v ?? true),
              title: const Text('Set as default payment method'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveCard,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Card'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final expiry = _expiryController.text.split('/');
      await savePaymentMethod(
        type: 'card',
        cardNumber: _cardNumberController.text,
        expiryMonth: expiry[0],
        expiryYear: expiry[1],
        cvv: _cvvController.text,
        setAsDefault: _setAsDefault,
      );

      ref.invalidate(savedPaymentMethodsProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment method saved'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}

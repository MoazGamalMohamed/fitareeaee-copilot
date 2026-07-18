import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../../../verification/presentation/pages/verification_screen.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        children: [
          // Notifications Section
          _buildSectionHeader(context, 'Notifications'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive trip updates and messages'),
            value: settings.notificationsEnabled,
            onChanged: (value) =>
                settingsNotifier.setNotificationsEnabled(value),
            secondary: const Icon(Icons.notifications_outlined),
          ),
          SwitchListTile(
            title: const Text('Sound'),
            subtitle: const Text('Play sound for notifications'),
            value: settings.soundEnabled,
            onChanged: (value) => settingsNotifier.setSoundEnabled(value),
            secondary: const Icon(Icons.volume_up_outlined),
          ),
          const Divider(),

          // Privacy Section
          _buildSectionHeader(context, 'Privacy'),
          SwitchListTile(
            title: const Text('Location Sharing'),
            subtitle: const Text('Share location during trips'),
            value: settings.locationSharingEnabled,
            onChanged: (value) =>
                settingsNotifier.setLocationSharingEnabled(value),
            secondary: const Icon(Icons.location_on_outlined),
          ),
          const Divider(),

          // Payment & Payout Section
          _buildSectionHeader(context, 'Payment & Payout'),
          _buildPaymentSettingsItem(
            context: context,
            ref: ref,
            icon: Icons.credit_card,
            title: 'Payment Card',
            subtitle: 'Card used for payments',
            type: 'card',
          ),
          _buildPaymentSettingsItem(
            context: context,
            ref: ref,
            icon: Icons.account_balance,
            title: 'Bank Account',
            subtitle: 'Account to receive payouts',
            type: 'bank',
          ),
          const Divider(),

          // Vehicle & Carrier Details Section
          _buildSectionHeader(context, 'Driver/Courier Profile'),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Vehicle & License Details'),
            subtitle: const Text('Required to offer rides or deliveries'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/driver-profile'),
          ),
          const Divider(),

          // ID Verification Section
          _buildSectionHeader(context, 'Verification'),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('ID Verification'),
            subtitle: const Text('Verify your identity with selfie + ID'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showIdVerificationFlow(context, ref),
          ),
          const Divider(),

          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: settings.darkModeEnabled,
            onChanged: (value) => settingsNotifier.setDarkModeEnabled(value),
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('Language'),
            subtitle: Text(_getLanguageName(settings.language)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, ref),
          ),
          const Divider(),

          // Support Section
          _buildSectionHeader(context, 'Support'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help Center'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon(context),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon(context),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon(context),
          ),
          const Divider(),

          // Account Section
          _buildSectionHeader(context, 'Account'),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.error),
            title: Text('Sign Out', style: TextStyle(color: AppColors.error)),
            onTap: () => _showSignOutDialog(context, ref),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: AppColors.error),
            title: Text(
              'Delete Account',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () => _showDeleteAccountDialog(context),
          ),
          const SizedBox(height: 24),

          // App Version
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, ref, 'en', 'English'),
            _buildLanguageOption(context, ref, 'ar', 'العربية'),
            _buildLanguageOption(context, ref, 'fr', 'Français'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext ctx,
    WidgetRef ref,
    String code,
    String name,
  ) {
    final current = ref.watch(settingsProvider).language;
    return ListTile(
      title: Text(name),
      trailing: current == code
          ? Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: () {
        ref.read(settingsProvider.notifier).setLanguage(code);
        Navigator.pop(ctx);
      },
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Coming soon!')));
  }

  Widget _buildPaymentSettingsItem({
    required BuildContext context,
    required WidgetRef ref,
    required IconData icon,
    required String title,
    required String subtitle,
    required String type,
  }) {
    final paymentMethods = ref.watch(savedPaymentMethodsProvider);

    return paymentMethods.when(
      data: (methods) {
        final hasMethod = type == 'card'
            ? methods.any((m) => m.type == 'card')
            : methods.any((m) => m.type == 'bank');
        final method = type == 'card'
            ? methods.where((m) => m.type == 'card').firstOrNull
            : methods.where((m) => m.type == 'bank').firstOrNull;

        return ListTile(
          leading: Icon(icon, color: hasMethod ? Colors.green : Colors.grey),
          title: Text(title),
          subtitle: Text(
            hasMethod
                ? (type == 'card'
                      ? '•••• ${method?.last4 ?? '****'}'
                      : 'Account ending in ${method?.last4 ?? '****'}')
                : subtitle,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasMethod)
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () => _showPaymentSettingsSheet(context, ref, type),
        );
      },
      loading: () => ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(title),
        subtitle: const Text('Loading...'),
        trailing: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, _) => ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showPaymentSettingsSheet(context, ref, type),
      ),
    );
  }

  void _showPaymentSettingsSheet(
    BuildContext context,
    WidgetRef ref,
    String type,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PaymentSettingsSheet(type: type),
    );
  }

  void _showIdVerificationFlow(BuildContext context, WidgetRef ref) {
    // Navigate to the proper verification screen with camera support
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VerificationScreen()),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: Text('Sign Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion coming soon')),
              );
            },
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

/// Payment Settings Sheet for adding/editing payment methods
class PaymentSettingsSheet extends ConsumerStatefulWidget {
  final String type; // 'card' or 'bank'

  const PaymentSettingsSheet({super.key, required this.type});

  @override
  ConsumerState<PaymentSettingsSheet> createState() =>
      _PaymentSettingsSheetState();
}

class _PaymentSettingsSheetState extends ConsumerState<PaymentSettingsSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Card fields
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardholderController = TextEditingController();

  // Bank fields
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _routingNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardholderController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _routingNumberController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCard = widget.type == 'card';

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isCard ? 'Payment Card' : 'Bank Account',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isCard
                    ? 'Add a card to pay for trips and services'
                    : 'Add a bank account to receive payouts',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              if (isCard) ..._buildCardFields() else ..._buildBankFields(),

              const SizedBox(height: 16),

              // Security notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.security, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your payment information is encrypted and secure. We only store the last 4 digits.',
                        style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _savePaymentMethod,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isCard ? 'Save Card' : 'Save Bank Account'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCardFields() {
    return [
      TextFormField(
        controller: _cardholderController,
        decoration: const InputDecoration(
          labelText: 'Cardholder Name',
          prefixIcon: Icon(Icons.person),
        ),
        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _cardNumberController,
        decoration: const InputDecoration(
          labelText: 'Card Number',
          prefixIcon: Icon(Icons.credit_card),
          hintText: '1234 5678 9012 3456',
        ),
        keyboardType: TextInputType.number,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Required';
          if (v.replaceAll(' ', '').length < 13) return 'Invalid card number';
          return null;
        },
      ),
      const SizedBox(height: 16),
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
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
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
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (v.length < 3) return 'Invalid';
                return null;
              },
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildBankFields() {
    return [
      TextFormField(
        controller: _accountHolderController,
        decoration: const InputDecoration(
          labelText: 'Account Holder Name',
          prefixIcon: Icon(Icons.person),
        ),
        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _bankNameController,
        decoration: const InputDecoration(
          labelText: 'Bank Name',
          prefixIcon: Icon(Icons.account_balance),
        ),
        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _accountNumberController,
        decoration: const InputDecoration(
          labelText: 'Account Number',
          prefixIcon: Icon(Icons.numbers),
        ),
        keyboardType: TextInputType.number,
        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _routingNumberController,
        decoration: const InputDecoration(
          labelText: 'Routing Number',
          prefixIcon: Icon(Icons.route),
        ),
        keyboardType: TextInputType.number,
        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
      ),
    ];
  }

  Future<void> _savePaymentMethod() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final isCard = widget.type == 'card';

      await savePaymentMethod(
        type: widget.type,
        cardNumber: isCard ? _cardNumberController.text : null,
        expiryMonth: isCard ? _expiryController.text.split('/').first : null,
        expiryYear: isCard ? _expiryController.text.split('/').last : null,
        cvv: isCard ? _cvvController.text : null,
        accountNumber: !isCard ? _accountNumberController.text : null,
        routingNumber: !isCard ? _routingNumberController.text : null,
        bankName: !isCard ? _bankNameController.text : null,
        holderName: isCard
            ? _cardholderController.text
            : _accountHolderController.text,
      );

      ref.invalidate(savedPaymentMethodsProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${isCard ? 'Card' : 'Bank account'} saved successfully',
            ),
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
}

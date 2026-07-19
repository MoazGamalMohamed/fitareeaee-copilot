import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../verification/presentation/pages/verification_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        children: [
          _section('Trust and safety'),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined),
            title: const Text('Manual identity verification'),
            subtitle: const Text(
              'Submit a selfie and ID for review by an authorized admin.',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VerificationScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy and AI safety'),
            subtitle: const Text('What the contest build sends and stores'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyAndSafety(context),
          ),
          const Divider(),
          _section('Contest build'),
          const ListTile(
            leading: Icon(Icons.payments_outlined),
            title: Text('Payments are disabled'),
            subtitle: Text(
              'No cards are charged and no escrow, refund, wallet, or payout is processed.',
            ),
          ),
          const ListTile(
            leading: Icon(Icons.language_outlined),
            title: Text('Language and currency'),
            subtitle: Text(
              'The interface and prices use English and US dollars. Copilot accepts English or Arabic requests.',
            ),
          ),
          const Divider(),
          _section('Account'),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.error),
            title: Text('Sign Out', style: TextStyle(color: AppColors.error)),
            onTap: () => _showSignOutDialog(context, ref),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Fitareeaee Copilot • Build Week judge build',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
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

  void _showPrivacyAndSafety(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy and AI safety',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              const Text(
                'Plan with AI sends only the natural-language trip request, locale, time-zone offset, and current date through an authenticated Firebase Function. Contact details are redacted before the request reaches OpenAI, and model responses are not stored by the API request.',
              ),
              const SizedBox(height: 12),
              const Text(
                'GPT-5.6 creates a draft only. It cannot book, approve identity, label a person safe, guarantee a match, process money, or make emergency decisions. You review the draft before deterministic live-trip matching.',
              ),
              const SizedBox(height: 12),
              const Text(
                'Identity images remain in Firebase Storage for manual admin review and are removed after a review decision. Never use this prototype for emergencies.',
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(sheetContext),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSignOutDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Sign Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(authRepositoryProvider).signOut();
    if (context.mounted) context.go('/login');
  }
}

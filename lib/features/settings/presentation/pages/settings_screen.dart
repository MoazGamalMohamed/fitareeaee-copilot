import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/currency/currency_formatter.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/user_path.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../verification/domain/models/verification_model.dart';
import '../../../verification/domain/verification_requirements.dart';
import '../../../verification/presentation/pages/verification_screen.dart';
import '../../../verification/presentation/providers/verification_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final user = ref
        .watch(authStateProvider)
        .maybeWhen(data: (value) => value, orElse: () => null);
    final profileAsync = user == null
        ? const AsyncValue<UserProfile?>.data(null)
        : ref.watch(userProfileProvider(user.id));
    final verificationAsync = user == null
        ? const AsyncValue<UserVerification?>.data(null)
        : ref.watch(userVerificationProvider(user.id));
    final isDriver = marketplacePathForRoles(user?.roles ?? const []).isDriver;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('settings_title')),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _section('Support'),
          ListTile(
            leading: const Icon(Icons.support_agent_outlined),
            title: const Text('Support chat'),
            subtitle: const Text(
              'Get instant guidance, then keep a ticket open for admin/support follow-up.',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/support'),
          ),
          const Divider(),
          _section('Trust and safety'),
          _buildVerificationProgress(
            context,
            verificationAsync,
            isDriver: isDriver,
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy and AI safety'),
            subtitle: const Text('What the contest build sends and stores'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyAndSafety(context),
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome_outlined),
            title: const Text('Built with Codex • Powered by GPT-5.6'),
            subtitle: const Text(
              'See the distinct Build Week role of each OpenAI technology',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showBuildWeekTechnology(context),
          ),
          const Divider(),
          _section(context.tr('settings_preferences')),
          ListTile(
            leading: const Icon(Icons.translate_outlined),
            title: Text(context.tr('settings_app_language')),
            subtitle: Text(context.tr('settings_app_language_help')),
            trailing: DropdownButton<String>(
              key: const ValueKey('app-language-selector'),
              value: settings.language,
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(context.tr('settings_english')),
                ),
                DropdownMenuItem(
                  value: 'ar',
                  child: Text(context.tr('settings_arabic')),
                ),
              ],
              onChanged: (value) async {
                if (value == null) return;
                await _saveSetting(
                  context,
                  () => ref.read(settingsProvider.notifier).setLanguage(value),
                  value == 'ar'
                      ? 'تم تغيير لغة التطبيق.'
                      : 'App language changed.',
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('settings_planning_languages'),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  context.tr('settings_planning_languages_help'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      avatar: const Icon(Icons.language, size: 18),
                      label: Text(context.tr('settings_english')),
                      selected: settings.preferredLanguages.contains('en'),
                      onSelected: (_) async => _saveSetting(
                        context,
                        () => ref
                            .read(settingsProvider.notifier)
                            .togglePreferredLanguage('en'),
                        context.tr('common_saved'),
                      ),
                    ),
                    FilterChip(
                      avatar: const Icon(Icons.translate, size: 18),
                      label: Text(context.tr('settings_arabic')),
                      selected: settings.preferredLanguages.contains('ar'),
                      onSelected: (_) async => _saveSetting(
                        context,
                        () => ref
                            .read(settingsProvider.notifier)
                            .togglePreferredLanguage('ar'),
                        context.tr('common_saved'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: Text(context.tr('settings_currency')),
            subtitle: Text(context.tr('settings_currency_help')),
            trailing: DropdownButton<String>(
              key: const ValueKey('currency-selector'),
              value: settings.currency,
              items: AppConstants.supportedCurrencies
                  .map(
                    (currency) => DropdownMenuItem(
                      value: currency,
                      child: Text(CurrencyFormatter.inputLabel(currency)),
                    ),
                  )
                  .toList(),
              onChanged: (value) async {
                if (value != null) {
                  await _saveSetting(
                    context,
                    () =>
                        ref.read(settingsProvider.notifier).setCurrency(value),
                    'Currency changed to $value.',
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(72, 0, 20, 8),
            child: Text(
              context.tr('settings_currency_note'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            subtitle: const Text('Booking, chat, support, and system updates'),
            value: settings.notificationsEnabled,
            onChanged: (value) async => _saveSetting(
              context,
              () => ref
                  .read(settingsProvider.notifier)
                  .setNotificationsEnabled(value),
              value ? 'App alerts enabled.' : 'App alerts disabled.',
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.location_on_outlined),
            title: const Text('Location sharing while active'),
            subtitle: const Text(
              'Reserved for active confirmed trip tracking.',
            ),
            value: settings.locationSharingEnabled,
            onChanged: (value) async => _saveSetting(
              context,
              () => ref
                  .read(settingsProvider.notifier)
                  .setLocationSharingEnabled(value),
              value
                  ? 'Active-trip location sharing preference enabled.'
                  : 'Active-trip location sharing preference disabled.',
            ),
          ),
          const Divider(),
          _section('Payments'),
          const ListTile(
            leading: Icon(Icons.payments_outlined),
            title: Text('Payments are disabled'),
            subtitle: Text(
              'No cards are charged and no escrow, refund, wallet, or payout is processed.',
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.credit_card),
            title: const Text('Save payment method later'),
            subtitle: const Text(
              'Preference only. No card details are collected in this judge build.',
            ),
            value: settings.savePaymentMethod,
            onChanged: (value) async => _saveSetting(
              context,
              () => ref
                  .read(settingsProvider.notifier)
                  .setSavePaymentMethod(value),
              value
                  ? 'Future payment-method saving preference enabled.'
                  : 'Future payment-method saving preference disabled.',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('Payment overview'),
            subtitle: const Text(
              'Passenger payable and driver receivable view',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/payments'),
          ),
          const Divider(),
          _section('Driver quality'),
          _buildDriverMetric(context, profileAsync),
          const Divider(),
          _section('Account'),
          ListTile(
            leading: const Icon(Icons.manage_accounts_outlined),
            title: const Text('Profile and address'),
            subtitle: profileAsync.maybeWhen(
              data: (_) => const Text('Edit your personal and contact details'),
              orElse: () => const Text('Edit your account details'),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: user == null
                ? null
                : () => context.push('/profile/edit', extra: user.id),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.error),
            title: Text('Sign Out', style: TextStyle(color: AppColors.error)),
            onTap: () => _showSignOutDialog(context, ref),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Fitareeaee • Rides and deliveries made simple',
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

  Widget _buildDriverMetric(
    BuildContext context,
    AsyncValue<UserProfile?> profileAsync,
  ) {
    return profileAsync.when(
      loading: () => const ListTile(
        leading: Icon(Icons.insights_outlined),
        title: Text('Driver priority metric'),
        subtitle: Text('Loading profile history...'),
      ),
      error: (_, _) => const ListTile(
        leading: Icon(Icons.insights_outlined),
        title: Text('Driver priority metric'),
        subtitle: Text('Profile history is unavailable.'),
      ),
      data: (profile) {
        final totalTrips = profile?.totalTrips ?? 0;
        final unlocked = totalTrips >= 50;
        final rating = profile?.rating ?? 0;
        final score = _driverPriorityScore(profile);
        return ListTile(
          leading: Icon(
            unlocked ? Icons.emoji_events_outlined : Icons.lock_outline,
          ),
          title: const Text('Driver priority metric'),
          subtitle: Text(
            unlocked
                ? 'Score ${score.toStringAsFixed(0)}/100 from rating, completed trips, and acceptance history.'
                : 'Unlocks after 50 completed rides or deliveries. Current history: $totalTrips.',
          ),
          trailing: unlocked
              ? CircleAvatar(child: Text(score.toStringAsFixed(0)))
              : Text('${rating.toStringAsFixed(1)} rating'),
        );
      },
    );
  }

  Widget _buildVerificationProgress(
    BuildContext context,
    AsyncValue<UserVerification?> verificationAsync, {
    required bool isDriver,
  }) {
    final subtitle = verificationAsync.when(
      loading: () => 'Loading live verification progress…',
      error: (_, _) => 'Progress unavailable — tap to retry in Verification',
      data: (verification) {
        final total = tripVerificationTotalSteps(driver: isDriver);
        final submitted = submittedTripVerificationStepCount(
          verification,
          driver: isDriver,
        );
        final approved = approvedTripVerificationStepCount(
          verification,
          driver: isDriver,
        );
        final pending = pendingTripVerificationStepCount(
          verification,
          driver: isDriver,
        );
        return '$submitted/$total submitted • $approved approved • $pending pending';
      },
    );
    return ListTile(
      leading: const Icon(Icons.verified_user_outlined),
      title: const Text('Verification progress'),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VerificationScreen()),
      ),
    );
  }

  double _driverPriorityScore(UserProfile? profile) {
    if (profile == null || profile.totalTrips < 50) return 0;
    final acceptanceRate = profile.metadata['acceptanceRate'];
    final completionRate = profile.metadata['completionRate'];
    final acceptance = acceptanceRate is num ? acceptanceRate.toDouble() : 0.8;
    final completion = completionRate is num ? completionRate.toDouble() : 0.9;
    final ratingScore = (profile.rating.clamp(0, 5).toDouble() / 5) * 60;
    final acceptanceScore = acceptance.clamp(0, 1).toDouble() * 25;
    final completionScore = completion.clamp(0, 1).toDouble() * 15;
    return ratingScore + acceptanceScore + completionScore;
  }

  Future<void> _saveSetting(
    BuildContext context,
    Future<void> Function() action,
    String successMessage,
  ) async {
    try {
      await action();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('That setting could not be saved. Please retry.'),
          ),
        );
    }
  }

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
                'Plan with GPT-5.6 sends only the natural-language trip request, locale, time-zone offset, and current date through an authenticated Firebase Function. Contact details are redacted before the request reaches OpenAI, and model responses are not stored by the API request.',
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

  void _showBuildWeekTechnology(BuildContext context) {
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
                'Built with Codex • Powered by GPT-5.6',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              const Text(
                'Codex was the primary engineering collaborator used during Build Week to audit the inherited app, implement and review Flutter and Firebase changes, harden authorization, write tests, run Android release gates, and preserve the evidence trail.',
              ),
              const SizedBox(height: 12),
              const Text(
                'GPT-5.6 is the runtime intelligence behind the trip planner and first-line support. It interprets English or Arabic into strict, validated drafts; deterministic application code—not the model—controls matching, verification, booking, payment state, and chat access.',
              ),
              const SizedBox(height: 12),
              const Text(
                'The developer made the product, scope, privacy, safety, architecture, and release decisions. Pre-existing work and the Build Week extension are documented separately in the public repository.',
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
    final authRepository = ref.read(authRepositoryProvider);
    // Dispose settings/profile streams while the old session still has read
    // access, then let the auth-aware router move Home to Login after sign-out.
    if (context.mounted) context.go('/home');
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await authRepository.signOut();
  }
}

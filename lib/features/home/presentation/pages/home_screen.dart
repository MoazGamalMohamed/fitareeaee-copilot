import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/user_path.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../verification/domain/models/verification_model.dart';
import '../../../verification/domain/verification_requirements.dart';
import '../../../verification/presentation/providers/verification_provider.dart';

/// Home presents Request and Offer as distinct marketplace actions.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref
        .watch(authStateProvider)
        .maybeWhen(data: (value) => value, orElse: () => null);
    final verificationAsync = user == null
        ? const AsyncValue<UserVerification?>.data(null)
        : ref.watch(verificationStatusProvider(user.id));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitareeaee'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('home_plan_title'),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tr('home_plan_subtitle'),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildCircularPlannerAction(context),

              const SizedBox(height: 28),

              Text(
                context.tr('home_question'),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              _buildPrimaryActionCard(
                context,
                key: const ValueKey('home-request-action'),
                icon: Icons.person_search_outlined,
                title: context.tr('home_request'),
                subtitle: context.tr('home_request_subtitle'),
                color: Colors.indigo,
                onTap: () => _handleCreateTrip(
                  context,
                  verificationAsync,
                  MarketplacePath.rider,
                ),
              ),
              const SizedBox(height: 12),
              _buildPrimaryActionCard(
                context,
                key: const ValueKey('home-offer-action'),
                icon: Icons.drive_eta_outlined,
                title: context.tr('home_offer'),
                subtitle: context.tr('home_offer_subtitle'),
                color: Colors.teal,
                onTap: () => _handleCreateTrip(
                  context,
                  verificationAsync,
                  MarketplacePath.driver,
                ),
              ),
              const SizedBox(height: 12),
              _buildPrimaryActionCard(
                context,
                icon: Icons.explore_outlined,
                title: context.tr('home_explore'),
                subtitle: context.tr('home_explore_subtitle'),
                color: AppColors.primary,
                onTap: () => context.push('/trips'),
              ),

              const SizedBox(height: 32),

              // Quick Links
              Text(
                context.tr('home_quick_links'),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickLink(
                      context,
                      icon: Icons.people,
                      label: context.tr('home_matches'),
                      onTap: () => context.push('/trips?tab=matches'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickLink(
                      context,
                      icon: Icons.history,
                      label: context.tr('home_past'),
                      onTap: () => context.push('/trips?tab=past'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickLink(
                      context,
                      icon: Icons.payments_outlined,
                      label: context.tr('home_payments'),
                      onTap: () => context.push('/payments'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickLink(
                      context,
                      icon: Icons.support_agent_outlined,
                      label: context.tr('home_support'),
                      onTap: () => context.push('/support'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              context.push('/trips');
              break;
            case 2:
              context.push('/chat');
              break;
            case 3:
              context.push('/profile');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: context.tr('home_nav_home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.route_outlined),
            label: context.tr('home_nav_trips'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.message),
            label: context.tr('home_nav_chat'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: context.tr('home_nav_profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularPlannerAction(BuildContext context) {
    return Center(
      child: Semantics(
        button: true,
        label: 'Plan a trip with GPT-5.6',
        child: Material(
          elevation: 10,
          shadowColor: Colors.deepPurple.withValues(alpha: 0.45),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            width: 156,
            height: 156,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepPurple, Colors.indigo.shade600],
              ),
            ),
            child: InkWell(
              key: const ValueKey('home-copilot-action'),
              customBorder: const CircleBorder(),
              onTap: () => context.push('/copilot'),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 36,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          context.tr('home_plan_ai'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleCreateTrip(
    BuildContext context,
    AsyncValue<UserVerification?> verificationAsync,
    MarketplacePath marketplacePath,
  ) {
    verificationAsync.when(
      data: (verification) {
        final ready = marketplacePath.isDriver
            ? driverTripVerificationComplete(verification)
            : participantTripVerificationComplete(verification);
        if (ready) {
          context.push('/trips/create?role=${marketplacePath.routeRole}');
          return;
        }
        _showVerificationGate(context, verification, marketplacePath);
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Checking verification. Please wait.')),
        );
      },
      error: (_, _) => _showVerificationGate(context, null, marketplacePath),
    );
  }

  void _showVerificationGate(
    BuildContext context,
    UserVerification? verification,
    MarketplacePath marketplacePath,
  ) {
    final driver = marketplacePath.isDriver;
    final missing = missingTripVerificationItems(verification, driver: driver);
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.verified_user_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    driver
                        ? 'Driver verification required'
                        : 'Trip verification required',
                    style: Theme.of(sheetContext).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                driver
                    ? 'Before publishing offers, drivers must verify email and phone, then complete manual ID, selfie, driver licence, and vehicle review.'
                    : 'Before publishing a ride or delivery request, riders and senders must verify email and phone, then complete manual ID and selfie review.',
                style: Theme.of(sheetContext).textTheme.bodyMedium,
              ),
              if (missing.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Still needed: ${missing.join(', ')}.'),
              ],
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  context.push(
                    '/verification?role=${driver ? 'driver' : 'rider'}',
                  );
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Complete verification'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryActionCard(
    BuildContext context, {
    Key? key,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      key: key,
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLink(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

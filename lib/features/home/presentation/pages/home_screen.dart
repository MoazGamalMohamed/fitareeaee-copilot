import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/user_path.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../verification/domain/models/verification_model.dart';
import '../../../verification/domain/verification_requirements.dart';
import '../../../verification/presentation/providers/verification_provider.dart';

/// Home screen showing only two primary options:
/// - Find a ride (Rider flow)
/// - Offer a ride (Driver flow)
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
    final marketplacePath = marketplacePathForRoles(user?.roles ?? const []);

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
              // Welcome Section
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
                      'Welcome to Fitareeaee!',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your trusted marketplace for rides and deliveries',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Card(
                color: marketplacePath.isDriver
                    ? Colors.green.shade50
                    : Colors.blue.shade50,
                child: ListTile(
                  leading: Icon(
                    marketplacePath.isDriver
                        ? Icons.drive_eta_outlined
                        : Icons.person_search_outlined,
                    color: marketplacePath.isDriver
                        ? Colors.green.shade700
                        : Colors.blue.shade700,
                  ),
                  title: Text('${marketplacePath.title} account'),
                  subtitle: Text(marketplacePath.accountGuidance),
                ),
              ),

              const SizedBox(height: 28),

              _buildCircularCopilotAction(context, marketplacePath),

              const SizedBox(height: 32),

              // Explicit browse and creation paths.
              Text(
                marketplacePath.isDriver
                    ? 'Find requests that fit your route'
                    : 'Find a trip that fits your needs',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Find a Ride - PRIMARY BUTTON
              _buildPrimaryActionCard(
                context,
                icon: Icons.search,
                title: marketplacePath.isDriver
                    ? 'Browse Ride & Delivery Requests'
                    : 'Browse Available Trips',
                subtitle: marketplacePath.isDriver
                    ? 'See rider and sender requests you can fulfill'
                    : 'Find live ride offers and package delivery',
                color: marketplacePath.isDriver ? Colors.green : Colors.blue,
                onTap: () {
                  context.push('/trips?role=${marketplacePath.routeRole}');
                },
              ),

              const SizedBox(height: 40),

              // Quick Links
              Text(
                'Quick Links',
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
                      label: 'Matches',
                      onTap: () => context.push(
                        '/trips?tab=matches&role=${marketplacePath.routeRole}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickLink(
                      context,
                      icon: Icons.history,
                      label: 'Past Trips',
                      onTap: () => context.push(
                        '/trips?tab=past&role=${marketplacePath.routeRole}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickLink(
                      context,
                      icon: Icons.payments_outlined,
                      label: 'Payments',
                      onTap: () => context.push('/payments'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickLink(
                      context,
                      icon: Icons.support_agent_outlined,
                      label: 'Support',
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
              _handleCreateTrip(context, verificationAsync, marketplacePath);
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
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(
              marketplacePath.isDriver ? Icons.add_road : Icons.person_search,
            ),
            label: marketplacePath.creationLabel,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCircularCopilotAction(
    BuildContext context,
    MarketplacePath marketplacePath,
  ) {
    final action = marketplacePath.isDriver ? 'offer' : 'request';
    return Center(
      child: Semantics(
        button: true,
        label: 'Plan a trip $action with GPT-5.6',
        child: Material(
          elevation: 10,
          shadowColor: Colors.deepPurple.withValues(alpha: 0.45),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            width: 176,
            height: 176,
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
              onTap: () =>
                  context.push('/copilot?role=${marketplacePath.routeRole}'),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 42,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Plan with\nGPT-5.6',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      marketplacePath.isDriver
                          ? 'Create an offer'
                          : 'Create a request',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
          const SnackBar(
            content: Text('Checking driver verification. Please wait.'),
          ),
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
                  context.push('/verification');
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
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
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

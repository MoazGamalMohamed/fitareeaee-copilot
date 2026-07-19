import 'package:flutter/material.dart';
import 'package:fitareeaee/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:fitareeaee/features/auth/presentation/pages/login_screen.dart';
import 'package:fitareeaee/features/auth/presentation/pages/signup_screen.dart';
import 'package:fitareeaee/features/auth/presentation/providers/auth_provider.dart';
import 'package:fitareeaee/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:fitareeaee/features/chat/presentation/pages/chat_screen.dart';
import 'package:fitareeaee/features/home/presentation/pages/home_screen.dart';
import 'package:fitareeaee/features/profile/presentation/pages/profile_screen.dart';
import 'package:fitareeaee/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:fitareeaee/features/settings/presentation/pages/settings_screen.dart';
import 'package:fitareeaee/features/trips/presentation/pages/booking_confirmation_screen.dart';
import 'package:fitareeaee/features/trips/presentation/pages/create_trip_screen.dart';
import 'package:fitareeaee/features/trips/presentation/pages/trip_details_screen.dart';
import 'package:fitareeaee/features/trips/presentation/pages/trips_list_screen.dart';
import 'package:fitareeaee/features/verification/presentation/pages/verification_screen.dart';
import 'package:fitareeaee/features/admin/presentation/pages/admin_verifications_screen.dart';
import 'package:fitareeaee/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:fitareeaee/features/payments/presentation/pages/payments_screen.dart';
import 'package:fitareeaee/features/copilot/domain/copilot_draft.dart';
import 'package:fitareeaee/features/copilot/presentation/pages/copilot_results_screen.dart';
import 'package:fitareeaee/features/copilot/presentation/pages/copilot_screen.dart';
import 'package:fitareeaee/features/support/presentation/pages/help_center_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const home = '/home';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const trips = '/trips';
  static const createTrip = '/trips/create';
  static const tripDetails = '/trips/:id';
  static const chat = '/chat';
  static const chatConversation = '/chat/:userId';
  static const settings = '/settings';
  static const verification = '/verification';
  static const notifications = '/notifications';
  static const payments = '/payments';
  static const support = '/support';
  static const copilot = '/copilot';
  static const copilotResults = '/copilot/results';
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authStateAsync = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main App Routes
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.copilot,
        name: 'copilot',
        builder: (context, state) => const CopilotScreen(),
      ),
      GoRoute(
        path: AppRoutes.copilotResults,
        name: 'copilot-results',
        builder: (context, state) {
          final draft = state.extra;
          if (draft is! CopilotDraft) {
            return const CopilotScreen();
          }
          return CopilotResultsScreen(draft: draft);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'edit-profile',
        builder: (context, state) {
          final userId = state.extra as String? ?? '';
          return EditProfileScreen(userId: userId);
        },
      ),

      // Trips Routes
      GoRoute(
        path: AppRoutes.trips,
        name: 'trips',
        builder: (context, state) {
          // Get role from query parameter (rider or driver)
          final role = state.uri.queryParameters['role'];
          final initialTab = state.uri.queryParameters['tab'];
          return TripsListScreen(role: role, initialTab: initialTab);
        },
      ),
      GoRoute(
        path: AppRoutes.createTrip,
        name: 'create-trip',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'];
          final draft = state.extra is CopilotDraft
              ? state.extra as CopilotDraft
              : null;
          return CreateTripScreen(role: role, initialDraft: draft);
        },
      ),
      GoRoute(
        path: '${AppRoutes.trips}/:id',
        name: 'trip-details',
        builder: (context, state) {
          final tripId = state.pathParameters['id'] ?? '';
          final requestedSeats = int.tryParse(
            state.uri.queryParameters['seats'] ?? '',
          );
          final bookingId = state.uri.queryParameters['bookingId'];
          return TripDetailsScreen(
            tripId: tripId,
            requestedSeats: requestedSeats,
            bookingId: bookingId,
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.trips}/:id/booking',
        name: 'booking-confirmation',
        builder: (context, state) {
          final tripId = state.pathParameters['id'] ?? '';
          if (tripId.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Trip ID not found')),
            );
          }
          final requestedSeats = int.tryParse(
            state.uri.queryParameters['seats'] ?? '',
          );
          return BookingConfirmationScreen(
            tripId: tripId,
            requestedSeats: requestedSeats,
          );
        },
      ),

      // Chat Routes
      GoRoute(
        path: AppRoutes.chat,
        name: 'chat',
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.chat}/:userId',
        name: 'chat-conversation',
        builder: (context, state) {
          final userId = state.pathParameters['userId'] ?? '';
          final conversationId =
              state.uri.queryParameters['conversationId'] ?? '';
          return ChatScreen(
            recipientId: userId,
            conversationId: conversationId,
          );
        },
      ),

      // Settings Route
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Notifications Route
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.payments,
        name: 'payments',
        builder: (context, state) => const PaymentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.support,
        name: 'support',
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.support}/ticket/:id',
        name: 'support-ticket',
        builder: (context, state) {
          final ticketId = state.pathParameters['id'] ?? '';
          return SupportTicketScreen(ticketId: ticketId);
        },
      ),

      // Driver Profile Route
      GoRoute(
        path: AppRoutes.verification,
        name: 'verification',
        builder: (context, state) => const VerificationScreen(),
      ),

      // Admin Routes
      GoRoute(
        path: '/admin/verifications',
        name: 'admin-verifications',
        builder: (context, state) => const AdminVerificationsScreen(),
      ),
    ],
    redirect: (context, state) {
      if (authStateAsync.isLoading) return null;

      final isAuthenticated = authStateAsync.when(
        data: (user) => user != null,
        loading: () => false,
        error: (_, _) => false,
      );

      final publicRoutes = [
        AppRoutes.login,
        AppRoutes.signup,
        AppRoutes.forgotPassword,
      ];

      final isPublicRoute = publicRoutes.contains(state.uri.path);

      if (isAuthenticated) {
        if (isPublicRoute) {
          return AppRoutes.home;
        }
      } else {
        if (!isPublicRoute) {
          return AppRoutes.login;
        }
      }

      return null; // Allow navigation
    },
  );
});

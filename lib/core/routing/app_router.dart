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
import 'package:fitareeaee/features/trips/presentation/pages/nearby_trips_map_screen.dart';
import 'package:fitareeaee/features/trips/presentation/pages/trip_details_screen.dart';
import 'package:fitareeaee/features/trips/presentation/pages/trips_list_screen.dart';
import 'package:fitareeaee/features/safety/presentation/pages/sos_screen.dart';
import 'package:fitareeaee/features/verification/presentation/pages/driver_profile_screen.dart';
import 'package:fitareeaee/features/admin/presentation/pages/admin_verifications_screen.dart';
import 'package:fitareeaee/features/notifications/presentation/pages/notifications_screen.dart';
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
  static const search = '/search';
  static const searchResults = '/search/results';
  static const chat = '/chat';
  static const chatConversation = '/chat/:userId';
  static const settings = '/settings';
  static const booking = '/booking';
  static const payment = '/payment';
  static const rating = '/rating';
  // New routes
  static const wallet = '/wallet';
  static const verification = '/verification';
  static const driverProfile = '/driver-profile';
  static const notifications = '/notifications';
  static const tracking = '/tracking';
  static const packagePhotos = '/package-photos';
  static const sos = '/sos';
  static const helpCenter = '/help';
  static const aiAssistant = '/ai-assistant';
  static const nearbyTripsMap = '/trips/map';
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
          return TripsListScreen(role: role);
        },
      ),
      GoRoute(
        path: AppRoutes.nearbyTripsMap,
        name: 'nearby-trips-map',
        builder: (context, state) => const NearbyTripsMapScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.trips}/create',
        name: 'create-trip',
        builder: (context, state) {
          // Get role from query parameter (driver or rider)
          final role = state.uri.queryParameters['role'];
          return CreateTripScreen(role: role);
        },
      ),
      GoRoute(
        path: '${AppRoutes.trips}/:id',
        name: 'trip-details',
        builder: (context, state) {
          final tripId = state.pathParameters['id'] ?? '';
          return TripDetailsScreen(tripId: tripId);
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
          return BookingConfirmationScreen(tripId: tripId);
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
          return ChatScreen(recipientId: userId);
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

      // Driver Profile Route
      GoRoute(
        path: AppRoutes.driverProfile,
        name: 'driver-profile',
        builder: (context, state) {
          final required = state.uri.queryParameters['required'] == 'true';
          return DriverProfileScreen(isRequired: required);
        },
      ),

      // SOS Route
      GoRoute(
        path: AppRoutes.sos,
        name: 'sos',
        builder: (context, state) {
          final tripId = state.extra as String?;
          return SOSScreen(tripId: tripId);
        },
      ),

      // Admin Routes
      GoRoute(
        path: '/admin/verifications',
        name: 'admin-verifications',
        builder: (context, state) => const AdminVerificationsScreen(),
      ),
    ],
    redirect: (context, state) {
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

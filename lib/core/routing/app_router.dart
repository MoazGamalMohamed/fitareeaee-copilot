import 'package:fitareeaee/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:fitareeaee/features/auth/presentation/pages/login_screen.dart';
import 'package:fitareeaee/features/auth/presentation/pages/signup_screen.dart';
import 'package:fitareeaee/features/auth/presentation/providers/auth_provider.dart';
import 'package:fitareeaee/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:fitareeaee/features/chat/presentation/pages/chat_screen.dart';
import 'package:fitareeaee/features/home/presentation/pages/home_screen.dart';
import 'package:fitareeaee/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:fitareeaee/features/profile/presentation/pages/profile_screen.dart';
import 'package:fitareeaee/features/search/presentation/pages/advanced_search_screen.dart';
import 'package:fitareeaee/features/search/presentation/pages/search_results_screen.dart';
import 'package:fitareeaee/features/settings/presentation/pages/settings_screen.dart';
import 'package:fitareeaee/features/booking/presentation/pages/booking_screen.dart';
import 'package:fitareeaee/features/booking/domain/models/booking_model.dart';
import 'package:fitareeaee/features/payment/presentation/pages/payment_screen.dart';
import 'package:fitareeaee/features/ratings/presentation/pages/rating_screen.dart';
import 'package:fitareeaee/features/trips/domain/entities/trip.dart';
import 'package:fitareeaee/features/trips/presentation/pages/create_trip_screen.dart';
import 'package:fitareeaee/features/trips/presentation/pages/trip_details_screen.dart';
import 'package:fitareeaee/features/trips/presentation/pages/trips_list_screen.dart';
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
        path: '${AppRoutes.profile}/edit',
        name: 'edit-profile',
        builder: (context, state) {
          final userId = state.extra as String? ?? 'current_user_id';
          return EditProfileScreen(userId: userId);
        },
      ),

      // Trips Routes
      GoRoute(
        path: AppRoutes.trips,
        name: 'trips',
        builder: (context, state) => const TripsListScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.trips}/create',
        name: 'create-trip',
        builder: (context, state) => const CreateTripScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.trips}/:id',
        name: 'trip-details',
        builder: (context, state) {
          final tripId = state.pathParameters['id'] ?? '';
          return TripDetailsScreen(tripId: tripId);
        },
      ),

      // Search Routes
      GoRoute(
        path: AppRoutes.search,
        name: 'advanced-search',
        builder: (context, state) => const AdvancedSearchScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.search}/results',
        name: 'search-results',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return SearchResultsScreen(
            origin: extra['origin'] ?? '',
            destination: extra['destination'] ?? '',
            departureDate: extra['departureDate'] ?? DateTime.now(),
            tripType: extra['tripType'] ?? 'person',
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
          return ChatScreen(recipientId: userId);
        },
      ),

      // Settings Route
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Booking Route
      GoRoute(
        path: AppRoutes.booking,
        name: 'booking',
        builder: (context, state) {
          final trip = state.extra as Trip;
          return BookingScreen(trip: trip);
        },
      ),

      // Payment Route
      GoRoute(
        path: AppRoutes.payment,
        name: 'payment',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return PaymentScreen(
            booking: data['booking'] as BookingModel,
            payeeId: data['payeeId'] as String,
          );
        },
      ),

      // Rating Route
      GoRoute(
        path: AppRoutes.rating,
        name: 'rating',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return RatingScreen(
            tripId: data['tripId'] as String,
            ratedUserId: data['ratedUserId'] as String,
            ratedUserName: data['ratedUserName'] as String,
          );
        },
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

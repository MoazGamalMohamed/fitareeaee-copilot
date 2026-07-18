import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/openrouter_service.dart';

/// Provider for OpenRouter AI service
/// Note: Set OPENROUTER_API_KEY environment variable or use --dart-define
final openRouterServiceProvider = Provider<OpenRouterService>((ref) {
  const apiKey = String.fromEnvironment('OPENROUTER_API_KEY', defaultValue: '');
  return OpenRouterService(apiKey: apiKey);
});

/// Check if AI service is available (has API key)
final isAIAvailableProvider = Provider<bool>((ref) {
  const apiKey = String.fromEnvironment('OPENROUTER_API_KEY', defaultValue: '');
  return apiKey.isNotEmpty;
});

/// Provider for generating trip description
final tripDescriptionProvider =
    FutureProvider.family<String, TripDescriptionParams>((ref, params) async {
      final service = ref.read(openRouterServiceProvider);
      return service.generateTripDescription(
        origin: params.origin,
        destination: params.destination,
        tripType: params.tripType,
        additionalNotes: params.notes,
      );
    });

/// Provider for price estimation
final priceEstimationProvider =
    FutureProvider.family<Map<String, dynamic>, PriceEstimationParams>((
      ref,
      params,
    ) async {
      final service = ref.read(openRouterServiceProvider);
      return service.estimatePrice(
        distanceKm: params.distanceKm,
        tripType: params.tripType,
        passengers: params.passengers,
        packageWeightKg: params.packageWeightKg,
      );
    });

/// Provider for FAQ answers
final faqAnswerProvider = FutureProvider.family<String, String>((
  ref,
  question,
) async {
  final service = ref.read(openRouterServiceProvider);
  return service.answerFAQ(question);
});

/// State notifier for AI chat assistant
class AIChatNotifier extends StateNotifier<List<ChatMessage>> {
  final OpenRouterService _service;
  final bool _isAvailable;

  AIChatNotifier(this._service, this._isAvailable) : super([]);

  Future<void> sendMessage(String message) async {
    // Add user message
    state = [...state, ChatMessage(role: 'user', content: message)];

    // Check if AI is available
    if (!_isAvailable) {
      state = [
        ...state,
        ChatMessage(role: 'assistant', content: _getOfflineResponse(message)),
      ];
      return;
    }

    try {
      final response = await _service.answerFAQ(message);
      state = [...state, ChatMessage(role: 'assistant', content: response)];
    } catch (e) {
      state = [
        ...state,
        ChatMessage(
          role: 'assistant',
          content:
              'Sorry, I encountered an error. Please try again later or contact support.',
        ),
      ];
    }
  }

  /// Provide basic offline responses for common questions
  String _getOfflineResponse(String question) {
    final q = question.toLowerCase();

    if (q.contains('book') || q.contains('ride')) {
      return 'To book a ride, go to the home screen and tap "Find a Ride". Enter your pickup and destination locations, select a trip, and confirm your booking.';
    } else if (q.contains('payment') || q.contains('pay')) {
      return 'We accept credit/debit cards and digital wallets. You can manage your payment methods in Settings > Payment Methods.';
    } else if (q.contains('cancel')) {
      return 'To cancel a booking, go to My Trips, select the trip, and tap "Cancel Booking". Note that cancellation fees may apply depending on timing.';
    } else if (q.contains('rating') || q.contains('review')) {
      return 'After each trip, you can rate your driver/rider from 1-5 stars. Ratings help maintain quality in our community.';
    } else if (q.contains('safety') || q.contains('emergency')) {
      return 'For emergencies, use the SOS button in the app. You can also share your trip with trusted contacts. Your safety is our priority!';
    } else if (q.contains('package') || q.contains('delivery')) {
      return 'To send a package, select "Offer a Ride" and choose "Package" as the trip type. Add package details and photos for verification.';
    } else {
      return 'I\'m currently in offline mode. For detailed assistance, please contact our support team through Help Center > Contact Support.';
    }
  }

  void clearChat() {
    state = [];
  }
}

final aiChatProvider = StateNotifierProvider<AIChatNotifier, List<ChatMessage>>(
  (ref) {
    final service = ref.read(openRouterServiceProvider);
    final isAvailable = ref.read(isAIAvailableProvider);
    return AIChatNotifier(service, isAvailable);
  },
);

// Parameter classes
class TripDescriptionParams {
  final String origin;
  final String destination;
  final String tripType;
  final String? notes;

  TripDescriptionParams({
    required this.origin,
    required this.destination,
    required this.tripType,
    this.notes,
  });
}

class PriceEstimationParams {
  final double distanceKm;
  final String tripType;
  final int? passengers;
  final double? packageWeightKg;

  PriceEstimationParams({
    required this.distanceKm,
    required this.tripType,
    this.passengers,
    this.packageWeightKg,
  });
}

class ChatMessage {
  final String role;
  final String content;
  final DateTime timestamp;

  ChatMessage({required this.role, required this.content, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

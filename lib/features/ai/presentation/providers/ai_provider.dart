import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/openrouter_service.dart';

/// Provider for OpenRouter AI service
/// Note: Replace 'YOUR_API_KEY' with actual API key from environment/config
final openRouterServiceProvider = Provider<OpenRouterService>((ref) {
  // TODO: Get API key from environment config
  const apiKey = String.fromEnvironment('OPENROUTER_API_KEY', defaultValue: '');
  return OpenRouterService(apiKey: apiKey);
});

/// Provider for generating trip description
final tripDescriptionProvider = FutureProvider.family<String, TripDescriptionParams>((ref, params) async {
  final service = ref.read(openRouterServiceProvider);
  return service.generateTripDescription(
    origin: params.origin,
    destination: params.destination,
    tripType: params.tripType,
    additionalNotes: params.notes,
  );
});

/// Provider for price estimation
final priceEstimationProvider = FutureProvider.family<Map<String, dynamic>, PriceEstimationParams>((ref, params) async {
  final service = ref.read(openRouterServiceProvider);
  return service.estimatePrice(
    distanceKm: params.distanceKm,
    tripType: params.tripType,
    passengers: params.passengers,
    packageWeightKg: params.packageWeightKg,
  );
});

/// Provider for FAQ answers
final faqAnswerProvider = FutureProvider.family<String, String>((ref, question) async {
  final service = ref.read(openRouterServiceProvider);
  return service.answerFAQ(question);
});

/// State notifier for AI chat assistant
class AIChatNotifier extends StateNotifier<List<ChatMessage>> {
  final OpenRouterService _service;

  AIChatNotifier(this._service) : super([]);

  Future<void> sendMessage(String message) async {
    // Add user message
    state = [...state, ChatMessage(role: 'user', content: message)];

    try {
      final response = await _service.answerFAQ(message);
      state = [...state, ChatMessage(role: 'assistant', content: response)];
    } catch (e) {
      state = [
        ...state,
        ChatMessage(
          role: 'assistant',
          content: 'Sorry, I encountered an error. Please try again later.',
        ),
      ];
    }
  }

  void clearChat() {
    state = [];
  }
}

final aiChatProvider = StateNotifierProvider<AIChatNotifier, List<ChatMessage>>((ref) {
  final service = ref.read(openRouterServiceProvider);
  return AIChatNotifier(service);
});

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

  ChatMessage({
    required this.role,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}


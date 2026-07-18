import 'dart:convert';
import 'package:http/http.dart' as http;

/// OpenRouter AI Service for AI-powered features
class OpenRouterService {
  static const String _baseUrl = 'https://openrouter.ai/api/v1';
  final String _apiKey;
  final String _model;

  OpenRouterService({
    required String apiKey,
    String model = 'openai/gpt-3.5-turbo',
  }) : _apiKey = apiKey,
       _model = model;

  /// Send a chat completion request
  Future<String> chatCompletion({
    required String systemPrompt,
    required String userMessage,
    double temperature = 0.7,
    int maxTokens = 500,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://fitareeaee.app',
          'X-Title': 'Fitareeaee App',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userMessage},
          ],
          'temperature': temperature,
          'max_tokens': maxTokens,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('AI request failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('AI service error: $e');
    }
  }

  /// Generate trip description
  Future<String> generateTripDescription({
    required String origin,
    required String destination,
    required String tripType,
    String? additionalNotes,
  }) async {
    const systemPrompt = '''You are a helpful assistant for a ride-sharing app.
Generate a brief, friendly trip description for a ride offer.
Keep it under 100 words and include relevant details about the route.''';

    final userMessage =
        '''
Generate a trip description for:
- From: $origin
- To: $destination
- Type: $tripType (ride or package delivery)
${additionalNotes != null ? '- Notes: $additionalNotes' : ''}
''';

    return chatCompletion(
      systemPrompt: systemPrompt,
      userMessage: userMessage,
      temperature: 0.7,
    );
  }

  /// Estimate fair price for trip
  Future<Map<String, dynamic>> estimatePrice({
    required double distanceKm,
    required String tripType,
    int? passengers,
    double? packageWeightKg,
  }) async {
    const systemPrompt = '''You are a pricing assistant for a ride-sharing app.
Based on the trip details, suggest a fair price range.
Return JSON with format: {"minPrice": number, "maxPrice": number, "suggestedPrice": number, "currency": "USD"}''';

    final userMessage =
        '''
Estimate price for:
- Distance: $distanceKm km
- Type: $tripType
${passengers != null ? '- Passengers: $passengers' : ''}
${packageWeightKg != null ? '- Package weight: $packageWeightKg kg' : ''}

Consider average market rates for ride-sharing services.
Return ONLY valid JSON.''';

    final response = await chatCompletion(
      systemPrompt: systemPrompt,
      userMessage: userMessage,
      temperature: 0.3,
    );

    try {
      // Extract JSON from response
      final jsonMatch = RegExp(r'\{[^}]+\}').firstMatch(response);
      if (jsonMatch != null) {
        return jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
      }
      // Fallback to default pricing
      return _calculateDefaultPrice(distanceKm, tripType);
    } catch (e) {
      return _calculateDefaultPrice(distanceKm, tripType);
    }
  }

  Map<String, dynamic> _calculateDefaultPrice(
    double distanceKm,
    String tripType,
  ) {
    final basePrice = tripType == 'package' ? 5.0 : 3.0;
    final pricePerKm = tripType == 'package' ? 0.8 : 0.5;
    final calculated = basePrice + (distanceKm * pricePerKm);
    return {
      'minPrice': (calculated * 0.8).roundToDouble(),
      'maxPrice': (calculated * 1.2).roundToDouble(),
      'suggestedPrice': calculated.roundToDouble(),
      'currency': 'USD',
    };
  }

  /// FAQ Assistant - Answer common questions
  Future<String> answerFAQ(String question) async {
    const systemPrompt =
        '''You are a customer support assistant for Fitareeaee, a ride-sharing and package delivery app.
Answer user questions helpfully and concisely. If you don't know the answer, suggest contacting support.
Keep responses under 150 words.''';

    return chatCompletion(
      systemPrompt: systemPrompt,
      userMessage: question,
      temperature: 0.5,
    );
  }

  /// Summarize dispute for admin
  Future<String> summarizeDispute({
    required String tripDetails,
    required List<String> chatMessages,
    required String complainantReport,
  }) async {
    const systemPrompt = '''You are an assistant helping admins review disputes.
Summarize the situation objectively, highlighting key points and potential resolutions.''';

    final userMessage =
        '''
Trip Details: $tripDetails

Chat History:
${chatMessages.join('\n')}

Complainant's Report: $complainantReport

Please summarize this dispute and suggest possible resolutions.''';

    return chatCompletion(
      systemPrompt: systemPrompt,
      userMessage: userMessage,
      temperature: 0.3,
      maxTokens: 800,
    );
  }
}

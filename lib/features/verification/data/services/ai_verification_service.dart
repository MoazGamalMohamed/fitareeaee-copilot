import 'dart:convert';
import 'package:http/http.dart' as http;

/// AI-powered verification service for ID documents and face matching
class AIVerificationService {
  static const String _openRouterApiUrl =
      'https://openrouter.ai/api/v1/chat/completions';
  static const String _apiKey =
      'YOUR_OPENROUTER_API_KEY'; // TODO: Move to environment variable

  /// Verify selfie with ID using AI vision model
  /// Returns detailed verification results including confidence scores
  Future<IDVerificationResult> verifySelfieWithID({
    required String selfieImageUrl,
    required String idDocumentUrl,
  }) async {
    try {
      // Prepare the AI prompt
      final prompt = _buildVerificationPrompt();

      // Call OpenRouter with vision model
      final response = await http.post(
        Uri.parse(_openRouterApiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://fitareeaee.app',
          'X-Title': 'Fitareeaee ID Verification',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'openai/gpt-4-vision-preview', // Use vision-capable model
          'messages': [
            {
              'role': 'user',
              'content': [
                {'type': 'text', 'text': prompt},
                {
                  'type': 'image_url',
                  'image_url': {'url': selfieImageUrl},
                },
                {
                  'type': 'image_url',
                  'image_url': {'url': idDocumentUrl},
                },
              ],
            },
          ],
          'temperature': 0.1, // Low temperature for consistent results
          'max_tokens': 500,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('AI service error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final aiResponse = data['choices'][0]['message']['content'] as String;

      // Parse AI response
      return _parseAIResponse(aiResponse);
    } catch (e) {
      return IDVerificationResult(
        success: false,
        overallConfidence: 0.0,
        faceMatchConfidence: 0.0,
        idValidityConfidence: 0.0,
        message: 'Verification failed: $e',
        issues: ['System error during verification'],
      );
    }
  }

  /// Verify ID document authenticity only
  Future<DocumentValidationResult> validateIDDocument(
    String idDocumentUrl,
  ) async {
    try {
      final prompt = _buildDocumentValidationPrompt();

      final response = await http.post(
        Uri.parse(_openRouterApiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://fitareeaee.app',
          'X-Title': 'Fitareeaee Document Validation',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'openai/gpt-4-vision-preview',
          'messages': [
            {
              'role': 'user',
              'content': [
                {'type': 'text', 'text': prompt},
                {
                  'type': 'image_url',
                  'image_url': {'url': idDocumentUrl},
                },
              ],
            },
          ],
          'temperature': 0.1,
          'max_tokens': 400,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('AI service error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final aiResponse = data['choices'][0]['message']['content'] as String;

      return _parseDocumentValidationResponse(aiResponse);
    } catch (e) {
      return DocumentValidationResult(
        isValid: false,
        confidence: 0.0,
        message: 'Document validation failed: $e',
        issues: ['System error'],
      );
    }
  }

  String _buildVerificationPrompt() {
    return '''Analyze these two images for identity verification:
1. First image: Selfie of a person holding an ID document
2. Second image: The ID document itself

Perform the following checks and provide a JSON response:

CHECKS:
1. Face Matching (0-100): Compare the face in the selfie with the face on the ID
2. ID Authenticity (0-100): Check if the ID appears genuine (security features, text clarity, holograms, formatting)
3. Photo Quality (0-100): Assess if both images are clear enough for verification
4. ID Visibility (0-100): Check if the ID in the selfie is clearly visible and readable
5. Liveness Detection (0-100): Check if the selfie appears to be of a live person (not a photo of a photo)

SPECIFIC THINGS TO CHECK:
- Does the face structure match (eyes, nose, mouth, face shape)?
- Are there signs of tampering or digital manipulation?
- Are the security features visible (holograms, watermarks, microprinting)?
- Is the ID format consistent with official documents?
- Is the text on the ID legible and properly aligned?
- Are there any signs this is a fake/printed ID?

Return ONLY valid JSON in this exact format:
{
  "faceMatch": 85,
  "idAuthenticity": 90,
  "photoQuality": 95,
  "idVisibility": 88,
  "liveness": 92,
  "overallScore": 90,
  "verified": true,
  "issues": [],
  "reasoning": "Brief explanation of the assessment"
}

If there are any concerns, include them in the "issues" array and set "verified" to false.''';
  }

  String _buildDocumentValidationPrompt() {
    return '''Analyze this ID document image and verify its authenticity.

Check for:
1. Security Features: Holograms, watermarks, microprinting, UV elements
2. Text Quality: Sharp, properly aligned, consistent fonts
3. Photo Quality: Clear, not pixelated, proper ID photo format
4. Document Structure: Correct layout for official ID documents
5. Signs of Tampering: Alterations, inconsistent textures, misalignments
6. Digital Manipulation: Cloning, pasting, color inconsistencies

Return ONLY valid JSON in this format:
{
  "authentic": true,
  "confidence": 85,
  "documentType": "National ID / Passport / Driver License",
  "securityFeatures": ["hologram visible", "text sharp"],
  "concerns": [],
  "reasoning": "Brief explanation"
}

Set "authentic" to false and list concerns if you detect any issues.''';
  }

  IDVerificationResult _parseAIResponse(String response) {
    try {
      // Extract JSON from response (AI might include explanation text)
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(response);
      if (jsonMatch == null) {
        throw Exception('No JSON found in AI response');
      }

      final jsonStr = jsonMatch.group(0)!;
      final Map<String, dynamic> data = jsonDecode(jsonStr);

      final verified = data['verified'] == true;
      final overallScore = (data['overallScore'] ?? 0).toDouble();
      final faceMatch = (data['faceMatch'] ?? 0).toDouble();
      final idAuthenticity = (data['idAuthenticity'] ?? 0).toDouble();
      final issues = List<String>.from(data['issues'] ?? []);

      String message;
      if (verified && overallScore >= 80) {
        message =
            'Identity verified successfully! Face matches the ID document.';
      } else if (verified && overallScore >= 60) {
        message =
            'Identity verified with moderate confidence. Manual review recommended.';
      } else {
        message = issues.isNotEmpty
            ? 'Verification failed: ${issues.join(", ")}'
            : 'Verification failed. Please ensure good lighting and clear photos.';
      }

      return IDVerificationResult(
        success: verified,
        overallConfidence: overallScore / 100,
        faceMatchConfidence: faceMatch / 100,
        idValidityConfidence: idAuthenticity / 100,
        message: message,
        issues: issues,
        reasoning: data['reasoning'] as String?,
      );
    } catch (e) {
      return IDVerificationResult(
        success: false,
        overallConfidence: 0.0,
        faceMatchConfidence: 0.0,
        idValidityConfidence: 0.0,
        message: 'Failed to parse verification results',
        issues: ['Parse error: $e'],
      );
    }
  }

  DocumentValidationResult _parseDocumentValidationResponse(String response) {
    try {
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(response);
      if (jsonMatch == null) {
        throw Exception('No JSON found in AI response');
      }

      final jsonStr = jsonMatch.group(0)!;
      final Map<String, dynamic> data = jsonDecode(jsonStr);

      final authentic = data['authentic'] == true;
      final confidence = (data['confidence'] ?? 0).toDouble();
      final concerns = List<String>.from(data['concerns'] ?? []);

      String message;
      if (authentic && confidence >= 80) {
        message = 'ID document appears authentic';
      } else if (authentic && confidence >= 60) {
        message = 'ID document validation passed with moderate confidence';
      } else {
        message = concerns.isNotEmpty
            ? 'Document validation failed: ${concerns.join(", ")}'
            : 'Document validation failed';
      }

      return DocumentValidationResult(
        isValid: authentic,
        confidence: confidence / 100,
        documentType: data['documentType'] as String?,
        securityFeatures: List<String>.from(data['securityFeatures'] ?? []),
        message: message,
        issues: concerns,
        reasoning: data['reasoning'] as String?,
      );
    } catch (e) {
      return DocumentValidationResult(
        isValid: false,
        confidence: 0.0,
        message: 'Failed to parse document validation results',
        issues: ['Parse error: $e'],
      );
    }
  }
}

/// Result of ID verification with face matching
class IDVerificationResult {
  final bool success;
  final double overallConfidence; // 0.0 to 1.0
  final double faceMatchConfidence; // 0.0 to 1.0
  final double idValidityConfidence; // 0.0 to 1.0
  final String message;
  final List<String> issues;
  final String? reasoning;

  IDVerificationResult({
    required this.success,
    required this.overallConfidence,
    required this.faceMatchConfidence,
    required this.idValidityConfidence,
    required this.message,
    required this.issues,
    this.reasoning,
  });

  bool get shouldAutoApprove => success && overallConfidence >= 0.80;
  bool get requiresManualReview =>
      success && overallConfidence >= 0.60 && overallConfidence < 0.80;
  bool get shouldReject => !success || overallConfidence < 0.60;
}

/// Result of document validation
class DocumentValidationResult {
  final bool isValid;
  final double confidence; // 0.0 to 1.0
  final String? documentType;
  final List<String> securityFeatures;
  final String message;
  final List<String> issues;
  final String? reasoning;

  DocumentValidationResult({
    required this.isValid,
    required this.confidence,
    this.documentType,
    this.securityFeatures = const [],
    required this.message,
    required this.issues,
    this.reasoning,
  });

  bool get shouldAutoApprove => isValid && confidence >= 0.80;
  bool get requiresManualReview =>
      isValid && confidence >= 0.60 && confidence < 0.80;
  bool get shouldReject => !isValid || confidence < 0.60;
}

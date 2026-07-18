import 'package:cloud_functions/cloud_functions.dart';

import '../domain/copilot_draft.dart';

class CopilotRepository {
  final FirebaseFunctions _functions;

  CopilotRepository({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instance;

  Future<CopilotPlanResult> plan(String request) async {
    final locale = RegExp(r'[\u0600-\u06FF]').hasMatch(request) ? 'ar' : 'en';
    try {
      final response = await _functions
          .httpsCallable('planTripWithCopilot')
          .call({
            'schemaVersion': 1,
            'request': request,
            'locale': locale,
            'timezone': DateTime.now().timeZoneName,
          });
      final data = Map<String, dynamic>.from(response.data as Map);
      final draft = Map<String, dynamic>.from(data['draft'] as Map);
      return CopilotPlanResult(
        draft: CopilotDraft.fromMap(draft),
        model: data['model'] as String? ?? 'gpt-5.6',
        piiRedacted: data['piiRedacted'] as bool? ?? false,
      );
    } on FirebaseFunctionsException catch (error) {
      throw CopilotException(
        error.message ?? 'AI planning is unavailable. Try manual search.',
      );
    } catch (_) {
      throw const CopilotException(
        'AI planning is unavailable. Retry or use manual search.',
      );
    }
  }
}

class CopilotException implements Exception {
  final String message;
  const CopilotException(this.message);

  @override
  String toString() => message;
}

class CopilotDraft {
  final int schemaVersion;
  final String intent;
  final String tripType;
  final String? origin;
  final String? destination;
  final String? departureDate;
  final String? departureTime;
  final int? passengerOrSeatCount;
  final String? packageDetails;
  final double? maximumBudget;
  final List<String> preferences;
  final String assistantSummary;
  final List<String> missingInformation;
  final String? clarificationQuestion;
  final String language;

  const CopilotDraft({
    required this.schemaVersion,
    required this.intent,
    required this.tripType,
    required this.origin,
    required this.destination,
    required this.departureDate,
    required this.departureTime,
    required this.passengerOrSeatCount,
    required this.packageDetails,
    required this.maximumBudget,
    required this.preferences,
    required this.assistantSummary,
    required this.missingInformation,
    required this.clarificationQuestion,
    required this.language,
  });

  factory CopilotDraft.fromMap(Map<String, dynamic> map) {
    return CopilotDraft(
      schemaVersion: map['schemaVersion'] as int? ?? 1,
      intent: map['intent'] as String,
      tripType: map['tripType'] as String,
      origin: map['origin'] as String?,
      destination: map['destination'] as String?,
      departureDate: map['departureDate'] as String?,
      departureTime: map['departureTime'] as String?,
      passengerOrSeatCount: (map['passengerOrSeatCount'] as num?)?.toInt(),
      packageDetails: map['packageDetails'] as String?,
      maximumBudget: (map['maximumBudget'] as num?)?.toDouble(),
      preferences: List<String>.from(map['preferences'] as List? ?? const []),
      assistantSummary: map['assistantSummary'] as String? ?? '',
      missingInformation: List<String>.from(
        map['missingInformation'] as List? ?? const [],
      ),
      clarificationQuestion: map['clarificationQuestion'] as String?,
      language: map['language'] as String? ?? 'en',
    );
  }

  bool get isReadyForMatching {
    return (origin?.trim().isNotEmpty ?? false) &&
        (destination?.trim().isNotEmpty ?? false) &&
        (departureDate?.trim().isNotEmpty ?? false);
  }

  CopilotDraft copyWith({
    String? intent,
    String? tripType,
    String? origin,
    String? destination,
    String? departureDate,
    String? departureTime,
    int? passengerOrSeatCount,
    String? packageDetails,
    double? maximumBudget,
    List<String>? preferences,
  }) {
    return CopilotDraft(
      schemaVersion: schemaVersion,
      intent: intent ?? this.intent,
      tripType: tripType ?? this.tripType,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departureDate: departureDate ?? this.departureDate,
      departureTime: departureTime ?? this.departureTime,
      passengerOrSeatCount: passengerOrSeatCount ?? this.passengerOrSeatCount,
      packageDetails: packageDetails ?? this.packageDetails,
      maximumBudget: maximumBudget ?? this.maximumBudget,
      preferences: preferences ?? this.preferences,
      assistantSummary: assistantSummary,
      missingInformation: missingInformation,
      clarificationQuestion: clarificationQuestion,
      language: language,
    );
  }
}

class CopilotPlanResult {
  final CopilotDraft draft;
  final String model;
  final bool piiRedacted;

  const CopilotPlanResult({
    required this.draft,
    required this.model,
    required this.piiRedacted,
  });
}

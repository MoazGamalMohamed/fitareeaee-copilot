import 'package:fitareeaee/features/trips/domain/entities/trip.dart';

/// Represents a matched trip with matching score and details
/// Minimal MatchResult stub (no codegen)
class MatchResult {
  final Trip trip;
  final double matchScore;
  final List<String> matchReasons;
  final double distance;

  MatchResult({
    required this.trip,
    this.matchScore = 0.0,
    this.matchReasons = const [],
    this.distance = 0.0,
  });

  String get matchQuality {
    if (matchScore >= 90) return 'Perfect Match';
    if (matchScore >= 75) return 'Great Match';
    if (matchScore >= 60) return 'Good Match';
    if (matchScore >= 45) return 'Fair Match';
    return 'Poor Match';
  }

  String get matchColor {
    if (matchScore >= 90) return '#4CAF50';
    if (matchScore >= 75) return '#8BC34A';
    if (matchScore >= 60) return '#FFC107';
    if (matchScore >= 45) return '#FF9800';
    return '#F44336';
  }
}

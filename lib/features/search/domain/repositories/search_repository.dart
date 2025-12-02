import '../../domain/entities/search_criteria.dart';
import '../../domain/entities/match_result.dart';
import '../../../trips/domain/entities/trip.dart';

/// Search repository interface for trip matching and search
abstract class SearchRepository {
  /// Search and match trips based on criteria
  /// Returns list of MatchResult sorted by match score
  Future<List<MatchResult>> searchAndMatchTrips(SearchCriteria criteria);

  /// Calculate distance between two locations (simple calculation)
  /// In production, use Google Maps Distance Matrix API
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  );

  /// Calculate match score between trip and search criteria
  double calculateMatchScore(Trip trip, SearchCriteria criteria);
}

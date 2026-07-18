import 'dart:math' as math;
import 'package:fitareeaee/features/search/domain/repositories/search_repository.dart';
import '../../domain/entities/search_criteria.dart';
import '../../domain/entities/match_result.dart';
import '../../../trips/domain/entities/trip.dart';

/// Implementation of search repository with matching algorithm
class SearchRepositoryImpl implements SearchRepository {
  /// Haversine formula to calculate distance between two coordinates
  /// Returns distance in kilometers
  @override
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  /// Convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  /// Calculate match score between trip and search criteria (0-100)
  @override
  double calculateMatchScore(Trip trip, SearchCriteria criteria) {
    double score = 0.0;
    final maxScore = 100.0;

    // Trip must be pending and available (50 points)
    if (trip.status == 'pending' && trip.availableSeats > 0) {
      score += 50;
    } else {
      return 0; // Not available, no match
    }

    // Trip type match (10 points)
    if (trip.type == criteria.tripType) {
      score += 10;
    }

    // Price check (15 points) - trip price must be <= max price
    if (criteria.maxPrice <= 0 || trip.pricePerSeat <= criteria.maxPrice) {
      score += 15;
    }

    // Amenities match (15 points)
    if (criteria.amenities.isNotEmpty && trip.amenities.isNotEmpty) {
      final matchedAmenities = trip.amenities
          .where((amenity) => criteria.amenities.contains(amenity))
          .length;
      final amenityScore = (matchedAmenities / criteria.amenities.length) * 15;
      score += amenityScore;
    } else if (criteria.amenities.isEmpty) {
      score += 15; // No amenity requirements
    }

    // Pet and smoking preferences (5 points each)
    if (criteria.allowPets && trip.allowPets) {
      score += 5;
    }
    if (criteria.allowSmoking && trip.allowSmoking) {
      score += 5;
    }

    // Driver rating match (5 points)
    if (criteria.minRating <= 0 ||
        (trip.metadata['driverRating'] ?? 0.0) >= criteria.minRating) {
      score += 5;
    }

    return score.clamp(0, maxScore);
  }

  /// Search and match trips based on criteria
  /// This would typically call Firestore, but for now uses provided trips
  @override
  Future<List<MatchResult>> searchAndMatchTrips(SearchCriteria criteria) async {
    try {
      // In a real implementation, fetch from Firestore
      // For now, return empty list - will be populated by provider
      return [];
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  /// Filter and score trips based on location and criteria
  /// Returns sorted list of match results (best matches first)
  List<MatchResult> filterAndScoreTrips(
    List<Trip> allTrips,
    SearchCriteria criteria,
  ) {
    final results = <MatchResult>[];

    for (final trip in allTrips) {
      // Calculate match score
      final matchScore = calculateMatchScore(trip, criteria);

      if (matchScore > 0) {
        // Calculate distance between trip origin and search origin
        final distance = calculateDistance(
          criteria.originLat ?? 0.0,
          criteria.originLng ?? 0.0,
          trip.originLat,
          trip.originLng,
        );

        // Build match reasons
        final matchReasons = <String>[];
        if (trip.type == criteria.tripType) {
          matchReasons.add('Matching trip type');
        }
        if (trip.pricePerSeat <= criteria.maxPrice || criteria.maxPrice <= 0) {
          matchReasons.add('Within budget');
        }
        if (trip.allowPets && criteria.allowPets) {
          matchReasons.add('Pets allowed');
        }
        if (trip.allowSmoking && criteria.allowSmoking) {
          matchReasons.add('Smoking allowed');
        }
        if (trip.amenities.isNotEmpty) {
          matchReasons.add('${trip.amenities.length} amenities');
        }

        results.add(
          MatchResult(
            trip: trip,
            matchScore: matchScore,
            matchReasons: matchReasons,
            distance: distance,
          ),
        );
      }
    }

    // Sort by match score (highest first)
    results.sort((a, b) => b.matchScore.compareTo(a.matchScore));

    return results;
  }
}

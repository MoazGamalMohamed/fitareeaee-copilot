import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitareeaee/features/trips/presentation/providers/trip_provider.dart';
import 'package:fitareeaee/features/search/data/repositories/search_repository_impl.dart';
import 'package:fitareeaee/features/search/domain/repositories/search_repository.dart';
import '../../domain/entities/search_criteria.dart';
import '../../domain/entities/match_result.dart';

/// Search repository provider
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl();
});

/// State for search results
class SearchState {
  final List<MatchResult> results;
  final SearchCriteria? criteria;
  final bool isLoading;
  final String? error;

  SearchState({
    this.results = const [],
    this.criteria,
    this.isLoading = false,
    this.error,
  });

  SearchState copyWith({
    List<MatchResult>? results,
    SearchCriteria? criteria,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      results: results ?? this.results,
      criteria: criteria ?? this.criteria,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// State notifier for search operations
class SearchNotifier extends StateNotifier<SearchState> {
  final SearchRepository searchRepository;
  final dynamic tripRepository; // Use dynamic to avoid type mismatch

  SearchNotifier({
    required this.searchRepository,
    required this.tripRepository,
  }) : super(SearchState());

  /// Perform search and matching
  Future<void> searchTrips(SearchCriteria criteria) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Fetch all available trips
      final allTrips = await tripRepository.getAllTrips();

      // Filter, score, and sort
      final matchResults = (searchRepository as SearchRepositoryImpl).filterAndScoreTrips(allTrips, criteria);

      state = state.copyWith(
        results: matchResults,
        criteria: criteria,
        isLoading: false,
      );
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        error: 'Search failed: ${e.toString()}',
      );
      debugPrint('Search error: $e\n$st');
    }
  }

  /// Clear search results
  void clearSearch() {
    state = SearchState();
  }

  /// Sort results by criteria
  void sortResults(String sortBy) {
    final sorted = List<MatchResult>.from(state.results);

    switch (sortBy) {
      case 'match_score':
        sorted.sort((a, b) => b.matchScore.compareTo(a.matchScore));
        break;
      case 'price':
        sorted.sort((a, b) => a.trip.pricePerSeat.compareTo(b.trip.pricePerSeat));
        break;
      case 'distance':
        sorted.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case 'departure_time':
        sorted.sort((a, b) => a.trip.departureTime.compareTo(b.trip.departureTime));
        break;
    }

    state = state.copyWith(results: sorted);
  }

  /// Filter results by match score
  void filterByMatchScore(double minScore) {
    final filtered = state.results
        .where((result) => result.matchScore >= minScore)
        .toList();

    state = state.copyWith(results: filtered);
  }

  /// Filter results by price
  void filterByPrice(double maxPrice) {
    final filtered = state.results
        .where((result) => result.trip.pricePerSeat <= maxPrice)
        .toList();

    state = state.copyWith(results: filtered);
  }

  /// Filter results by distance
  void filterByDistance(double maxDistance) {
    final filtered = state.results
        .where((result) => result.distance <= maxDistance)
        .toList();

    state = state.copyWith(results: filtered);
  }
}

/// Search provider
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final searchRepository = ref.watch(searchRepositoryProvider);
  final tripRepository = ref.watch(tripRepositoryProvider);

  return SearchNotifier(
    searchRepository: searchRepository,
    tripRepository: tripRepository,
  );
});

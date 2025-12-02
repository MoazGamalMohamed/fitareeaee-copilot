import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/search_provider.dart';
import '../../../../core/theme/app_colors.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final String origin;
  final String destination;
  final DateTime departureDate;
  final String tripType;
  final double? maxPrice;
  final List<String>? amenities;
  final double? minRating;
  final bool? allowPets;
  final bool? allowSmoking;

  const SearchResultsScreen({
    Key? key,
    required this.origin,
    required this.destination,
    required this.departureDate,
    required this.tripType,
    this.maxPrice,
    this.amenities,
    this.minRating,
    this.allowPets,
    this.allowSmoking,
  }) : super(key: key);

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  String _sortBy = 'match_score';
  double _minMatchScore = 0;
  bool _showAdvancedFilters = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performSearch();
    });
  }

  void _performSearch() {
    // TODO: Implement actual search with criteria
    // For now, just trigger the search provider
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _sortBy = value);
              ref.read(searchProvider.notifier).sortResults(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'match_score',
                child: Text('Sort by Match'),
              ),
              const PopupMenuItem(
                value: 'price',
                child: Text('Sort by Price'),
              ),
              const PopupMenuItem(
                value: 'distance',
                child: Text('Sort by Distance'),
              ),
              const PopupMenuItem(
                value: 'departure_time',
                child: Text('Sort by Departure'),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(Icons.sort),
            ),
          ),
        ],
      ),
      body: searchState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : searchState.error != null
              ? _buildErrorState(searchState.error!)
              : searchState.results.isEmpty
                  ? _buildEmptyState()
                  : _buildResultsList(searchState, context),
      bottomSheet: _showAdvancedFilters ? _buildFilterSheet(context) : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _showAdvancedFilters = !_showAdvancedFilters);
        },
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _performSearch,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No matching trips found',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Modify Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(SearchState state, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Search summary
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${state.results.length} trips found',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Sorted by ${_sortBy.replaceAll('_', ' ')}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Results
        ...state.results.asMap().entries.map((entry) {
          final index = entry.key;
          final matchResult = entry.value;

          return _buildMatchCard(context, matchResult, index);
        }),
      ],
    );
  }

  Widget _buildMatchCard(BuildContext context, dynamic matchResult, int index) {
    final trip = matchResult.trip;
    final matchScore = matchResult.matchScore;
    final matchReasons = matchResult.matchReasons;

    return GestureDetector(
      onTap: () => context.push('/trips/${trip.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            // Match Score Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getMatchColor(matchScore),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMatchLabel(matchScore),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${matchScore.toStringAsFixed(0)}% match',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          widthFactor: matchScore / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trip.priceDisplay,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Trip Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.originAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '→ ${trip.destinationAddress}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Trip Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildDetailChip(
                          context,
                          Icons.schedule,
                          trip.timeDisplay,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDetailChip(
                          context,
                          Icons.people,
                          '${trip.availableSeats}/${trip.totalSeats}',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDetailChip(
                          context,
                          Icons.directions,
                          '${matchResult.distance.toStringAsFixed(1)}km',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Match Reasons
                  if (matchReasons.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: matchReasons
                          .map((reason) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  reason,
                                  style:
                                      Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: Colors.grey[700],
                                      ),
                                ),
                              ))
                          .toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSheet(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Results',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Minimum Match Score',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Slider(
            value: _minMatchScore,
            onChanged: (value) {
              setState(() => _minMatchScore = value);
              ref.read(searchProvider.notifier).filterByMatchScore(value);
            },
            min: 0,
            max: 100,
            divisions: 10,
            label: '${_minMatchScore.toStringAsFixed(0)}%',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() => _showAdvancedFilters = false);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Color _getMatchColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 75) return Colors.lightGreen;
    if (score >= 60) return Colors.amber;
    if (score >= 45) return Colors.orange;
    return Colors.red;
  }

  String _getMatchLabel(double score) {
    if (score >= 90) return 'Perfect Match';
    if (score >= 75) return 'Great Match';
    if (score >= 60) return 'Good Match';
    if (score >= 45) return 'Fair Match';
    return 'Poor Match';
  }
}

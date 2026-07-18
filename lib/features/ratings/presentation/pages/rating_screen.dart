import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/rating_model.dart';
import '../providers/rating_provider.dart';

class RatingScreen extends ConsumerStatefulWidget {
  final String tripId;
  final String ratedUserId;
  final String ratedUserName;

  const RatingScreen({
    super.key,
    required this.tripId,
    required this.ratedUserId,
    required this.ratedUserName,
  });

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  final _reviewController = TextEditingController();
  bool _isLoading = false;

  final List<String> _availableTags = [
    'Friendly',
    'Punctual',
    'Safe Driver',
    'Clean Vehicle',
    'Good Communication',
    'Helpful',
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final ratingState = ref.watch(ratingStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rate Your Trip'), centerTitle: true),
      body: authState.when(
        data: (user) {
          if (user == null) return const Center(child: Text('Please log in'));
          return _buildRatingForm(context, user.id, ratingState);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildRatingForm(
    BuildContext context,
    String userId,
    RatingState ratingState,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // User Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              widget.ratedUserName.isNotEmpty
                  ? widget.ratedUserName[0].toUpperCase()
                  : '?',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'How was your trip with',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            widget.ratedUserName,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = index + 1;
              return IconButton(
                onPressed: () =>
                    ref.read(ratingStateProvider.notifier).setRating(starValue),
                icon: Icon(
                  starValue <= ratingState.rating
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 40,
                ),
              );
            }),
          ),
          Text(
            _getRatingText(ratingState.rating),
            style: TextStyle(
              fontSize: 16,
              color: ratingState.rating > 0
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Tags
          Text(
            'What did you like?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _availableTags.map((tag) {
              final isSelected = ratingState.tags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (_) =>
                    ref.read(ratingStateProvider.notifier).toggleTag(tag),
                selectedColor: AppColors.primaryLight,
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Review Text
          TextFormField(
            controller: _reviewController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Write a review (optional)',
              hintText: 'Share your experience...',
              alignLabelWithHint: true,
            ),
            onChanged: (value) =>
                ref.read(ratingStateProvider.notifier).setReview(value),
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: ratingState.rating > 0 && !_isLoading
                  ? () => _submitRating(userId, ratingState)
                  : null,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Submit Rating'),
            ),
          ),
          const SizedBox(height: 16),

          // Skip Button
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Skip for now'),
          ),
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Tap to rate';
    }
  }

  Future<void> _submitRating(String userId, RatingState ratingState) async {
    setState(() => _isLoading = true);

    try {
      final rating = RatingModel(
        id: '',
        tripId: widget.tripId,
        ratedByUserId: userId,
        ratedUserId: widget.ratedUserId,
        rating: ratingState.rating,
        review: _reviewController.text.isNotEmpty
            ? _reviewController.text
            : null,
        tags: ratingState.tags.isNotEmpty ? ratingState.tags : null,
        createdAt: DateTime.now(),
      );

      await ref.read(submitRatingProvider(rating).future);

      if (mounted) {
        ref.read(ratingStateProvider.notifier).reset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your rating!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit rating: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

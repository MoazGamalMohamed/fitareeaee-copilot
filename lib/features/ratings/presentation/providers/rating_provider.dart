import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/rating_model.dart';

final _firestore = FirebaseFirestore.instance;

RatingModel _ratingFromFirestore(
  DocumentSnapshot<Map<String, dynamic>> document,
) {
  final data = Map<String, dynamic>.from(document.data()!);
  final createdAt = data['createdAt'];
  if (createdAt is Timestamp)
    data['createdAt'] = createdAt.toDate().toIso8601String();
  return RatingModel.fromJson({...data, 'id': document.id});
}

class TripRatingSubmission {
  const TripRatingSubmission({required this.bookingId, required this.rating});

  final String bookingId;
  final RatingModel rating;
}

// Ratings are created and aggregated only by the authenticated callable.
final submitRatingProvider =
    FutureProvider.family<String, TripRatingSubmission>((
      ref,
      submission,
    ) async {
      final result = await FirebaseFunctions.instance
          .httpsCallable('submitTripRating')
          .call({
            'schemaVersion': 1,
            'bookingId': submission.bookingId,
            'rating': submission.rating.rating,
            'review': submission.rating.review,
            'tags': submission.rating.tags ?? const <String>[],
          });
      final data = Map<String, dynamic>.from(result.data as Map);
      final ratingId = data['ratingId'];
      if (ratingId is! String || ratingId.isEmpty) {
        throw StateError('Rating response was incomplete');
      }
      return ratingId;
    });

final ratingExistsProvider =
    StreamProvider.family<bool, ({String bookingId, String userId})>(
      (ref, key) => _firestore
          .collection('ratings')
          .doc('${key.bookingId}_${key.userId}')
          .snapshots()
          .map((snapshot) => snapshot.exists),
    );

// Get user ratings
final userRatingsProvider = StreamProvider.family<List<RatingModel>, String>((
  ref,
  userId,
) {
  return _firestore
      .collection('ratings')
      .where('ratedUserId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map(_ratingFromFirestore).toList());
});

// Get trip ratings
final tripRatingsProvider = FutureProvider.family<List<RatingModel>, String>((
  ref,
  tripId,
) async {
  final snapshot = await _firestore
      .collection('ratings')
      .where('tripId', isEqualTo: tripId)
      .get();

  return snapshot.docs.map(_ratingFromFirestore).toList();
});

// Rating state for UI
class RatingState {
  final int rating;
  final String review;
  final List<String> tags;

  const RatingState({this.rating = 0, this.review = '', this.tags = const []});

  RatingState copyWith({int? rating, String? review, List<String>? tags}) {
    return RatingState(
      rating: rating ?? this.rating,
      review: review ?? this.review,
      tags: tags ?? this.tags,
    );
  }
}

class RatingStateNotifier extends StateNotifier<RatingState> {
  RatingStateNotifier() : super(const RatingState());

  void setRating(int value) => state = state.copyWith(rating: value);
  void setReview(String value) => state = state.copyWith(review: value);
  void toggleTag(String tag) {
    final tags = List<String>.from(state.tags);
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }
    state = state.copyWith(tags: tags);
  }

  void reset() => state = const RatingState();
}

final ratingStateProvider =
    StateNotifierProvider<RatingStateNotifier, RatingState>((ref) {
      return RatingStateNotifier();
    });

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/rating_model.dart';

final _firestore = FirebaseFirestore.instance;

// Submit rating
final submitRatingProvider = FutureProvider.family<RatingModel, RatingModel>((ref, rating) async {
  final docRef = _firestore.collection('ratings').doc();
  final ratingWithId = RatingModel(
    id: docRef.id,
    tripId: rating.tripId,
    ratedByUserId: rating.ratedByUserId,
    ratedUserId: rating.ratedUserId,
    rating: rating.rating,
    review: rating.review,
    tags: rating.tags,
    createdAt: DateTime.now(),
  );
  
  await docRef.set(ratingWithId.toJson());
  
  // Update user's average rating
  await _updateUserAverageRating(rating.ratedUserId);
  
  return ratingWithId;
});

// Update user's average rating
Future<void> _updateUserAverageRating(String userId) async {
  final ratingsSnapshot = await _firestore
      .collection('ratings')
      .where('ratedUserId', isEqualTo: userId)
      .get();
  
  if (ratingsSnapshot.docs.isEmpty) return;
  
  final ratings = ratingsSnapshot.docs
      .map((doc) => doc.data()['rating'] as int)
      .toList();
  
  final averageRating = ratings.reduce((a, b) => a + b) / ratings.length;
  
  await _firestore.collection('users').doc(userId).update({
    'averageRating': averageRating,
    'totalRatings': ratings.length,
  });
}

// Get user ratings
final userRatingsProvider = StreamProvider.family<List<RatingModel>, String>((ref, userId) {
  return _firestore
      .collection('ratings')
      .where('ratedUserId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => RatingModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

// Get trip ratings
final tripRatingsProvider = FutureProvider.family<List<RatingModel>, String>((ref, tripId) async {
  final snapshot = await _firestore
      .collection('ratings')
      .where('tripId', isEqualTo: tripId)
      .get();
  
  return snapshot.docs
      .map((doc) => RatingModel.fromJson({...doc.data(), 'id': doc.id}))
      .toList();
});

// Rating state for UI
class RatingState {
  final int rating;
  final String review;
  final List<String> tags;

  const RatingState({
    this.rating = 0,
    this.review = '',
    this.tags = const [],
  });

  RatingState copyWith({
    int? rating,
    String? review,
    List<String>? tags,
  }) {
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

final ratingStateProvider = StateNotifierProvider<RatingStateNotifier, RatingState>((ref) {
  return RatingStateNotifier();
});


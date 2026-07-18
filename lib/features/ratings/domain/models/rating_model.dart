import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating_model.freezed.dart';
part 'rating_model.g.dart';

@freezed
class RatingModel with _$RatingModel {
  const factory RatingModel({
    required String id,
    required String tripId,
    required String ratedByUserId,
    required String ratedUserId,
    required int rating, // 1-5
    required String? review,
    required List<String>? tags,
    required DateTime createdAt,
  }) = _RatingModel;

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);
}

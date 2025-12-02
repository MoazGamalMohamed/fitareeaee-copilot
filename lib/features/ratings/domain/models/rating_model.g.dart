// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RatingModelImpl _$$RatingModelImplFromJson(Map<String, dynamic> json) =>
    _$RatingModelImpl(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      ratedByUserId: json['ratedByUserId'] as String,
      ratedUserId: json['ratedUserId'] as String,
      rating: (json['rating'] as num).toInt(),
      review: json['review'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$RatingModelImplToJson(_$RatingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tripId': instance.tripId,
      'ratedByUserId': instance.ratedByUserId,
      'ratedUserId': instance.ratedUserId,
      'rating': instance.rating,
      'review': instance.review,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
    };

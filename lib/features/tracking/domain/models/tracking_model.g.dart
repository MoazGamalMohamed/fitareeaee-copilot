// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LiveLocationImpl _$$LiveLocationImplFromJson(Map<String, dynamic> json) =>
    _$LiveLocationImpl(
      oderId: json['oderId'] as String,
      tripId: json['tripId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$LiveLocationImplToJson(_$LiveLocationImpl instance) =>
    <String, dynamic>{
      'oderId': instance.oderId,
      'tripId': instance.tripId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'speed': instance.speed,
      'heading': instance.heading,
      'accuracy': instance.accuracy,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_$TripTrackingImpl _$$TripTrackingImplFromJson(
  Map<String, dynamic> json,
) => _$TripTrackingImpl(
  tripId: json['tripId'] as String,
  driverId: json['driverId'] as String,
  status: $enumDecode(_$TrackingStatusEnumMap, json['status']),
  currentLocation: json['currentLocation'] == null
      ? null
      : LiveLocation.fromJson(json['currentLocation'] as Map<String, dynamic>),
  sharedWithUserIds:
      (json['sharedWithUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  originLatitude: (json['originLatitude'] as num?)?.toDouble(),
  originLongitude: (json['originLongitude'] as num?)?.toDouble(),
  destinationLatitude: (json['destinationLatitude'] as num?)?.toDouble(),
  destinationLongitude: (json['destinationLongitude'] as num?)?.toDouble(),
  estimatedDistanceKm: (json['estimatedDistanceKm'] as num?)?.toDouble(),
  estimatedDurationMinutes: (json['estimatedDurationMinutes'] as num?)?.toInt(),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$TripTrackingImplToJson(_$TripTrackingImpl instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'driverId': instance.driverId,
      'status': _$TrackingStatusEnumMap[instance.status]!,
      'currentLocation': instance.currentLocation,
      'sharedWithUserIds': instance.sharedWithUserIds,
      'originLatitude': instance.originLatitude,
      'originLongitude': instance.originLongitude,
      'destinationLatitude': instance.destinationLatitude,
      'destinationLongitude': instance.destinationLongitude,
      'estimatedDistanceKm': instance.estimatedDistanceKm,
      'estimatedDurationMinutes': instance.estimatedDurationMinutes,
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$TrackingStatusEnumMap = {
  TrackingStatus.inactive: 'inactive',
  TrackingStatus.active: 'active',
  TrackingStatus.paused: 'paused',
  TrackingStatus.completed: 'completed',
};

_$LocationHistoryImpl _$$LocationHistoryImplFromJson(
  Map<String, dynamic> json,
) => _$LocationHistoryImpl(
  id: json['id'] as String,
  tripId: json['tripId'] as String,
  userId: json['userId'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  speed: (json['speed'] as num?)?.toDouble(),
  heading: (json['heading'] as num?)?.toDouble(),
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$$LocationHistoryImplToJson(
  _$LocationHistoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'tripId': instance.tripId,
  'userId': instance.userId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'speed': instance.speed,
  'heading': instance.heading,
  'timestamp': instance.timestamp.toIso8601String(),
};

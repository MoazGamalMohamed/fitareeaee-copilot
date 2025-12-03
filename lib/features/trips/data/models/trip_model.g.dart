// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripModelImpl _$$TripModelImplFromJson(Map<String, dynamic> json) =>
    _$TripModelImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      direction: json['direction'] as String,
      driverId: json['driverId'] as String,
      passengerId: json['passengerId'] as String?,
      originAddress: json['origin_address'] as String,
      destinationAddress: json['destination_address'] as String,
      originLat: (json['origin_lat'] as num).toDouble(),
      originLng: (json['origin_lng'] as num).toDouble(),
      destinationLat: (json['destination_lat'] as num).toDouble(),
      destinationLng: (json['destination_lng'] as num).toDouble(),
      departureTime: DateTime.parse(json['departure_time'] as String),
      distance: (json['distance'] as num).toDouble(),
      estimatedDuration: (json['estimated_duration'] as num).toInt(),
      pricePerSeat: (json['price_per_seat'] as num).toDouble(),
      totalSeats: (json['total_seats'] as num).toInt(),
      availableSeats: (json['available_seats'] as num).toInt(),
      passengerIds:
          (json['passenger_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: json['status'] as String? ?? 'pending',
      description: json['description'] as String?,
      allowPets: json['allowPets'] as bool? ?? false,
      allowSmoking: json['allowSmoking'] as bool? ?? false,
      amenities:
          (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      includesPerson: json['includes_person'] as bool? ?? true,
      includesPackage: json['includes_package'] as bool? ?? false,
      packageWeight: (json['package_weight'] as num?)?.toDouble(),
      packageDescription: json['package_description'] as String?,
      packagePhotoUrls:
          (json['package_photo_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TripModelImplToJson(_$TripModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'direction': instance.direction,
      'driverId': instance.driverId,
      'passengerId': instance.passengerId,
      'origin_address': instance.originAddress,
      'destination_address': instance.destinationAddress,
      'origin_lat': instance.originLat,
      'origin_lng': instance.originLng,
      'destination_lat': instance.destinationLat,
      'destination_lng': instance.destinationLng,
      'departure_time': instance.departureTime.toIso8601String(),
      'distance': instance.distance,
      'estimated_duration': instance.estimatedDuration,
      'price_per_seat': instance.pricePerSeat,
      'total_seats': instance.totalSeats,
      'available_seats': instance.availableSeats,
      'passenger_ids': instance.passengerIds,
      'status': instance.status,
      'description': instance.description,
      'allowPets': instance.allowPets,
      'allowSmoking': instance.allowSmoking,
      'amenities': instance.amenities,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'includes_person': instance.includesPerson,
      'includes_package': instance.includesPackage,
      'package_weight': instance.packageWeight,
      'package_description': instance.packageDescription,
      'package_photo_urls': instance.packagePhotoUrls,
    };

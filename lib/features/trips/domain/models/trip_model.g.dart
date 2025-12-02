// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripModelImpl _$$TripModelImplFromJson(Map<String, dynamic> json) =>
    _$TripModelImpl(
      id: json['id'] as String,
      driverId: json['driverId'] as String,
      startLocation: json['startLocation'] as String,
      endLocation: json['endLocation'] as String,
      startLatitude: (json['startLatitude'] as num).toDouble(),
      startLongitude: (json['startLongitude'] as num).toDouble(),
      endLatitude: (json['endLatitude'] as num).toDouble(),
      endLongitude: (json['endLongitude'] as num).toDouble(),
      departureTime: DateTime.parse(json['departureTime'] as String),
      distance: (json['distance'] as num).toDouble(),
      estimatedDuration: (json['estimatedDuration'] as num).toDouble(),
      pricePerSeat: (json['pricePerSeat'] as num).toDouble(),
      totalSeats: (json['totalSeats'] as num).toInt(),
      availableSeats: (json['availableSeats'] as num).toInt(),
      passengerIds: (json['passengerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TripModelImplToJson(_$TripModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driverId': instance.driverId,
      'startLocation': instance.startLocation,
      'endLocation': instance.endLocation,
      'startLatitude': instance.startLatitude,
      'startLongitude': instance.startLongitude,
      'endLatitude': instance.endLatitude,
      'endLongitude': instance.endLongitude,
      'departureTime': instance.departureTime.toIso8601String(),
      'distance': instance.distance,
      'estimatedDuration': instance.estimatedDuration,
      'pricePerSeat': instance.pricePerSeat,
      'totalSeats': instance.totalSeats,
      'availableSeats': instance.availableSeats,
      'passengerIds': instance.passengerIds,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

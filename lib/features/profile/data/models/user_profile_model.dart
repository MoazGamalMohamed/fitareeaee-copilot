import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

/// Helper to parse DateTime from various Firestore formats
DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
  return DateTime.now();
}

/// User profile data model with JSON serialization
@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String userId,
    required String email,
    required String name,
    String? phone,
    String? photoUrl,
    String? bio,
    String? address,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    @Default([]) List<String> roles,
    @Default(0.0) double rating,
    @Default(0) int totalRatings,
    @Default(0) int totalTrips,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isPhoneVerified,
    @Default(false) bool isProfileComplete,
    @Default({}) Map<String, dynamic> metadata,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserProfileModel;

  /// Custom factory to handle Firestore Timestamp conversion
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Pre-process the json to handle Timestamps
    final processedJson = Map<String, dynamic>.from(json);

    // Handle created_at - can be Timestamp, String, or missing
    if (processedJson['created_at'] != null) {
      processedJson['created_at'] = _parseDateTime(processedJson['created_at']).toIso8601String();
    } else if (processedJson['createdAt'] != null) {
      processedJson['created_at'] = _parseDateTime(processedJson['createdAt']).toIso8601String();
    } else {
      processedJson['created_at'] = DateTime.now().toIso8601String();
    }

    // Handle updated_at - can be Timestamp, String, or missing
    if (processedJson['updated_at'] != null) {
      processedJson['updated_at'] = _parseDateTime(processedJson['updated_at']).toIso8601String();
    } else if (processedJson['updatedAt'] != null) {
      processedJson['updated_at'] = _parseDateTime(processedJson['updatedAt']).toIso8601String();
    } else {
      processedJson['updated_at'] = DateTime.now().toIso8601String();
    }

    // Ensure required fields have defaults
    processedJson['userId'] ??= '';
    processedJson['email'] ??= '';
    processedJson['name'] ??= '';

    return _$UserProfileModelFromJson(processedJson);
  }
}

/// Extension to convert between model and entity
extension UserProfileModelExtension on UserProfileModel {
  /// Convert model to domain entity
  UserProfile toEntity() => UserProfile(
        userId: userId,
        email: email,
        name: name,
        phone: phone,
        photoUrl: photoUrl,
        bio: bio,
        address: address,
        city: city,
        country: country,
        latitude: latitude,
        longitude: longitude,
        roles: roles,
        rating: rating,
        totalRatings: totalRatings,
        totalTrips: totalTrips,
        isEmailVerified: isEmailVerified,
        isPhoneVerified: isPhoneVerified,
        isProfileComplete: isProfileComplete,
        metadata: metadata,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  /// Convert to JSON for Firestore
  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'email': email,
        'name': name,
        'phone': phone,
        'photoUrl': photoUrl,
        'bio': bio,
        'address': address,
        'city': city,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
        'roles': roles,
        'rating': rating,
        'totalRatings': totalRatings,
        'totalTrips': totalTrips,
        'isEmailVerified': isEmailVerified,
        'isPhoneVerified': isPhoneVerified,
        'isProfileComplete': isProfileComplete,
        'metadata': metadata,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// Extension to convert entity to model
extension UserProfileToModel on UserProfile {
  /// Convert entity to model
  UserProfileModel toModel() => UserProfileModel(
        userId: userId,
        email: email,
        name: name,
        phone: phone,
        photoUrl: photoUrl,
        bio: bio,
        address: address,
        city: city,
        country: country,
        latitude: latitude,
        longitude: longitude,
        roles: roles,
        rating: rating,
        totalRatings: totalRatings,
        totalTrips: totalTrips,
        isEmailVerified: isEmailVerified,
        isPhoneVerified: isPhoneVerified,
        isProfileComplete: isProfileComplete,
        metadata: metadata,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

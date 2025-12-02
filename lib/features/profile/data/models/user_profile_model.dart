import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

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

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
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

import '../../domain/entities/user_profile.dart';

/// User profile data model with JSON serialization
class UserProfileModel {
  UserProfileModel({
    required this.userId,
    required this.email,
    required this.name,
    this.phone,
    this.photoUrl,
    this.bio,
    this.address,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.roles = const [],
    this.rating = 0.0,
    this.totalRatings = 0,
    this.totalTrips = 0,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.isProfileComplete = false,
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  final String userId;
  final String email;
  final String name;
  final String? phone;
  final String? photoUrl;
  final String? bio;
  final String? address;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;
  final List<String> roles;
  final double rating;
  final int totalRatings;
  final int totalTrips;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isProfileComplete;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Factory to create from JSON
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['userId'] as String? ?? json['id'] as String,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String?,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: json['totalRatings'] as int? ?? 0,
      totalTrips: json['totalTrips'] as int? ?? 0,
      isEmailVerified: json['isEmailVerified'] as bool? ?? json['isVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : {},
      createdAt: json['createdAt'] is DateTime 
          ? json['createdAt'] as DateTime
          : (json['created_at'] is DateTime 
              ? json['created_at'] as DateTime
              : DateTime.parse((json['createdAt'] ?? json['created_at']) as String)),
      updatedAt: json['updatedAt'] is DateTime 
          ? json['updatedAt'] as DateTime
          : (json['updated_at'] is DateTime 
              ? json['updated_at'] as DateTime
              : DateTime.parse((json['updatedAt'] ?? json['updated_at']) as String)),
    );
  }

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

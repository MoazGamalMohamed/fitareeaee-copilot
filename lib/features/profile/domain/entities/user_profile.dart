import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// User profile entity with extended information
@freezed
class UserProfile with _$UserProfile {
  const UserProfile._(); // Add private constructor

  const factory UserProfile({
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
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  /// Check if user has a specific role
  bool hasRole(String role) => roles.contains(role);

  /// Get list of readable role names
  List<String> get roleNames {
    const roleMap = {
      'driver': 'Driver',
      'courier': 'Courier',
      'rider': 'Rider',
      'sender': 'Sender',
      'admin': 'Administrator',
    };
    return roles.map((r) => roleMap[r] ?? r).toList();
  }

  /// Check if driver
  bool get isDriver => hasRole('driver');

  /// Check if courier
  bool get isCourier => hasRole('courier');

  /// Check if rider
  bool get isRider => hasRole('rider');

  /// Check if sender
  bool get isSender => hasRole('sender');

  /// Check if admin
  bool get isAdmin => hasRole('admin');

  /// Get rating star display (e.g., 4.5)
  String get ratingDisplay => rating.toStringAsFixed(1);

  /// Check if profile is complete (has name, email, photo, and at least one role)
  bool get profileCompleteCheck =>
      name.isNotEmpty &&
      email.isNotEmpty &&
      photoUrl != null &&
      photoUrl!.isNotEmpty &&
      roles.isNotEmpty &&
      phone != null &&
      phone!.isNotEmpty;

  /// Get profile completion percentage
  int get completionPercentage {
    int completed = 0;
    int total = 8;

    if (name.isNotEmpty) completed++;
    if (email.isNotEmpty) completed++;
    if (photoUrl != null && photoUrl!.isNotEmpty) completed++;
    if (phone != null && phone!.isNotEmpty) completed++;
    if (bio != null && bio!.isNotEmpty) completed++;
    if (address != null && address!.isNotEmpty) completed++;
    if (roles.isNotEmpty) completed++;
    if (isEmailVerified) completed++;

    return ((completed / total) * 100).toInt();
  }

  /// Create a copy with some fields replaced
  UserProfile copyWithProfile({
    String? name,
    String? phone,
    String? photoUrl,
    String? bio,
    String? address,
    String? city,
    String? country,
  }) {
    return copyWith(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      updatedAt: DateTime.now(),
    );
  }
}

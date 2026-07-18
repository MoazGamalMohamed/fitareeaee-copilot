import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Represents a user in the system
class AppUser {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? photoUrl;
  final List<String> roles; // 'driver', 'courier', 'rider', 'sender', 'admin'
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final double rating;
  final int totalRatings;
  final int totalTrips;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppUser({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.photoUrl,
    required this.roles,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.rating,
    required this.totalRatings,
    required this.totalTrips,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from Firebase User
  factory AppUser.fromFirebaseUser(firebase_auth.User user) {
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      phone: user.phoneNumber,
      photoUrl: user.photoURL,
      roles: [],
      isEmailVerified: user.emailVerified,
      isPhoneVerified: user.phoneNumber != null,
      rating: 5.0,
      totalRatings: 0,
      totalTrips: 0,
      isVerified: false,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'photoUrl': photoUrl,
      'roles': roles,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'rating': rating,
      'totalRatings': totalRatings,
      'totalTrips': totalTrips,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      photoUrl: json['photoUrl'] as String?,
      roles: List<String>.from(json['roles'] as List? ?? []),
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      totalRatings: json['totalRatings'] as int? ?? 0,
      totalTrips: json['totalTrips'] as int? ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  /// Copy with
  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? photoUrl,
    List<String>? roles,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    double? rating,
    int? totalRatings,
    int? totalTrips,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      roles: roles ?? this.roles,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      totalTrips: totalTrips ?? this.totalTrips,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if user has a specific role
  bool hasRole(String role) => roles.contains(role);

  /// Check if user is driver
  bool get isDriver => roles.contains('driver');

  /// Check if user is courier
  bool get isCourier => roles.contains('courier');

  /// Check if user is rider
  bool get isRider => roles.contains('rider');

  /// Check if user is sender
  bool get isSender => roles.contains('sender');

  /// Check if user is admin
  bool get isAdmin => roles.contains('admin');

  @override
  String toString() => 'AppUser(id: $id, email: $email, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}

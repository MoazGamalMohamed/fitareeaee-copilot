import 'package:cloud_firestore/cloud_firestore.dart';

/// Helper utilities for Firestore data conversion
class FirestoreHelpers {
  /// Convert Timestamp fields in a Map to ISO8601 strings for JSON parsing
  /// This prevents "type 'Timestamp' is not a subtype of type 'String'" errors
  static Map<String, dynamic> convertTimestamps(Map<String, dynamic> data) {
    final converted = Map<String, dynamic>.from(data);

    converted.forEach((key, value) {
      if (value is Timestamp) {
        converted[key] = value.toDate().toIso8601String();
      } else if (value is Map) {
        // Recursively convert nested maps
        converted[key] = convertTimestamps(Map<String, dynamic>.from(value));
      } else if (value is List) {
        // Convert timestamps in lists
        converted[key] = value.map((item) {
          if (item is Timestamp) {
            return item.toDate().toIso8601String();
          } else if (item is Map) {
            return convertTimestamps(Map<String, dynamic>.from(item));
          }
          return item;
        }).toList();
      }
    });

    return converted;
  }

  /// Convert a single Timestamp value to ISO8601 string, or return as-is if not a Timestamp
  static dynamic convertTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) {
      return value.toDate().toIso8601String();
    }
    return value;
  }

  /// Convert Timestamp to DateTime, handling multiple formats
  static DateTime? timestampToDateTime(dynamic timestamp) {
    if (timestamp == null) return null;

    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is DateTime) {
      return timestamp;
    } else if (timestamp is String) {
      try {
        return DateTime.parse(timestamp);
      } catch (e) {
        return null;
      }
    } else if (timestamp is Map) {
      // Handle serialized Timestamp format
      final seconds = timestamp['_seconds'] ?? timestamp['seconds'];
      final nanoseconds =
          timestamp['_nanoseconds'] ?? timestamp['nanoseconds'] ?? 0;
      if (seconds != null) {
        return DateTime.fromMillisecondsSinceEpoch(
          seconds * 1000 + nanoseconds ~/ 1000000,
        );
      }
    }

    return null;
  }
}

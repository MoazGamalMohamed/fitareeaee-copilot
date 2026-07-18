import 'package:cloud_functions/cloud_functions.dart';

/// Service to interact with Google Places API via Cloud Functions
/// This ensures API key security and works across all platforms
class PlacesService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Get autocomplete predictions for a search query
  /// Returns list of place predictions or empty list on error
  Future<List<PlacePrediction>> getAutocomplete(String input, {String? components}) async {
    if (input.length < 2) return [];

    try {
      print('🔍 Calling placesAutocomplete with input: $input');
      final result = await _functions
          .httpsCallable('placesAutocomplete')
          .call({
            'input': input,
            if (components != null) 'components': components,
          });

      print('📡 Got response: ${result.data}');
      print('📡 Response type: ${result.data.runtimeType}');
      final data = result.data as Map<String, dynamic>;
      
      print('📊 Status: ${data['status']}, Has predictions: ${data['predictions'] != null}');
      if (data['error'] != null) {
        print('⚠️ API Error: ${data['error']}');
      }
      
      if (data['status'] == 'OK' && data['predictions'] != null) {
        final predictions = data['predictions'] as List;
        print('✅ Found ${predictions.length} predictions');
        return predictions.map((p) => PlacePrediction.fromJson(Map<String, dynamic>.from(p as Map))).toList();
      }
      
      print('⚠️ No predictions: status=${data['status']}');
      return [];
    } catch (e, stackTrace) {
      print('❌ Places autocomplete error: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Get detailed information about a place by place_id
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final result = await _functions
          .httpsCallable('placeDetails')
          .call({'placeId': placeId});

      final data = result.data as Map<String, dynamic>;
      
      if (data['status'] == 'OK') {
        return PlaceDetails.fromJson(data);
      }
      
      return null;
    } catch (e) {
      print('❌ Place details error: $e');
      return null;
    }
  }

  /// Reverse geocode coordinates to address
  Future<String?> reverseGeocode(double lat, double lng) async {
    try {
      final result = await _functions
          .httpsCallable('reverseGeocode')
          .call({
            'lat': lat,
            'lng': lng,
          });

      final data = result.data as Map<String, dynamic>;
      return data['address'] as String?;
    } catch (e) {
      print('❌ Reverse geocode error: $e');
      return null;
    }
  }
}

/// Place prediction from autocomplete
class PlacePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    final structuredRaw = json['structured_formatting'];
    final structured = structuredRaw != null 
        ? Map<String, dynamic>.from(structuredRaw as Map)
        : <String, dynamic>{};
    return PlacePrediction(
      placeId: json['place_id'] as String? ?? '',
      description: json['description'] as String? ?? '',
      mainText: structured['main_text'] as String? ?? '',
      secondaryText: structured['secondary_text'] as String? ?? '',
    );
  }
}

/// Detailed place information
class PlaceDetails {
  final double lat;
  final double lng;
  final String address;
  final String? name;

  PlaceDetails({
    required this.lat,
    required this.lng,
    required this.address,
    this.name,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final locationRaw = json['location'];
    final location = locationRaw != null 
        ? Map<String, dynamic>.from(locationRaw as Map)
        : <String, dynamic>{};
    return PlaceDetails(
      lat: (location['lat'] as num).toDouble(),
      lng: (location['lng'] as num).toDouble(),
      address: json['address'] as String? ?? '',
      name: json['name'] as String?,
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// A human-readable OpenStreetMap location returned by Nominatim.
class GeocodedPlace {
  const GeocodedPlace({
    required this.displayName,
    required this.latitude,
    required this.longitude,
    this.city,
    this.country,
  });

  final String displayName;
  final double latitude;
  final double longitude;
  final String? city;
  final String? country;
}

abstract class AddressGeocoder {
  Future<List<GeocodedPlace>> search(String query, {String language = 'en'});

  Future<GeocodedPlace?> reverse(
    double latitude,
    double longitude, {
    String language = 'en',
  });
}

/// Lightweight Nominatim client for deliberate searches and pin lookups.
///
/// Public Nominatim must not be queried on every keystroke. The UI calls this
/// client only after the user presses Search or places a pin, and this client
/// serializes requests to at most one per second.
class OpenStreetMapGeocoder implements AddressGeocoder {
  OpenStreetMapGeocoder({HttpClient? client})
    : _client = client ?? HttpClient();

  static const _host = 'nominatim.openstreetmap.org';
  static DateTime? _lastRequestAt;
  static Future<void> _requestQueue = Future<void>.value();

  final HttpClient _client;

  @override
  Future<List<GeocodedPlace>> search(
    String query, {
    String language = 'en',
  }) async {
    final normalized = query.trim();
    if (normalized.length < 3) return const [];
    final uri = Uri.https(_host, '/search', {
      'format': 'jsonv2',
      'q': normalized,
      'limit': '6',
      'addressdetails': '1',
      'accept-language': language,
    });
    final json = await _getJson(uri);
    if (json is! List) return const [];
    return json
        .whereType<Map>()
        .map((item) => _placeFromJson(Map<String, dynamic>.from(item)))
        .whereType<GeocodedPlace>()
        .toList(growable: false);
  }

  @override
  Future<GeocodedPlace?> reverse(
    double latitude,
    double longitude, {
    String language = 'en',
  }) async {
    final uri = Uri.https(_host, '/reverse', {
      'format': 'jsonv2',
      'lat': latitude.toString(),
      'lon': longitude.toString(),
      'zoom': '18',
      'addressdetails': '1',
      'accept-language': language,
    });
    final json = await _getJson(uri);
    if (json is! Map) return null;
    return _placeFromJson(Map<String, dynamic>.from(json));
  }

  Future<Object?> _getJson(Uri uri) async {
    Object? result;
    Object? failure;
    final completion = Completer<void>();
    _requestQueue = _requestQueue.then((_) async {
      try {
        final lastRequestAt = _lastRequestAt;
        if (lastRequestAt != null) {
          final remaining =
              const Duration(seconds: 1) -
              DateTime.now().difference(lastRequestAt);
          if (!remaining.isNegative) await Future<void>.delayed(remaining);
        }
        _lastRequestAt = DateTime.now();
        final request = await _client
            .getUrl(uri)
            .timeout(const Duration(seconds: 10));
        request.headers.set(
          HttpHeaders.userAgentHeader,
          'Fitareeaee/1.0 (https://github.com/MoazGamalMohamed/fitareeaee-copilot)',
        );
        request.headers.set(HttpHeaders.acceptHeader, 'application/json');
        final response = await request.close().timeout(
          const Duration(seconds: 10),
        );
        if (response.statusCode != HttpStatus.ok) {
          throw HttpException(
            'Address service returned ${response.statusCode}',
            uri: uri,
          );
        }
        final body = await utf8.decoder.bind(response).join();
        result = jsonDecode(body);
      } catch (error) {
        failure = error;
      } finally {
        completion.complete();
      }
    });
    await completion.future;
    if (failure != null) throw failure!;
    return result;
  }

  GeocodedPlace? _placeFromJson(Map<String, dynamic> json) {
    final latitude = double.tryParse(json['lat']?.toString() ?? '');
    final longitude = double.tryParse(json['lon']?.toString() ?? '');
    final displayName = json['display_name']?.toString().trim() ?? '';
    if (latitude == null || longitude == null || displayName.isEmpty) {
      return null;
    }
    final address = json['address'] is Map
        ? Map<String, dynamic>.from(json['address'] as Map)
        : const <String, dynamic>{};
    return GeocodedPlace(
      displayName: displayName,
      latitude: latitude,
      longitude: longitude,
      city: _firstNonEmpty(address, const [
        'city',
        'town',
        'village',
        'municipality',
        'county',
      ]),
      country: _firstNonEmpty(address, const ['country']),
    );
  }

  String? _firstNonEmpty(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }
}

class PlaceSuggestion {
  const PlaceSuggestion({
    required this.city,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  final String city;
  final String region;
  final String country;
  final double latitude;
  final double longitude;

  String get label => '$city, $region, $country';
}

const placeSuggestions = <PlaceSuggestion>[
  PlaceSuggestion(
    city: 'Dallas',
    region: 'Texas',
    country: 'United States',
    latitude: 32.7767,
    longitude: -96.7970,
  ),
  PlaceSuggestion(
    city: 'Austin',
    region: 'Texas',
    country: 'United States',
    latitude: 30.2672,
    longitude: -97.7431,
  ),
  PlaceSuggestion(
    city: 'Houston',
    region: 'Texas',
    country: 'United States',
    latitude: 29.7604,
    longitude: -95.3698,
  ),
  PlaceSuggestion(
    city: 'Chicago',
    region: 'Illinois',
    country: 'United States',
    latitude: 41.8781,
    longitude: -87.6298,
  ),
  PlaceSuggestion(
    city: 'Milwaukee',
    region: 'Wisconsin',
    country: 'United States',
    latitude: 43.0389,
    longitude: -87.9065,
  ),
  PlaceSuggestion(
    city: 'New York',
    region: 'New York',
    country: 'United States',
    latitude: 40.7128,
    longitude: -74.0060,
  ),
  PlaceSuggestion(
    city: 'Los Angeles',
    region: 'California',
    country: 'United States',
    latitude: 34.0522,
    longitude: -118.2437,
  ),
  PlaceSuggestion(
    city: 'San Francisco',
    region: 'California',
    country: 'United States',
    latitude: 37.7749,
    longitude: -122.4194,
  ),
  PlaceSuggestion(
    city: 'Seattle',
    region: 'Washington',
    country: 'United States',
    latitude: 47.6062,
    longitude: -122.3321,
  ),
  PlaceSuggestion(
    city: 'Miami',
    region: 'Florida',
    country: 'United States',
    latitude: 25.7617,
    longitude: -80.1918,
  ),
  PlaceSuggestion(
    city: 'Cairo',
    region: 'Cairo',
    country: 'Egypt',
    latitude: 30.0444,
    longitude: 31.2357,
  ),
  PlaceSuggestion(
    city: 'Alexandria',
    region: 'Alexandria',
    country: 'Egypt',
    latitude: 31.2001,
    longitude: 29.9187,
  ),
  PlaceSuggestion(
    city: 'Riyadh',
    region: 'Riyadh',
    country: 'Saudi Arabia',
    latitude: 24.7136,
    longitude: 46.6753,
  ),
  PlaceSuggestion(
    city: 'Jeddah',
    region: 'Makkah',
    country: 'Saudi Arabia',
    latitude: 21.4858,
    longitude: 39.1925,
  ),
  PlaceSuggestion(
    city: 'Dubai',
    region: 'Dubai',
    country: 'United Arab Emirates',
    latitude: 25.2048,
    longitude: 55.2708,
  ),
  PlaceSuggestion(
    city: 'Abu Dhabi',
    region: 'Abu Dhabi',
    country: 'United Arab Emirates',
    latitude: 24.4539,
    longitude: 54.3773,
  ),
  PlaceSuggestion(
    city: 'Amman',
    region: 'Amman',
    country: 'Jordan',
    latitude: 31.9539,
    longitude: 35.9106,
  ),
  PlaceSuggestion(
    city: 'Kuwait City',
    region: 'Al Asimah',
    country: 'Kuwait',
    latitude: 29.3759,
    longitude: 47.9774,
  ),
  PlaceSuggestion(
    city: 'London',
    region: 'England',
    country: 'United Kingdom',
    latitude: 51.5072,
    longitude: -0.1276,
  ),
  PlaceSuggestion(
    city: 'Toronto',
    region: 'Ontario',
    country: 'Canada',
    latitude: 43.6532,
    longitude: -79.3832,
  ),
];

PlaceSuggestion? placeSuggestionForLabel(String value) {
  final normalized = value.trim().toLowerCase();
  for (final place in placeSuggestions) {
    if (place.label.toLowerCase() == normalized ||
        place.city.toLowerCase() == normalized) {
      return place;
    }
  }
  return null;
}

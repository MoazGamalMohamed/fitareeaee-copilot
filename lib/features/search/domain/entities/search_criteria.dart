/// Minimal search criteria stub (no codegen)
class SearchCriteria {
  final String origin;
  final String destination;
  final double? originLat;
  final double? originLng;
  final DateTime departureDate;
  final String tripType;
  final double maxPrice;
  final List<String> amenities;
  final bool allowPets;
  final bool allowSmoking;
  final double minRating;

  SearchCriteria({
    this.origin = '',
    this.destination = '',
    this.originLat,
    this.originLng,
    DateTime? departureDate,
    this.tripType = 'person',
    this.maxPrice = 0.0,
    this.amenities = const [],
    this.allowPets = false,
    this.allowSmoking = false,
    this.minRating = 0.0,
  }) : departureDate = departureDate ?? DateTime.now();
}

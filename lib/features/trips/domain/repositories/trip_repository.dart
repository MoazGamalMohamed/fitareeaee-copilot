import '../../domain/entities/trip.dart';

abstract class TripRepository {
  Future<Trip> createTrip(Trip trip);
  Future<void> updateTrip(Trip trip);
  Future<void> deleteTrip(String tripId);
  Future<Trip> getTripById(String tripId);
  Future<List<Trip>> getAllTrips();
  Future<List<Trip>> getUserTrips(String userId);
  Future<List<Trip>> searchTrips({
    required String origin,
    required String destination,
    DateTime? departureDate,
    String? tripType,
  });
  Stream<List<Trip>> streamAvailableTrips({String? excludeUserId});
  Future<void> bookTrip(String tripId, String userId, int seats);
  Future<void> cancelBooking(String tripId, String userId);
}

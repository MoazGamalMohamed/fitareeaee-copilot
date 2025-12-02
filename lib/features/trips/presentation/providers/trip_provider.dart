import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/trip.dart';
import '../../data/repositories/trip_repository_impl.dart' as repo;

// Repository Provider
final tripRepositoryProvider = Provider((ref) {
  final firestore = FirebaseFirestore.instance;

  return repo.TripRepositoryImpl(
    firestore: firestore,
  );
});

// Stream Providers
final availableTripsProvider = StreamProvider<List<Trip>>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.streamAvailableTrips();
});

final userTripsProvider = StreamProvider.family<List<Trip>, String>((
  ref,
  String userId,
) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.streamAvailableTrips();
});

// Future Providers
final allTripsProvider = FutureProvider<List<Trip>>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getAllTrips();
});

final tripDetailProvider = FutureProvider.family<Trip, String>((
  ref,
  String tripId,
) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getTripById(tripId);
});

// State Notifiers
class CreateTripStateNotifier extends StateNotifier<AsyncValue<Trip?>> {
  final repo.TripRepositoryImpl _repository;

  CreateTripStateNotifier(this._repository)
      : super(const AsyncValue.data(null));

  Future<void> createTrip(Trip trip) async {
    state = const AsyncValue.loading();
    try {
      final createdTrip = await _repository.createTrip(trip);
      state = AsyncValue.data(createdTrip);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

class SearchTripsStateNotifier extends StateNotifier<AsyncValue<List<Trip>>> {
  final repo.TripRepositoryImpl _repository;

  SearchTripsStateNotifier(this._repository)
      : super(const AsyncValue.data([]));

  Future<void> searchTrips({
    required String origin,
    required String destination,
    DateTime? departureDate,
    String? tripType,
  }) async {
    state = const AsyncValue.loading();
    try {
      final results = await _repository.searchTrips(
        origin: origin,
        destination: destination,
        departureDate: departureDate,
        tripType: tripType,
      );
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

class TripBookingStateNotifier extends StateNotifier<AsyncValue<void>> {
  final repo.TripRepositoryImpl _repository;

  TripBookingStateNotifier(this._repository)
      : super(const AsyncValue.data(null));

  Future<void> bookTrip(String tripId, String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.bookTrip(tripId, userId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> cancelBooking(String tripId, String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.cancelBooking(tripId, userId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// State Notifier Providers
final createTripProvider =
    StateNotifierProvider.autoDispose<CreateTripStateNotifier, AsyncValue<Trip?>>((
  ref,
) {
  final repository = ref.watch(tripRepositoryProvider);
  return CreateTripStateNotifier(repository);
});

final searchTripsProvider =
    StateNotifierProvider.autoDispose<SearchTripsStateNotifier, AsyncValue<List<Trip>>>((
  ref,
) {
  final repository = ref.watch(tripRepositoryProvider);
  return SearchTripsStateNotifier(repository);
});

final tripBookingProvider =
    StateNotifierProvider.autoDispose<TripBookingStateNotifier, AsyncValue<void>>((
  ref,
) {
  final repository = ref.watch(tripRepositoryProvider);
  return TripBookingStateNotifier(repository);
});

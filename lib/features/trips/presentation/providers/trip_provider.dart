import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../domain/entities/trip.dart';
import '../../data/repositories/trip_repository_impl.dart' as repo;
import '../../../auth/presentation/providers/auth_provider.dart';

// Repository Provider
final tripRepositoryProvider = Provider((ref) {
  final firestore = FirebaseFirestore.instance;

  return repo.TripRepositoryImpl(
    firestore: firestore,
    functions: FirebaseFunctions.instance,
  );
});

// Stream Providers
final availableTripsProvider = StreamProvider<List<Trip>>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  final currentUserAsync = ref.watch(authStateProvider);

  // Return empty stream if not authenticated
  return currentUserAsync.when(
    data: (user) {
      if (user == null) {
        return Stream.value([]);
      }
      // Stream available trips excluding user's own trips
      return repository.streamAvailableTrips(excludeUserId: user.id);
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
});

final userTripsProvider = StreamProvider.family<List<Trip>, String>((
  ref,
  String userId,
) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.streamUserTrips(userId);
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

  SearchTripsStateNotifier(this._repository) : super(const AsyncValue.data([]));

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

  Future<repo.BookingStartResult> bookTrip(
    String tripId,
    String userId,
    int seats,
  ) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.bookTrip(tripId, userId, seats);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> cancelBooking(String tripId, String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.cancelBooking(tripId, userId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

// State Notifier Providers
final createTripProvider =
    StateNotifierProvider.autoDispose<
      CreateTripStateNotifier,
      AsyncValue<Trip?>
    >((ref) {
      final repository = ref.watch(tripRepositoryProvider);
      return CreateTripStateNotifier(repository);
    });

final searchTripsProvider =
    StateNotifierProvider.autoDispose<
      SearchTripsStateNotifier,
      AsyncValue<List<Trip>>
    >((ref) {
      final repository = ref.watch(tripRepositoryProvider);
      return SearchTripsStateNotifier(repository);
    });

final tripBookingProvider =
    StateNotifierProvider.autoDispose<
      TripBookingStateNotifier,
      AsyncValue<void>
    >((ref) {
      final repository = ref.watch(tripRepositoryProvider);
      return TripBookingStateNotifier(repository);
    });

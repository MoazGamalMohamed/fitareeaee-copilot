import 'package:fitareeaee/features/copilot/domain/copilot_draft.dart';
import 'package:fitareeaee/features/copilot/domain/copilot_match.dart';
import 'package:fitareeaee/features/trips/domain/entities/trip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final draft = CopilotDraft(
    schemaVersion: 1,
    intent: 'find',
    tripType: 'ride',
    origin: 'Dallas',
    destination: 'Austin',
    departureDate: '2030-07-20',
    departureTime: '09:00',
    passengerOrSeatCount: 2,
    packageDetails: null,
    maximumBudget: 40,
    preferences: const ['no smoking'],
    assistantSummary: 'Draft',
    missingInformation: const [],
    clarificationQuestion: null,
    language: 'en',
  );

  test(
    'ranking is deterministic and explains route, time, seats, and price',
    () {
      final best = _trip(
        id: 'best',
        origin: 'Dallas, TX',
        destination: 'Austin, TX',
        departure: DateTime(2030, 7, 20, 9, 30),
        price: 18,
      );
      final later = _trip(
        id: 'later',
        origin: 'Dallas',
        destination: 'Austin',
        departure: DateTime(2030, 7, 20, 14),
        price: 15,
      );
      final results = rankCopilotMatches([later, best], draft);

      expect(results.map((result) => result.trip.id), ['best', 'later']);
      expect(results.first.reasons, contains('Within your maximum budget'));
      expect(results.first.reasons, contains('2 seats are available'));
      expect(results.first.reasons, contains('No-smoking preference matches'));
    },
  );

  test(
    'ranking excludes wrong routes, unavailable seats, and over-budget trips',
    () {
      final trips = [
        _trip(id: 'wrong-route', origin: 'Houston'),
        _trip(id: 'full', seats: 1),
        _trip(id: 'expensive', price: 25),
      ];
      expect(rankCopilotMatches(trips, draft), isEmpty);
    },
  );

  test('empty Firestore input remains empty and never fabricates trips', () {
    expect(rankCopilotMatches(const [], draft), isEmpty);
  });

  test('missing required draft fields do not start matching', () {
    expect(rankCopilotMatches([_trip()], draft.copyWith(origin: '')), isEmpty);
  });

  test('past trips are excluded before the booking path', () {
    expect(
      rankCopilotMatches(
        [_trip(departure: DateTime.now().subtract(const Duration(hours: 1)))],
        draft.copyWith(
          departureDate: DateTime.now().toIso8601String().substring(0, 10),
        ),
      ),
      isEmpty,
    );
  });

  test('offer intent returns request trips for coordination', () {
    final result = rankCopilotMatches([
      _trip(role: 'request'),
    ], draft.copyWith(intent: 'offer'));
    expect(result.single.trip.role, 'request');
  });

  test('package capacity and Arabic place tokens are deterministic', () {
    final packageDraft = draft.copyWith(
      tripType: 'package',
      origin: 'شيكاغو',
      destination: 'ميلووكي',
      packageDetails: 'طرد 5 كيلو',
      passengerOrSeatCount: 1,
    );
    final fits = _trip(
      type: 'package',
      origin: 'Chicago, Illinois',
      destination: 'Milwaukee, Wisconsin',
      packageWeight: 10,
    );
    expect(
      rankCopilotMatches([fits], packageDraft).single.reasons,
      contains('Package weight fits the listed capacity'),
    );
    expect(
      rankCopilotMatches([fits.copyWith(packageWeight: 2)], packageDraft),
      isEmpty,
    );
  });
}

Trip _trip({
  String id = 'trip',
  String origin = 'Dallas',
  String destination = 'Austin',
  DateTime? departure,
  int seats = 3,
  double price = 18,
  String type = 'person',
  String role = 'offer',
  double? packageWeight,
}) {
  final now = DateTime(2030, 7, 1);
  return Trip(
    id: id,
    type: type,
    role: role,
    driverId: 'driver',
    originAddress: origin,
    destinationAddress: destination,
    originLat: 0,
    originLng: 0,
    destinationLat: 0,
    destinationLng: 0,
    departureTime: departure ?? DateTime(2030, 7, 20, 9),
    distance: 300,
    estimatedDuration: 180,
    pricePerSeat: price,
    totalSeats: seats,
    availableSeats: seats,
    status: 'pending',
    allowSmoking: false,
    packageWeight: packageWeight,
    createdAt: now,
    updatedAt: now,
  );
}

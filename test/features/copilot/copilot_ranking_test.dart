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
}

Trip _trip({
  String id = 'trip',
  String origin = 'Dallas',
  String destination = 'Austin',
  DateTime? departure,
  int seats = 3,
  double price = 18,
}) {
  final now = DateTime(2030, 7, 1);
  return Trip(
    id: id,
    type: 'person',
    role: 'offer',
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
    createdAt: now,
    updatedAt: now,
  );
}

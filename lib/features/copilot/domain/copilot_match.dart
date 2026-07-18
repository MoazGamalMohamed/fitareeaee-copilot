import '../../trips/domain/entities/trip.dart';
import 'copilot_draft.dart';

class CopilotMatch {
  final Trip trip;
  final double score;
  final List<String> reasons;

  const CopilotMatch({
    required this.trip,
    required this.score,
    required this.reasons,
  });
}

List<CopilotMatch> rankCopilotMatches(List<Trip> trips, CopilotDraft draft) {
  if (!draft.isReadyForMatching) return const [];
  final requestedDate = DateTime.tryParse(draft.departureDate!);
  if (requestedDate == null) return const [];
  final count = draft.passengerOrSeatCount ?? 1;
  final expectedRole = draft.intent == 'find' ? 'offer' : 'request';
  final expectedType = draft.tripType == 'package' ? 'package' : 'person';
  final results = <CopilotMatch>[];

  for (final trip in trips) {
    if (trip.status != 'pending' || trip.availableSeats < count) continue;
    if (trip.role != expectedRole) continue;
    if (trip.type != expectedType && trip.type != 'both') continue;

    final originScore = _locationSimilarity(draft.origin!, trip.originAddress);
    final destinationScore = _locationSimilarity(
      draft.destination!,
      trip.destinationAddress,
    );
    if (originScore < 0.34 || destinationScore < 0.34) continue;

    final dayDifference =
        DateTime(
              trip.departureTime.year,
              trip.departureTime.month,
              trip.departureTime.day,
            )
            .difference(
              DateTime(
                requestedDate.year,
                requestedDate.month,
                requestedDate.day,
              ),
            )
            .inDays
            .abs();
    if (dayDifference > 1) continue;

    final totalPrice = trip.pricePerSeat * count;
    if (draft.intent == 'find' &&
        draft.maximumBudget != null &&
        totalPrice > draft.maximumBudget!) {
      continue;
    }

    var score = ((originScore + destinationScore) / 2) * 35;
    final reasons = <String>['Compatible origin and destination'];

    if (dayDifference == 0) {
      score += 18;
      reasons.add('Departure date matches');
    } else {
      score += 8;
      reasons.add('Departure is within one day');
    }

    final requestedTime = _requestedDateTime(draft, requestedDate);
    if (requestedTime != null) {
      final hours =
          trip.departureTime.difference(requestedTime).inMinutes.abs() / 60;
      if (hours <= 2) {
        score += 12;
        reasons.add('Departure time is within 2 hours');
      } else if (hours <= 6) {
        score += 6;
        reasons.add('Departure time is within 6 hours');
      }
    } else {
      score += 6;
    }

    score += 15;
    reasons.add('$count ${count == 1 ? 'seat is' : 'seats are'} available');

    if (draft.maximumBudget == null || totalPrice <= draft.maximumBudget!) {
      score += 13;
      reasons.add(
        draft.maximumBudget == null
            ? 'Price shown transparently'
            : 'Within your maximum budget',
      );
    }

    final preferenceScore = _preferenceScore(trip, draft.preferences, reasons);
    score += preferenceScore;

    results.add(
      CopilotMatch(
        trip: trip,
        score: score.clamp(0, 100).toDouble(),
        reasons: reasons,
      ),
    );
  }

  results.sort((a, b) {
    final score = b.score.compareTo(a.score);
    if (score != 0) return score;
    final time = a.trip.departureTime.compareTo(b.trip.departureTime);
    if (time != 0) return time;
    return a.trip.pricePerSeat.compareTo(b.trip.pricePerSeat);
  });
  return results;
}

DateTime? _requestedDateTime(CopilotDraft draft, DateTime date) {
  final value = draft.departureTime;
  if (value == null) return null;
  final parts = value.split(':');
  if (parts.length != 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  return DateTime(date.year, date.month, date.day, hour, minute);
}

double _locationSimilarity(String requested, String actual) {
  final left = _tokens(requested);
  final right = _tokens(actual);
  if (left.isEmpty || right.isEmpty) return 0;
  final overlap = left.intersection(right).length;
  return overlap / left.length;
}

Set<String> _tokens(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\u0600-\u06ff ]'), ' ')
      .split(RegExp(r'\s+'))
      .where((token) => token.length > 1)
      .toSet();
}

double _preferenceScore(
  Trip trip,
  List<String> preferences,
  List<String> reasons,
) {
  if (preferences.isEmpty) return 7;
  var matched = 0;
  for (final preference in preferences) {
    final normalized = preference.toLowerCase();
    if ((normalized.contains('no smoking') ||
            normalized.contains('non-smoking')) &&
        !trip.allowSmoking) {
      matched++;
      reasons.add('No-smoking preference matches');
    } else if ((normalized.contains('pet') || normalized.contains('حيوان')) &&
        trip.allowPets) {
      matched++;
      reasons.add('Pet preference matches');
    } else if (trip.amenities.any(
      (amenity) => normalized.contains(amenity.toLowerCase()),
    )) {
      matched++;
      reasons.add('Requested amenity is available');
    }
  }
  return (matched / preferences.length) * 7;
}

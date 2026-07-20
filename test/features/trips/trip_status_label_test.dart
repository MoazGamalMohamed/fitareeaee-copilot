import 'package:fitareeaee/features/trips/presentation/pages/trips_list_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pending trips distinguish available inventory from full inventory', () {
    expect(
      tripCardStatusLabel(status: 'pending', availableSeats: 2),
      'Available',
    );
    expect(tripCardStatusLabel(status: 'pending', availableSeats: 0), 'Full');
  });

  test('closed and active lifecycle states are not mislabeled as full', () {
    expect(
      tripCardStatusLabel(status: 'confirmed', availableSeats: 0),
      'Confirmed',
    );
    expect(
      tripCardStatusLabel(status: 'in_progress', availableSeats: 0),
      'In progress',
    );
    expect(
      tripCardStatusLabel(status: 'completed', availableSeats: 0),
      'Completed',
    );
    expect(
      tripCardStatusLabel(status: 'cancelled', availableSeats: 2),
      'Cancelled',
    );
  });
}

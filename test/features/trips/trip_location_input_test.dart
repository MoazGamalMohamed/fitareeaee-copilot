import 'package:fitareeaee/features/trips/presentation/pages/create_trip_screen.dart';
import 'package:fitareeaee/features/trips/presentation/pages/trip_location_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('replaces only generated map labels when a point is re-picked', () {
    const selection = TripLocationSelection(
      latitude: 39.86364,
      longitude: -98.55923,
    );

    expect(
      tripLocationLabelAfterMapPick('', selection),
      'Map pin 39.86364, -98.55923',
    );
    expect(
      tripLocationLabelAfterMapPick('Map pin 39.82830, -98.57950', selection),
      'Map pin 39.86364, -98.55923',
    );
    expect(
      tripLocationLabelAfterMapPick('Dallas, Texas', selection),
      'Dallas, Texas',
    );
  });

  testWidgets('tapping From field opens the interactive map callback', (
    tester,
  ) async {
    var picks = 0;
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            child: TripLocationInput(
              controller: controller,
              label: 'From',
              icon: Icons.trip_origin,
              selection: null,
              onPick: () => picks++,
            ),
          ),
        ),
      ),
    );

    final field = find.byKey(const ValueKey('trip-location-From'));
    expect(field, findsOneWidget);
    final editable = find.descendant(
      of: field,
      matching: find.byType(EditableText),
    );
    expect(tester.widget<EditableText>(editable).readOnly, isTrue);

    await tester.tap(field);
    await tester.pump();
    expect(picks, 1);
  });

  testWidgets('tapping To map icon opens the same picker callback', (
    tester,
  ) async {
    var picks = 0;
    final controller = TextEditingController(text: 'Austin');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            child: TripLocationInput(
              controller: controller,
              label: 'To',
              icon: Icons.location_on_outlined,
              selection: null,
              onPick: () => picks++,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Pick To on map'));
    await tester.pump();
    expect(picks, 1);
  });
}

import 'package:fitareeaee/features/trips/presentation/pages/trip_location_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keeps OpenStreetMap attribution visible and actionable', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: TripLocationPickerScreen(title: 'Pick origin')),
    );

    expect(find.byType(SimpleAttributionWidget), findsOneWidget);
    expect(find.text('OpenStreetMap contributors'), findsOneWidget);

    final attribution = tester.widget<SimpleAttributionWidget>(
      find.byType(SimpleAttributionWidget),
    );
    expect(attribution.onTap, isNotNull);
  });
}

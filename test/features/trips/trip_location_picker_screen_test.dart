import 'package:fitareeaee/features/trips/presentation/pages/trip_location_picker_screen.dart';
import 'package:fitareeaee/core/location/open_street_map_geocoder.dart';
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

  testWidgets('search returns address choices and confirms the selected one', (
    tester,
  ) async {
    TripLocationSelection? confirmed;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => FilledButton(
            onPressed: () async {
              confirmed = await Navigator.of(context).push(
                MaterialPageRoute<TripLocationSelection>(
                  builder: (_) => TripLocationPickerScreen(
                    title: 'Pick origin',
                    geocoder: _FakeGeocoder(),
                  ),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final searchField = find.descendant(
      of: find.byKey(const ValueKey('map-address-search-field')),
      matching: find.byType(EditableText),
    );
    expect(searchField, findsOneWidget);
    await tester.enterText(searchField, 'Dallas Main Street');
    await tester.tap(find.byKey(const ValueKey('map-address-search-button')));
    await tester.pump();

    expect(find.text('100 Main Street, Dallas, Texas, USA'), findsOneWidget);
    expect(find.text('200 Main Street, Dallas, Texas, USA'), findsOneWidget);
    await tester.tap(find.text('100 Main Street, Dallas, Texas, USA'));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('map-confirm-location-button')));
    await tester.pump();

    expect(confirmed?.address, '100 Main Street, Dallas, Texas, USA');
    expect(confirmed?.city, 'Dallas');
    expect(confirmed?.country, 'United States');
  });
}

class _FakeGeocoder implements AddressGeocoder {
  @override
  Future<List<GeocodedPlace>> search(
    String query, {
    String language = 'en',
  }) async => const [
    GeocodedPlace(
      displayName: '100 Main Street, Dallas, Texas, USA',
      latitude: 32.7767,
      longitude: -96.7970,
      city: 'Dallas',
      country: 'United States',
    ),
    GeocodedPlace(
      displayName: '200 Main Street, Dallas, Texas, USA',
      latitude: 32.7780,
      longitude: -96.7990,
      city: 'Dallas',
      country: 'United States',
    ),
  ];

  @override
  Future<GeocodedPlace?> reverse(
    double latitude,
    double longitude, {
    String language = 'en',
  }) async => null;
}

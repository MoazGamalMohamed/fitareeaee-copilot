import 'package:fitareeaee/features/auth/domain/entities/app_user.dart';
import 'package:fitareeaee/features/auth/presentation/providers/auth_provider.dart';
import 'package:fitareeaee/features/home/presentation/pages/home_screen.dart';
import 'package:fitareeaee/features/verification/presentation/providers/verification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home always presents Request and Offer as separate actions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final now = DateTime(2026, 7, 21);
    final user = AppUser(
      id: 'driver-account',
      email: 'driver@example.test',
      roles: const ['driver', 'courier'],
      isEmailVerified: true,
      isPhoneVerified: true,
      rating: 5,
      totalRatings: 0,
      totalTrips: 0,
      isVerified: true,
      createdAt: now,
      updatedAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(user)),
          verificationStatusProvider(
            user.id,
          ).overrideWith((ref) => Stream.value(null)),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('home-request-action')), findsOneWidget);
    expect(find.byKey(const ValueKey('home-offer-action')), findsOneWidget);
    expect(find.text('Request a ride or delivery'), findsOneWidget);
    expect(find.text('Offer a ride or delivery'), findsOneWidget);
    expect(find.text('Plan with\nGPT-5.6'), findsOneWidget);
    expect(find.text('Trips'), findsOneWidget);
  });
}

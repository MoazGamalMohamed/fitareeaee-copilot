import 'package:fitareeaee/features/copilot/domain/copilot_draft.dart';
import 'package:fitareeaee/features/copilot/presentation/pages/copilot_screen.dart';
import 'package:fitareeaee/features/copilot/presentation/pages/copilot_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('Copilot preserves requested seat count in the details handoff', () {
    expect(copilotTripDetailsRoute('trip-1', _draft), '/trips/trip-1?seats=2');
  });

  testWidgets('Copilot failure keeps retry and manual fallback available', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var calls = 0;
    final router = GoRouter(
      initialLocation: '/copilot',
      routes: [
        GoRoute(
          path: '/copilot',
          builder: (context, state) => CopilotScreen(
            planner: (_) async {
              calls++;
              throw Exception('AI planning is temporarily unavailable.');
            },
          ),
        ),
        GoRoute(
          path: '/trips',
          builder: (context, state) => const Scaffold(body: Text('Manual')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.enterText(find.byType(TextField).first, 'Dallas to Austin');
    await tester.pump();
    await tester.tap(find.text('Create AI draft'));
    await tester.pumpAndSettle();

    expect(calls, 1);
    final error = find.textContaining('AI planning is unavailable');
    expect(error, findsOneWidget);
    expect(tester.getCenter(error).dy, inInclusiveRange(0, 1800));
    expect(find.textContaining('temporarily unavailable'), findsNothing);
    expect(find.text('Create AI draft'), findsOneWidget);
    expect(find.text('Use manual trip search'), findsOneWidget);
  });

  testWidgets('AI output remains a draft until explicit confirmation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var plannerCalls = 0;
    CopilotDraft? confirmedDraft;
    final router = GoRouter(
      initialLocation: '/copilot',
      routes: [
        GoRoute(
          path: '/copilot',
          builder: (context, state) => CopilotScreen(
            planner: (request) async {
              plannerCalls++;
              return CopilotPlanResult(
                model: 'gpt-5.6',
                piiRedacted: false,
                draft: _draft,
              );
            },
          ),
        ),
        GoRoute(
          path: '/copilot/results',
          builder: (context, state) {
            confirmedDraft = state.extra as CopilotDraft;
            return const Scaffold(body: Text('Deterministic results'));
          },
        ),
        GoRoute(
          path: '/trips',
          builder: (context, state) =>
              const Scaffold(body: Text('Manual search')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.enterText(
      find.byType(TextField).first,
      'Dallas to Austin on July 20 at 9 AM for two people',
    );
    await tester.pump();
    final createDraft = find.text('Create AI draft');
    await tester.tap(createDraft);
    await tester.pumpAndSettle();

    expect(plannerCalls, 1);
    expect(confirmedDraft, isNull);
    expect(
      find.textContaining('review required', skipOffstage: false),
      findsOneWidget,
    );
    final review = find.textContaining('review required');
    expect(tester.getCenter(review).dy, inInclusiveRange(0, 1800));

    final confirm = find.text('Confirm draft and find transparent matches');
    await tester.drag(find.byType(ListView), const Offset(0, -2200));
    await tester.pumpAndSettle();
    await tester.tap(confirm);
    await tester.pumpAndSettle();

    expect(confirmedDraft, isNotNull);
    expect(find.text('Deterministic results'), findsOneWidget);
  });
}

const _draft = CopilotDraft(
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
  preferences: ['no smoking'],
  assistantSummary: 'Review this ride draft.',
  missingInformation: [],
  clarificationQuestion: null,
  language: 'en',
);

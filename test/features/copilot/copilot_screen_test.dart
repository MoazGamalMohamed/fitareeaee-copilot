import 'package:fitareeaee/features/copilot/domain/copilot_draft.dart';
import 'package:fitareeaee/features/copilot/presentation/pages/copilot_screen.dart';
import 'package:fitareeaee/features/copilot/presentation/pages/copilot_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Copilot preserves requested seat count in the details handoff', () {
    expect(copilotTripDetailsRoute('trip-1', _draft), '/trips/trip-1?seats=2');
    expect(copilotCreationRoute(_draft), '/trips/create?role=rider');
    expect(
      copilotCreationRoute(_draft.copyWith(intent: 'offer')),
      '/trips/create?role=driver',
    );
  });

  test('account role deterministically locks the Copilot intent', () {
    expect(copilotIntentForRole('driver'), 'offer');
    expect(copilotIntentForRole('rider'), 'find');
    expect(copilotIntentForRole(null), 'find');
  });

  test('voice errors distinguish permission, silence, and busy states', () {
    expect(
      copilotVoiceErrorMessage('error_permission'),
      contains('permission is off'),
    );
    expect(
      copilotVoiceErrorMessage('error_speech_timeout'),
      contains('No speech was heard'),
    );
    expect(
      copilotVoiceErrorMessage('error_no_match'),
      contains('No speech was heard'),
    );
    expect(
      copilotVoiceErrorMessage('error_recognizer_busy'),
      contains('recognition is busy'),
    );
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
          path: '/trips/create',
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
    expect(find.text('Create a request manually'), findsOneWidget);
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
          path: '/trips/create',
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

  testWidgets('driver Copilot locks a returned draft to the offer path', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 5000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final router = GoRouter(
      initialLocation: '/copilot',
      routes: [
        GoRoute(
          path: '/copilot',
          builder: (context, state) => CopilotScreen(
            role: 'driver',
            planner: (_) async => throw UnimplementedError(),
          ),
        ),
        GoRoute(
          path: '/trips/create',
          builder: (context, state) =>
              const Scaffold(body: Text('Manual offer')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    expect(find.text('Driver / Courier path'), findsOneWidget);
    expect(find.text('Create an offer manually'), findsOneWidget);
  });

  testWidgets('signed-in user can save and reuse an editable local template', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1000, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: CopilotScreen(templateOwnerId: 'fictional-rider'),
      ),
    );
    await tester.pumpAndSettle();
    const request = 'I need a ride from Dallas to Austin every Monday at 9 AM.';
    await tester.enterText(find.byType(TextField).first, request);
    await tester.pump();
    await tester.tap(find.text('Saved trip templates'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save current request as template'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Template name'),
      'Monday commute',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Trip template saved.'), findsOneWidget);
    expect(find.text('Monday commute'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Temporary request');
    await tester.tap(find.text('Monday commute'));
    await tester.pump();
    expect(
      (tester.widget<TextField>(find.byType(TextField).first).controller?.text),
      request,
    );
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

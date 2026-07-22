import 'package:fitareeaee/features/copilot/data/trip_prompt_template_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('templates are isolated by account and persist edits', () async {
    final store = TripPromptTemplateStore();
    final original = TripPromptTemplate(
      id: 'commute',
      name: 'Weekday commute',
      request: 'I need a ride from Dallas to Austin tomorrow at 9 AM.',
      updatedAt: DateTime.utc(2026, 7, 20),
    );

    await store.upsert('rider-a', original);
    expect(await store.load('driver-b'), isEmpty);
    expect((await store.load('rider-a')).single.name, 'Weekday commute');

    await store.upsert(
      'rider-a',
      TripPromptTemplate(
        id: original.id,
        name: 'Early commute',
        request: 'I need a ride from Dallas to Austin tomorrow at 8 AM.',
        updatedAt: DateTime.utc(2026, 7, 20, 1),
      ),
    );
    final updated = await store.load('rider-a');
    expect(updated, hasLength(1));
    expect(updated.single.name, 'Early commute');
    expect(updated.single.request, contains('8 AM'));
  });

  test(
    'store bounds entries, rejects sensitive-size abuse, and deletes',
    () async {
      final store = TripPromptTemplateStore();
      for (var index = 0; index < 10; index++) {
        await store.upsert(
          'rider',
          TripPromptTemplate(
            id: '$index',
            name: 'Trip $index',
            request: 'Recurring trip request number $index',
            updatedAt: DateTime.utc(2026, 7, 20, index),
          ),
        );
      }

      final bounded = await store.load('rider');
      expect(bounded, hasLength(TripPromptTemplateStore.maxTemplates));
      expect(bounded.first.id, '9');

      final afterDelete = await store.delete('rider', bounded.first.id);
      expect(afterDelete, hasLength(TripPromptTemplateStore.maxTemplates - 1));
      expect(afterDelete.any((item) => item.id == '9'), isFalse);

      await expectLater(
        store.upsert(
          'rider',
          TripPromptTemplate(
            id: 'too-long',
            name: 'Invalid',
            request: List.filled(
              TripPromptTemplateStore.maxRequestLength + 1,
              'x',
            ).join(),
            updatedAt: DateTime.utc(2026),
          ),
        ),
        throwsA(isA<FormatException>()),
      );
    },
  );
}

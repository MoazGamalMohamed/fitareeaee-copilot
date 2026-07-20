import 'package:fitareeaee/core/widgets/assisted_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'location field offers suggestions and still accepts custom text',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      String? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssistedTextFormField(
              controller: controller,
              label: 'City',
              hint: 'Start typing',
              icon: Icons.location_city,
              suggestions: const ['Dallas, Texas', 'Austin, Texas'],
              onSelected: (value) => selected = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Dal');
      await tester.pump();
      expect(find.text('Dallas, Texas'), findsOneWidget);

      await tester.tap(find.text('Dallas, Texas'));
      await tester.pump();
      expect(selected, 'Dallas, Texas');
      expect(controller.text, 'Dallas, Texas');

      await tester.enterText(find.byType(TextFormField), 'My custom village');
      expect(controller.text, 'My custom village');
    },
  );
}

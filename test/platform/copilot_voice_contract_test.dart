import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Copilot explicitly requests microphone access and caps voice at 3 minutes',
    () {
      final source = File(
        'lib/features/copilot/presentation/pages/copilot_screen.dart',
      ).readAsStringSync();
      final manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();

      expect(manifest, contains('android.permission.RECORD_AUDIO'));
      expect(source, contains('await _speech.hasPermission'));
      expect(source, contains("title: const Text('Use your microphone?')"));
      expect(source, contains("child: const Text('Allow and start')"));
      expect(source, contains('listenFor: const Duration(minutes: 3)'));
      expect(source, contains('_voiceSecondsRemaining = 180'));
    },
  );
}

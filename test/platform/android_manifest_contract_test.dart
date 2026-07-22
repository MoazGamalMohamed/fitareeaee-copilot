import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android manifest exposes speech recognition on API 30+', () {
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();

    expect(manifest, contains('android.permission.RECORD_AUDIO'));
    expect(manifest, contains('android.speech.RecognitionService'));
  });
}

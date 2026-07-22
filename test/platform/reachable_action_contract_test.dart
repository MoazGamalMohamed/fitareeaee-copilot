import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reachable GoRouter actions use a registered route family', () {
    final dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('.dart') &&
              !file.path.endsWith('.g.dart') &&
              !file.path.endsWith('.freezed.dart'),
        );
    final routePattern = RegExp(r"context\.(?:push|go)\('([^']+)");
    const registeredRouteFamilies = <String>{
      '/home',
      '/login',
      '/signup',
      '/forgot-password',
      '/profile',
      '/trips',
      '/chat',
      '/settings',
      '/verification',
      '/notifications',
      '/payments',
      '/support',
      '/copilot',
      '/admin/verifications',
    };
    final unknown = <String>[];

    for (final file in dartFiles) {
      final source = file.readAsStringSync();
      for (final match in routePattern.allMatches(source)) {
        final target = match.group(1)!;
        final path = target.split('?').first;
        final familyIsRegistered = registeredRouteFamilies.any(
          (route) => path == route || path.startsWith('$route/'),
        );
        if (!familyIsRegistered) {
          unknown.add('${file.path}: $target');
        }
      }
    }

    expect(unknown, isEmpty, reason: 'Unregistered button routes: $unknown');
  });

  test('handwritten UI has no empty button or tap callbacks', () {
    final dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('.dart') &&
              !file.path.endsWith('.g.dart') &&
              !file.path.endsWith('.freezed.dart'),
        );
    final emptyHandler = RegExp(
      r'on(?:Pressed|Tap)\s*:\s*\(\)\s*(?:async\s*)?\{\s*\}',
      multiLine: true,
    );
    final offenders = <String>[];

    for (final file in dartFiles) {
      if (emptyHandler.hasMatch(file.readAsStringSync())) {
        offenders.add(file.path);
      }
    }

    expect(offenders, isEmpty, reason: 'Empty button handlers: $offenders');
  });
}

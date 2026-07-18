import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'environment.dart';

/// Firebase configuration and initialization
class FirebaseConfig {
  /// Initializes Firebase from the native platform configuration.
  ///
  /// Android reads the ignored `android/app/google-services.json` supplied for
  /// the intended Firebase project. Web builds use compile-time values so no
  /// local environment file needs to be bundled into the application.
  static Future<void> initialize() async {
    if (Firebase.apps.isNotEmpty) return;

    if (kIsWeb) {
      _validateWebConfiguration();
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: Environment.firebaseApiKey,
          appId: Environment.firebaseAppId,
          messagingSenderId: Environment.firebaseMessagingSenderId,
          projectId: Environment.firebaseProjectId,
          authDomain: Environment.firebaseAuthDomain,
          storageBucket: Environment.firebaseStorageBucket,
        ),
      );
      return;
    }

    final app = await Firebase.initializeApp();
    if (app.options.projectId != Environment.firebaseProjectId) {
      throw StateError(
        'Unexpected Firebase project. Expected '
        '${Environment.firebaseProjectId}, received ${app.options.projectId}.',
      );
    }
  }

  static void _validateWebConfiguration() {
    final values = <String>[
      Environment.firebaseApiKey,
      Environment.firebaseAppId,
      Environment.firebaseMessagingSenderId,
      Environment.firebaseProjectId,
    ];
    if (values.any((value) => value.isEmpty || value.startsWith('YOUR_'))) {
      throw StateError(
        'Firebase web configuration is missing. Supply the documented '
        '--dart-define values before running a web build.',
      );
    }
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'environment.dart';

/// Firebase configuration and initialization
class FirebaseConfig {
  /// Initialize Firebase with configuration from environment variables
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: Environment.firebaseApiKey,
        appId: Environment.firebaseAppId,
        messagingSenderId: Environment.firebaseMessagingSenderId,
        projectId: Environment.firebaseProjectId,
        authDomain: Environment.firebaseAuthDomain,
        storageBucket: Environment.firebaseStorageBucket,
        databaseURL: 'https://${Environment.firebaseProjectId}.firebaseio.com',
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Firebase configuration and initialization
class FirebaseConfig {
  /// Initialize Firebase with configuration from google-services.json
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: kIsWeb ? const FirebaseOptions(
        apiKey: 'YOUR_WEB_API_KEY',
        appId: 'YOUR_WEB_APP_ID',
        messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
        projectId: 'YOUR_PROJECT_ID',
        authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
        storageBucket: 'YOUR_PROJECT_ID.firebasestorage.app',
      ) : const FirebaseOptions(
        apiKey: 'YOUR_ANDROID_API_KEY',
        appId: 'YOUR_ANDROID_APP_ID',
        messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
        projectId: 'YOUR_PROJECT_ID',
        storageBucket: 'YOUR_PROJECT_ID.firebasestorage.app',
      ),
    );
  }
}

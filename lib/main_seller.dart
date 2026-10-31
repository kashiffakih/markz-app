import 'package:aadab/core/services/firebase_api.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/seller/seller_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// Markz SELLER app entry point.
///   flutter run -t lib/main_seller.dart --dart-define=API_URL=http://<PC-IP>:8000
///   flutter build apk -t lib/main_seller.dart --dart-define=API_URL=...
Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  runApp(const SellerApp());

  // push notifications (new order alerts) - never block the UI
  Future.microtask(() async {
    try {
      await FirebaseApi().initNotifications().timeout(
            const Duration(seconds: 5),
            onTimeout: () => debugPrint('Firebase initNotifications timed out'),
          );
    } catch (e) {
      debugPrint('Firebase notifications init error: $e');
    }
  });
}

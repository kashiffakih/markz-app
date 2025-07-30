import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:flutter/services.dart' show rootBundle;

Future<String> getAccessToken() async {
  try {
    // Load the service account credentials from a JSON file
    final serviceAccountKey = json
        .decode(await rootBundle.loadString('assets/service_account_key.json'));
    final credentials =
        auth.ServiceAccountCredentials.fromJson(serviceAccountKey);
    const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    // Obtain access credentials
    final auth.AccessCredentials accessCredentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            credentials, scopes, http.Client());

    return accessCredentials.accessToken.data;
  } catch (e) {
    //print('Error obtaining access token: $e');
    rethrow;
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  //print('Background message received:');
  //print('Title: ${message.notification?.title}');
  //print('Body: ${message.notification?.body}');
  //print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    try {
      // Request notification permissions for iOS
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Set foreground notification presentation options
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Get FCM token for potential future use
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await _firebaseMessaging.getToken();
        //print('FCM Token obtained');
      } else {
        //print('User declined notification permissions');
      }

      // Initialize flutter_local_notifications
      await _initLocalNotifications();

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        //print('Foreground message received: ${message.notification?.title}');
        if (message.notification != null) {
          _showNotification(message);
        }
      });
    } catch (e) {
      //print('Error initializing notifications: $e');
    }
  }

  Future<void> _initLocalNotifications() async {
    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // Combine platform settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        //print('Notification tapped with payload: ${response.payload}');
      },
    );
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'fcm_channel_id',
      'FCM Notifications',
      channelDescription: 'Notifications from Firebase Cloud Messaging',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.messageId.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      platformDetails,
      payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
    );
  }
}

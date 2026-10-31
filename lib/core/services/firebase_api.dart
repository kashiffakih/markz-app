import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/core/services/auth_s.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('Background message received:');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Callback for notification taps
  static Function(Map<String, dynamic>)? onNotificationTap;

  // Store FCM token
  static String? _fcmToken;
  static String? get fcmToken => _fcmToken;

  /// Force refresh FCM token - call this on login to ensure fresh token
  Future<String?> forceRefreshToken() async {
    try {
      debugPrint('Getting FCM token on login...');

      // Just get the current token - don't delete it
      // Deleting can cause race conditions where the new token isn't registered yet
      _fcmToken = await _firebaseMessaging.getToken();
      debugPrint('FCM Token on login: $_fcmToken');

      return _fcmToken;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  Future<void> initNotifications() async {
    try {
      // Request notification permissions
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

      debugPrint(
          'Notification permission status: ${settings.authorizationStatus}');

      // Set foreground notification presentation options
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Get FCM token
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _fcmToken = await _firebaseMessaging.getToken();
        debugPrint('FCM Token: $_fcmToken');

        // Subscribe to general topics for broadcast notifications
        await _firebaseMessaging.subscribeToTopic('all_users');
        await _firebaseMessaging
            .subscribeToTopic('allUser'); // Backup for legacy

        // Listen for token refresh
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          _fcmToken = newToken;
          debugPrint('FCM Token refreshed: $newToken');

          // Update token on server
          try {
            final authService = locator<AuthService>();
            authService.updateFcmToken(newToken: newToken);
          } catch (e) {
            debugPrint('Error locating AuthService during token refresh: $e');
          }
        });
      } else {
        debugPrint('User declined notification permissions');
      }

      // Initialize flutter_local_notifications
      await _initLocalNotifications();

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Foreground message received:');
        debugPrint('Title: ${message.notification?.title}');
        debugPrint('Body: ${message.notification?.body}');
        debugPrint('Data: ${message.data}');

        // Always show notification in foreground, whether notification payload exists or not
        _showNotification(message);
      });

      // Handle notification when app is opened from terminated state
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          debugPrint('App opened from terminated state via notification');
          _handleNotificationTap(message.data);
        }
      });

      // Handle notification when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('App opened from background via notification');
        _handleNotificationTap(message.data);
      });
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
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

    // Create the notification channel explicitly for Android
    // This ensures background notifications work even if _showNotification hasn't been called yet
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'aadab_notifications', // id
      'Markz Notifications', // title
      description: 'Important notifications from Markz app', // description
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

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
        debugPrint('Notification tapped with payload: ${response.payload}');
        if (response.payload != null) {
          try {
            final data = jsonDecode(response.payload!);
            _handleNotificationTap(data);
          } catch (e) {
            debugPrint('Error parsing notification payload: $e');
          }
        }
      },
    );
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    debugPrint('Handling notification tap with data: $data');

    // Call the callback if set
    if (onNotificationTap != null) {
      onNotificationTap!(data);
    }

    // You can also handle specific navigation here based on data
    // For example:
    // if (data['type'] == 'order') {
    //   navigatorKey.currentState?.pushNamed('/orderDetails', arguments: data['orderId']);
    // }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    // Get title and body from notification or data payload
    final title =
        message.notification?.title ?? message.data['title'] ?? 'Markz';
    final body = message.notification?.body ??
        message.data['body'] ??
        'You have a new notification';

    // Create notification channel for Android with default sound
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'aadab_notifications',
      'Markz Notifications',
      channelDescription: 'Important notifications from Markz app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      enableLights: true,
      playSound: true,
      color: Color(0xFF2196F3),
      ledColor: Color(0xFF2196F3),
      ledOnMs: 1000,
      ledOffMs: 500,
      styleInformation: BigTextStyleInformation(
        body,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
      ),
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
      threadIdentifier: 'aadab_notifications',
    );

    NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Generate unique notification ID
    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      platformDetails,
      payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
    );
  }

  // Method to cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Method to cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // Method to get pending notifications (Android only)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}

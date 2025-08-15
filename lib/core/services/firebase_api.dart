import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

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

      debugPrint('Notification permission status: ${settings.authorizationStatus}');

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
        
        // Listen for token refresh
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          _fcmToken = newToken;
          debugPrint('FCM Token refreshed: $newToken');
          // TODO: Update token on server if needed
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
        
        if (message.notification != null) {
          _showNotification(message);
        }
      });
      
      // Handle notification when app is opened from terminated state
      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
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
    // Create notification channel for Android
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'aadab_notifications',
      'Aadab Notifications',
      channelDescription: 'Important notifications from Aadab app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      enableLights: true,
      color: const Color(0xFF2196F3),
      ledColor: const Color(0xFF2196F3),
      ledOnMs: 1000,
      ledOffMs: 500,
      styleInformation: BigTextStyleInformation(
        message.notification?.body ?? '',
        htmlFormatBigText: true,
        contentTitle: message.notification?.title,
        htmlFormatContentTitle: true,
      ),
    );
    
    // Add custom sound if available
    if (message.notification?.android?.sound != null) {
      androidDetails = AndroidNotificationDetails(
        'aadab_notifications',
        'Aadab Notifications',
        channelDescription: 'Important notifications from Aadab app',
        importance: Importance.high,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(
          message.notification!.android!.sound!.split('.').first,
        ),
        styleInformation: BigTextStyleInformation(
          message.notification?.body ?? '',
          htmlFormatBigText: true,
          contentTitle: message.notification?.title,
          htmlFormatContentTitle: true,
        ),
      );
    }

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
      message.notification?.title ?? 'Aadab',
      message.notification?.body ?? 'You have a new notification',
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

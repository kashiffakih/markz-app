import 'package:aadab/core/services/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/auth_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/notification_pr.dart';
import 'package:aadab/core/providers/order_pr.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/core/providers/review_pr.dart';
import 'package:aadab/core/providers/coupon_pr.dart';
import 'package:aadab/core/providers/user_address_pr.dart';
import 'package:aadab/core/providers/user_wallet_pr.dart';
import 'package:aadab/core/providers/wish_list_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/root_p.dart';
import 'package:aadab/ui/routing/router.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/deeplink/deep_link_listener.dart';
// import 'package:aadab/ui/views/home/home_p.dart';

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi();
  // await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseMessaging _messaging;
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late final AndroidNotificationChannel channel;

  @override
  void initState() {
    super.initState();

    // Initialize the notification channel and plugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    // Create the channel on the device
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Foreground message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.data}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/launcher_icon', // Ensure this is correct
              playSound: true,
              enableVibration: true,
            ),
          ),
        );
      }
    });

    // Message opened while app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification opened with app in background: ${message.data}");
      _handleNotificationNavigation(message);
    });
  }

  void _handleNotificationNavigation(RemoteMessage message) {
    // TODO: Implement navigation logic based on notification data
    // Example:
    // final data = message.data;
    // if (data['route'] != null) {
    //   Navigator.of(context).pushNamed(data['route']);
    // }
    print('Handle notification navigation: ${message.data}');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConfigModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddToCartModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => WishListModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserAddressModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CouponModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserWalletModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateRoute,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: Theme.of(context).textTheme.copyWith(
                titleLarge: MyGoogleFontStyle(),
                // This is used by the text boxes
                titleMedium: MyGoogleFontStyle(),
                titleSmall: MyGoogleFontStyle(),
                labelSmall: MyGoogleFontStyle(),
                labelMedium: MyGoogleFontStyle(),
                labelLarge: MyGoogleFontStyle(),
                bodySmall: MyGoogleFontStyle(),
              ),
        ),
        home: DeepLinkListener(
          child: RootPage(),
        ),
      ),
    );
  }
}

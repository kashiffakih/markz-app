import 'package:aadab/core/services/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
import 'package:aadab/core/services/connectivity_service.dart';
import 'package:aadab/ui/widgets/network_aware_widget.dart';
import 'package:aadab/ui/widgets/network_status_overlay.dart';

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize Firebase notifications
  final firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();
  
  // Initialize connectivity service before running the app
  final connectivityService = ConnectivityService();
  await connectivityService.initialize();
  
  // Small delay to ensure service is ready
  await Future.delayed(Duration(milliseconds: 100));
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    
    // Set up notification tap callback
    FirebaseApi.onNotificationTap = _handleNotificationData;

    // Handle notifications when app is opened from terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationNavigation(message);
      }
    });

    // Handle notifications when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message);
    });
  }

  void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;
    debugPrint('Handle notification navigation: ${message.data}');
    _handleNotificationData(data);
  }
  
  void _handleNotificationData(Map<String, dynamic> data) {
    if (_navigatorKey.currentState == null) return;
    
    // Handle different notification types
    if (data['type'] != null) {
      switch (data['type']) {
        case 'order':
          if (data['orderId'] != null) {
            _navigatorKey.currentState!.pushNamed(
              '/orderDetailsPage',
              arguments: data['orderId'],
            );
          }
          break;
        case 'promotion':
          _navigatorKey.currentState!.pushNamed('/promocodes');
          break;
        case 'product':
          if (data['productId'] != null) {
            _navigatorKey.currentState!.pushNamed(
              '/productIdPage',
              arguments: data['productId'],
            );
          }
          break;
        default:
          // Default route handling
          if (data['route'] != null) {
            _navigatorKey.currentState!.pushNamed(data['route']);
          }
      }
    } else if (data['route'] != null) {
      // Fallback to route if no type specified
      _navigatorKey.currentState!.pushNamed(data['route']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthModel()),
        ChangeNotifierProvider(create: (_) => ConfigModel()),
        ChangeNotifierProvider(create: (_) => ProductModel()),
        ChangeNotifierProvider(create: (_) => AddToCartModel()),
        ChangeNotifierProvider(create: (_) => OrderModel()),
        ChangeNotifierProvider(create: (_) => WishListModel()),
        ChangeNotifierProvider(create: (_) => ReviewModel()),
        ChangeNotifierProvider(create: (_) => UserAddressModel()),
        ChangeNotifierProvider(create: (_) => NotificationModel()),
        ChangeNotifierProvider(create: (_) => CouponModel()),
        ChangeNotifierProvider(create: (_) => UserWalletModel()),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateRoute,
        theme: ThemeData(
          primarySwatch:
              Colors.blue, // Fixed typo: primary свиш -> primarySwatch
          textTheme: Theme.of(context).textTheme.copyWith(
                titleLarge: MyGoogleFontStyle(),
                titleMedium: MyGoogleFontStyle(),
                titleSmall: MyGoogleFontStyle(),
                labelSmall: MyGoogleFontStyle(),
                labelMedium: MyGoogleFontStyle(),
                labelLarge: MyGoogleFontStyle(),
                bodySmall: MyGoogleFontStyle(),
              ),
        ),
        home: NetworkAwareWidget(
          child: NetworkStatusOverlay(
            child: DeepLinkListener(
              child: RootPage(),
            ),
          ),
        ),
      ),
    );
  }
}

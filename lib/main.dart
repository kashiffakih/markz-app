import 'package:firebase_core/firebase_core.dart';
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
// import 'package:aadab/ui/views/home/home_p.dart';

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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

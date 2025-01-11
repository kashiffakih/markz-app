import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/auth_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/notification_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/core/providers/product_pr.dart';
import 'package:sales_app/core/providers/review_pr.dart';
import 'package:sales_app/core/providers/coupon_pr.dart';
import 'package:sales_app/core/providers/user_address_pr.dart';
import 'package:sales_app/core/providers/user_wallet_pr.dart';
import 'package:sales_app/core/providers/wish_list_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/root_p.dart';
import 'package:sales_app/ui/routing/router.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/deeplink/deep_link_listener.dart';
// import 'package:sales_app/ui/views/home/home_p.dart';

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

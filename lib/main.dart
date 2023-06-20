import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/auth_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/product_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/routing/router.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

void main() {
  setupLocator();
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
      ),
    );
  }
}

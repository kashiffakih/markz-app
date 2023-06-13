import 'package:flutter/material.dart';
import 'package:sales_app/ui/routing/routes.dart';
import 'package:sales_app/ui/views/auth/login_p.dart';

// Auth
import 'package:sales_app/ui/root_p.dart';
import 'package:sales_app/ui/views/auth/register_p.dart';
import 'package:sales_app/ui/views/auth/splash_p.dart';
import 'package:sales_app/ui/views/auth/splash_2_p.dart';
import 'package:sales_app/ui/views/auth/update_app_p.dart';
import 'package:sales_app/ui/views/all_pages_p.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case root:
      return MaterialPageRoute(builder: (BuildContext context) {
        return RootPage();
      });
    case updateApp:
      return MaterialPageRoute(builder: (BuildContext context) {
        return UpdateAppPage();
      });
    case allPages:
      return MaterialPageRoute(builder: (BuildContext context) {
        return AllPagesPage();
      });
    case splashPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return SplashPage();
      });
    case splash2Page:
      return MaterialPageRoute(builder: (BuildContext context) {
        return Splash2Page();
      });
    case loginPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      });
    case registerPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return RegisterPage();
      });

    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return RootPage();
      });
  }
}

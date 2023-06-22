import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/product_pr.dart';
import 'package:sales_app/ui/routing/routes.dart';
import 'package:sales_app/ui/views/auth/change-password.dart';
import 'package:sales_app/ui/views/auth/forgot-password.dart';
import 'package:sales_app/ui/views/auth/login_p.dart';

// Auth
import 'package:sales_app/ui/root_p.dart';
import 'package:sales_app/ui/views/auth/password_changed_p.dart';
import 'package:sales_app/ui/views/auth/register_p.dart';
import 'package:sales_app/ui/views/auth/splash_p.dart';
import 'package:sales_app/ui/views/auth/splash_2_p.dart';
import 'package:sales_app/ui/views/auth/update_app_p.dart';
import 'package:sales_app/ui/views/all_pages_p.dart';
import 'package:sales_app/ui/views/checkout/cart_p.dart';
import 'package:sales_app/ui/views/checkout/checkout_p.dart';
import 'package:sales_app/ui/views/home/home_p.dart';
import 'package:sales_app/ui/views/products/product_id_p.dart';
import 'package:sales_app/ui/views/products/products_p.dart';

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
    case forgotPasswordPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ForgotPasswordPage();
      });
    case changePasswordPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ChangePasswordPage(
          arguments: null,
        );
      });
    case successPasswordPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return PasswordChangesPage();
      });
    case homePage:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<ProductModel>(context, listen: false).getProduct();
        Provider.of<ProductModel>(context, listen: false).getCategories();
        return HomePage();
      });
    case productPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ProductsPage(
          arguments: null,
        );
      });
    case productIdPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ProductIdPage();
      });
    case cartPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return CartPage();
      });
    case checkoutPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return CheckoutPage();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return RootPage();
      });
  }
}

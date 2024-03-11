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
import 'package:sales_app/ui/views/checkout/success_p.dart';
import 'package:sales_app/ui/views/home/home_p.dart';
import 'package:sales_app/ui/views/products/product_id_p.dart';
import 'package:sales_app/ui/views/products/products_p.dart';
import 'package:sales_app/ui/views/products/shops_p.dart';
import 'package:sales_app/ui/views/profile/address_p.dart';
import 'package:sales_app/ui/views/profile/contact_p.dart';
import 'package:sales_app/ui/views/profile/notifications_p.dart';
import 'package:sales_app/ui/views/profile/order-details-processing.dart';
import 'package:sales_app/ui/views/profile/orders_p.dart';
import 'package:sales_app/ui/views/profile/profile_p.dart';
import 'package:sales_app/ui/views/profile/refund-policy_p.dart';
import 'package:sales_app/ui/views/profile/review_id_p.dart';
import 'package:sales_app/ui/views/profile/reviews_p.dart';
import 'package:sales_app/ui/views/profile/rewards_p.dart';
import 'package:sales_app/ui/views/profile/setting_id.dart';
import 'package:sales_app/ui/views/profile/settings_p.dart';
import 'package:sales_app/ui/views/profile/shipping_create_p.dart';
import 'package:sales_app/ui/views/profile/shipping_id_p.dart';
import 'package:sales_app/ui/views/profile/terms-condition_p.dart';
import 'package:sales_app/ui/views/profile/wishlist_p.dart';
import 'package:sales_app/ui/widgets/menu-drawer.dart';

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
        // Provider.of<ProductModel>(context, listen: false).getProduct();
        // Provider.of<ProductModel>(context, listen: false).getCategories();
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
        return ProductIdPage(
          arguments: {},
        );
      });
    case cartPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return CartPage();
      });
    case checkoutPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return CheckoutPage();
      });
    case successPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return SuccessPage();
      });
    case profilePage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ProfilePage();
      });
    case notificationPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return NotificationsPage();
      });
    case ordersPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return OrdersPage();
      });
    case orderDetailsPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return OrderDetailsPage();
      });
    case addressPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return AddressPage(
            // arguments: null,
            );
      });

    case wishlistPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return WishlistPage();
      });
    case reviewsPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ReviewsPage();
      });
    case reviewUpdatePage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ReviewUpdatePage(
          arguments: null,
        );
      });
    case shippingCreatePage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ShippingCreatePage();
      });
    case shippingUpdatePage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ShippingUpdatePage(
          arguments: null,
        );
      });
    case settingsPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return SettingsPage();
      });
    case settingUpdatePage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return SettingUpdatePage(
          arguments: null,
        );
      });
    case rewardsPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return RewardsPage();
      });
    case contactPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ContactPage();
      });
    case menuWidget:
      return MaterialPageRoute(builder: (BuildContext context) {
        return MenuWidget();
      });
    case shopsPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ShopsPage();
      });
    case refundPolicyPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return RefundPolicyPage();
      });
    case termAndConditionPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return TermsAndConditionsPage();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return RootPage();
      });
  }
}

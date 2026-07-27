import 'package:flutter/material.dart';
import 'package:aadab/ui/routing/routes.dart';
import 'package:aadab/ui/views/auth/change-password.dart';
import 'package:aadab/ui/views/auth/forgot-password.dart';
import 'package:aadab/ui/views/auth/login_p.dart';

// Auth
import 'package:aadab/ui/root_p.dart';
import 'package:aadab/ui/views/auth/password_changed_p.dart';
import 'package:aadab/ui/views/auth/register_p.dart';
import 'package:aadab/ui/views/auth/splash_p.dart';
import 'package:aadab/ui/views/auth/splash_2_p.dart';
import 'package:aadab/ui/views/auth/update_app_p.dart';
import 'package:aadab/ui/views/all_pages_p.dart';
import 'package:aadab/ui/views/checkout/cart_p.dart';
import 'package:aadab/ui/views/checkout/checkout_p.dart';
import 'package:aadab/ui/views/checkout/success_p.dart';
import 'package:aadab/ui/views/home/home_p.dart';
import 'package:aadab/ui/views/products/product_id_p.dart';
import 'package:aadab/ui/views/products/products_p.dart';
import 'package:aadab/ui/views/products/shops_p.dart';
import 'package:aadab/ui/views/profile/address_p.dart';
import 'package:aadab/ui/views/profile/contact_p.dart';
import 'package:aadab/ui/views/profile/notifications_p.dart';
import 'package:aadab/ui/views/profile/order-details-processing.dart';
import 'package:aadab/ui/views/profile/orders_p.dart';
import 'package:aadab/ui/views/profile/profile_p.dart';
import 'package:aadab/ui/views/profile/refund-policy_p.dart';
import 'package:aadab/ui/views/profile/review_id_p.dart';
import 'package:aadab/ui/views/profile/reviews_p.dart';
import 'package:aadab/ui/views/profile/rewards_p.dart';
import 'package:aadab/ui/views/profile/setting_id.dart';
import 'package:aadab/ui/views/profile/settings_p.dart';
import 'package:aadab/ui/views/profile/shipping_create_p.dart';
import 'package:aadab/ui/views/profile/shipping_id_p.dart';
import 'package:aadab/ui/views/profile/terms-condition_p.dart';
import 'package:aadab/ui/views/profile/wishlist_p.dart';
import 'package:aadab/ui/views/promocodes/promocodes_p.dart';
import 'package:aadab/ui/widgets/menu-drawer.dart';
import 'package:aadab/ui/widgets/multi_image_w.dart';
import 'package:aadab/ui/views/network/no_network_page.dart';
import 'package:aadab/ui/views/permissions/permissions_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case root:
      return MaterialPageRoute(builder: (BuildContext context) {
        return RootPage();
      });
    case updateApp:
      return MaterialPageRoute(builder: (BuildContext context) {
        return UpdateAppPage(
          arguments: settings.arguments as Map<String, dynamic>?,
        );
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
        return LoginPage(
          argument: settings.arguments,
        );
      });
    case registerPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return RegisterPage(
          argument: settings.arguments,
        );
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
        return CartPage(
          isProfile: settings.arguments as bool?,
        );
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
        return OrdersPage(
          isProfile: settings.arguments as bool?,
        );
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
        return ReviewsPage(
          arguments: settings.arguments,
        );
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
    case multipleImages:
      return MaterialPageRoute(builder: (BuildContext context) {
        return MultipleImageUploadPage();
      });
    case promocodes:
      return MaterialPageRoute(builder: (BuildContext context) {
        return PromocodesPage();
      });
    case noNetworkPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return NoNetworkPage();
      });
    case permissionsPage:
      return MaterialPageRoute(builder: (BuildContext context) {
        return PermissionsPage();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return RootPage();
      });
  }
}

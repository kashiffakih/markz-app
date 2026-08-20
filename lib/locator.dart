import 'package:get_it/get_it.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/services/add_to_cart_s.dart';
import 'package:aadab/core/services/auth_s.dart';
import 'package:aadab/core/services/config_s.dart';
import 'package:aadab/core/services/notification_s.dart';
import 'package:aadab/core/services/order_s.dart';
import 'package:aadab/core/services/product_s.dart';
import 'package:aadab/core/services/review_s.dart';
import 'package:aadab/core/services/user_address_s.dart';
import 'package:aadab/core/services/user_wallet_s.dart';
import 'package:aadab/core/services/wish_list_s.dart';
import 'package:aadab/core/services/coupon_s.dart';
import 'package:aadab/core/services/phonepe_s.dart';
import 'package:aadab/core/services/product_notification_s.dart';
import 'package:aadab/core/services/invoice_service.dart';
import 'package:aadab/core/services/favourite_wholesaler_s.dart';
import 'package:aadab/core/services/offline_order_s.dart';
// import 'package:aadab/core/services/delhivery_s.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ConfigService());
  locator.registerLazySingleton(() => ConfigModel());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => ProductService());
  locator.registerLazySingleton(() => AddToCartService());
  locator.registerLazySingleton(() => OrderService());
  locator.registerLazySingleton(() => WishListService());
  locator.registerLazySingleton(() => ReviewService());
  locator.registerLazySingleton(() => UserAddressService());
  locator.registerLazySingleton(() => CouponService());
  locator.registerLazySingleton(() => UserWalletService());
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => PhonePeService());
  locator.registerLazySingleton(() => ProductNotificationService());
  locator.registerLazySingleton(() => InvoiceService());
  locator.registerLazySingleton(() => FavouriteWholesalerService());
  locator.registerLazySingleton(() => OfflineOrderService());
  // locator.registerLazySingleton(() => DelhiveryService());
}

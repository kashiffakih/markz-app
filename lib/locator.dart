import 'package:get_it/get_it.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/services/add_to_cart_s.dart';
import 'package:sales_app/core/services/auth_s.dart';
import 'package:sales_app/core/services/config_s.dart';
import 'package:sales_app/core/services/notification_s.dart';
import 'package:sales_app/core/services/order_s.dart';
import 'package:sales_app/core/services/product_s.dart';
import 'package:sales_app/core/services/review_s.dart';
import 'package:sales_app/core/services/user_address_s.dart';
import 'package:sales_app/core/services/wish_list_s.dart';

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
  locator.registerLazySingleton(() => NotificationService());
}

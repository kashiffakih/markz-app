import 'package:get_it/get_it.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/services/auth_s.dart';
import 'package:sales_app/core/services/config_s.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ConfigService());
  locator.registerLazySingleton(() => ConfigModel());
  locator.registerLazySingleton(() => AuthService());
}

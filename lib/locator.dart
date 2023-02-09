import 'package:get_it/get_it.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/services/analytics_s.dart';
import 'package:sales_app/core/services/attendance_s.dart';
import 'package:sales_app/core/services/auth_s.dart';
import 'package:sales_app/core/services/config_s.dart';
import 'package:sales_app/core/services/device_info_s.dart';
import 'package:sales_app/core/services/location_s.dart';
import 'package:sales_app/core/services/notice_s.dart';
import 'package:sales_app/core/services/profile_s.dart';
import 'package:sales_app/core/services/profiles_s.dart';
import 'package:sales_app/core/services/visitor_s.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ConfigService());
  locator.registerLazySingleton(() => ConfigModel());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => AttendanceService());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => DeviceInfoService());
  locator.registerLazySingleton(() => NoticeService());
  locator.registerLazySingleton(() => ProfileService());
  locator.registerLazySingleton(() => VisitorService());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => ProfilesService());
}

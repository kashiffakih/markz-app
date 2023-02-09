import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/kpi_report.dart';
import 'package:sales_app/core/providers/attendance_pr.dart';
import 'package:sales_app/core/providers/device_info_pr.dart';
import 'package:sales_app/core/providers/location_pr.dart';
import 'package:sales_app/core/providers/notice_pr.dart';
import 'package:sales_app/core/providers/profile_pr.dart';
import 'package:sales_app/core/providers/profiles_pr.dart';
import 'package:sales_app/ui/routing/routes.dart';

// Auth
import 'package:sales_app/ui/views/auth/login_p.dart';
import 'package:sales_app/ui/root_p.dart';
import 'package:sales_app/ui/views/auth/update_app_p.dart';

// Dashboard
import 'package:sales_app/ui/views/dashboard/home_p.dart';
import 'package:sales_app/ui/views/dashboard/dashboard_p.dart';

// Attendance
import 'package:sales_app/ui/views/attendance/attendance_p.dart';

import 'package:sales_app/ui/views/profile/profile_p.dart';
import 'package:sales_app/ui/views/profiles/profile_create_p.dart';
import 'package:sales_app/ui/views/profiles/profile_id_p.dart';
import 'package:sales_app/ui/views/profiles/profiles_p.dart';
import 'package:sales_app/ui/views/reports/kpi_report_p.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case root:
      return MaterialPageRoute(builder: (BuildContext context) {
        return RootPage();
      });
    case home:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<NoticeModel>(context, listen: false).getNotices();
        // final ConfigModel _configModel = locator<ConfigModel>();
        // if (_configModel.user.imagePath == null || _configModel.user.phone == 0)
        //   return ProfilePage();
        return HomePage();
      });
    // Auth
    case login:
      return MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      });
    case updateApp:
      return MaterialPageRoute(builder: (BuildContext context) {
        return UpdateAppPage();
      });
    // Dashboard
    case dashboard:
      return MaterialPageRoute(builder: (BuildContext context) {
        return DashboardPage();
      });
    // Attendance
    case attendance:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<AttendanceModel>(context, listen: false).getSessionTypes();
        DateFormat dateFormat = DateFormat('yyyy-MM-dd');
        Provider.of<AttendanceModel>(context, listen: false).getAttendance(
          date: dateFormat.format(DateTime.now()),
        );
        Provider.of<LocationModel>(context, listen: false).getCurrentLocation();
        Provider.of<DeviceInfoModel>(context, listen: false).getBatteryLevel();
        return AttendancePage();
      });
    // Profile
    case profile:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ProfilePage();
      });
    // Profiles
    case profiles:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<ProfilesModel>(context, listen: false).getProfiles();
        return ProfilesPage();
      });
    case profileCreate:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ProfileCreatePage(
          arguments: settings.arguments, // profile
        );
      });
    case profileId:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ProfileIdPage(
          arguments: settings.arguments, // profile
        );
      });
    case kpiReport:
      return MaterialPageRoute(builder: (BuildContext context) {
        return KpiReportPage();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return DashboardPage();
      });
  }
}

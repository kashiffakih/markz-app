import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/analytics_pr.dart';
import 'package:sales_app/core/providers/attendance_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/device_info_pr.dart';
import 'package:sales_app/core/providers/location_pr.dart';
import 'package:sales_app/core/providers/notice_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';
import 'package:sales_app/core/providers/sku_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/routing/routes.dart';

// Auth
import 'package:sales_app/ui/views/auth/login_p.dart';
import 'package:sales_app/ui/root_p.dart';
import 'package:sales_app/ui/views/damage_stocks/damage_stocks_create_p.dart';
import 'package:sales_app/ui/views/damage_stocks/damage_stocks_p.dart';

// Dashboard
import 'package:sales_app/ui/views/dashboard/home_p.dart';
import 'package:sales_app/ui/views/dashboard/dashboard_p.dart';

// Attendance
import 'package:sales_app/ui/views/attendance/attendance_p.dart';
import 'package:sales_app/ui/views/attendance/attendance_calendar_p.dart';
import 'package:sales_app/ui/views/notifications/notification_p.dart';

// Order Bookings
import 'package:sales_app/ui/views/order_bookings/beat_outlets_p.dart';
import 'package:sales_app/ui/views/order_bookings/beats_p.dart';
import 'package:sales_app/ui/views/order_bookings/order_p.dart';
import 'package:sales_app/ui/views/order_bookings/confirm_order_p.dart';
import 'package:sales_app/ui/views/order_bookings/outlet_details_p.dart';
import 'package:sales_app/ui/views/order_details/order_detail_items_p.dart';
import 'package:sales_app/ui/views/order_details/order_details_p.dart';
import 'package:sales_app/ui/views/profile/profile_p.dart';
import 'package:sales_app/ui/views/reports/daily_order_summary_p.dart';

// Target vs Achieved
import 'package:sales_app/ui/views/reports/target_vs_achieved_p.dart';

//Sale Trends
import 'package:sales_app/ui/views/reports/sale_tends_p.dart';

// Billed Outlets
import 'package:sales_app/ui/views/reports/billed_outlets_p.dart';

// Invoice Details
import 'package:sales_app/ui/views/invoice_details/invoice_details_p.dart';

// Products Master
import 'package:sales_app/ui/views/products/products_master_p.dart';
import 'package:sales_app/ui/views/products/scheme_products_p.dart';

// Day Summary
import 'package:sales_app/ui/views/reports/day_summary_p.dart';

// FAQs
import 'package:sales_app/ui/views/faqs/faqs_p.dart';

// KPI Report
import 'package:sales_app/ui/views/reports/kpi_report_p.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case root:
      return MaterialPageRoute(builder: (BuildContext context) {
        return RootPage();
      });
    case home:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<AnalyticsModel>(context, listen: false).getDaySummary();
        Provider.of<NoticeModel>(context, listen: false).getNotices();
        final ConfigModel _configModel = locator<ConfigModel>();
        if (_configModel.user.imagePath == null || _configModel.user.phone == 0)
          return ProfilePage();
        return HomePage();
      });
    // Auth
    case login:
      return MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
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
    case attendanceCalendar:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<AnalyticsModel>(context, listen: false)
            .getAttendanceCalendar();
        return AttendanceCalendarPage();
      });
    // Order Bookings
    case beats:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<ReferencePlanModel>(context, listen: false)
            .getReferencePlans();
        Provider.of<SkuModel>(context, listen: false).getSkus();
        return BeatsPage();
      });
    case beatOutlets:
      return MaterialPageRoute(builder: (BuildContext context) {
        return BeatOutletsPage(
          arguments: settings.arguments,
        );
      });
    case outletDetails:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<OrderModel>(context, listen: false).getReasons();

        return OutletDetailsPage(
          arguments: settings.arguments,
        );
      });
    case order:
      return MaterialPageRoute(builder: (BuildContext context) {
        return OrderPage(
          arguments: settings.arguments,
        );
      });
    case confirmOrder:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ConfirmOrderPage(
          arguments: settings.arguments,
        );
      });
    // Target vs Achieved
    case targetVsAchieved:
      return MaterialPageRoute(builder: (BuildContext context) {
        final _analyticsModel =
            Provider.of<AnalyticsModel>(context, listen: false);
        _analyticsModel.getTargetVsAchieved();
        return TargetVsAchievedPage();
      });
    // Sale Trends
    case saleTrends:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<AnalyticsModel>(context, listen: false).getSalesTrend();
        return SaleTrendsPage();
      });
    // Billed Outlets
    case billedOutlets:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<AnalyticsModel>(context, listen: false).getBilledOutlet();
        return BilledOutletsPage();
      });
    // Order Details
    case orderDetails:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<OrderModel>(context, listen: false).fetchOrdersOfToday();
        return OrderDetailsPage();
      });
    // Order Detail Items
    case orderDetailItems:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<OrderModel>(context, listen: false).fetchOrdersOfToday();
        return OrderDetailItemsPage(
          arguments: settings.arguments,
        );
      });
    // Invoice Details
    case invoiceDetails:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<AnalyticsModel>(context, listen: false).getInvoiceDetail();
        return InvoiceDetailsPage();
      });
    // Products Master
    case productsMaster:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<SkuModel>(context, listen: false).getSkus();
        return ProductsMasterPage();
      });
    case schemeProducts:
      return MaterialPageRoute(builder: (BuildContext context) {
        return SchemeProductsPage();
      });
    // Day Summary
    case daySummary:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<AnalyticsModel>(context, listen: false).getDaySummary();
        return DaySummaryPage();
      });
    case dailyOrderSummary:
      return MaterialPageRoute(builder: (BuildContext context) {
        return DailyOrderSummaryPage();
      });
    // FAQs
    case faqs:
      return MaterialPageRoute(builder: (BuildContext context) {
        return FaqsPage();
      });
    // KPI Report
    case kpiReport:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<AnalyticsModel>(context, listen: false).getKpiReport();
        return KpiReportPage();
      });
    // Notifications
    case notifications:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<NoticeModel>(context, listen: false).getNotices();
        return NotificationsPage();
      });
    // Profile
    case profile:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ProfilePage();
      });
    // Damage Stocks
    case damageStocks:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<SkuModel>(context, listen: false).getSkus();
        return DamageStocksPage();
      });
    case damageStocksCreate:
      return MaterialPageRoute(builder: (BuildContext context) {
        return DamageStocksCreatePage();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return DashboardPage();
      });
  }
}

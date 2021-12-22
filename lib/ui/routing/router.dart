import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/analytics_pr.dart';
import 'package:sales_app/core/providers/asset_pr.dart';
import 'package:sales_app/core/providers/attendance_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/course_pr.dart';
import 'package:sales_app/core/providers/daily_photo_pr.dart';
import 'package:sales_app/core/providers/device_info_pr.dart';
import 'package:sales_app/core/providers/location_pr.dart';
import 'package:sales_app/core/providers/manufacturer_pr.dart';
import 'package:sales_app/core/providers/notice_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';
import 'package:sales_app/core/providers/requisition_pr.dart';
import 'package:sales_app/core/providers/sku_availability_pr.dart';
import 'package:sales_app/core/providers/sku_pr.dart';
import 'package:sales_app/core/providers/visitor_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/routing/routes.dart';
import 'package:sales_app/ui/views/asset_tracking/asset_beat_outlets_p.dart';
import 'package:sales_app/ui/views/asset_tracking/asset_beats_p.dart';
import 'package:sales_app/ui/views/asset_tracking/asset_create_p.dart';
import 'package:sales_app/ui/views/asset_tracking/asset_edit_p.dart';
import 'package:sales_app/ui/views/asset_tracking/asset_images_p.dart';
import 'package:sales_app/ui/views/asset_tracking/asset_status/asset_status_create_p.dart';
import 'package:sales_app/ui/views/asset_tracking/assets_p.dart';

// Auth
import 'package:sales_app/ui/views/auth/login_p.dart';
import 'package:sales_app/ui/root_p.dart';
import 'package:sales_app/ui/views/auth/update_app_p.dart';
import 'package:sales_app/ui/views/daily_photos/daily_photos_create_p.dart';
import 'package:sales_app/ui/views/daily_photos/daily_photos_p.dart';
import 'package:sales_app/ui/views/damage_stocks/damage_stocks_create_p.dart';
import 'package:sales_app/ui/views/damage_stocks/damage_stocks_p.dart';

// Dashboard
import 'package:sales_app/ui/views/dashboard/home_p.dart';
import 'package:sales_app/ui/views/dashboard/dashboard_p.dart';

// Attendance
import 'package:sales_app/ui/views/attendance/attendance_p.dart';
import 'package:sales_app/ui/views/attendance/attendance_calendar_p.dart';
import 'package:sales_app/ui/views/new_visitors/new_visitor_create_p.dart';
import 'package:sales_app/ui/views/new_visitors/new_visitor_details_p.dart';
import 'package:sales_app/ui/views/new_visitors/new_visitors_p.dart';
import 'package:sales_app/ui/views/notifications/notification_p.dart';

// Order Bookings
import 'package:sales_app/ui/views/order_bookings/beat_outlets_p.dart';
import 'package:sales_app/ui/views/order_bookings/beats_p.dart';
import 'package:sales_app/ui/views/order_bookings/order_p.dart';
import 'package:sales_app/ui/views/order_bookings/confirm_order_p.dart';
import 'package:sales_app/ui/views/order_bookings/outlet_details_p.dart';
import 'package:sales_app/ui/views/order_details/order_detail_items_p.dart';
import 'package:sales_app/ui/views/order_details/order_details_p.dart';
import 'package:sales_app/ui/views/productivity/productivity_create_p.dart';
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
import 'package:sales_app/ui/views/shelf_analysis/shelf_beat_outlets_p.dart';
import 'package:sales_app/ui/views/shelf_analysis/shelf_beats_p.dart';
import 'package:sales_app/ui/views/shelf_analysis/shelfs_p.dart';
import 'package:sales_app/ui/views/sku_tracking/sku_availability_p.dart';
import 'package:sales_app/ui/views/sku_tracking/sku_beat_outlets_p.dart';
import 'package:sales_app/ui/views/sku_tracking/sku_beats_p.dart';
import 'package:sales_app/ui/views/stocks/%20stock_beats_p.dart';
import 'package:sales_app/ui/views/stocks/stock_beat_outlets_p.dart';
import 'package:sales_app/ui/views/stocks/stock_report_p.dart';
import 'package:sales_app/ui/views/training_videos/training_video_list_p.dart';
import 'package:sales_app/ui/views/training_videos/training_videos_p.dart';
import 'package:sales_app/ui/views/visitors/visitor_create_1_p.dart';
import 'package:sales_app/ui/views/visitors/visitor_id_p.dart';
import 'package:sales_app/ui/views/visitors/visitors_p.dart';

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
        return BeatsPage(
          arguments: settings.arguments, // tag (Visitors));
        );
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
    // Asset Tracking
    case assetBeats:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<ReferencePlanModel>(context, listen: false)
            .getReferencePlans();
        Provider.of<SkuModel>(context, listen: false).getSkus();
        return AssetBeatsPage();
      });
    case assetBeatOutlets:
      return MaterialPageRoute(builder: (BuildContext context) {
        return AssetBeatOutletsPage(
          arguments: settings.arguments,
        );
      });
    case assets:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<AssetModel>(context, listen: false).getAssets();
        return AssetsPage(
          arguments: settings.arguments, // beat, outlet
        );
      });
    case assetCreate:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<ManufacturerModel>(context, listen: false)
            .getManufacturers();
        return AssetCreatePage(
          arguments: settings.arguments,
        );
      });
    case assetEdit:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<ManufacturerModel>(context, listen: false)
            .getManufacturers();
        return AssetEditPage(
          arguments: settings.arguments, // asset // beat // outlet
        );
      });
    case assetImages:
      return MaterialPageRoute(builder: (BuildContext context) {
        return AssetImagesPage(
          arguments: settings.arguments, // asset // beat // outlet
        );
      });
    case assetStatusCreate:
      return MaterialPageRoute(builder: (BuildContext context) {
        return AssetStatusCreatePage(
          arguments: settings.arguments, // asset
        );
      });
    // Shelf Analysis
    case shelfBeats:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<ReferencePlanModel>(context, listen: false)
            .getReferencePlans();
        Provider.of<SkuModel>(context, listen: false).getSkus();
        return ShelfBeatsPage();
      });

    case shelfBeatOutlets:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ShelfBeatOutletsPage(
          arguments: settings.arguments,
        );
      });
    case shelfs:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<AssetModel>(context, listen: false).getAssets();
        return ShelfsPage(
          arguments: settings.arguments, // beat, outlet
        );
      });
    case shelfCreate:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<ManufacturerModel>(context, listen: false)
            .getManufacturers();
        return AssetCreatePage(
          arguments: settings.arguments,
        );
      });
    // Sku Tracking
    case skuBeats:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<ReferencePlanModel>(context, listen: false)
            .getReferencePlans();
        Provider.of<SkuModel>(context, listen: false).getSkus();
        return SkuBeatsPage();
      });
    case skuBeatOutlets:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<ReferencePlanModel>(context, listen: false)
            .getReferencePlans();
        Provider.of<SkuModel>(context, listen: false).getSkus();
        return SkuBeatOutletsPage(
          arguments: settings.arguments,
        );
      });
    case skuAvailabilities:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<SkuAvailabilityModel>(context, listen: false)
            .getSkuAvailabilities(
                retailerId: (settings.arguments as Map)['outlet'].id);
        return SkuAvailabilityPage(
          arguments: settings.arguments, // beat, outlet
        );
      });
    // Stock Report
    case stockBeats:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<ReferencePlanModel>(context, listen: false)
            .getReferencePlans();
        Provider.of<SkuModel>(context, listen: false).getSkus();
        return StockBeatsPage();
      });
    case stockBeatOutlets:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<ReferencePlanModel>(context, listen: false)
            .getReferencePlans();
        Provider.of<SkuModel>(context, listen: false).getSkus();
        return StockBeatOutletsPage(
          arguments: settings.arguments,
        );
      });
    case stockReport:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<SkuAvailabilityModel>(context, listen: false)
            .getSkuAvailabilities(
                retailerId: (settings.arguments as Map)['outlet'].id);
        return StockReportPage(
          arguments: settings.arguments, // beat, outlet
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
        Provider.of<ReferencePlanModel>(context, listen: false)
            .getReferencePlans();
        return DamageStocksCreatePage();
      });
    case dailyPhotos:
      return MaterialPageRoute(builder: (BuildContext context) {
        DateFormat dateFormat = DateFormat('yyyy-MM-dd');
        Provider.of<DailyPhotoModel>(context, listen: false).getDailyPhotos(
          date: dateFormat.format(DateTime.now()),
        );
        return DailyPhotosPage();
      });
    case dailyPhotosCreate:
      return MaterialPageRoute(builder: (BuildContext context) {
        // Provider.of<DailyPhotoModel>(context, listen: false).getDailyPhotos()();
        return DailyPhotosCreatePage();
      });
    // Training Videos
    case trainingVideos:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<CourseModel>(context, listen: false).getCourses();
        return TrainingVideosPage();
      });
    case trainingVideoList:
      return MaterialPageRoute(builder: (BuildContext context) {
        return TrainingVideoListPage(
          course: (settings.arguments as Map)['course'],
        );
      });
    // Visitors
    case visitors:
      return MaterialPageRoute(builder: (BuildContext context) {
        Provider.of<RequisitionModel>(context, listen: false).getRequisitions();
        return VisitorsPage();
      });
    case visitorCreate:
      return MaterialPageRoute(builder: (BuildContext context) {
        return VisitorCreatePage();
      });
    case visitorId:
      return MaterialPageRoute(builder: (BuildContext context) {
        return VisitorIdPage(arguments: settings.arguments);
      });
    // New Visitors
    case newVisitors:
      return MaterialPageRoute(builder: (BuildContext context) {
        var retailerId = (settings.arguments as Map)['outlet'].id;
        Provider.of<VisitorModel>(context, listen: false)
            .getVisitors(retailerId: retailerId);
        return NewVisitorsPage(
          arguments: settings.arguments,
        );
      });
    case newVisitorCreate:
      return MaterialPageRoute(builder: (BuildContext context) {
        return NewVisitorCreatePage(
          arguments: settings.arguments,
        );
      });
    case newVisitorDetails:
      return MaterialPageRoute(builder: (BuildContext context) {
        return NewVisitorDetailsPage(
          arguments: settings.arguments, // visitor
        );
      });
    // Productivity
    case productivityCreate:
      return MaterialPageRoute(builder: (BuildContext context) {
        return ProductivityCreatePage();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return DashboardPage();
      });
  }
}

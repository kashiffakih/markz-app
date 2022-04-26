import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/customer_data_entry.dart';
import 'package:sales_app/core/providers/analytics_pr.dart';
import 'package:sales_app/core/providers/asset_pr.dart';
import 'package:sales_app/core/providers/attendance_pr.dart';
import 'package:sales_app/core/providers/auth_pr.dart';
import 'package:sales_app/core/providers/competitor_data_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/course_pr.dart';
import 'package:sales_app/core/providers/customer_data_entry_pr.dart';
import 'package:sales_app/core/providers/customer_pr.dart';
import 'package:sales_app/core/providers/daily_photo_pr.dart';
import 'package:sales_app/core/providers/device_info_pr.dart';
import 'package:sales_app/core/providers/location_pr.dart';
import 'package:sales_app/core/providers/manufacturer_pr.dart';
import 'package:sales_app/core/providers/my_order_pr.dart';
import 'package:sales_app/core/providers/notice_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/core/providers/profile_pr.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';
import 'package:sales_app/core/providers/requisition_pr.dart';
import 'package:sales_app/core/providers/sku_availability_pr.dart';
import 'package:sales_app/core/providers/sku_pr.dart';
import 'package:sales_app/core/providers/visitor_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/routing/router.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConfigModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AttendanceModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DeviceInfoModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReferencePlanModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SkuModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyOrderModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AnalyticsModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => NoticeModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AssetModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ManufacturerModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SkuAvailabilityModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DailyPhotoModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CourseModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => RequisitionModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => VisitorModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomerModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomerDataEntryModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CompetitorDataModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateRoute,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline1: TextStyle(
                    fontFamily: Font.primaryFont,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          textTheme: Theme.of(context).textTheme.copyWith(
                subtitle1: TextStyle(
                  fontFamily: Font.primaryFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                subtitle2: TextStyle(
                  fontFamily: Font.primaryFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                headline1: TextStyle(
                  fontFamily: Font.primaryFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                headline2: TextStyle(
                  fontFamily: Font.primaryFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                headline3: TextStyle(
                  fontFamily: Font.primaryFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                headline4: TextStyle(
                  fontFamily: Font.primaryFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                headline5: TextStyle(
                  fontFamily: Font.primaryFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                headline6: TextStyle(
                  fontFamily: Font.primaryFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                bodyText1: TextStyle(
                  fontFamily: Font.primaryFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                bodyText2: TextStyle(
                  fontFamily: Font.primaryFont,
                  fontSize: 18,
                  // fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

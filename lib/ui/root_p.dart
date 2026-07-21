import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/auth_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aadab/core/services/permission_service.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final PermissionService _permissionService = PermissionService();

  authenticateUser(_, AuthModel authModel, ConfigModel configModel) async {
    // configModel.getApiConfig(domain: 'http://192.168.0.105:9090');
    // configModel.getApiConfig(domain: 'http://localhost:7070');
    configModel.getApiConfig(domain: 'https://api.staging.aadab.online');
    // print(configModel.apiConfig['baseURL']);
    await configModel.fetchLoginData();

    String currentAppVersion = await getPackageDetails();

    if (configModel.loginData.isEmpty) {
      // Future.delayed(
      //   Duration.zero,
      //   () => Navigator.pushReplacementNamed(context, '/allPages'),
      // );
      Future.delayed(
        Duration.zero,
        () => Navigator.pushReplacementNamed(context, '/splash2Page'),
      );
    } else {
      await authModel.login(loginData: configModel.loginData);
      debugPrint('APP: $currentAppVersion');
      debugPrint('API: ${configModel.currentAndroidVersionFromApi}');

      if (configModel.isLoggedIn) {
        // if (currentAppVersion != configModel.currentAndroidVersionFromApi) {
        //   Navigator.pushReplacementNamed(context, '/updateApp');
        // } else {

        // Check if all permissions are granted
        bool allPermissionsGranted = await _permissionService
            .areAllPermissionsGranted();

        if (!allPermissionsGranted) {
          // Navigate to permissions page
          Future.delayed(Duration.zero, () async {
            final result = await Navigator.pushNamed(context, '/permissions');
            if (result == true) {
              // Permissions granted, navigate to home
              Navigator.pushReplacementNamed(context, '/homePage');
            } else {
              // Permissions not granted, stay on permissions page or show message
              Navigator.pushReplacementNamed(context, '/permissions');
            }
          });
        } else {
          // All permissions granted, navigate to home
          Future.delayed(
            Duration.zero,
            () => Navigator.pushReplacementNamed(context, '/homePage'),
          );
        }
        // }
      } else {
        Future.delayed(
          Duration.zero,
          () => Navigator.pushReplacementNamed(context, '/splash2Page'),
        );
      }
    }
  }

  getPackageDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

  launchUrlMethod(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final _authModel = Provider.of<AuthModel>(context, listen: false);
      final _configModel = locator<ConfigModel>();
      authenticateUser(context, _authModel, _configModel);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xffFFFDF7), Color(0xffFFF9E6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              // Logo with subtle animation effect
              Hero(
                tag: 'app_logo',
                child: Container(
                  width: 220,
                  height: 220,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffEED056).withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/aadab-logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 50),
              // Loading text with modern styling
              Text(
                'Loading...',
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff232323),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 20),
              // Modern progress bar
              Container(
                width: 220,
                height: 6,
                decoration: BoxDecoration(
                  color: Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xffEED056),
                    ),
                  ),
                ),
              ),
              Spacer(flex: 3),
              // Subtle branding footer
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    Text(
                      'Welcome to Aadab',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff909090),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your trusted shopping companion',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffAAAAAA),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

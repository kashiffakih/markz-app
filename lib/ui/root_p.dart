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
    // configModel.getApiConfig(domain: 'http://192.168.0.100:9090');
    // configModel.getApiConfig(domain: 'http://172.20.10.2:8089');
    // configModel.getApiConfig(domain: 'http://192.168.0.103:7070');
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
        bool allPermissionsGranted =
            await _permissionService.areAllPermissionsGranted();

        if (!allPermissionsGranted) {
          // Navigate to permissions page
          Future.delayed(
            Duration.zero,
            () async {
              final result = await Navigator.pushNamed(context, '/permissions');
              if (result == true) {
                // Permissions granted, navigate to home
                Navigator.pushReplacementNamed(context, '/homePage');
              } else {
                // Permissions not granted, stay on permissions page or show message
                Navigator.pushReplacementNamed(context, '/permissions');
              }
            },
          );
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 600,
                  child: Image.asset(
                    'assets/images/aadab-logo.png',
                  ),
                ),
                Text(
                  'Loading...',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    color: Color(0xff000000),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Color(0xffd9d9d9),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: LinearProgressIndicator(
                      color: Color(0xff232323),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

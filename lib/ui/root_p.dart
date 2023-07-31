import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/auth_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:url_launcher/url_launcher.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  authenticateUser(_, AuthModel authModel, ConfigModel configModel) async {
    // configModel.getApiConfig(domain: 'http://192.168.29.9:9090');
    configModel.getApiConfig(domain: 'http://api.pw.aaibuzz.com');
    await configModel.fetchLoginData();

    String currentAppVersion = await getPackageDetails();

    if (configModel.loginData.length == 0) {
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
      print('APP: ' + currentAppVersion);
      print('API: ' + configModel.currentAndroidVersionFromApi);

      if (configModel.isLoggedIn) {
        if (currentAppVersion != configModel.currentAndroidVersionFromApi) {
          Navigator.pushReplacementNamed(context, '/updateApp');
        } else {
          Future.delayed(
            Duration.zero,
            () => Navigator.pushReplacementNamed(context, '/homePage'),
          );
        }
      } else {
        Future.delayed(
          Duration.zero,
          () => Navigator.pushReplacementNamed(context, '/loginPage'),
        );
      }
    }
  }

  getPackageDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
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
                    'assets/images/pinewrapslogo-1.png',
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

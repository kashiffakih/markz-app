import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/auth_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'package:url_launcher/url_launcher.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  authenticateUser(_, AuthModel authModel, ConfigModel configModel) async {
    // configModel.getApiConfig(domain: 'http://192.168.29.9:8080');
    configModel.getApiConfig(domain: 'http://api.me.aaibuzz.com');
    await configModel.fetchLoginData();

    String currentAppVersion = await getPackageDetails();

    if (configModel.loginData.length == 0) {
      Future.delayed(
        Duration.zero,
        () => Navigator.pushReplacementNamed(context, '/login'),
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
            () => Navigator.pushReplacementNamed(context, '/home'),
          );
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) => AlertDialog(
          //     title: Text('Survery Form'),
          //     content: Column(
          //       children: [
          //         Text(
          //             'Please fill the Survey Form. Press "YES" to fill the form. Press "NO" if already filled.'),
          //         SizedBox(
          //           height: 20,
          //         ),
          //         Text(
          //             'कृपया Survey फॉर्म भरें। फॉर्म भरने के लिए "YES" दबाएं। यदि पहले से भरा हुआ है तो "No" दबाएं।'),
          //       ],
          //     ),
          //     actions: [
          //       FlatButton(
          //         onPressed: () {
          //           Navigator.pop(context);
          //           Future.delayed(
          //             Duration.zero,
          //             () => Navigator.pushReplacementNamed(context, '/home'),
          //           );
          //         },
          //         child: Text('NO'),
          //       ),
          //       RaisedButton(
          //         color: Theme.of(context).primaryColor,
          //         onPressed: () {
          //           launch(
          //               'https://docs.google.com/forms/d/e/1FAIpQLSeEUGFXul-2tezhDw0fVjMxx9F9nIIacmyf5qcexDwnwepuxQ/viewform?usp=sf_link');
          //         },
          //         child: Text('YES'),
          //       )
          //     ],
          //   ),
          // );
        }
      } else {
        Future.delayed(
          Duration.zero,
          () => Navigator.pushReplacementNamed(context, '/login'),
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.backgroundImg),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (Platform.isAndroid)
                Image.asset(
                  Images.logo,
                  height: 150,
                ),
              if (Platform.isIOS)
                Image.asset(
                  Images.logoIOS,
                  height: 150,
                ),
              Text('Logging you in ...'),
              SizedBox(
                height: 25,
              ),
              CircularProgressIndicator(),
              SizedBox(
                height: 25,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

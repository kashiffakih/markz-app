import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:get_ip_address/get_ip_address.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/auth_pr.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class Splash2Page extends StatefulWidget {
  const Splash2Page({Key? key}) : super(key: key);

  @override
  State<Splash2Page> createState() => _Splash2PageState();
}

class _Splash2PageState extends State<Splash2Page> {
  // String userIpAddress = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  int generateRandomNumber() {
    // Create a Random object
    Random random = Random();

    // Generate a random number between 100000 and 999999 (inclusive)
    return 100000 + random.nextInt(900000);
  }

  String? identifier = '';
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // try {
    /// Initialize Ip Address
    //   var ipAddress = IpAddress(type: RequestType.json);

    //   /// Get the IpAddress based on requestType.
    //   dynamic data = await ipAddress.getIpAddress();
    //   userIpAddress =
    //       data.toString().split(':')[1].split("}")[0].split(" ")[1].toString();
    //   print(data.toString().split(':')[1].split("}")[0].split(" ")[1]);
    // } on IpAddressException catch (exception) {
    //   /// Handle the exception.
    //   print(exception.message);
    // }
    try {
      if (Platform.isAndroid) {
        _deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }
    } on PlatformException {
      _deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    identifier = _deviceData['id'] + '@' + _deviceData['model'] + 'gmail.com';

    // print(identifier);
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'displaySizeInches':
          ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }

  Map<String, dynamic> _registerData = {
    'first_name': 'Guest',
    'email': '',
    'phone': '',
    'password': '',
  };

  Map<String, dynamic> _loginData = {
    'email': '',
    'password': '',
    'rememberme': 1,
  };
  @override
  Widget build(BuildContext context) {
    int randomNumber = generateRandomNumber();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: SizedBox(
                    width: 200,
                    height: 300,
                    child: Image.asset(
                      'assets/images/aadab-logo.png',
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/loginPage',
                        arguments: {'role': 'Distributor'});
                  },
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Color(0xff0f0f0f),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Wholesaler',
                        textAlign: TextAlign.center,
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff000000)),
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Consumer<AuthModel>(
                    builder: (context, authModel, child) => MaterialButton(
                      height: 55,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10)),
                      minWidth: MediaQuery.of(context).size.width * .8,
                      color: Colors.white,
                      onPressed: () async {
                        _registerData['email'] = identifier;
                        _registerData['password'] = '123456';
                        _registerData['phone'] = randomNumber;
                        _registerData['role'] = 'User';
                        await authModel.register(registerData: _registerData);
                        _loginData['email'] = identifier;
                        _loginData['password'] = '123456';
                        await authModel.login(loginData: _loginData);
                        Navigator.pushNamed(context, '/homePage');
                      },
                      child: Text(
                        'Customer',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
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

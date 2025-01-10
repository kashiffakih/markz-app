import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/auth_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class RegisterPage extends StatefulWidget {
  final argument;
  const RegisterPage({Key? key, this.argument}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  ConfigModel _configModel = locator<ConfigModel>();

  Map<String, dynamic> _registerData = {
    'first_name': '',
    'email': '',
    'phone': '',
    'password': '',
  };
  Map<String, dynamic> _loginData = {};
  bool _isLoading = false;
  @override
  void initState() {
    initPlatformState();
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String? identifier = '';

  Future<void> initPlatformState() async {
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
      // 'displaySizeInches':
      //     ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      // 'displayWidthPixels': build.displayMetrics.widthPx,
      // 'displayWidthInches': build.displayMetrics.widthInches,
      // 'displayHeightPixels': build.displayMetrics.heightPx,
      // 'displayHeightInches': build.displayMetrics.heightInches,
      // 'displayXDpi': build.displayMetrics.xDpi,
      // 'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }
  bool _isValidEmail(String input) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(emailPattern).hasMatch(input);
  }
  @override
  Widget build(BuildContext context) {
    // print(widget.argument['role']);
    // debugPrint("role ${widget.argument['role']}");
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(6, 36, 6, 80),
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Image.asset(
                              'assets/images/vector-GJ4.png',
                              height: 15,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Register',
                            textAlign: TextAlign.center,
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e232c),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Hello !',
                  textAlign: TextAlign.center,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1e232c),
                  ),
                ),
              ),
              Container(
                child: Text(
                  'Register to get started',
                  textAlign: TextAlign.center,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1e232c),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _registerKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffe8ecf4)),
                        color: Color(0xfff7f8f9),
                        borderRadius: BorderRadius.circular(7.6632652283),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(17.94 * fem,
                              16.34 * fem, 17.94 * fem, 17.66 * fem),
                          hintText: 'Full Name',
                          hintStyle: TextStyle(color: Color(0xff8390a1)),
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.25 * ffem / fem,
                          color: Color(0xff000000),
                        ),
                        // initialValue: _registerData['first_name'],
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Full name cannot be empty';
                          return null;
                        },
                        onSaved: (value) {
                          _registerData['first_name'] = value;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffe8ecf4)),
                        color: Color(0xfff7f8f9),
                        borderRadius: BorderRadius.circular(7.6632652283),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(17.94 * fem,
                              16.34 * fem, 17.94 * fem, 17.66 * fem),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Color(0xff8390a1)),
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.25 * ffem / fem,
                          color: Color(0xff000000),
                        ),
                        // initialValue: _registerData['email'],
                        validator: (value) {
                          if (value!.isEmpty) return 'Email cannot be empty';
                          if (!_isValidEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _registerData['email'] = value;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffe8ecf4)),
                        color: Color(0xfff7f8f9),
                        borderRadius: BorderRadius.circular(7.6632652283),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(17.94 * fem,
                              16.34 * fem, 17.94 * fem, 17.66 * fem),
                          hintText: 'Phone',
                          hintStyle: TextStyle(color: Color(0xff8390a1)),
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.25 * ffem / fem,
                          color: Color(0xff000000),
                        ),
                        // initialValue: _registerData['phone'],
                        validator: (value) {
                          if (value!.isEmpty) return 'Phone cannot be empty';
                          return null;
                        },
                        onSaved: (value) {
                          _registerData['phone'] = value;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffe8ecf4)),
                        color: Color(0xfff7f8f9),
                        borderRadius: BorderRadius.circular(7.6632652283),
                      ),
                      child: TextFormField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(17.94 * fem,
                              16.34 * fem, 17.94 * fem, 17.66 * fem),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Color(0xff8390a1)),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.25 * ffem / fem,
                          color: Color(0xff000000),
                        ),
                        // initialValue: _registerData['password'],
                        validator: (value) {
                          if (value!.isEmpty) return 'Password cannot be empty';
                          return null;
                        },
                        onSaved: (value) {
                          _registerData['password'] = value;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          20 * fem, 10 * fem, 20 * fem, 46 * fem),
                      width: double.infinity,
                      height: 52 * fem,
                      decoration: BoxDecoration(
                        color: Color(0xff0f0f0f),
                        borderRadius: BorderRadius.circular(7.6632652283 * fem),
                      ),
                      child: Consumer<AuthModel>(
                        builder: (context, authModel, child) => MaterialButton(
                          height: 52 * fem,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  7.6632652283 * fem)),
                          minWidth: MediaQuery.of(context).size.width * .8,
                          color: Color(0xff0f0f0f),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            if (_registerKey.currentState!.validate()) {
                              _registerKey.currentState!.save();
                              _registerData['guest_email'] = identifier;
                              _registerData['role'] = widget.argument['role'];

                              // print(_registerData);
                              bool response = await authModel.register(
                                  registerData: _registerData);
                              if (response == true) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    title: Text(
                                        'Registeration successfully done.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/loginPage');
                                        },
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    title: Text('Registration failed!'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }

                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: _isLoading
                              ? SizedBox(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                  height: 20,
                                  width: 20,
                                )
                              : Text(
                                  'Sign Up',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 15 * ffem,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Expanded(
              //         child: Container(
              //           margin: EdgeInsets.fromLTRB(
              //               0 * fem, 1.91 * fem, 12.44 * fem, 0 * fem),
              //           width: 105.57 * fem,
              //           height: 0.94 * fem,
              //           decoration: BoxDecoration(
              //             color: Color(0xffe8ecf4),
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         child: Container(
              //           margin: EdgeInsets.fromLTRB(
              //               0 * fem, 0 * fem, 12.36 * fem, 0 * fem),
              //           child: Text(
              //             'Or Register with',
              //             style: MyGoogleFontStyle(
              //               fontFamily: 'Urbanist',
              //               fontSize: 12.792224884 * ffem,
              //               fontWeight: FontWeight.w600,
              //               height: 1.2 * ffem / fem,
              //               color: Color(0xff6a707c),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         child: Container(
              //           margin: EdgeInsets.fromLTRB(
              //               0 * fem, 1.91 * fem, 0 * fem, 0 * fem),
              //           width: 104.63 * fem,
              //           height: 0.94 * fem,
              //           decoration: BoxDecoration(
              //             color: Color(0xffe8ecf4),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Container(
              //           margin: EdgeInsets.all(5),
              //           padding: EdgeInsets.fromLTRB(
              //               31.47 * fem, 15.08 * fem, 36.19 * fem, 15.08 * fem),
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Color(0xffe8ecf4)),
              //             color: Color(0xffffffff),
              //             borderRadius:
              //                 BorderRadius.circular(7.5407857895 * fem),
              //           ),
              //           child: Center(
              //             child: SizedBox(
              //               width: 11.31 * fem,
              //               height: 22.62 * fem,
              //               child: Image.asset(
              //                 'assets/images/facebookic.png',
              //                 width: 11.31 * fem,
              //                 height: 52.62 * fem,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         child: Container(
              //           margin: EdgeInsets.all(5),
              //           padding: EdgeInsets.fromLTRB(
              //               30.99 * fem, 15.25 * fem, 35.7 * fem, 15.25 * fem),
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Color(0xffe8ecf4)),
              //             color: Color(0xffffffff),
              //             borderRadius:
              //                 BorderRadius.circular(7.5407857895 * fem),
              //           ),
              //           child: Center(
              //             child: SizedBox(
              //               width: 22.28 * fem,
              //               height: 22.28 * fem,
              //               child: Image.asset(
              //                 'assets/images/googleic-3Lc.png',
              //                 width: 22.28 * fem,
              //                 height: 22.28 * fem,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         child: Container(
              //           padding: EdgeInsets.fromLTRB(
              //               30.88 * fem, 14.14 * fem, 35.59 * fem, 14.14 * fem),
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Color(0xffe8ecf4)),
              //             color: Color(0xffffffff),
              //             borderRadius:
              //                 BorderRadius.circular(7.5407857895 * fem),
              //           ),
              //           child: Center(
              //             child: SizedBox(
              //               width: 24.51 * fem,
              //               height: 24.51 * fem,
              //               child: Image.asset(
              //                 'assets/images/cib-apple-KaY.png',
              //                 width: 24.51 * fem,
              //                 height: 24.51 * fem,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),


              InkWell(
                onTap: () {
                  {
                    FacebookAuth.instance
                        .login(
                      //   permissions: [
                      //   "public_profile",
                      //   "email"
                      // ]
                    )
                        .then((value) {
                      FacebookAuth.instance
                          .getUserData()
                          .then((userData) async {
                        print(userData);
                        print(userData['email']);

                        setState(() {
                          _isLoading = true;
                        });
                        _loginData['email'] = userData['email'];
                        _loginData['is_social_login'] = true;
                        _loginData['social_login_name'] = "FACEBOOK";

                        var authModel =
                        Provider.of<AuthModel>(context, listen: false);
                        await authModel.login(loginData: _loginData);
                        if (_configModel.isLoggedIn) {
                          Navigator.pushReplacementNamed(
                            context,
                            '/',
                          );
                        }
                      });
                    });
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.fromLTRB(31.47 * fem,
                              15.08 * fem, 36.19 * fem, 15.08 * fem),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffe8ecf4)),
                            color: Color(0xffffffff),
                            borderRadius:
                            BorderRadius.circular(7.5407857895 * fem),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 11.31 * fem,
                              height: 22.62 * fem,
                              child: Image.asset(
                                'assets/images/facebookic.png',
                                width: 11.31 * fem,
                                height: 52.62 * fem,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            // _handleSignIn();
                            {
                              final googleAccount =
                              await GoogleSignIn().signIn();
                              final googleAuth =
                              await googleAccount?.authentication;

                              final credential =
                              GoogleAuthProvider.credential(
                                accessToken: googleAuth?.accessToken,
                                idToken: googleAuth?.idToken,
                              );

                              final userCredential = await FirebaseAuth
                                  .instance
                                  .signInWithCredential(credential);

                              print(userCredential.user?.email);

                              setState(() {
                                _isLoading = true;
                              });

                              _loginData['email'] =
                                  userCredential.user?.email;
                              _loginData['is_social_login'] = true;
                              _loginData['social_login_name'] = "GOOGLE";

                              var authModel = Provider.of<AuthModel>(context,
                                  listen: false);
                              await authModel.login(loginData: _loginData);
                              if (_configModel.isLoggedIn) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/',
                                );
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.fromLTRB(30.99 * fem,
                                15.25 * fem, 35.7 * fem, 15.25 * fem),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffe8ecf4)),
                              color: Color(0xffffffff),
                              borderRadius:
                              BorderRadius.circular(7.5407857895 * fem),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 22.28 * fem,
                                height: 22.28 * fem,
                                child: Image.asset(
                                  'assets/images/googleic-3Lc.png',
                                  width: 22.28 * fem,
                                  height: 22.28 * fem,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Container(
                      //     padding: EdgeInsets.fromLTRB(30.88 * fem,
                      //         14.14 * fem, 35.59 * fem, 14.14 * fem),
                      //     decoration: BoxDecoration(
                      //       border: Border.all(color: Color(0xffe8ecf4)),
                      //       color: Color(0xffffffff),
                      //       borderRadius:
                      //           BorderRadius.circular(7.5407857895 * fem),
                      //     ),
                      //     child: Center(
                      //       child: SizedBox(
                      //         width: 24.51 * fem,
                      //         height: 24.51 * fem,
                      //         child: Image.asset(
                      //           'assets/images/cib-apple-KaY.png',
                      //           width: 24.51 * fem,
                      //           height: 24.51 * fem,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/loginPage');
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: MyGoogleFontStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13 * ffem,
                      fontWeight: FontWeight.w600,
                      height: 1.399999912 * ffem / fem,
                      letterSpacing: 0.13 * fem,
                      color: Color(0xff1e232c),
                    ),
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.399999912 * ffem / fem,
                          letterSpacing: 0.13 * fem,
                          color: Color(0xff1e232c),
                        ),
                      ),
                      TextSpan(
                        text: 'Login Now',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w700,
                          height: 1.399999912 * ffem / fem,
                          letterSpacing: 0.13 * fem,
                          color: Color(0xffc9b758),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

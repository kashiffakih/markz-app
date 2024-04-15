import 'package:flutter/material.dart';
// import 'package:get_ip_address/get_ip_address.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/auth_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

// import 'package:firebase_auth/firebase_auth.dart';
class LoginPage extends StatefulWidget {
  final argument;
  const LoginPage({Key? key, this.argument}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    fetchLoginData();
  }

  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   // try {
  //   //   /// Initialize Ip Address
  //   //   var ipAddress = IpAddress(type: RequestType.json);

  //   //   /// Get the IpAddress based on requestType.
  //   //   dynamic data = await ipAddress.getIp();
  //   //   print(data.toString());
  //   // } on IpAddressException catch (exception) {
  //   //   /// Handle the exception.
  //   //   print(exception.message);
  //   // }
  //   try {
  //     if (Platform.isAndroid) {
  //       _deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  //     } else if (Platform.isIOS) {
  //       _deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
  //     } else if (Platform.isLinux) {
  //       _deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
  //     } else if (Platform.isMacOS) {
  //       _deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
  //     } else if (Platform.isWindows) {
  //       _deviceData =
  //           _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
  //     }
  //   } on PlatformException {
  //     _deviceData = <String, dynamic>{
  //       'Error:': 'Failed to get platform version.'
  //     };
  //   }

  //   String? identifier =
  //       _deviceData['manufacturer'] + ' ' + _deviceData['model'];

  //   loginData = Map.of(loginData);
  //   loginData['imei_no'] = identifier;

  //   print(loginData);
  // }

  // GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  // Future<void> _handleSignIn() async {
  //   try {
  //     final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
  //     // print(gUser);
  //     final GoogleSignInAuthentication gAuth = await gUser!.authentication;
  //     print(gAuth);
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: gAuth.accessToken,
  //       idToken: gAuth.idToken,
  //     );
  //     // print(credential);
  //     var user = await FirebaseAuth.instance.signInWithCredential(credential);
  //     // print(user);

  //     // Handle successful sign-in
  //   } catch (error) {
  //     print('Google Sign-In Error: $error');
  //   }
  // }

  bool _obscurePassword = true;

  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  ConfigModel _configModel = locator<ConfigModel>();

  Map<String, dynamic> _loginData = {
    'email': '',
    'password': '',
    'rememberme': 1,
  };
  bool _isLoading = false;

  // @override
  // void initState() {

  //   super.initState();
  // }

  fetchLoginData() async {
    await _configModel.fetchLoginData();
  }

  //  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    // print(widget.argument['role']);
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
          child: Form(
            key: _loginKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                'assets/images/vector-GJ4.png',
                                height: 15,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Login',
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
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Text(
                    'Hello! Welcome Back',
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
                  height: 30,
                ),
                Container(
                  // enteryouremailinputdtz (318:3047)
                  margin: EdgeInsets.fromLTRB(
                      20 * fem, 0 * fem, 20 * fem, 10 * fem),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.6632652283 * fem),
                    border: Border.all(color: Color(0xffe8ecf4)),
                    color: Color(0xfff7f8f9),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(
                          16.82 * fem, 15.87 * fem, 16.82 * fem, 18.13 * fem),
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Color(0xff8390a1)),
                    ),
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.25 * ffem / fem,
                      color: Color(0xff000000),
                    ),
                    initialValue: _loginData['email'],
                    validator: (value) {
                      if (value!.isEmpty) return 'Username cannot be empty';
                      return null;
                    },
                    onSaved: (value) {
                      _loginData['email'] = value;
                    },
                  ),
                ),
                Container(
                  // enteryourpasswordinputSbY (318:3044)
                  margin: EdgeInsets.fromLTRB(
                      20 * fem, 0 * fem, 20 * fem, 10 * fem),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.6632652283 * fem),
                    border: Border.all(color: Color(0xffe8ecf4)),
                    color: Color(0xfff7f7f8),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(
                          16.82 * fem, 15.86 * fem, 16.82 * fem, 18.14 * fem),
                      hintText: 'Enter your password',
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
                    obscureText: _obscurePassword,
                    initialValue: _loginData['password'],
                    validator: (value) {
                      if (value!.isEmpty) return 'Password cannot be empty';
                      return null;
                    },
                    onSaved: (value) {
                      _loginData['password'] = value;
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/forgotPasswordPage');
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(207, 0, 0, 39),
                    child: Text(
                      'Forgot Password?',
                      textAlign: TextAlign.right,
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 13 * ffem,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffc7b456),
                      ),
                    ),
                  ),
                ),
                Consumer<AuthModel>(
                  builder: (context, authModel, child) => MaterialButton(
                    height: 52 * fem,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            new BorderRadius.circular(7.6632652283 * fem)),
                    minWidth: MediaQuery.of(context).size.width * .8,
                    color: Color(0xff0f0f0f),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_loginKey.currentState!.validate()) {
                        _loginKey.currentState!.save();
                        await authModel.login(loginData: _loginData);
                        if (_configModel.isLoggedIn) {
                          Navigator.pushReplacementNamed(
                            context,
                            '/',
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              title: Text(_configModel.loginFailedMessage),
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
                            'Login',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 15 * ffem,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffffffff),
                            ),
                          ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 1.91 * fem, 12.44 * fem, 0 * fem),
                          width: 105.57 * fem,
                          height: 0.94 * fem,
                          decoration: BoxDecoration(
                            color: Color(0xffe8ecf4),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 12.36 * fem, 0 * fem),
                          child: Text(
                            'Or Login with',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12.792224884 * ffem,
                              fontWeight: FontWeight.w600,
                              height: 1.2 * ffem / fem,
                              color: Color(0xff6a707c),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 1.91 * fem, 0 * fem, 0 * fem),
                          width: 104.63 * fem,
                          height: 0.94 * fem,
                          decoration: BoxDecoration(
                            color: Color(0xffe8ecf4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.fromLTRB(31.47 * fem, 15.08 * fem,
                              36.19 * fem, 15.08 * fem),
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
                          onTap: () {
                            // _handleSignIn();
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
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30.88 * fem, 14.14 * fem,
                              35.59 * fem, 14.14 * fem),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffe8ecf4)),
                            color: Color(0xffffffff),
                            borderRadius:
                                BorderRadius.circular(7.5407857895 * fem),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 24.51 * fem,
                              height: 24.51 * fem,
                              child: Image.asset(
                                'assets/images/cib-apple-KaY.png',
                                width: 24.51 * fem,
                                height: 24.51 * fem,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Text(_platformVersion),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/registerPage',
                        arguments: {'role': widget.argument['role']});
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
                          text: 'Don’t have an account? ',
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
                          text: 'Register Now',
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
                //  SizedBox(
                //   height: 30,
                // ),
                // InkWell(
                //   onTap: () {

                //     Navigator.pushNamed(context, '/homePage');
                //   },
                //   child: Container(
                //   child: Text(
                //     'Skip for now',
                //     textAlign: TextAlign.center,
                //     style: MyGoogleFontStyle(
                //       fontFamily: 'Urbanist',
                //       fontSize: 16,

                //       fontWeight: FontWeight.bold,
                //       color: Color(0xff1e232c),
                //     ),
                //   ),
                // ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

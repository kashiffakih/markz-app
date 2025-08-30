import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/auth_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';

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
  // @override
  // void initState() {
  //   initPlatformState();
  // }

  // static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  // Map<String, dynamic> _deviceData = <String, dynamic>{};
  // String? identifier = '';

  // Future<void> initPlatformState() async {
  //   try {
  //     if (Platform.isAndroid) {
  //       _deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  //     }
  //   } on PlatformException {
  //     _deviceData = <String, dynamic>{
  //       'Error:': 'Failed to get platform version.'
  //     };
  //   }

  //   identifier = _deviceData['id'] + '@' + _deviceData['model'] + 'gmail.com';
  // }

  // Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  //   return <String, dynamic>{
  //     'version.securityPatch': build.version.securityPatch,
  //     'version.sdkInt': build.version.sdkInt,
  //     'version.release': build.version.release,
  //     'version.previewSdkInt': build.version.previewSdkInt,
  //     'version.incremental': build.version.incremental,
  //     'version.codename': build.version.codename,
  //     'version.baseOS': build.version.baseOS,
  //     'board': build.board,
  //     'bootloader': build.bootloader,
  //     'brand': build.brand,
  //     'device': build.device,
  //     'display': build.display,
  //     'fingerprint': build.fingerprint,
  //     'hardware': build.hardware,
  //     'host': build.host,
  //     'id': build.id,
  //     'manufacturer': build.manufacturer,
  //     'model': build.model,
  //     'product': build.product,
  //     'supported32BitAbis': build.supported32BitAbis,
  //     'supported64BitAbis': build.supported64BitAbis,
  //     'supportedAbis': build.supportedAbis,
  //     'tags': build.tags,
  //     'type': build.type,
  //     'isPhysicalDevice': build.isPhysicalDevice,
  //     'systemFeatures': build.systemFeatures,
  //     // 'displaySizeInches':
  //     //     ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
  //     // 'displayWidthPixels': build.displayMetrics.widthPx,
  //     // 'displayWidthInches': build.displayMetrics.widthInches,
  //     // 'displayHeightPixels': build.displayMetrics.heightPx,
  //     // 'displayHeightInches': build.displayMetrics.heightInches,
  //     // 'displayXDpi': build.displayMetrics.xDpi,
  //     // 'displayYDpi': build.displayMetrics.yDpi,
  //     'serialNumber': build.serialNumber,
  //   };
  // }

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
                        keyboardType: TextInputType.emailAddress,
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
                        keyboardType: TextInputType.number,
                        maxLength: 10,
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
                          counterText: '', // Hide the counter text
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
                          if (value.length != 10)
                            return "Phone number must be exactly 10 digits";
                          // Check if the value contains only digits
                          if (!RegExp(r'^[0-9]+$').hasMatch(value))
                            return "Phone number must contain only digits";
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
                              // _registerData['guest_email'] = identifier;
                              _registerData['role'] = widget.argument['role'];

                              print(_registerData);
                              Map<String, dynamic> response = await authModel
                                  .register(registerData: _registerData);
                              print('Registration response: $response');
                              if (response['success'] == true) {
                                _showSuccessDialog();
                              } else if (response['error'] ==
                                  'EMAIL_ALREADY_EXISTS') {
                                _showAlreadyRegisteredDialog();
                              } else {
                                _showErrorDialog(response['message'] ??
                                    'Registration failed! Please try again.');
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
              Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 12.36 * fem, 0 * fem),
                child: Text(
                  'Or Register with',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12.792224884 * ffem,
                    fontWeight: FontWeight.w600,
                    height: 1.2 * ffem / fem,
                    color: Color(0xff6a707c),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: InkWell(
                  onTap: () async {
                    try {
                      final googleAccount = await GoogleSignIn().signIn();
                      if (googleAccount == null) {
                        // User canceled the sign-in
                        return;
                      }

                      final googleAuth = await googleAccount.authentication;

                      final credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );

                      final userCredential = await FirebaseAuth.instance
                          .signInWithCredential(credential);

                      print(userCredential.user?.email);

                      setState(() {
                        _isLoading = true;
                      });

                      _loginData['email'] = userCredential.user?.email;
                      _loginData['phone'] = userCredential.user?.phoneNumber;
                      _loginData['first_name'] =
                          userCredential.user?.displayName;
                      _loginData['is_social_login'] = true;
                      _loginData['is_social_register'] = true;
                      _loginData['social_login_name'] = "GOOGLE";
                      print('Google Login Data ${_loginData}');
                      var authModel =
                          Provider.of<AuthModel>(context, listen: false);

                      // Handle the login response to check for existing users
                      Map<String, dynamic> loginResponse =
                          await authModel.login(loginData: _loginData);
                      if (_configModel.isLoggedIn) {
                        Navigator.pushReplacementNamed(
                          context,
                          '/',
                        );
                      } else {
                        // Check if it's an existing user error
                        String errorMessage =
                            loginResponse['message'] ?? 'Login failed';
                        if (loginResponse['error'] == 'EMAIL_ALREADY_EXISTS' ||
                            errorMessage
                                .toLowerCase()
                                .contains('already exists') ||
                            errorMessage
                                .toLowerCase()
                                .contains('already registered')) {
                          // Show existing user dialog with appropriate message for social login
                          _showSocialLoginExistingUserDialog();
                        } else {
                          // Show generic error dialog
                          _showErrorDialog(errorMessage);
                        }
                      }
                    } catch (e) {
                      print('Social login error: $e');
                      _showErrorDialog(
                          'Failed to sign in with Google. Please try again.');
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.fromLTRB(
                        30.99 * fem, 15.25 * fem, 35.7 * fem, 15.25 * fem),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffe8ecf4)),
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(7.5407857895 * fem),
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

  // Show beautiful success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                // Success Title
                Text(
                  'Registration Successful!',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Success Message
                Text(
                  'Your account has been created successfully. You can now login with your credentials.',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Continue Button
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/loginPage',
                          arguments: {'role': widget.argument['role']});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc9b758),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Continue to Login',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show beautiful error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Error Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5252),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                // Error Title
                Text(
                  'Registration Failed',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Error Message
                Text(
                  message,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Try Again Button
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5252),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Try Again',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show dialog for already registered user
  void _showAlreadyRegisteredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9800),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                // Warning Title
                Text(
                  'Already Registered!',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Warning Message
                Text(
                  'An account with this email or phone number already exists. Please use different credentials or try logging in instead.',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Action Buttons
                Row(
                  children: [
                    // Try Again Button
                    Expanded(
                      child: Container(
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFF9800)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: Text(
                            'Try Again',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFF9800),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Go to Login Button
                    Expanded(
                      child: Container(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/loginPage',
                                arguments: {'role': widget.argument['role']});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffc9b758),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Go to Login',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show dialog for existing user during social login
  void _showSocialLoginExistingUserDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9800),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                // Warning Title
                Text(
                  'Account Already Exists!',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Warning Message
                Text(
                  'An account with this email already exists. Please login with your existing credentials or use a different Google account.',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Action Buttons
                Row(
                  children: [
                    // Go to Login Button
                    Expanded(
                      child: Container(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/loginPage',
                                arguments: {'role': widget.argument['role']});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffc9b758),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Go to Login',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
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
  bool _obscureConfirmPassword = true;
  ConfigModel _configModel = locator<ConfigModel>();

  Map<String, dynamic> _registerData = {
    'first_name': '',
    'email': '',
    'phone': '',
    'password': '',
    'confirm_password': '',
  };
  Map<String, dynamic> _loginData = {};
  bool _isLoading = false;

  bool _isValidEmail(String input) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(emailPattern).hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
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
                          contentPadding: EdgeInsets.fromLTRB(17.94.w,
                              16.34.w, 17.94.w, 17.66.w),
                          hintText: 'Full Name',
                          hintStyle: TextStyle(color: Color(0xff8390a1)),
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                          color: Color(0xff000000),
                        ),
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
                          contentPadding: EdgeInsets.fromLTRB(17.94.w,
                              16.34.w, 17.94.w, 17.66.w),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Color(0xff8390a1)),
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                          color: Color(0xff000000),
                        ),
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
                          contentPadding: EdgeInsets.fromLTRB(17.94.w,
                              16.34.w, 17.94.w, 17.66.w),
                          hintText: 'Phone',
                          hintStyle: TextStyle(color: Color(0xff8390a1)),
                          counterText: '',
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                          color: Color(0xff000000),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return 'Phone cannot be empty';
                          if (value.length != 10)
                            return "Phone number must be exactly 10 digits";
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
                          contentPadding: EdgeInsets.fromLTRB(17.94.w,
                              16.34.w, 17.94.w, 17.66.w),
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
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                          color: Color(0xff000000),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return 'Password cannot be empty';
                          _registerData['password'] =
                              value; // Update password for comparison
                          return null;
                        },
                        onChanged: (value) {
                          _registerData['password'] = value;
                          _registerKey.currentState!
                              .validate(); // Revalidate form
                        },
                        onSaved: (value) {
                          _registerData['password'] = value;
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
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(17.94.w,
                              16.34.w, 17.94.w, 17.66.w),
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: Color(0xff8390a1)),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            child: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                          color: Color(0xff000000),
                        ),
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Confirm password cannot be empty';
                          if (value != _registerData['password']) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _registerKey.currentState!
                              .validate(); // Revalidate form
                        },
                        onSaved: (value) {
                          _registerData['confirm_password'] = value;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          20.0.w, 10.0.w, 20.0.w, 46.0.w),
                      width: double.infinity,
                      height: 52.0.w,
                      decoration: BoxDecoration(
                        color: Color(0xff0f0f0f),
                        borderRadius: BorderRadius.circular(7.6632652283.r),
                      ),
                      child: Consumer<AuthModel>(
                        builder: (context, authModel, child) => MaterialButton(
                          height: 52.0.w,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  7.6632652283.w)),
                          minWidth: 0.8.sw,
                          color: Color(0xff0f0f0f),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            if (_registerKey.currentState!.validate()) {
                              _registerKey.currentState!.save();
                              _registerData['role'] = widget.argument['role'];

                              print(_registerData);
                              Map<String, dynamic> response = await authModel
                                  .register(registerData: _registerData);
                              print('Registration response: $response');
                              if (response['success'] == true) {
                                // Mark user as new for welcome bonus
                                await _configModel.setNewUserFlag(true);
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
                                    fontSize: 15.0.sp,
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
                    EdgeInsets.fromLTRB(0.0.w, 0.0.w, 12.36.w, 0.0.w),
                child: Text(
                  'Or Register with',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12.792224884.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
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

                      Map<String, dynamic> loginResponse =
                          await authModel.login(loginData: _loginData);
                      if (_configModel.isLoggedIn) {
                        // Mark as new user for welcome bonus (social registration)
                        await _configModel.setNewUserFlag(true);
                        Navigator.pushReplacementNamed(
                          context,
                          '/',
                        );
                      } else {
                        String errorMessage =
                            loginResponse['message'] ?? 'Login failed';
                        if (loginResponse['error'] == 'EMAIL_ALREADY_EXISTS' ||
                            errorMessage
                                .toLowerCase()
                                .contains('already exists') ||
                            errorMessage
                                .toLowerCase()
                                .contains('already registered')) {
                          _showSocialLoginExistingUserDialog();
                        } else {
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
                        30.99.w, 15.25.w, 35.7.w, 15.25.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffe8ecf4)),
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(7.5407857895.r),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 22.28.w,
                        height: 22.28.w,
                        child: Image.asset(
                          'assets/images/googleic-3Lc.png',
                          width: 22.28.w,
                          height: 22.28.w,
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
                      fontSize: 13.0.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.399999912,
                      letterSpacing: 0.13.w,
                      color: Color(0xff1e232c),
                    ),
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13.0.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.399999912,
                          letterSpacing: 0.13.w,
                          color: Color(0xff1e232c),
                        ),
                      ),
                      TextSpan(
                        text: 'Login Now',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13.0.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.399999912,
                          letterSpacing: 0.13.w,
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
                Row(
                  children: [
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
                Row(
                  children: [
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/auth_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/auth/change-password.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _enterCode = false;

  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  Map<String, dynamic> _loginData = {'email': '', 'code': ''};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(6, 36, 6, 80),
          // height: MediaQuery.of(context).size.height,
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
                                'Reset Password',
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
                  height: 20,
                ),
                Container(
                  child: Text(
                    'Forgot Password?',
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
                  // dontworryitoccurspleaseenterth (318:2072)
                  margin: EdgeInsets.fromLTRB(
                      0.w, 0.w, 3.24.w, 40.w),
                  constraints: BoxConstraints(
                    maxWidth: 302.w,
                  ),
                  child: Text(
                    'Don\'t worry! It occurs. Please enter the email address linked with your account.',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Color(0xff8390a1),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  // enteryouremailinputdtz (318:3047)
                  margin: EdgeInsets.fromLTRB(
                      20.w, 0.w, 20.w, 10.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.6632652283.w),
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
                          16.82.w, 15.87.w, 16.82.w, 18.13.w),
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Color(0xff8390a1)),
                    ),
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
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
                Visibility(
                  visible: _enterCode == true,
                  child: Container(
                    // enteryouremailinputdtz (318:3047)
                    margin: EdgeInsets.fromLTRB(
                        20.w, 0.w, 20.w, 10.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.6632652283.w),
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
                            16.82.w, 15.87.w, 16.82.w, 18.13.w),
                        hintText: 'Enter Code',
                        hintStyle: TextStyle(color: Color(0xff8390a1)),
                      ),
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                        color: Color(0xff000000),
                      ),
                      initialValue: _loginData['code'],
                      validator: (value) {
                        if (value!.isEmpty) return 'Code cannot be empty';
                        return null;
                      },
                      onSaved: (value) {
                        _loginData['code'] = value;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                _enterCode == false
                    ? Consumer<AuthModel>(
                        builder: (context, authModel, child) => MaterialButton(
                          height: 52.w,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  7.6632652283.w)),
                          minWidth: MediaQuery.of(context).size.width * .8,
                          color: Color(0xff0f0f0f),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            if (_loginKey.currentState!.validate()) {
                              _loginKey.currentState!.save();
                              bool response = await authModel
                                  .sendCodeForResetPassword(email: _loginData);
                              if (response == true) {
                                setState(() {
                                  _enterCode = true;
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    title: Text(
                                        'Reset code has been sent to your email'),
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
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    title: Text(
                                        "The provided email address doesn't match with our system."),
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
                                  'Send Code',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                        ),
                      )
                    : Consumer<AuthModel>(
                        builder: (context, authModel, child) => MaterialButton(
                          height: 52.w,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  7.6632652283.w)),
                          minWidth: MediaQuery.of(context).size.width * .8,
                          color: Color(0xff0f0f0f),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            if (_loginKey.currentState!.validate()) {
                              _loginKey.currentState!.save();
                              bool response =
                                  await authModel.verifyCode(data: _loginData);
                              if (response == true) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChangePasswordPage(
                                        arguments: _loginData)));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    title:
                                        Text("The provided code is invalid."),
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
                              _enterCode = false;
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
                                  'Verify Code',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                        ),
                      ),
                Container(
                  // rememberpasswordloginANa (318:2064)
                  margin: EdgeInsets.fromLTRB(
                      13.76.w, 270.w, 0.w, 0.w),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/loginPage');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: MyGoogleFontStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.399999912,
                          letterSpacing: 0.13.w,
                          color: Color(0xff1e232c),
                        ),
                        children: [
                          TextSpan(
                            text: 'Remember Password? ',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.399999912,
                              letterSpacing: 0.13.w,
                              color: Color(0xff1e232c),
                            ),
                          ),
                          TextSpan(
                            text: 'Login',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 13.sp,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

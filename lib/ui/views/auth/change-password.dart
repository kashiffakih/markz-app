import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/auth_pr.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class ChangePasswordPage extends StatefulWidget {
  final arguments;
  const ChangePasswordPage({Key? key, @required this.arguments})
      : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _changePasswordKey = GlobalKey<FormState>();

  var confirmPass;
  Map<String, dynamic> _changePasswordData = {
    'password': '',
    'confirm_password': '',
    'email': '',
  };
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.arguments['email']);
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(6, 16, 6, 80),
          // height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Form(
            key: _changePasswordKey,
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
                                'New Password',
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
                    'Create new password',
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
                      0 * fem, 0 * fem, 3.24 * fem, 40 * fem),
                  constraints: BoxConstraints(
                    maxWidth: 302 * fem,
                  ),
                  child: Text(
                    'Your new password must be unique from those previously used.',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 13 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.5 * ffem / fem,
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
                      hintText: 'New Password',
                      hintStyle: TextStyle(color: Color(0xff8390a1)),
                    ),
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.25 * ffem / fem,
                      color: Color(0xff000000),
                    ),
                    initialValue: _changePasswordData['password'],
                    validator: (value) {
                      if (value!.isEmpty) return 'Password cannot be empty';
                      confirmPass = value;
                      return null;
                    },
                    onSaved: (value) {
                      _changePasswordData['password'] = value;
                    },
                  ),
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
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(color: Color(0xff8390a1)),
                    ),
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.25 * ffem / fem,
                      color: Color(0xff000000),
                    ),
                    initialValue: _changePasswordData['confirm_password'],
                    validator: (changePassword) {
                      if (changePassword!.isEmpty)
                        return 'Confirm password cannot be empty';
                      if (changePassword != confirmPass) {
                        return 'Confirm password cannot match with password.';
                      }
                      return null;
                    },
                    onSaved: (changePassword) {
                      _changePasswordData['confirm_password'] = changePassword;
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
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
                      if (_changePasswordKey.currentState!.validate()) {
                        _changePasswordKey.currentState!.save();
                        _changePasswordData['email'] =
                            widget.arguments['email'].toString();
                        bool response = await authModel.changePassword(
                            data: _changePasswordData);
                        if (response == true) {
                          Navigator.pushNamed(context, '/successPassword');
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              title: Text(
                                  "There is some error please try again in sometime."),
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
                            'Submit',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 15 * ffem,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffffffff),
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

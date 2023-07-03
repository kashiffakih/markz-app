import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/auth_pr.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  // ConfigModel _configModel = locator<ConfigModel>();

  Map<String, dynamic> _registerData = {
    'first_name': '',
    'email': '',
    'phone': '',
    'password': '',
  };
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(6, 16, 6, 80),
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
                height: 30,
              ),
              Container(
                child: Text(
                  'Hello! Register to get started',
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
                          contentPadding: EdgeInsets.fromLTRB(16.94 * fem,
                              20.26 * fem, 16.94 * fem, 13.74 * fem),
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
                              15.39 * fem, 17.94 * fem, 18.61 * fem),
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
                          contentPadding: EdgeInsets.fromLTRB(14.95 * fem,
                              15.36 * fem, 14.95 * fem, 18.64 * fem),
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
                          20 * fem, 0 * fem, 20 * fem, 86 * fem),
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
                margin: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.fromLTRB(
                            41.47 * fem, 15.08 * fem, 46.19 * fem, 15.08 * fem),
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
                              'assets/images/facebookic-Srt.png',
                              width: 11.31 * fem,
                              height: 22.62 * fem,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.fromLTRB(
                            35.99 * fem, 15.25 * fem, 40.7 * fem, 15.25 * fem),
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
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            34.88 * fem, 14.14 * fem, 39.59 * fem, 14.14 * fem),
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

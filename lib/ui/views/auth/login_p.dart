import 'package:flutter/material.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                padding: EdgeInsets.fromLTRB(16.82, 15.87, 16.82, 18.13),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffe8ecf4)),
                  color: Color(0xfff7f8f9),
                  borderRadius: BorderRadius.circular(7.6632652283),
                ),
                child: Text(
                  'Enter your email',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff8390a1),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                padding: EdgeInsets.fromLTRB(16.82, 15.87, 16.82, 18.13),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffe8ecf4)),
                  color: Color(0xfff7f8f9),
                  borderRadius: BorderRadius.circular(7.6632652283),
                ),
                child: Text(
                  'Enter your password',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff8390a1),
                  ),
                ),
              ),
              Container(
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
              Container(
                margin:
                    EdgeInsets.fromLTRB(20 * fem, 0 * fem, 20 * fem, 86 * fem),
                width: double.infinity,
                height: 52 * fem,
                decoration: BoxDecoration(
                  color: Color(0xff0f0f0f),
                  borderRadius: BorderRadius.circular(7.6632652283 * fem),
                ),
                child: Center(
                  child: Text(
                    'Log in',
                    textAlign: TextAlign.center,
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
              RichText(
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
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class PasswordChangesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Container(
          // passwordchangedWzi (318:2094)
          padding:
              EdgeInsets.fromLTRB(26 * fem, 242 * fem, 26 * fem, 146 * fem),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // successmarkdZY (318:2101)
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 35 * fem),
                width: 100 * fem,
                height: 100 * fem,
                child: Image.asset(
                  'assets/images/successmark.png',
                  width: 100 * fem,
                  height: 100 * fem,
                ),
              ),
              Container(
                // textk8N (318:2098)
                margin:
                    EdgeInsets.fromLTRB(29 * fem, 0 * fem, 29 * fem, 40 * fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // passwordchangedgGv (318:2100)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 12 * fem),
                      child: Text(
                        'Password Changed!',
                        textAlign: TextAlign.center,
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 28 * ffem,
                          fontWeight: FontWeight.w700,
                          height: 1.2 * ffem / fem,
                          color: Color(0xff1e232c),
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 195 * fem),
                      child: Text(
                        'Your password has been changed successfully.',
                        textAlign: TextAlign.center,
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.5 * ffem / fem,
                          color: Color(0xff8390a1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                // backtologinbuttonUCn (318:2095)
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: double.infinity,
                  height: 52 * fem,
                  decoration: BoxDecoration(
                    color: Color(0xff0f0f0f),
                    borderRadius: BorderRadius.circular(8 * fem),
                  ),
                  child: Center(
                    child: Text(
                      'Back to Login',
                      textAlign: TextAlign.center,
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 15 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.2 * ffem / fem,
                        color: Color(0xffffffff),
                      ),
                    ),
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

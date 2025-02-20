import 'package:flutter/material.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConfigModel _configModel = locator<ConfigModel>();

    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Container(
          // menudrawermMT (617:1921)
          padding:
              EdgeInsets.fromLTRB(19 * fem, 29 * fem, 20 * fem, 0.89 * fem),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // group8976FXX (617:1922)
                margin: EdgeInsets.fromLTRB(
                    0 * fem, 0 * fem, 138.35 * fem, 44.13 * fem),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // Aadablogo1MaZ (617:1924)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 14.7 * fem),
                      width: 39.65 * fem,
                      height: 60.11 * fem,
                      child: Image.asset(
                        'assets/images/logo-kg1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 143 * fem,
                      height: 55.63 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 95 * fem,
                                height: 24 * fem,
                                child: Text(
                                  'Welcome to',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15.346613884 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.4999999689 * ffem / fem,
                                    color: Color(0xff303030),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // Aadab59B (617:1925)
                            left: 0 * fem,
                            top: 16.6254882812 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 143 * fem,
                                height: 39 * fem,
                                child: Text(
                                  'Aadab',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Righteous',
                                    fontSize: 25.5776882172 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4999999627 * ffem / fem,
                                    color: Color(0xff303030),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    3.84 * fem, 0 * fem, 0 * fem, 10.23 * fem),
                width: 317.16 * fem,
                height: 63.94 * fem,
                decoration: BoxDecoration(
                  // color: Color(0xffeff6ff),
                  borderRadius: BorderRadius.circular(5.1155376434 * fem),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/homePage');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        18.54 * fem, 15.35 * fem, 197.78 * fem, 15.35 * fem),
                    width: double.infinity,
                    height: 56.69 * fem,
                    decoration: BoxDecoration(
                      // color: Color(0xffeecf56),
                      borderRadius: BorderRadius.circular(5.1155376434 * fem),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 23.66 * fem, 0.03 * fem),
                          width: 19.18 * fem,
                          height: 21.34 * fem,
                          child: Image.asset(
                            'assets/images/u-home-alt.png',
                            width: 19.18 * fem,
                            height: 21.34 * fem,
                          ),
                        ),
                        Text(
                          'Home',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.4621505737 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.25 * ffem / fem,
                            color: Color(0xff232323),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    3.84 * fem, 0 * fem, 0 * fem, 10.23 * fem),
                width: 317.16 * fem,
                height: 63.94 * fem,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/shopsPage');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        18.54 * fem, 15.35 * fem, 204.78 * fem, 15.35 * fem),
                    width: double.infinity,
                    height: 56.69 * fem,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.1155376434 * fem),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 23.66 * fem, 0 * fem),
                          width: 19.18 * fem,
                          height: 19.18 * fem,
                          child: Image.asset(
                            'assets/images/u-create-dashboard.png',
                            width: 19.18 * fem,
                            height: 19.18 * fem,
                          ),
                        ),
                        Text(
                          'Shop',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.4621505737 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.25 * ffem / fem,
                            color: Color(0xff313f53),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Container(
              //   // navtextitembEZ (617:1932)
              //   margin:
              //       EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8.1 * fem),
              //   width: double.infinity,
              //   height: 63.94 * fem,
              //   child: Container(
              //     // contentKwF (I617:1932;42:2038)
              //     padding: EdgeInsets.fromLTRB(
              //         17.33 * fem, 15.35 * fem, 173.78 * fem, 15.35 * fem),
              //     width: double.infinity,
              //     height: 56.69 * fem,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5.1155376434 * fem),
              //     ),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Container(
              //           // usettingEoK (I617:1932;42:2039)
              //           margin: EdgeInsets.fromLTRB(
              //               0 * fem, 0 * fem, 23.12 * fem, 0 * fem),
              //           width: 20.94 * fem,
              //           height: 21.32 * fem,
              //           child: Image.asset(
              //             'assets/Aadab/images/u-setting.png',
              //             width: 20.94 * fem,
              //             height: 21.32 * fem,
              //           ),
              //         ),
              //         Text(
              //           // labelkmf (I617:1932;42:2040)
              //           'Settings',
              //           style: MyGoogleFontStyle(
              //             fontFamily: 'Inter',
              //             fontSize: 20.4621505737 * ffem,
              //             fontWeight: FontWeight.w500,
              //             height: 1.25 * ffem / fem,
              //             color: Color(0xff313f53),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Container(
                // navtextitemhB7 (617:1933)
                width: double.infinity,
                height: 63.94 * fem,
                child: Container(
                  // contentrZo (I617:1933;42:2038)
                  padding: EdgeInsets.fromLTRB(
                      17.48 * fem, 15.35 * fem, 186.78 * fem, 15.35 * fem),
                  width: double.infinity,
                  height: 56.69 * fem,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.1155376434 * fem),
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: Text('Are you sure you want to logout?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('NO'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await _configModel.removeLoginData();
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: Text('YES'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // usignoutaltnCZ (I617:1933;42:2039)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 22.6 * fem, 0 * fem),
                          width: 21.31 * fem,
                          height: 21.31 * fem,
                          child: Image.asset(
                            'assets/images/u-sign-out-alt.png',
                            width: 21.31 * fem,
                            height: 21.31 * fem,
                          ),
                        ),
                        Text(
                          // labelHf7 (I617:1933;42:2040)
                          'Logout',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.4621505737 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.25 * ffem / fem,
                            color: Color(0xff313f53),
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
    );
  }
}

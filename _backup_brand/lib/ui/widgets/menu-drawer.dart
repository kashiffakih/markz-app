import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConfigModel _configModel = locator<ConfigModel>();
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Container(
          // menudrawermMT (617:1921)
          padding:
              EdgeInsets.fromLTRB(19.0.w, 29.0.w, 20.0.w, 0.89.w),
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
                    0.0.w, 0.0.w, 138.35.w, 44.13.w),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // Aadablogo1MaZ (617:1924)
                      margin: EdgeInsets.fromLTRB(
                          0.0.w, 0.0.w, 0.0.w, 14.7.w),
                      width: 39.65.w,
                      height: 60.11.w,
                      child: Image.asset(
                        'assets/images/logo-kg1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 143.0.w,
                      height: 55.63.w,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0.0.w,
                            top: 0.0.w,
                            child: Align(
                              child: SizedBox(
                                width: 95.0.w,
                                height: 24.0.w,
                                child: Text(
                                  'Welcome to',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15.346613884.sp,
                                    fontWeight: FontWeight.w700,
                                    height: 1.4999999689,
                                    color: Color(0xff303030),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // Aadab59B (617:1925)
                            left: 0.0.w,
                            top: 16.6254882812.w,
                            child: Align(
                              child: SizedBox(
                                width: 143.0.w,
                                height: 39.0.w,
                                child: Text(
                                  'Aadab',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Righteous',
                                    fontSize: 25.5776882172.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4999999627,
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
                    3.84.w, 0.0.w, 0.0.w, 10.23.w),
                width: 317.16.w,
                height: 63.94.w,
                decoration: BoxDecoration(
                  // color: Color(0xffeff6ff),
                  borderRadius: BorderRadius.circular(5.1155376434.w),
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
                        18.54.w, 15.35.w, 197.78.w, 15.35.w),
                    width: double.infinity,
                    height: 56.69.w,
                    decoration: BoxDecoration(
                      // color: Color(0xffeecf56),
                      borderRadius: BorderRadius.circular(5.1155376434.w),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0.0.w, 0.0.w, 23.66.w, 0.03.w),
                          width: 19.18.w,
                          height: 21.34.w,
                          child: Image.asset(
                            'assets/images/u-home-alt.png',
                            width: 19.18.w,
                            height: 21.34.w,
                          ),
                        ),
                        Text(
                          'Home',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.4621505737.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
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
                    3.84.w, 0.0.w, 0.0.w, 10.23.w),
                width: 317.16.w,
                height: 63.94.w,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/shopsPage');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        18.54.w, 15.35.w, 204.78.w, 15.35.w),
                    width: double.infinity,
                    height: 56.69.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.1155376434.w),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0.0.w, 0.0.w, 23.66.w, 0.0.w),
                          width: 19.18.w,
                          height: 19.18.w,
                          child: Image.asset(
                            'assets/images/u-create-dashboard.png',
                            width: 19.18.w,
                            height: 19.18.w,
                          ),
                        ),
                        Text(
                          'Shop',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.4621505737.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
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
              //       EdgeInsets.fromLTRB(0.0.w, 0.0.w, 0.0.w, 8.1.w),
              //   width: double.infinity,
              //   height: 63.94.w,
              //   child: Container(
              //     // contentKwF (I617:1932;42:2038)
              //     padding: EdgeInsets.fromLTRB(
              //         17.33.w, 15.35.w, 173.78.w, 15.35.w),
              //     width: double.infinity,
              //     height: 56.69.w,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5.1155376434.w),
              //     ),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Container(
              //           // usettingEoK (I617:1932;42:2039)
              //           margin: EdgeInsets.fromLTRB(
              //               0.0.w, 0.0.w, 23.12.w, 0.0.w),
              //           width: 20.94.w,
              //           height: 21.32.w,
              //           child: Image.asset(
              //             'assets/Aadab/images/u-setting.png',
              //             width: 20.94.w,
              //             height: 21.32.w,
              //           ),
              //         ),
              //         Text(
              //           // labelkmf (I617:1932;42:2040)
              //           'Settings',
              //           style: MyGoogleFontStyle(
              //             fontFamily: 'Inter',
              //             fontSize: 20.4621505737.sp,
              //             fontWeight: FontWeight.w500,
              //             height: 1.25,
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
                height: 63.94.w,
                child: Container(
                  // contentrZo (I617:1933;42:2038)
                  padding: EdgeInsets.fromLTRB(
                      17.48.w, 15.35.w, 186.78.w, 15.35.w),
                  width: double.infinity,
                  height: 56.69.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.1155376434.w),
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
                              0.0.w, 0.0.w, 22.6.w, 0.0.w),
                          width: 21.31.w,
                          height: 21.31.w,
                          child: Image.asset(
                            'assets/images/u-sign-out-alt.png',
                            width: 21.31.w,
                            height: 21.31.w,
                          ),
                        ),
                        Text(
                          // labelHf7 (I617:1933;42:2040)
                          'Logout',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.4621505737.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
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

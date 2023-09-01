import 'package:flutter/material.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class DrawerWidget extends StatelessWidget {
  final ConfigModel _configModel = locator<ConfigModel>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: DrawerHeader(
                // decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  children: <Widget>[
                    Container(
                      // pinewrapslogo1MaZ (617:1924)
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 14.7),
                      width: 50,
                      height: 80,
                      child: Image.asset(
                        'assets/images/pinewrapslogo-1-kg1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 143,
                      height: 55.63,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Align(
                              child: SizedBox(
                                width: 95,
                                height: 24,
                                child: Text(
                                  'Welcome to',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15.346613884,
                                    fontWeight: FontWeight.w700,
                                    height: 1.4999999689,
                                    color: Color(0xff303030),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // pinewraps59B (617:1925)
                            left: 0,
                            top: 16.6254882812,
                            child: Align(
                              child: SizedBox(
                                  width: 120,
                                  height: 25,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 2, 0, 4.7),
                                    height: 100,
                                    width: 100,
                                    child: Image.asset(
                                      'assets/images/NewPineWrapsText.jpeg',
                                      height: 100,
                                      width: 100,
                                      // fit: BoxFit.fill,
                                    ),
                                  )
                                  // Text(
                                  //   'PINEWRAPS',
                                  //   style: MyGoogleFontStyle(
                                  //     fontFamily: 'Righteous',
                                  //     fontSize: 25.5776882172,
                                  //     fontWeight: FontWeight.w400,
                                  //     height: 1.4999999627,
                                  //     color: Color(0xff303030),
                                  //   ),
                                  // ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/homePage');
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 23.66, 0.03),
                      width: 19.18,
                      height: 21.34,
                      child: Image.asset(
                        'assets/images/u-home-alt.png',
                        width: 19.18,
                        height: 21.34,
                      ),
                    ),
                    Text(
                      'Home',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                        color: Color(0xff232323),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/shopsPage');
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 23.66, 0.03),
                      width: 19.18,
                      height: 21.34,
                      child: Image.asset(
                        'assets/images/u-create-dashboard.png',
                        width: 19.18,
                        height: 21.34,
                      ),
                    ),
                    Text(
                      'Shop',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                        color: Color(0xff232323),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/refundPolicyPage');
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 19, 0.03),
                      width: 25,
                      height: 25,
                      child: Image.asset(
                        'assets/images/contract.png',
                        width: 25,
                        height: 25,
                      ),
                    ),
                    Text(
                      'Refund Policy',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                        color: Color(0xff232323),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, '/termAndConditionPage');
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 19, 0.03),
                      width: 25,
                      height: 25,
                      child: Image.asset(
                        'assets/images/contract.png',
                        width: 20,
                        height: 25,
                      ),
                    ),
                    Text(
                      'Terms & Conditions',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                        color: Color(0xff232323),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
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
                        child:
                            Text('NO', style: TextStyle(color: Colors.black)),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _configModel.removeLoginData();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          'YES',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 23.66, 0.03),
                      width: 19.18,
                      height: 21.34,
                      child: Image.asset(
                        'assets/images/u-sign-out-alt.png',
                        width: 19.18,
                        height: 21.34,
                      ),
                    ),
                    Text(
                      'Logout',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                        color: Color(0xff232323),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

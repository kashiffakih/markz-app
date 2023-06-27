import 'package:flutter/material.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                // Title
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
                                'Reviews',
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
                // Body
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // 1st Review
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffc7b456)),
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x338a959e),
                              offset: Offset(0, 7.6690645218),
                              blurRadius: 19.1726608276,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Photo and Title
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            // mediaF3t (I318:2555;0:1388)
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 15, 0),
                                            width: 66.71,
                                            height: 66.71,
                                            child: Image.asset(
                                              'assets/images/media.png',
                                              width: 66.71,
                                              height: 66.71,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Coffee Table',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff232323),
                                                ),
                                              ),
                                              Text(
                                                // BLr (I318:2555;0:1392)
                                                '\$ 50.00',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff232323),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Stars
                            Row(
                              children: [
                                Expanded(
                                  child: Text('Star Widget'),
                                ),
                                Expanded(
                                  child: Text(
                                    // 8hL (I318:2555;0:1369)
                                    '20/03/2020',
                                    textAlign: TextAlign.right,
                                    style: MyGoogleFontStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff909090),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Description
                            Text(
                              'Nice Furniture with good delivery. The delivery time is very fast. Then products look like exactly the picture in the app. Besides, color is also the same and quality is very good despite very cheap price',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff909090),
                              ),
                            )
                          ],
                        ),
                      ),
                      // 2nd Review
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffc7b456)),
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x338a959e),
                              offset: Offset(0, 7.6690645218),
                              blurRadius: 19.1726608276,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Photo and Title
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            // mediaF3t (I318:2555;0:1388)
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 15, 0),
                                            width: 66.71,
                                            height: 66.71,
                                            child: Image.asset(
                                              'assets/images/media.png',
                                              width: 66.71,
                                              height: 66.71,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Coffee Table',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff232323),
                                                ),
                                              ),
                                              Text(
                                                // BLr (I318:2555;0:1392)
                                                '\$ 50.00',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff232323),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Stars
                            Row(
                              children: [
                                Expanded(
                                  child: Text('Star Widget'),
                                ),
                                Expanded(
                                  child: Text(
                                    // 8hL (I318:2555;0:1369)
                                    '20/03/2020',
                                    textAlign: TextAlign.right,
                                    style: MyGoogleFontStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff909090),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Description
                            Text(
                              'Nice Furniture with good delivery. The delivery time is very fast. Then products look like exactly the picture in the app. Besides, color is also the same and quality is very good despite very cheap price',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff909090),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

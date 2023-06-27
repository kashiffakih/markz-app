import 'package:flutter/material.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({Key? key}) : super(key: key);

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
                                'Rewards',
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
                      // Photo and Name
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/gift-removebg-preview-1.png',
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Total points',
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff303030),
                                ),
                              ),
                              Text(
                                '500',
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Rewards
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
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
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Rewards',
                                    style: MyGoogleFontStyle(
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff232323),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    // alreadyhave10orders9Ca (I318:2511;0:1158)
                                    'Order and earn 20 points',
                                    style: MyGoogleFontStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff909090),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/star-9.png',
                                  width: 7.18,
                                  height: 12.92,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '250 Points',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),
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

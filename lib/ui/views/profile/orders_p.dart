import 'package:flutter/material.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

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
                                'Orders',
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
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        // Tabs
                        Container(
                          child: TabBar(
                            tabs: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Delivered',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Processing',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Cancelled',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tab Content
                        Container(
                          height: MediaQuery.of(context).size.height - 124,
                          child: TabBarView(
                            children: [
                              // Tab 1
                              Column(
                                children: [
                                  // 1st Row
                                  Container(
                                    height: 130,
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xffc7b456)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Order No: 1234',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff232323),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '20/03/2020',
                                                textAlign: TextAlign.right,
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff909090),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xff000000),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'Quantity: ',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xffaaaaaa),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '03',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: RichText(
                                                textAlign: TextAlign.right,
                                                text: TextSpan(
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xff000000),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'Total Amount: ',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xffaaaaaa),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '150',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 74.5,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Color(0xff232323),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Detail',
                                                  textAlign: TextAlign.center,
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Cancelled',
                                                textAlign: TextAlign.right,
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffeb5757),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 2nd Row
                                  Container(
                                    height: 130,
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xffc7b456)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Order No: 1234',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff232323),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '20/03/2020',
                                                textAlign: TextAlign.right,
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff909090),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xff000000),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'Quantity: ',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xffaaaaaa),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '03',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: RichText(
                                                textAlign: TextAlign.right,
                                                text: TextSpan(
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xff000000),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'Total Amount: ',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xffaaaaaa),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '150',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 74.5,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Color(0xff232323),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Detail',
                                                  textAlign: TextAlign.center,
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Cancelled',
                                                textAlign: TextAlign.right,
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffeb5757),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text('Tab 2'),
                              Text('Tab 3'),
                            ],
                          ),
                        )
                      ],
                    ),
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

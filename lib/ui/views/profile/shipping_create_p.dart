import 'package:flutter/material.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class ShippingCreatePage extends StatelessWidget {
  const ShippingCreatePage({Key? key}) : super(key: key);

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
                                'Add Shipping Address',
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
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      // Full Name
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xffe3e3e3)),
                          color: Color(0xfffbfbfb),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
                            hintText: 'Enter your promo code',
                            hintStyle: TextStyle(color: Color(0x3f000000)),
                          ),
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w500,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Address
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xffe3e3e3)),
                          color: Color(0xfffbfbfb),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
                            hintText: 'Address',
                            hintStyle: TextStyle(color: Color(0x3f000000)),
                          ),
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w500,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Save address
                      Container(
                        // primaryXwC (318:2628)
                        margin: EdgeInsets.fromLTRB(5, 0, 6.34, 0),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 53,
                            decoration: BoxDecoration(
                              color: Color(0xff1e1e1e),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Save address',
                                textAlign: TextAlign.center,
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 15.1428556442,
                                  fontWeight: FontWeight.w700,
                                  height: 1.4999999685,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
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

import 'package:flutter/material.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  bool _isShipping = false;

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
                                'Addresses',
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
                      // Shipping Address 1
                      Row(
                        children: [
                          Checkbox(
                            value: _isShipping,
                            onChanged: (value) {
                              _isShipping = true;
                            },
                          ),
                          Expanded(
                            child: Text(
                              'Use as the shipping address',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff232323),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bruno Fernandes',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w700,
                                color: Color(0xff232323),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Text(
                              '25 rue Robert Latouche, Nice, 06200, Côte D’azur, France',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w400,
                                color: Color(0xff909090),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Shipping Address 2
                      Row(
                        children: [
                          Checkbox(
                            value: _isShipping,
                            onChanged: (value) {
                              _isShipping = true;
                            },
                          ),
                          Expanded(
                            child: Text(
                              'Use as the shipping address',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff232323),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bruno Fernandes',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w700,
                                color: Color(0xff232323),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Text(
                              '25 rue Robert Latouche, Nice, 06200, Côte D’azur, France',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w400,
                                color: Color(0xff909090),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/shippingCreatePage');
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Color(0xffffffff),
      ),
    );
  }
}

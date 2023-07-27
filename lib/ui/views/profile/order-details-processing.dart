import 'package:flutter/material.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class OrderDetailsPage extends StatefulWidget {
  final arguments;
  const OrderDetailsPage({Key? key, this.arguments}) : super(key: key);
  @override
  State<OrderDetailsPage> createState() => OorderDetailsPageState();
}

class OorderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    // print(widget.arguments['order']['id'].toString());
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20),
        width: double.infinity,
        child: Container(
          width: double.infinity,
          height: 900 * fem,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 22.1181640625 * fem,
                top: 50 * fem,
                child: Container(
                  width: 205.88 * fem,
                  height: 24 * fem,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 2.4 * fem, 101.59 * fem, 0 * fem),
                          width: 8.29 * fem,
                          height: 13.75 * fem,
                          child: Image.asset(
                            'assets/images/vector-GJ4.png',
                            width: 8.29 * fem,
                            height: 13.75 * fem,
                          ),
                        ),
                      ),
                      Text(
                        'Order Details',
                        textAlign: TextAlign.center,
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 18 * ffem,
                          fontWeight: FontWeight.w700,
                          height: 1.2999999788 * ffem / fem,
                          letterSpacing: -0.9 * fem,
                          color: Color(0xff1e232c),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 19 * fem,
                top: 90 * fem,
                child: Container(
                  width: 320 * fem,
                  height: 60 * fem,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 5 * fem),
                        width: double.infinity,
                        child: Text(
                          widget.arguments['status'].toString(),
                          textAlign: TextAlign.start,
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 18 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.2999999788 * ffem / fem,
                            letterSpacing: -0.9 * fem,
                            color: widget.arguments['status'].toString() ==
                                    'Delivered'
                                ? Colors.green
                                : widget.arguments['status'].toString() ==
                                        'Order in processing'
                                    ? Colors.orange
                                    : widget.arguments['status'].toString() ==
                                            'Cancelled'
                                        ? Colors.red
                                        : Colors.black,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          'Order #' +
                              widget.arguments['order']['id'].toString(),
                          textAlign: TextAlign.start,
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 12 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.2999999523 * ffem / fem,
                            letterSpacing: -0.6 * fem,
                            color: Color(0xff1e1e1e),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 19 * fem,
                top: 132 * fem,
                child: Container(
                    width: 322 * fem,
                    height: 100 * fem,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount:
                          widget.arguments['order']['order_details'].length,
                      itemBuilder: (BuildContext context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 11 * fem),
                            child: Text(
                              widget.arguments['order']['order_details'][index]
                                      ['product']['name']
                                  .toString(),
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.2 * ffem / fem,
                                letterSpacing: -0.3 * fem,
                                color: Color(0xff1e1e1e),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 7 * fem),
                            constraints: BoxConstraints(
                              maxWidth: 205 * fem,
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12 * ffem,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5 * ffem / fem,
                                  letterSpacing: -0.24 * fem,
                                  color: Color(0xff1e1e1e),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Flavour: ',
                                    style: MyGoogleFontStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 12 * ffem,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2 * ffem / fem,
                                      letterSpacing: -0.24 * fem,
                                      color: Color(0xff1e1e1e),
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.arguments['order']
                                                    ['order_details'][index]
                                                ['flavour'] !=
                                            null
                                        ? widget.arguments['order']
                                                ['order_details'][index]
                                                ['flavour']
                                            .toString()
                                        : '',
                                    style: MyGoogleFontStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 12 * ffem,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2 * ffem / fem,
                                      letterSpacing: -0.24 * fem,
                                      color: Color(0xff1e1e1e),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                1 * fem, 0 * fem, 0 * fem, 0 * fem),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 34 * fem, 0 * fem),
                                  child: RichText(
                                    text: TextSpan(
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2 * ffem / fem,
                                        letterSpacing: -0.24 * fem,
                                        color: Color(0xff1e1e1e),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Size: ',
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 12 * ffem,
                                            fontWeight: FontWeight.w400,
                                            height: 1.2 * ffem / fem,
                                            letterSpacing: -0.24 * fem,
                                            color: Color(0xff1e1e1e),
                                          ),
                                        ),
                                        TextSpan(
                                          text: widget.arguments['order']
                                                  ['order_details'][index]
                                                  ['product_pack']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 151 * fem, 0 * fem),
                                  child: RichText(
                                    text: TextSpan(
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2 * ffem / fem,
                                        letterSpacing: -0.24 * fem,
                                        color: Color(0xff1e1e1e),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Quantity: ',
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 12 * ffem,
                                            fontWeight: FontWeight.w400,
                                            height: 1.2 * ffem / fem,
                                            letterSpacing: -0.24 * fem,
                                            color: Color(0xff1e1e1e),
                                          ),
                                        ),
                                        TextSpan(
                                          text: widget.arguments['order']
                                                  ['order_details'][index]
                                                  ['quantity']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  'د.إ' +
                                      ' ' +
                                      widget.arguments['order']['order_details']
                                              [index]['order_detail_cost']
                                          .toString(),
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 12 * ffem,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2 * ffem / fem,
                                    letterSpacing: -0.24 * fem,
                                    color: Color(0xff1e1e1e),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                          )
                        ],
                      ),
                    )),
              ),
              // ),
              Positioned(
                left: 19 * fem,
                top: 250 * fem,
                child: Column(
                  children: [
                    Container(
                      width: 321 * fem,
                      height: 100 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Container(
                              width: 321 * fem,
                              height: 24 * fem,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 218 * fem, 0 * fem),
                                    child: Text(
                                      'Item total',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 15 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.6 * ffem / fem,
                                        color: Color(0xff1e1e1e),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 1 * fem, 0 * fem, 0 * fem),
                                    child: Text(
                                      'د.إ' +
                                          ' ' +
                                          widget.arguments['order']
                                                  ['order_cost']
                                              .toString(),
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2 * ffem / fem,
                                        letterSpacing: -0.24 * fem,
                                        color: Color(0xff1e1e1e),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0 * fem,
                            top: 23 * fem,
                            child: Container(
                              width: 321 * fem,
                              height: 24 * fem,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 256 * fem, 0 * fem),
                                    child: Text(
                                      'Taxes',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 2 * ffem / fem,
                                        color: Color(0xff1e1e1e),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 1 * fem, 0 * fem, 0 * fem),
                                    child: Text(
                                      'د.إ' +
                                          ' ' +
                                          widget.arguments['order']
                                                  ['tax_amount']
                                              .toString(),
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2 * ffem / fem,
                                        letterSpacing: -0.24 * fem,
                                        color: Color(0xff1e1e1e),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0 * fem,
                            top: 42 * fem,
                            child: Container(
                              width: 320 * fem,
                              height: 24 * fem,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 205 * fem, 0 * fem),
                                    child: Text(
                                      'Delivery charge',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 2 * ffem / fem,
                                        color: Color(0xff1e1e1e),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 1 * fem, 0 * fem, 0 * fem),
                                    child: Text(
                                      'د.إ' +
                                          ' ' +
                                          widget.arguments['order']
                                                  ['delivery_amount']
                                              .toString(),
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2 * ffem / fem,
                                        letterSpacing: -0.24 * fem,
                                        color: Color(0xff1e1e1e),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0 * fem,
                            top: 62 * fem,
                            child: Container(
                              width: 320 * fem,
                              height: 24 * fem,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 205 * fem, 0 * fem),
                                    child: Text(
                                      'Packing charge',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 2 * ffem / fem,
                                        color: Color(0xff1e1e1e),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 1 * fem, 0 * fem, 0 * fem),
                                    child: Text(
                                      'د.إ' +
                                          ' ' +
                                          widget.arguments['order']
                                                  ['packaging_amount']
                                              .toString(),
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2 * ffem / fem,
                                        letterSpacing: -0.24 * fem,
                                        color: Color(0xff1e1e1e),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                left: 19 * fem,
                top: 386 * fem,
                child: Column(
                  children: [
                    Container(
                      width: 320 * fem,
                      height: 24 * fem,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 191 * fem, 0 * fem),
                            child: Text(
                              'Grand Total',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.6 * ffem / fem,
                                color: Color(0xff1e1e1e),
                              ),
                            ),
                          ),
                          Text(
                            'د.إ' +
                                ' ' +
                                widget.arguments['order']['total_amount']
                                    .toString(),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 15 * ffem,
                              fontWeight: FontWeight.w500,
                              height: 1.2 * ffem / fem,
                              letterSpacing: -0.3 * fem,
                              color: Color(0xff1e1e1e),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                left: 19 * fem,
                top: 440 * fem,
                child: Container(
                  width: 200 * fem,
                  height: 44 * fem,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 47 * fem,
                            height: 24 * fem,
                            child: Text(
                              'Payment',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 2 * ffem / fem,
                                color: Color(0xff1e1e1e),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0 * fem,
                        top: 20 * fem,
                        child: Align(
                          child: SizedBox(
                            // width: 100 * fem,
                            // height: 24 * fem,
                            child: Text(
                              'Paid : Cash on Delivery',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.8461538462 * ffem / fem,
                                color: Color(0xff1e1e1e),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 19 * fem,
                top: 496 * fem,
                child: Container(
                  width: 141 * fem,
                  height: 44 * fem,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 26 * fem,
                            height: 24 * fem,
                            child: Text(
                              'Date',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 2 * ffem / fem,
                                color: Color(0xff1e1e1e),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0 * fem,
                        top: 20 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 141 * fem,
                            height: 24 * fem,
                            child: Text(
                              widget.arguments['order']['created_at']
                                  .toString(),
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.8461538462 * ffem / fem,
                                color: Color(0xff1e1e1e),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 19 * fem,
                top: 552 * fem,
                child: Container(
                  width: 80 * fem,
                  height: 44 * fem,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 77 * fem,
                            height: 24 * fem,
                            child: Text(
                              'Phone number',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 2 * ffem / fem,
                                color: Color(0xff1e1e1e),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0 * fem,
                        top: 20 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 80 * fem,
                            height: 24 * fem,
                            child: Text(
                              widget.arguments['order']['user']['phone']
                                  .toString(),
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.8461538462 * ffem / fem,
                                color: Color(0xff1e1e1e),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 19 * fem,
                top: 609 * fem,
                child: Container(
                  width: 285 * fem,
                  height: 60 * fem,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 1 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 50 * fem,
                            height: 24 * fem,
                            child: Text(
                              'Deliver to',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 2 * ffem / fem,
                                color: Color(0xff1e1e1e),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0 * fem,
                        top: 21 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 285 * fem,
                            height: 49 * fem,
                            child: Text(
                              widget.arguments['order']['address']['add_1']
                                      .toString() +
                                  ', ' +
                                  widget.arguments['order']['address']['add_2']
                                      .toString() +
                                  ', ' +
                                  widget.arguments['order']['address']['add_3']
                                      .toString() +
                                  ', ' +
                                  widget.arguments['order']['address']['city']
                                      .toString() +
                                  ', ' +
                                  widget.arguments['order']['address']['state']
                                      .toString() +
                                  ', ' +
                                  widget.arguments['order']['address']
                                          ['pincode']
                                      .toString(),
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.4748200637 * ffem / fem,
                                color: Color(0xff1e1e1e),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

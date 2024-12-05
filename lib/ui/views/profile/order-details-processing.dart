import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/review_pr.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/widgets/multi_image_w.dart';

import '../../../core/providers/config_pr.dart';
import '../../../locator.dart';

class OrderDetailsPage extends StatefulWidget {
  final arguments;
  const OrderDetailsPage({Key? key, this.arguments}) : super(key: key);
  @override
  State<OrderDetailsPage> createState() => OorderDetailsPageState();
}

class OorderDetailsPageState extends State<OrderDetailsPage> {
  final _reviewFormKey = GlobalKey<FormState>();
  var _reviewDescription = '';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final ConfigModel _configModel = locator<ConfigModel>();
    final ReviewModel _reviewModel = Provider.of<ReviewModel>(context);

    // print(widget.arguments['order']['id'].toString());
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            // padding: EdgeInsets.only(top: 20),
            width: double.infinity,
            child: Container(
              width: double.infinity,
              height: 900 * fem,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 10, left: 30, bottom: 20, right: 30),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Image.asset(
                                  'assets/images/vector-GJ4.png',
                                  height: 15,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Order Details',
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

                  Container(
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
                  Container(
                    width: 322 * fem,
                    // height: 130 * fem,
                    height: MediaQuery.of(context).size.height *
                        (0.23 *
                            (widget.arguments['order']['order_details'].length <
                                    2
                                ? widget
                                    .arguments['order']['order_details'].length
                                : 2)),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount:
                          widget.arguments['order']['order_details'].length,
                      itemBuilder: (BuildContext context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 11 * fem),
                                child: Text(
                                  widget.arguments['order']['order_details']
                                          [index]['product']['name']
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
                              SizedBox(
                                width: 50,
                              ),
                              Container(
                                width: 60,
                                height: 80,
                                child: Image.network(
                                  _configModel.apiConfig['mediaURL'] +
                                      widget.arguments['order']['order_details']
                                              [index]['product']['imagepath1']
                                          .toString(),
                                  fit: BoxFit.fill,
                                  // fit: BoxFit.cover,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      title: Text("Add your review"),
                                      content: SizedBox(
                                        height: 350,
                                        child: Column(
                                          children: [
                                            Form(
                                              key: _reviewFormKey,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color(
                                                              0xffdadada)),
                                                      color: Color(0xffffffff),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: TextFormField(
                                                      maxLines: 6,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Write your review here.',
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        hintStyle: TextStyle(
                                                            color: Color(
                                                                0xff8390a1)),
                                                      ),
                                                      initialValue:
                                                          _reviewDescription,
                                                      onSaved: (value) {
                                                        _reviewDescription =
                                                            value.toString();
                                                      },
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please write some review.';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  SizedBox(
                                                      height: 120,
                                                      // width: 150,
                                                      child:
                                                          MultipleImageUploadPage()),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        5, 0, 6.34, 0),
                                                    child: TextButton(
                                                      onPressed: _loading
                                                          ? null
                                                          : () async {
                                                              if (_reviewFormKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                _reviewFormKey
                                                                    .currentState!
                                                                    .save();

                                                                if (_configModel
                                                                        .files
                                                                        .length ==
                                                                    0)
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        AlertDialog(
                                                                      title: Text(
                                                                          'Please upload an image'),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text('Ok'),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                else {
                                                                  setState(() {
                                                                    _loading =
                                                                        true;
                                                                  });

                                                                  await _reviewModel
                                                                      .getMyReviews(
                                                                    widget.arguments['order']['order_details']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'product']['id'],
                                                                    _reviewDescription,
                                                                  );

                                                                  setState(() {
                                                                    _loading =
                                                                        false;
                                                                  });

                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              }
                                                            },
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 53,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff1e1e1e),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Center(
                                                          child: _loading
                                                              ? SizedBox(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  height: 20,
                                                                  width: 20,
                                                                )
                                                              : Text(
                                                                  'Post Review',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      MyGoogleFontStyle(
                                                                    fontFamily:
                                                                        'Urbanist',
                                                                    fontSize:
                                                                        15.1428556442,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    height:
                                                                        1.4999999685,
                                                                    color: Color(
                                                                        0xffffffff),
                                                                  ),
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
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 74.5,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Color(0xff232323),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+ Review',
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
                              )
                            ],
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
                                    text: 'Colour: ',
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
                                  'RS' +
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
                    ),
                  ),
                  // ),
                  Column(
                    children: [
                      Container(
                        width: 321 * fem,
                        height: 24 * fem,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 215 * fem, 0 * fem),
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
                                'RS' +
                                    ' ' +
                                    widget.arguments['order']['order_cost']
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
                      Container(
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
                                'RS' +
                                    ' ' +
                                    widget.arguments['order']['tax_amount']
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
                      Container(
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
                                'RS' +
                                    ' ' +
                                    widget.arguments['order']['delivery_amount']
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
                      Container(
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
                                'RS' +
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
                      SizedBox(
                        width: 320,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  Column(
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
                                  fontSize: 14 * ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.6 * ffem / fem,
                                  color: Color(0xff1e1e1e),
                                ),
                              ),
                            ),
                            Text(
                              'RS' +
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

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Container(
                      // width: 200 * fem,
                      // height: 44 * fem,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
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
                          Align(
                            alignment: Alignment.centerLeft,
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Container(
                      // width: 141 * fem,
                      // height: 44 * fem,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
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
                          Align(
                            alignment: Alignment.centerLeft,
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Container(
                      // width: 80 * fem,
                      // height: 44 * fem,
                      child: Column(
                        children: [
                          SizedBox(
                            // width: 77 * fem,
                            // height: 24 * fem,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Phone number: ',
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
                          SizedBox(
                            // width: 80 * fem,
                            // height: 24 * fem,
                            child: Align(
                              alignment: Alignment.centerLeft,
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Container(
                      // width: 285 * fem,
                      // height: 60 * fem,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Deliver to: ',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 2 * ffem / fem,
                                color: Color(0xff1e1e1e),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
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
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   elevation: 10,
      //   iconSize: 30,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.black,
      //   selectedFontSize: 14,
      //   unselectedFontSize: 14,
      //   onTap: (value) async {
      //     if (value == 0) {
      //       Navigator.pushNamed(context, '/homePage');
      //     }
      //     if (value == 1) {
      //       Navigator.pushNamed(context, '/wishlistPage');
      //     }

      //     if (value == 2) {
      //       Map<String, dynamic> _CartData = {
      //         'kindOfFlower': '',
      //         'flavour': '',
      //         'writeOnCake': '',
      //         'pack': ''
      //       };
      //       await _addToCartModel.getAddToCart('', '', _CartData);
      //       Navigator.pushNamed(context, '/cartPage');
      //     }
      //     if (value == 3) {
      //       Navigator.pushNamed(context, '/profilePage');
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: Iconoir(Iconoir.home_simple),
      //       // icon: Icon(DonIcons.wap_home, size: 23),
      //     ),
      //     BottomNavigationBarItem(label: 'Saved', icon: Iconoir(Iconoir.heart)),
      //     BottomNavigationBarItem(
      //       label: 'Cart',
      //       icon: Iconoir(Iconoir.shopping_bag),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Profile',
      //       icon: Icon(
      //         DonIcons.user_o,
      //         size: 23,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

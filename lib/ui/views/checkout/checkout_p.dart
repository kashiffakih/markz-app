import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class CheckoutPage extends StatefulWidget {
  final arguments;
  const CheckoutPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    final OrderModel _orderModel = Provider.of<OrderModel>(context);
    final ConfigModel _configModel = locator<ConfigModel>();

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
                                'Checkout',
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
                  height: 600,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 25,
                        top: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Shipping Address
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Shipping address',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/edit-2-mP4.png',
                                    width: 15.34,
                                    height: 19.15,
                                  )
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 50,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _configModel.user.firstName.toString(),
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
                              // Payment
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Payment',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/edit-2-mP4.png',
                                    width: 15.34,
                                    height: 19.15,
                                  )
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 50,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cash On Delivery',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Delivery Method
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Delivery Method',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/edit-2-mP4.png',
                                    width: 15.34,
                                    height: 19.15,
                                  )
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 50,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Delivery Method',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Send as a gift
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Send as a gift',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/edit-2-mP4.png',
                                    width: 15.34,
                                    height: 19.15,
                                  )
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 50,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Order',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff909090),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '₹ ' +
                                              widget.arguments['cartTotal']
                                                  .toString(),
                                          textAlign: TextAlign.right,
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff303030),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Delivery',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff909090),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '₹ ' +
                                              _configModel.user.companies![0]
                                                  .deliveryCharges
                                                  .toString(),
                                          textAlign: TextAlign.right,
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff303030),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Tax %',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff909090),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '₹ ' +
                                              _configModel
                                                  .user.companies![0].taxPercent
                                                  .toString(),
                                          textAlign: TextAlign.right,
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff303030),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Tax Amount',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff909090),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '₹ ' +
                                              (int.parse(widget.arguments[
                                                              'cartTotal']
                                                          .toString()) /
                                                      100 *
                                                      int.parse(_configModel
                                                          .user
                                                          .companies![0]
                                                          .taxPercent
                                                          .toString()))
                                                  .toString(),
                                          textAlign: TextAlign.right,
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff303030),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Packaging',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff909090),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '₹ ' +
                                              (int.parse(_configModel
                                                      .user
                                                      .companies![0]
                                                      .packagingCharges
                                                      .toString()))
                                                  .toString(),
                                          textAlign: TextAlign.right,
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff303030),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff909090),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '₹ ' +
                                              (int.parse(widget.arguments['cartTotal'].toString()) +
                                                      int.parse(_configModel
                                                          .user
                                                          .companies![0]
                                                          .deliveryCharges
                                                          .toString()) +
                                                      (int.parse(widget.arguments[
                                                                  'cartTotal']
                                                              .toString()) /
                                                          100 *
                                                          int.parse(_configModel
                                                              .user
                                                              .companies![0]
                                                              .taxPercent
                                                              .toString())) +
                                                      (int.parse(_configModel
                                                          .user
                                                          .companies![0]
                                                          .packagingCharges
                                                          .toString())))
                                                  .toString(),
                                          textAlign: TextAlign.right,
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff303030),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Submit Order
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0.89, 0, 0, 0),
                                child: TextButton(
                                  onPressed: () async {
                                    bool response =
                                        await _orderModel.placedOrder(
                                            widget.arguments['cartItems'],
                                            widget.arguments['cartTotal']
                                                .toString());
                                    if (response == true) {
                                      Navigator.pushNamed(
                                          context, '/successPage');
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Container(
                                    width: 321,
                                    height: 53,
                                    decoration: BoxDecoration(
                                      color: Color(0xff1e1e1e),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Submit Order',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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

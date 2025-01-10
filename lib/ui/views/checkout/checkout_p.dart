import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/core/providers/user_wallet_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/profile/address_p.dart';

class CheckoutPage extends StatefulWidget {
  final arguments;
  const CheckoutPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

List<String> timeSlotForDubai = [
  '11 AM - 1 PM',
  '2 PM - 5 PM',
  '4 PM - 7 PM',
  '7 PM - 9:30 PM'
];
List<String> timeSlotForOther = ['4 PM - 7:30 PM', '7 PM - 9:30 PM'];
List<String> paymentOptions = ['UPI'];

var paymentOption = '';
var deliveryMethod = '';

class _CheckoutPageState extends State<CheckoutPage> {
  bool isGift = false;
  @override
  Widget build(BuildContext context) {
    final OrderModel _orderModel = Provider.of<OrderModel>(context);
    final ConfigModel _configModel = locator<ConfigModel>();
    setState(() {
      Provider.of<UserWalletModel>(context, listen: false).getMyUserWallets();
    });
    final UserWalletModel _userWaletModel =
        Provider.of<UserWalletModel>(context);
    // print(_userWaletModel.totalEarnPoint.toString());
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20),
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
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddressPage(arguments: {
                                                    'cartItems': widget
                                                        .arguments['cartItems'],
                                                    'cartTotal': widget
                                                        .arguments['cartTotal'],
                                                    'couponValue':
                                                        widget.arguments[
                                                            'couponValue'],
                                                    'isAddress': true
                                                  })));
                                    },
                                    child: Image.asset(
                                      'assets/images/edit-2-mP4.png',
                                      width: 15.34,
                                      height: 19.15,
                                    ),
                                  )
                                ],
                              ),
                              if (widget.arguments['address'] != null)
                                Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
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
                                      Text(
                                        _configModel.user!.firstName
                                                .toString() +
                                            " [${widget.arguments!['address']['label'].toString()}]",
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
                                        widget.arguments!['address']['add_1']
                                                .toString() +
                                            ', ' +
                                            widget.arguments!['address']
                                                    ['add_2']
                                                .toString() +
                                            ', ' +
                                            widget.arguments!['address']
                                                    ['nationality']
                                                .toString() +
                                            ', ' +
                                            widget.arguments!['address']['city']
                                                .toString() +
                                            ', ' +
                                            widget.arguments!['address']
                                                    ['state']
                                                .toString(),
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff909090),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (widget.arguments['address'] == null)
                                Center(
                                  child: Container(
                                    width: 150,
                                    height: 40,
                                    margin: EdgeInsets.fromLTRB(0.89, 10, 0, 0),
                                    child: TextButton(
                                      onPressed: () {
                                        // widget.arguments['cartTotal']
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddressPage(arguments: {
                                                      'cartItems':
                                                          widget.arguments[
                                                              'cartItems'],
                                                      'cartTotal':
                                                          widget.arguments[
                                                              'cartTotal'],
                                                      'couponValue':
                                                          widget.arguments[
                                                              'couponValue'],
                                                      'isAddress': true
                                                    })));
                                        // Navigator.pushNamed(
                                        //     context, '/addressPage');
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Container(
                                        width: 321,
                                        height: 53,
                                        decoration: BoxDecoration(
                                          color: Color(0xff1e1e1e),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Add Address',
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
                                  // Image.asset(
                                  //   'assets/images/edit-2-mP4.png',
                                  //   width: 15.34,
                                  //   height: 19.15,
                                  // )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Color(0xffdadada)),
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: Color(0xffc7b456)),
                                  ),
                                  child: DropdownButtonFormField(
                                      // value: paymentOption,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          labelText: 'Select Payment Method',
                                          contentPadding: EdgeInsets.all(10)),
                                      items: paymentOptions
                                          .map(
                                            (_payment) => DropdownMenuItem(
                                              child: Text(
                                                _payment,
                                              ),
                                              value: _payment,
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          print(value.toString);
                                          paymentOption = value.toString();

                                          // _userAddress.nationality = value.toString();
                                        });
                                      })),
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
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  // border: Border.all(color: Color(0xffdadada)),
                                  color: Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Color(0xffc7b456)),
                                ),
                                child: widget.arguments!['address']
                                                    ['nationality']
                                                .toString() ==
                                            "Dubai" &&
                                        widget.arguments!['address']['state']
                                                .toString() ==
                                            "Dubai"
                                    ? DropdownButtonFormField(
                                        // value: deliveryMethod,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            labelText: 'Select Delivery Method',
                                            contentPadding: EdgeInsets.all(10)),
                                        items: timeSlotForDubai
                                            .map(
                                              (_deliveryMethod) =>
                                                  DropdownMenuItem(
                                                child: Text(
                                                  _deliveryMethod,
                                                ),
                                                value: _deliveryMethod,
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            print(value.toString);
                                            deliveryMethod = value.toString();

                                            // _userAddress.nationality = value.toString();
                                          });
                                        })
                                    : DropdownButtonFormField(
                                        // value: deliveryMethod,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            labelText: 'Select Delivery Method',
                                            contentPadding: EdgeInsets.all(10)),
                                        items: timeSlotForOther
                                            .map(
                                              (_deliveryMethod) =>
                                                  DropdownMenuItem(
                                                child: Text(
                                                  _deliveryMethod,
                                                ),
                                                value: _deliveryMethod,
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            print(value.toString);
                                            deliveryMethod = value.toString();

                                            // _userAddress.nationality = value.toString();
                                          });
                                        }),
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
                                  Checkbox(
                                    value: isGift,
                                    activeColor: Colors.black,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isGift = value ?? false;
                                      });

                                      if (isGift == true) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            title: Text(
                                                "Is it the same address as mentioned above?"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddressPage(
                                                                  arguments: {
                                                                    'cartItems':
                                                                        widget.arguments[
                                                                            'cartItems'],
                                                                    'cartTotal':
                                                                        widget.arguments[
                                                                            'cartTotal'],
                                                                    'couponValue':
                                                                        widget.arguments[
                                                                            'couponValue'],
                                                                    'isAddress':
                                                                        true
                                                                  })));
                                                },
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
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
                                            'Sub Total',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff909090),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'RS' +
                                              ' ' +
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
                                          'RS' +
                                              ' ' +
                                              _configModel.user!.companies![0]
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
                                          'RS' +
                                              ' ' +
                                              _configModel.user!.companies![0]
                                                  .taxPercent
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
                                          'RS' +
                                              ' ' +
                                              (int.parse(widget.arguments[
                                                              'cartTotal']
                                                          .toString()) /
                                                      100 *
                                                      int.parse(_configModel
                                                          .user!
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
                                            'Coupon (-)',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff909090),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'RS' +
                                              ' ' +
                                              widget.arguments['couponValue']
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
                                            'Wallet (-)',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff909090),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'RS' +
                                              ' ' +
                                              (int.parse(_userWaletModel
                                                          .totaRemainingPoint
                                                          .toString()) /
                                                      3)
                                                  .toStringAsFixed(0),
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
                                          'RS' +
                                              ' ' +
                                              (int.parse(widget.arguments['cartTotal'].toString()) +
                                                      int.parse(_configModel
                                                          .user!
                                                          .companies![0]
                                                          .deliveryCharges
                                                          .toString()) +
                                                      (int.parse(widget.arguments['cartTotal'].toString()) /
                                                          100 *
                                                          int.parse(_configModel
                                                              .user!
                                                              .companies![0]
                                                              .taxPercent
                                                              .toString())) +
                                                      -(int.parse(
                                                          widget.arguments['couponValue']
                                                              .toString())) -
                                                      (int.parse(_userWaletModel
                                                              .totaRemainingPoint
                                                              .toString()) /
                                                          3))
                                                  .toStringAsFixed(0),
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
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 120,
                ),
                widget.arguments['address'] != null
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0.89, 0, 0, 0),
                          child: TextButton(
                            onPressed: () async {
                              var orderCost = (int.parse(widget
                                          .arguments['cartTotal']
                                          .toString()) +
                                      int.parse(_configModel
                                          .user!.companies![0].deliveryCharges
                                          .toString()) +
                                      (int.parse(widget.arguments['cartTotal'].toString()) /
                                          100 *
                                          int.parse(_configModel
                                              .user!.companies![0].taxPercent
                                              .toString())) +
                                      -(int.parse(widget
                                          .arguments['couponValue']
                                          .toString())) -
                                      (int.parse(_userWaletModel.totaRemainingPoint.toString()) /
                                          1))
                                  .toStringAsFixed(0);

                              var userWalletUsed = (int.parse(_userWaletModel
                                          .totaRemainingPoint
                                          .toString()) /
                                      3)
                                  .toStringAsFixed(0);
                              var addressId = widget.arguments['address']['id'];
                              bool response = await _orderModel.placedOrder(
                                widget.arguments['cartItems'],
                                widget.arguments['cartTotal'].toString(),
                                addressId,
                                isGift,
                                userWalletUsed,
                                widget.arguments['couponId'].toString(),
                                paymentOption,
                                deliveryMethod,
                                widget.arguments['couponValue'].toString(),
                              );
                              if (response == true) {
                                Navigator.pushNamed(context, '/successPage');
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
                                  'Paid/Continue',
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
                      )
                    : Center(
                        child: Text(
                          'Select/Add Address befor checkout.',
                          style: TextStyle(fontSize: 16, color: Colors.red),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/user_address.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/coupon_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/core/providers/user_wallet_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/checkout/checkout_p.dart';
import 'package:sales_app/ui/views/products/shops_p.dart';
import 'package:sales_app/ui/views/profile/address_p.dart';
import 'package:sales_app/ui/views/promocodes/promocodes_p.dart';

class CartPage extends StatefulWidget {
  final arguments;
  const CartPage({
    Key? key,
    this.arguments,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String coupon = '';
  String couponId = '';
  int couponValue = 0;
  UserAddress address = UserAddress();

  // bool type = true;
  @override
  void initState() {
    Provider.of<AddToCartModel>(context, listen: false)
        .getAddToCart('', '', '');
    Provider.of<OrderModel>(context, listen: false).getOrder();
    super.initState();
    Provider.of<UserWalletModel>(context, listen: false).getMyUserWallets();
  }

  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': ''
  };
  TextEditingController _controller = TextEditingController();
  List<String> paymentOptions = [
    'CoD (Not available)',
    'Google Pay',
    'PhonePe'
  ];

  var paymentOption = '';

  bool isGift = false;
  @override
  Widget build(BuildContext context) {
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final ConfigModel _configModel = locator<ConfigModel>();
    final OrderModel _orderModel = Provider.of<OrderModel>(context);
    final CouponModel _couponModel = Provider.of<CouponModel>(context);
    final UserWalletModel _userWaletModel =
        Provider.of<UserWalletModel>(context);

    setState(() {
      if (_orderModel.orders.length > 0) {
        address = _orderModel.orders[0].address!;
      }
      if (widget.arguments != null) {
        if (widget.arguments['address'] != null) {
          address = UserAddress.fromJson(widget.arguments['address']);
        }
      }
      print(address.add1.toString());
    });

    return new WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/homePage');
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
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
                              child: Center(
                                child: Text(
                                  'My Cart',
                                  textAlign: TextAlign.center,
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff1e232c),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/homePage');
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 15,
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 18,
                                      color: Color(0xffEED056),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Container(
                                  width: 238,
                                  height: 38,
                                  padding: const EdgeInsets.only(
                                    left: 21,
                                    right: 20.70,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 0.50,
                                          color: Color(0xFFC7B456)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, // Center vertically
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 17.0),
                                          child: TextFormField(
                                            controller: _controller,
                                            onChanged: (value) {
                                              // if (value.length % 3 == 0) {
                                              // Call your API here
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ShopsPage(
                                                      initialText: value
                                                          .toString()), // Pass initialText if needed
                                                ),
                                              );
                                              _controller.clear();
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Search',
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 18,
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w600,
                                              // letterSpacing: -0.36,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                          'assets/images/Search-1.png',
                                          height: 20,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      // Body
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        // height: MediaQuery.of(context).size.height - 250,
                        child: _addToCartModel.addToCarts!.isEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 60,
                                    child: Center(child: Text('Cart is empty')),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: Center(
                                        child: TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.black),
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              shape: MaterialStateProperty.all<
                                                  OutlinedBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // Adjust the radius as needed
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ShopsPage(
                                                      initialText:
                                                          ''), // Pass initialText if needed
                                                ),
                                              );
                                            },
                                            child: Text('Add Products'))),
                                  ),
                                ],
                              )
                            : SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    (0.23 *
                                        (_addToCartModel.addToCarts!.length < 2
                                            ? _addToCartModel.addToCarts!.length
                                            : 2)),
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        _addToCartModel.addToCarts!.length,
                                    itemBuilder: (BuildContext context, index) {
                                      double discountPrice = (int.parse(
                                                  _addToCartModel
                                                      .addToCarts![index]
                                                      .product!
                                                      .productPrices![0]
                                                      .price
                                                      .toString()) -
                                              int.parse(_addToCartModel
                                                  .addToCarts![index]
                                                  .product!
                                                  .productPrices![0]
                                                  .offerPrice
                                                  .toString())) /
                                          int.parse(_addToCartModel
                                              .addToCarts![index]
                                              .product!
                                              .productPrices![0]
                                              .price
                                              .toString()) *
                                          100;
                                      // print(discountPrice.round());
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 10, 0),
                                                  child: Center(
                                                      child: Image.network(
                                                    _configModel.apiConfig[
                                                            'mediaURL'] +
                                                        _addToCartModel
                                                            .addToCarts![index]
                                                            .product!
                                                            .imagepath1
                                                            .toString(),
                                                    // 'assets/images/mask-group-HvE.png',
                                                    fit: BoxFit.contain,
                                                    // width: 120,
                                                    // height: 150,
                                                  )),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          _addToCartModel
                                                              .addToCarts![
                                                                  index]
                                                              .product!
                                                              .name
                                                              .toString(),
                                                          style:
                                                              MyGoogleFontStyle(
                                                            fontFamily:
                                                                'Urbanist',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff909090),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: _addToCartModel
                                                                      .addToCarts![
                                                                          index]
                                                                      .product!
                                                                      .productPrices![
                                                                          0]
                                                                      .offerPrice !=
                                                                  0
                                                              ? Text.rich(
                                                                  TextSpan(
                                                                      children: [
                                                                      new TextSpan(
                                                                        text:
                                                                            'RS. ${_addToCartModel.addToCarts![index].product!.productPrices![0].price.toString()}',
                                                                        style:
                                                                            new TextStyle(
                                                                          color:
                                                                              Colors.grey,
                                                                          decoration:
                                                                              TextDecoration.lineThrough,
                                                                        ),
                                                                      ),
                                                                      new TextSpan(
                                                                        text:
                                                                            ' RS.${_addToCartModel.addToCarts![index].product!.productPrices![0].offerPrice.toString()}',
                                                                      ),
                                                                    ]))
                                                              : Text(
                                                                  'RS. ${_addToCartModel.addToCarts![index].product!.productPrices![0].price.toString()}',
                                                                  style:
                                                                      MyGoogleFontStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 1.5,
                                                                    letterSpacing:
                                                                        -0.2190869331,
                                                                    color: Color(
                                                                        0x99000000),
                                                                  ),
                                                                )),
                                                      if (discountPrice != 0.0)
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '( ${discountPrice.round()}% Off)',
                                                            style:
                                                                MyGoogleFontStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                            ),
                                                          ),
                                                        ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Size:  ${_addToCartModel.addToCarts![index].kindOfFlower}',
                                                          style:
                                                              MyGoogleFontStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Colour:  ${_addToCartModel.addToCarts![index].flavour}',
                                                          style:
                                                              MyGoogleFontStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            Text(
                                                              ' ( ${(_addToCartModel.addToCarts![index].product!.reviews == null ? 0 : _addToCartModel.addToCarts![index].product!.reviews?.length)} ratings )',
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Expanded(flex: 1, child: Text('')),
                                              Expanded(
                                                flex: 6,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Row(
                                                    children: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          bool minus = false;
                                                          await _addToCartModel
                                                              .getAddToCart(
                                                                  _addToCartModel
                                                                      .addToCarts![
                                                                          index]
                                                                      .product!
                                                                      .id,
                                                                  minus,
                                                                  _CartData);
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          padding:
                                                              EdgeInsets.zero,
                                                        ),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border:
                                                                Border.all(),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                          ),
                                                          child: Icon(
                                                              Icons.remove,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      Text(
                                                        _addToCartModel
                                                            .addToCarts![index]
                                                            .qty
                                                            .toString(),
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          bool type = true;

                                                          await _addToCartModel
                                                              .getAddToCart(
                                                                  _addToCartModel
                                                                      .addToCarts![
                                                                          index]
                                                                      .product!
                                                                      .id,
                                                                  type,
                                                                  _CartData);
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          padding:
                                                              EdgeInsets.zero,
                                                        ),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border:
                                                                Border.all(),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                          ),
                                                          child: Icon(Icons.add,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // SizedBox(
                                          //   height: 5,
                                          // ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                50,
                                            child: Divider(
                                              thickness: 2,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                      ),
                    ],
                  ),
                ),
                if (_addToCartModel.addToCarts!.length != 0)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Column(
                        children: [
                          // if (couponValue == '')
                          Form(
                            key: _formKey,
                            child: Row(children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Color(0xffe3e3e3)),
                                    color: Color(0xfffbfbfb),
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(9, 6, 1, 5),
                                      hintText: 'Enter your promocode',
                                      hintStyle:
                                          TextStyle(color: Color(0x3f000000)),
                                    ),
                                    style: MyGoogleFontStyle(
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff000000),
                                    ),
                                    onSaved: (value) {
                                      coupon = value.toString();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () async {
                                    _formKey.currentState!.save();

                                    await _couponModel.verifyCoupon(coupon);
                                    // print(_couponModel.coupons![0].minOrderValue);
                                    if (_couponModel.coupons != null &&
                                        _couponModel.coupons!.isNotEmpty) {
                                      final firstCoupon =
                                          _couponModel.coupons![0];
                                      final cartTotal = int.parse(
                                          _addToCartModel.cartTotal.toString());

                                      if (firstCoupon.minOrderValue! <
                                          cartTotal) {
                                        setState(() {
                                          couponValue = double.parse(
                                                  firstCoupon.value.toString())
                                              .toInt();
                                          couponId = firstCoupon.id.toString();
                                        });
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            title: Text(
                                                "The Product amount should be greater than ${firstCoupon.minOrderValue.toString()}"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Ok'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          title: Text("Invalid coupon."),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Ok'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xff1e1e1e),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Apply',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          ),

                          // Promo Code
                          InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PromocodesPage()),
                              );
                              // setState(() {
                              await _couponModel.verifyCoupon(result);
                              final firstCoupon = _couponModel.coupons![0];
                              final cartTotal = int.parse(
                                  _addToCartModel.cartTotal.toString());

                              if (firstCoupon.minOrderValue! < cartTotal) {
                                setState(() {
                                  couponValue =
                                      double.parse(firstCoupon.value.toString())
                                          .toInt();
                                  couponId = firstCoupon.id.toString();
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    title: Text(
                                        "The Product amount should be greater than ${firstCoupon.minOrderValue.toString()}"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              // });
                              // print(result);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('View all promocodes'),
                            ),
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // if (_addToCartModel.addToCarts!.length != 0)
                          //   Row(
                          //     children: [
                          //       Text(
                          //         'Total:',
                          //         style: MyGoogleFontStyle(
                          //           fontFamily: 'Urbanist',
                          //           fontWeight: FontWeight.w700,
                          //           color: Color(0xff808080),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: Text(
                          //           _addToCartModel.cartTotal.toString() != null
                          //               ? 'RS' +
                          //                   ' ' +
                          //                   (int.parse(_addToCartModel.cartTotal
                          //                               .toString()) -
                          //                           int.parse(
                          //                               couponValue.toString()))
                          //                       .toString()
                          //               : 'RS' + '0',
                          //           textAlign: TextAlign.right,
                          //           style: MyGoogleFontStyle(
                          //             fontFamily: 'Inter',
                          //             fontWeight: FontWeight.w700,
                          //             color: Color(0xff303030),
                          //           ),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          SizedBox(
                            height: 10,
                          ),
                          // _addToCartModel.addToCarts!.length != 0
                          //     ? Container(
                          //         margin: EdgeInsets.fromLTRB(0.89, 0, 0, 0),
                          //         child: TextButton(
                          //           onPressed: () {
                          //             Navigator.of(context).push(
                          //                 MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         CheckoutPage(arguments: {
                          //                           'cartTotal': _addToCartModel
                          //                               .cartTotal
                          //                               .toString(),
                          //                           'cartItems': _addToCartModel
                          //                               .addToCarts,
                          //                           'address': _orderModel
                          //                                   .orders.isNotEmpty
                          //                               ? _orderModel
                          //                                   .orders[0].address!
                          //                                   .toJson()
                          //                               : null,
                          //                           'couponValue': couponValue,
                          //                           'couponId': couponId
                          //                         })));
                          //           },
                          //           style: TextButton.styleFrom(
                          //             padding: EdgeInsets.zero,
                          //           ),
                          //           child: Container(
                          //             width: 321,
                          //             height: 53,
                          //             decoration: BoxDecoration(
                          //               color: Color(0xff1e1e1e),
                          //               borderRadius: BorderRadius.circular(10),
                          //             ),
                          //             child: Center(
                          //               child: Text(
                          //                 'Checkout',
                          //                 style: MyGoogleFontStyle(
                          //                   fontFamily: 'Urbanist',
                          //                   fontWeight: FontWeight.w700,
                          //                   color: Color(0xffffffff),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       )
                          //     : Text(''),
                          Container(
                            // height: 750,
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                // Title

                                // Body
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.65,
                                  // height: 480,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                            AddressPage(
                                                                arguments: {
                                                                  'cartTotal':
                                                                      _addToCartModel
                                                                          .cartTotal
                                                                          .toString(),
                                                                  'cartItems':
                                                                      _addToCartModel
                                                                          .addToCarts,

                                                                  'couponValue':
                                                                      couponValue,

                                                                  // 'cartItems':
                                                                  //     widget
                                                                  //         .arguments['cartItems'],
                                                                  // 'cartTotal':
                                                                  //     widget
                                                                  //         .arguments['cartTotal'],
                                                                  // 'couponValue':
                                                                  //     widget
                                                                  //         .arguments['couponValue'],
                                                                  'isAddress':
                                                                      true
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
                                        if (_orderModel.orders.length > 0)
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                50,
                                            margin: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xffc7b456)),
                                              color: Color(0xffffffff),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x338a959e),
                                                  offset:
                                                      Offset(0, 7.6690645218),
                                                  blurRadius: 19.1726608276,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _configModel.user.firstName
                                                          .toString() +
                                                      " [${address.label.toString()}]",
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
                                                  address!.add1.toString() +
                                                      ', ' +
                                                      address!.add2.toString() +
                                                      ', ' +
                                                      address!.nationality
                                                          .toString() +
                                                      ', ' +
                                                      address!.city.toString() +
                                                      ', ' +
                                                      address!.state.toString(),
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff909090),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (_orderModel.orders.length == 0)
                                          Center(
                                            child: Container(
                                              width: 150,
                                              height: 40,
                                              margin: EdgeInsets.fromLTRB(
                                                  0.89, 10, 0, 0),
                                              child: TextButton(
                                                onPressed: () {
                                                  // _addToCartModel
                                                  // .cartTotal
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddressPage(
                                                                  arguments: {
                                                                    'cartTotal':
                                                                        _addToCartModel
                                                                            .cartTotal
                                                                            .toString(),
                                                                    'cartItems':
                                                                        _addToCartModel
                                                                            .addToCarts,
                                                                    'couponValue':
                                                                        couponValue,
                                                                    'isAddress':
                                                                        true
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
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Add Address',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xffffffff),
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
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Color(0xffc7b456)),
                                            ),
                                            child: DropdownButtonFormField(
                                                // value: paymentOption,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    labelText:
                                                        'Select Payment Method',
                                                    contentPadding:
                                                        EdgeInsets.all(10)),
                                                items: paymentOptions
                                                    .map(
                                                      (_payment) =>
                                                          DropdownMenuItem(
                                                        child: Text(
                                                          _payment,
                                                        ),
                                                        value: _payment,
                                                      ),
                                                    )
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    paymentOption =
                                                        value.toString();

                                                    // _userAddress.nationality = value.toString();
                                                  });
                                                })),

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
                                              activeColor: Color.fromARGB(
                                                  255, 250, 225, 1),
                                              checkColor: Colors.black,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isGift = value ?? false;
                                                });

                                                if (isGift == true) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      title: Text(
                                                          "Is it the same address as mentioned above?"),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Yes',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                                              'cartTotal': _addToCartModel.cartTotal.toString(),
                                                                              'cartItems': _addToCartModel.addToCarts,
                                                                              'couponValue': couponValue,
                                                                              'isAddress': true
                                                                            })));
                                                          },
                                                          child: Text(
                                                            'No',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          height: 210,
                                          margin: EdgeInsets.only(
                                            top: 10,
                                          ),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xffc7b456)),
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
                                                      'Sub Total',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff909090),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'RS' +
                                                        ' ' +
                                                        _addToCartModel
                                                            .cartTotal
                                                            .toString(),
                                                    textAlign: TextAlign.right,
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff909090),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'RS' +
                                                        ' ' +
                                                        _configModel
                                                            .user
                                                            .companies![0]
                                                            .deliveryCharges
                                                            .toString(),
                                                    textAlign: TextAlign.right,
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff909090),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'RS' +
                                                        ' ' +
                                                        _configModel
                                                            .user
                                                            .companies![0]
                                                            .taxPercent
                                                            .toString(),
                                                    textAlign: TextAlign.right,
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff909090),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'RS' +
                                                        ' ' +
                                                        (int.parse(_addToCartModel
                                                                    .cartTotal
                                                                    .toString()) /
                                                                100 *
                                                                int.parse(_configModel
                                                                    .user
                                                                    .companies![
                                                                        0]
                                                                    .taxPercent
                                                                    .toString()))
                                                            .toString(),
                                                    textAlign: TextAlign.right,
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff909090),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'RS' +
                                                        ' ' +
                                                        couponValue.toString(),
                                                    textAlign: TextAlign.right,
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff909090),
                                                      ),
                                                    ),
                                                  ),
                                                  if (_userWaletModel
                                                          .totaRemainingPoint !=
                                                      0)
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _userWaletModel
                                                              .totaRemainingPoint = 0;
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0),
                                                        child: Text('(Remove)'),
                                                      ),
                                                    ),
                                                  if (_userWaletModel
                                                          .totaRemainingPoint ==
                                                      0)
                                                    InkWell(
                                                      onTap: () async {
                                                        await _userWaletModel
                                                            .getMyUserWallets();
                                                        setState(() {
                                                          // _userWaletModel
                                                          //         .totaRemainingPoint =
                                                          //     _userWaletModel
                                                          //         .totaRemainingPoint; // Not sure what this line is doing
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0),
                                                        child: Text('(Add)'),
                                                      ),
                                                    ),
                                                  Text(
                                                    'RS ${(_userWaletModel.totaRemainingPoint ~/ 3)}', // Division by 3 directly
                                                    textAlign: TextAlign.right,
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff909090),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'RS' +
                                                        ' ' +
                                                        (int.parse(_addToCartModel
                                                                    .cartTotal
                                                                    .toString()) +
                                                                int.parse(_configModel
                                                                    .user
                                                                    .companies![
                                                                        0]
                                                                    .deliveryCharges
                                                                    .toString()) +
                                                                (int.parse(_addToCartModel
                                                                        .cartTotal
                                                                        .toString()) /
                                                                    100 *
                                                                    int.parse(_configModel
                                                                        .user
                                                                        .companies![
                                                                            0]
                                                                        .taxPercent
                                                                        .toString())) +
                                                                -(int.parse(couponValue.toString())) -
                                                                (int.parse(_userWaletModel.totaRemainingPoint.toString()) / 3))
                                                            .toStringAsFixed(0),
                                                    textAlign: TextAlign.right,
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                ),
                                SizedBox(
                                  height: 60,
                                  child: Center(
                                      child: TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.black),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10.0), // Adjust the radius as needed
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ShopsPage(
                                                    initialText:
                                                        ''), // Pass initialText if needed
                                              ),
                                            );
                                          },
                                          child: Text('Add More Products'))),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                _orderModel.orders.length > 0
                                    ? Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0.89, 0, 0, 0),
                                          child: TextButton(
                                            onPressed: () async {
                                              var orderCost = (int.parse(
                                                          _addToCartModel
                                                              .cartTotal
                                                              .toString()) +
                                                      int.parse(_configModel
                                                          .user
                                                          .companies![0]
                                                          .deliveryCharges
                                                          .toString()) +
                                                      (int.parse(_addToCartModel
                                                              .cartTotal
                                                              .toString()) /
                                                          100 *
                                                          int.parse(_configModel
                                                              .user
                                                              .companies![0]
                                                              .taxPercent
                                                              .toString())) +
                                                      -(int.parse(couponValue.toString())) -
                                                      (int.parse(_userWaletModel.totaRemainingPoint.toString()) / 3))
                                                  .toStringAsFixed(0);

                                              var userWalletUsed = (int.parse(
                                                          _userWaletModel
                                                              .totaRemainingPoint
                                                              .toString()) /
                                                      3)
                                                  .toStringAsFixed(0);
                                              var addressId = address.id;
                                              bool response =
                                                  await _orderModel.placedOrder(
                                                _addToCartModel.addToCarts!
                                                    .toList(),
                                                _addToCartModel.cartTotal
                                                    .toString(),
                                                addressId,
                                                isGift,
                                                userWalletUsed,
                                                couponId.toString(),
                                                paymentOption,
                                                deliveryMethod,
                                                couponValue.toString(),
                                              );
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.red),
                                        ),
                                      )
                              ],
                            ),
                          )
                        ],
                      ),
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

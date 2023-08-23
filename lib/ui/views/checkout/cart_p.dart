import 'package:flutter/material.dart';
import 'package:icon_forest/don_icons.dart';
import 'package:icon_forest/iconoir.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/coupon_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/checkout/checkout_p.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String coupon = '';
  String couponId = '';
  int couponValue = 0;
  // bool type = true;
  @override
  void initState() {
    Provider.of<AddToCartModel>(context, listen: false)
        .getAddToCart('', '', '');
    Provider.of<OrderModel>(context, listen: false).getOrder();
    super.initState();
  }

  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': ''
  };

  @override
  Widget build(BuildContext context) {
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final ConfigModel _configModel = locator<ConfigModel>();
    final OrderModel _orderModel = Provider.of<OrderModel>(context);
    final CouponModel _couponModel = Provider.of<CouponModel>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Body
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      // height: MediaQuery.of(context).size.height - 250,
                      child: _addToCartModel.addToCarts!.isEmpty
                          ? SizedBox(
                              height: 60,
                              child: Center(child: Text('Cart is empty')),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.width + 130,
                              child: ListView.builder(
                                itemCount: _addToCartModel.addToCarts!.length,
                                itemBuilder: (BuildContext context, index) =>
                                    Column(
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
                                              _configModel
                                                      .apiConfig['mediaURL'] +
                                                  _addToCartModel
                                                      .addToCarts![index]
                                                      .product!
                                                      .imagepath1
                                                      .toString(),
                                              // 'assets/images/mask-group-HvE.png',
                                              width: 80,
                                              height: 100,
                                            )),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    _addToCartModel
                                                        .addToCarts![index]
                                                        .product!
                                                        .name
                                                        .toString(),
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Urbanist',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff909090),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'د.إ' +
                                                        ' ' +
                                                        _addToCartModel
                                                            .addToCarts![index]
                                                            .product!
                                                            .productPrices![0]
                                                            .price
                                                            .toString(),
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xff1e1e1e),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Expanded(
                                            flex: 5,
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
                                                  style: TextButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                    ),
                                                    child: Icon(Icons.remove,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Text(
                                                  _addToCartModel
                                                      .addToCarts![index].qty
                                                      .toString(),
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
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
                                                  style: TextButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                    ),
                                                    child: Icon(Icons.add,
                                                        color: Colors.black),
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
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      child: Divider(
                                        thickness: 2,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              if (_addToCartModel.addToCarts!.length != 0)
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Row(children: [
                          Expanded(
                            flex: 8,
                            child: Container(
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
                                  contentPadding:
                                      EdgeInsets.fromLTRB(9, 6, 1, 5),
                                  hintText: 'Enter your promo code',
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
                                  final firstCoupon = _couponModel.coupons![0];
                                  final cartTotal = int.parse(
                                      _addToCartModel.cartTotal.toString());

                                  if (firstCoupon.minOrderValue! < cartTotal) {
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

                      SizedBox(
                        height: 10,
                      ),
                      if (_addToCartModel.addToCarts!.length != 0)
                        Row(
                          children: [
                            Text(
                              'Total:',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w700,
                                color: Color(0xff808080),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _addToCartModel.cartTotal.toString() != null
                                    ? 'د.إ' +
                                        ' ' +
                                        (int.parse(_addToCartModel.cartTotal
                                                    .toString()) -
                                                int.parse(
                                                    couponValue.toString()))
                                            .toString()
                                    : 'د.إ' + '0',
                                textAlign: TextAlign.right,
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff303030),
                                ),
                              ),
                            )
                          ],
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      _addToCartModel.addToCarts!.length != 0
                          ? Container(
                              margin: EdgeInsets.fromLTRB(0.89, 0, 0, 0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          CheckoutPage(arguments: {
                                            'cartTotal': _addToCartModel
                                                .cartTotal
                                                .toString(),
                                            'cartItems':
                                                _addToCartModel.addToCarts,
                                            'address': _orderModel
                                                    .orders.isNotEmpty
                                                ? _orderModel.orders[0].address!
                                                    .toJson()
                                                : null,
                                            'couponValue': couponValue,
                                            'couponId': couponId
                                          })));
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
                                      'Checkout',
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
                          : Text(''),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) async {
          if (value == 0) {
            Navigator.pushNamed(context, '/homePage');
          }
          if (value == 1) {
            Navigator.pushNamed(context, '/wishlistPage');
          }

          if (value == 2) {
            Map<String, dynamic> _CartData = {
              'kindOfFlower': '',
              'flavour': '',
              'writeOnCake': '',
              'pack': ''
            };
            await _addToCartModel.getAddToCart('', '', _CartData);
            Navigator.pushNamed(context, '/cartPage');
          }
          if (value == 3) {
            Navigator.pushNamed(context, '/profilePage');
          }
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Iconoir(Iconoir.home_simple),
            // icon: Icon(DonIcons.wap_home, size: 23),
          ),
          BottomNavigationBarItem(label: 'Saved', icon: Iconoir(Iconoir.heart)),
          BottomNavigationBarItem(
            label: 'Cart',
            icon: Iconoir(Iconoir.shopping_bag),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              DonIcons.user_o,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }
}

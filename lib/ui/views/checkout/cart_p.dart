import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:sales_app/core/models/add_to_cart.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
// import 'package:provider/provider.dart';
// import 'package:sales_app/core/providers/add_to_cart_pr.dart';
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
  // bool type = true;
  @override
  void initState() {
    Provider.of<AddToCartModel>(context, listen: false)
        .getAddToCart('', '', '');
    super.initState();
  }

  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
  };

  @override
  Widget build(BuildContext context) {
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
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
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 25,
                        top: 0,
                        child: SingleChildScrollView(
                          child: Container(
                            width: MediaQuery.of(context).size.width - 50,
                            height: MediaQuery.of(context).size.height - 250,
                            child: _addToCartModel.addToCartLoader
                                ? SizedBox(
                                    height: 60,
                                    child: Center(child: Text('Cart is empty')),
                                  )
                                : ListView.builder(
                                    itemCount:
                                        _addToCartModel.addToCarts!.length,
                                    itemBuilder:
                                        (BuildContext context, index) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 18, 0),
                                                child: Image.network(
                                                  _configModel.apiConfig[
                                                          'mediaURL'] +
                                                      _addToCartModel
                                                          .addToCarts![index]
                                                          .product!
                                                          .imagepath1
                                                          .toString(),
                                                  // 'assets/images/mask-group-HvE.png',
                                                  width: 100,
                                                  height: 100,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      _addToCartModel
                                                          .addToCarts![index]
                                                          .product!
                                                          .name
                                                          .toString(),
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff909090),
                                                      ),
                                                    ),
                                                    Text(
                                                      '₹ ' +
                                                          _addToCartModel
                                                              .addToCarts![
                                                                  index]
                                                              .product!
                                                              .productPrices![0]
                                                              .price
                                                              .toString(),
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff1e1e1e),
                                                      ),
                                                    ),
                                                    Row(
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
                                                                Icons.remove),
                                                          ),
                                                        ),
                                                        Text(
                                                          _addToCartModel
                                                              .addToCarts![
                                                                  index]
                                                              .qty
                                                              .toString(),
                                                          style:
                                                              MyGoogleFontStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff1e1e1e),
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
                                                            child:
                                                                Icon(Icons.add),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
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
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 25,
                        bottom: 100,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: Column(
                            children: [
                              // Promo Code
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Color(0xffe3e3e3)),
                                  color: Color(0xfffbfbfb),
                                ),
                                child: TextField(
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
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
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
                                      _addToCartModel.cartTotal.toString() !=
                                              null
                                          ? '₹ ' +
                                              _addToCartModel.cartTotal
                                                  .toString()
                                          : '₹ 0',
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
                                      margin:
                                          EdgeInsets.fromLTRB(0.89, 0, 0, 0),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckoutPage(arguments: {
                                                        'cartTotal':
                                                            _addToCartModel
                                                                .cartTotal
                                                                .toString(),
                                                        'cartItems':
                                                            _addToCartModel
                                                                .addToCarts
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                      ),
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

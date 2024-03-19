import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/wish_list_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

import '../products/shops_p.dart';
import 'package:badges/badges.dart' as badges;

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var productId = '';
      await Provider.of<WishListModel>(context, listen: false)
          .getWishLists(productId);
    });
  }

  double discountPrice = 0.0;
  @override
  Widget build(BuildContext context) {
    final WishListModel _wishListModel = Provider.of<WishListModel>(context);
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final ConfigModel _configModel = locator<ConfigModel>();
    TextEditingController _controller = TextEditingController();
    var cartCount = 0;
    setState(() {
      cartCount = _addToCartModel.addToCarts == null
          ? 0
          : _addToCartModel.addToCarts!.length;
    });
    return Scaffold(
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
                                'Wishlist',
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
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 15,
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
                                width: 258,
                                height: 38,
                                padding: const EdgeInsets.only(
                                  left: 21,
                                  right: 20.70,
                                ),
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 0.50, color: Color(0xFFC7B456)),
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
                                            const EdgeInsets.only(top: 15.0),
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
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/cartPage');
                                },
                                child: badges.Badge(
                                  badgeContent: Text(
                                    cartCount.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, // Center vertically
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/images/shopping_cart.png',
                                          height: 20,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                  ),
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
                      // height: MediaQuery.of(context).size.height - 90,
                      child: _wishListModel.wishLists!.length == 0
                          ? SizedBox(
                              height: 60,
                              child: Center(child: Text('Wishlist is empty')),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height - 240,
                              child: ListView.builder(
                                itemCount: _wishListModel.wishLists!.length,
                                itemBuilder: (BuildContext context, index) {
                                  discountPrice = (int.parse(_wishListModel
                                              .wishLists![index]
                                              .product!
                                              .productPrices![0]
                                              .price
                                              .toString()) -
                                          int.parse(_wishListModel
                                              .wishLists![index]
                                              .product!
                                              .productPrices![0]
                                              .offerPrice
                                              .toString())) /
                                      int.parse(_wishListModel.wishLists![index]
                                          .product!.productPrices![0].price
                                          .toString()) *
                                      100;
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 90,
                                            width: 80,
                                            child: Image.network(
                                              _configModel
                                                      .apiConfig['mediaURL'] +
                                                  _wishListModel
                                                      .wishLists![index]
                                                      .product!
                                                      .imagepath1
                                                      .toString(),
                                              // 'assets/images/mask-group-HvE.png',
                                              width: 80,
                                              height: 100,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            child: Expanded(
                                              flex: 5,
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      _wishListModel
                                                          .wishLists![index]
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
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text.rich(
                                                        TextSpan(
                                                          text: 'Total Price',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[500]),
                                                          children: [
                                                            WidgetSpan(
                                                              child: SizedBox(
                                                                  width:
                                                                      10), // Adjust the width as needed
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  'RS. ${_wishListModel.wishLists![index].product!.productPrices![0].price.toString()}',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFFC7B456),
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            WidgetSpan(
                                                              child: SizedBox(
                                                                  width:
                                                                      10), // Adjust the width as needed
                                                            ),
                                                            TextSpan(
                                                                text:
                                                                    'RS.${_wishListModel.wishLists![index].product!.productPrices![0].offerPrice.toString()}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            if (discountPrice !=
                                                                0.0)
                                                              WidgetSpan(
                                                                child: SizedBox(
                                                                    width:
                                                                        10), // Adjust the width as needed
                                                              ),
                                                            if (discountPrice !=
                                                                0.0)
                                                              TextSpan(
                                                                  text:
                                                                      '( ${discountPrice.round()}% Off)',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                          ],
                                                        ),
                                                      )

                                                      // Text(
                                                      //   'RS' +
                                                      //       ' ' +
                                                      // _wishListModel
                                                      //     .wishLists![index]
                                                      //     .product!
                                                      //     .productPrices![0]
                                                      //     .price
                                                      //           .toString(),
                                                      //   style: MyGoogleFontStyle(
                                                      //     fontFamily: 'Poppins',
                                                      //     fontWeight:
                                                      //         FontWeight.w600,
                                                      //     color:
                                                      //         Color(0xff1e1e1e),
                                                      //   ),
                                                      // ),
                                                      ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        bool type = true;
                                                        Map<String, dynamic>
                                                            _CartData = {
                                                          'kindOfFlower': '',
                                                          'flavour': '',
                                                          'writeOnCake': '',
                                                        };
                                                        await _addToCartModel
                                                            .getAddToCart(
                                                                _wishListModel
                                                                    .wishLists![
                                                                        index]
                                                                    .product!
                                                                    .id,
                                                                type,
                                                                _CartData);
                                                        setState(() {
                                                          _wishListModel
                                                              .getWishLists('');
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                13, 4, 14, 6),
                                                        width: 100,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff000000),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(0,
                                                                      0, 5, 0),
                                                              child: Text(
                                                                'Add to Cart',
                                                                style:
                                                                    MyGoogleFontStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Color(
                                                                      0xffffffff),
                                                                ),
                                                              ),
                                                            ),
                                                            Image.asset(
                                                              'assets/images/shopping-bag-03-YoY.png',
                                                              width: 9.5,
                                                              height: 9.2,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await _wishListModel.getWishLists(
                                                  _wishListModel
                                                      .wishLists![index]
                                                      .product!
                                                      .id);
                                            },
                                            icon: Icon(Icons.close_rounded),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        child: Divider(
                                          thickness: 2,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  child: Column(
                    children: [
                      if (_wishListModel.wishLists!.length != 0)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0.89, 0, 0, 0),
                            child: TextButton(
                              onPressed: () async {
                                await _wishListModel.addAllToCart();
                                setState(() {
                                  _wishListModel.getWishLists('');
                                });
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
                                    'Add all to my cart',
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
                    ],
                  ),
                ),
              ),
            ],
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

import 'package:flutter/material.dart';
import 'package:icon_forest/don_icons.dart';
import 'package:icon_forest/iconoir.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/wish_list_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    var productId = '';
    Provider.of<WishListModel>(context, listen: false).getWishLists(productId);
  }

  @override
  Widget build(BuildContext context) {
    final WishListModel _wishListModel = Provider.of<WishListModel>(context);
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final ConfigModel _configModel = locator<ConfigModel>();

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
                              ],
                            ),
                          ),
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
                                itemBuilder: (BuildContext context, index) =>
                                    Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 90,
                                          width: 80,
                                          child: Image.network(
                                            _configModel.apiConfig['mediaURL'] +
                                                _wishListModel.wishLists![index]
                                                    .product!.imagepath1
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
                                                        _wishListModel
                                                            .wishLists![index]
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
                                                      decoration: BoxDecoration(
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
                                                                .fromLTRB(
                                                                    0, 0, 5, 0),
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
                                                _wishListModel.wishLists![index]
                                                    .product!.id);
                                          },
                                          icon: Icon(Icons.close_rounded),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
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

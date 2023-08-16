import 'package:flutter/material.dart';
import 'package:icon_forest/don_icons.dart';
import 'package:icon_forest/iconoir.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/product.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/product_pr.dart';
import 'package:sales_app/core/providers/wish_list_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/products/product_id_p.dart';
import 'package:sales_app/ui/views/products/products_p.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({Key? key}) : super(key: key);

  @override
  State<ShopsPage> createState() => ShopsPageState();
}

class ShopsPageState extends State<ShopsPage> {
  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': ''
  };
  bool _isInitialLoad = false;
  List<Product>? filteredProducts = [];
  @override
  void initState() {
    super.initState();
    var productId = '';
    Provider.of<AddToCartModel>(context, listen: false)
        .getAddToCart(productId, '', _CartData);
    Provider.of<ProductModel>(context, listen: false).getAllProducts();
    Provider.of<ProductModel>(context, listen: false).getCategories();
    Provider.of<WishListModel>(context, listen: false).getWishLists(productId);
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.arguments['category'].toString());
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    final ConfigModel _configModel = locator<ConfigModel>();
    final ProductModel _productModel = Provider.of<ProductModel>(context);
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final WishListModel _wishListModel = Provider.of<WishListModel>(context);

    setState(() {
      if (!_isInitialLoad && _productModel.allProducts?.isNotEmpty == true) {
        filteredProducts = _productModel.allProducts;
        _isInitialLoad = true;
        // filteredProducts = [];
      } else {
        _isInitialLoad = false;
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.fromLTRB(9 * fem, 16 * fem, 0 * fem, 22 * fem),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    EdgeInsets.only(left: 20, top: 30, bottom: 20, right: 20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/homePage');
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
                              'Shops',
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
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                width: 381 * fem,
                height: 35 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          // filteredProducts = _productModel.allProducts!
                          //     .where((element) =>
                          //         element.categoryId ==
                          //         widget.arguments['categoryId'])
                          //     .toList();
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: 50 * fem,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5 * fem),
                        ),
                        child: Center(
                          child: Text(
                            'All',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 15 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.2 * ffem / fem,
                              letterSpacing: -0.36 * fem,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2 * fem,
                    ),
                    SizedBox(
                      width: 280,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _productModel.categories!.length,
                          itemBuilder: (BuildContext context, index) {
                            return Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductsPage(arguments: {
                                                    'categoryId': _productModel
                                                            .categories![index]
                                                        ['id'],
                                                    'subCategory': _productModel
                                                            .categories![index]
                                                        ['sub_categories'],
                                                    'category': _productModel
                                                            .categories![index]
                                                        ['name']
                                                  })));
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Container(
                                    width: 79 * fem,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xffc7b456)),
                                      borderRadius:
                                          BorderRadius.circular(5 * fem),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _productModel.categories![index]['name']
                                            .toString(),
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 15 * ffem,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2 * ffem / fem,
                                          letterSpacing: -0.36 * fem,
                                          color: Color(0x99000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 6 * fem,
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(12 * fem, 0 * fem, 22 * fem, 0 * fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    filteredProducts!.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            height: 782 * fem,
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 1 / 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                itemCount: filteredProducts!.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 145 * fem,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15 * fem),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 210.33 * fem,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    // frame9SvA (318:2815)
                                                    left: 0 * fem,
                                                    top: 0 * fem,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ProductIdPage(
                                                                        arguments: {
                                                                          'product': _productModel
                                                                              .allProducts![index]
                                                                              .toJson()
                                                                        })));
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                106 * fem,
                                                                13 * fem,
                                                                14 * fem,
                                                                13 * fem),
                                                        width: 145 * fem,
                                                        height: 193 * fem,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15 * fem),
                                                          color:
                                                              Color(0x0c000000),
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                              _configModel.apiConfig[
                                                                      'mediaURL'] +
                                                                  _productModel
                                                                      .allProducts![
                                                                          index]
                                                                      .imagepath1
                                                                      .toString(),
                                                            ),
                                                            // 'assets/images/shades-chocolate-cake-3-1-2-1-bg.png',
                                                          ),
                                                        ),
                                                        child: InkWell(
                                                          onTap: () async {
                                                            await _wishListModel
                                                                .getWishLists(
                                                                    _productModel
                                                                        .products![
                                                                            index]
                                                                        .id);
                                                          },
                                                          child: _wishListModel
                                                                      .wishLists!
                                                                      .where((wishList) =>
                                                                          wishList.productId == _productModel.allProducts![index].id &&
                                                                          wishList.userId ==
                                                                              _configModel.user.id)
                                                                      .toList()
                                                                      .length ==
                                                                  0
                                                              ? Align(
                                                                  // vectorRZx (318:2001)
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      SizedBox(
                                                                    width: 25 *
                                                                        fem,
                                                                    height:
                                                                        22.4 *
                                                                            fem,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/vector-yse.png',
                                                                      width: 25 *
                                                                          fem,
                                                                      height:
                                                                          22.4 *
                                                                              fem,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Align(
                                                                  // vectorRZx (318:2001)
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      SizedBox(
                                                                    width: 25 *
                                                                        fem,
                                                                    height:
                                                                        22.4 *
                                                                            fem,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/vector-wXc.png',
                                                                      width: 25 *
                                                                          fem,
                                                                      height:
                                                                          22.4 *
                                                                              fem,
                                                                    ),
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (_addToCartModel
                                                      .addToCarts!
                                                      .where((cart) =>
                                                          cart.productId ==
                                                              _productModel
                                                                  .allProducts![
                                                                      index]
                                                                  .id &&
                                                          cart.userId ==
                                                              _configModel
                                                                  .user.id)
                                                      .toList()
                                                      .isEmpty)
                                                    Positioned(
                                                      // frame494xX8 (318:2821)
                                                      left: 31 * fem,
                                                      top: 165 * fem,
                                                      child: TextButton(
                                                        onPressed: () async {
                                                          bool type = true;
                                                          await _addToCartModel
                                                              .getAddToCart(
                                                                  _productModel
                                                                      .allProducts![
                                                                          index]
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
                                                          width: 82 * fem,
                                                          height: 30 * fem,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Color(
                                                                    0xffeaeaea)),
                                                            color: Color(
                                                                0xffffffff),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7.0163693428 *
                                                                            fem),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0x3f000000),
                                                                offset: Offset(
                                                                    0 * fem,
                                                                    2.1298701763 *
                                                                        fem),
                                                                blurRadius:
                                                                    1 * fem,
                                                              ),
                                                            ],
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'ADD',
                                                              style:
                                                                  MyGoogleFontStyle(
                                                                fontFamily:
                                                                    'DM Sans',
                                                                fontSize:
                                                                    12 * ffem,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                height: 1 *
                                                                    ffem /
                                                                    fem,
                                                                color: Color(
                                                                    0xffc7b456),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  if (_addToCartModel
                                                      .addToCarts!
                                                      .where((cart) =>
                                                          cart.productId ==
                                                              _productModel
                                                                  .allProducts![
                                                                      index]
                                                                  .id &&
                                                          cart.userId ==
                                                              _configModel
                                                                  .user.id)
                                                      .toList()
                                                      .isNotEmpty)
                                                    Positioned(
                                                      left: 5 * fem,
                                                      top: 175 * fem,
                                                      child: Center(
                                                        child: Container(
                                                          width: 135 * fem,
                                                          height: 30 * fem,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Color(
                                                                    0xffeaeaea)),
                                                            color: Color(
                                                                0xffffffff),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7.0163693428 *
                                                                            fem),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0x3f000000),
                                                                offset: Offset(
                                                                    0 * fem,
                                                                    2.1298701763 *
                                                                        fem),
                                                                blurRadius:
                                                                    2.1298701763 *
                                                                        fem,
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            4.0,
                                                                        bottom:
                                                                            4),
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    bool minus =
                                                                        false;
                                                                    await _addToCartModel.getAddToCart(
                                                                        _productModel
                                                                            .allProducts![index]
                                                                            .id,
                                                                        minus,
                                                                        _CartData);
                                                                  },
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border
                                                                          .all(),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            5),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size:
                                                                            20,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                // '1',
                                                                _addToCartModel
                                                                    .addToCarts!
                                                                    .where((_aTC) =>
                                                                        _aTC.productId ==
                                                                        _productModel
                                                                            .allProducts![index]
                                                                            .id)
                                                                    .toList()[0]
                                                                    .qty
                                                                    .toString(),
                                                                style:
                                                                    MyGoogleFontStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                      0xff1e1e1e),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            4.0,
                                                                        bottom:
                                                                            4),
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    bool type =
                                                                        true;

                                                                    await _addToCartModel.getAddToCart(
                                                                        _productModel
                                                                            .allProducts![index]
                                                                            .id,
                                                                        type,
                                                                        _CartData);
                                                                  },
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border
                                                                          .all(),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            5),
                                                                      ),
                                                                    ),
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      size: 20,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
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
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductIdPage(
                                                                arguments: {
                                                                  'product': _productModel
                                                                      .allProducts![
                                                                          index]
                                                                      .toJson()
                                                                })));
                                              },
                                              child: Container(
                                                // shadechocolatecake3mjU (318:2819)
                                                margin: EdgeInsets.fromLTRB(
                                                    10 * fem,
                                                    0 * fem,
                                                    0 * fem,
                                                    4 * fem),
                                                constraints: BoxConstraints(
                                                  maxWidth: 123 * fem,
                                                ),
                                                child: Text(
                                                  _productModel
                                                      .allProducts![index].name
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 15 * ffem,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.2 * ffem / fem,
                                                    letterSpacing: -0.3 * fem,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              // TMQ (318:2820)
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem,
                                                  0 * fem,
                                                  1 * fem,
                                                  0 * fem),
                                              child: Text(
                                                _productModel
                                                        .allProducts![index]
                                                        .productPrices![0]
                                                        .price
                                                        .toString() +
                                                    ' ' +
                                                    'د.إ',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13 * ffem,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.5 * ffem / fem,
                                                  letterSpacing:
                                                      -0.2190869331 * fem,
                                                  color: Color(0x99000000),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          )
                        : SizedBox(
                            height: 550,
                            child: Center(child: Text('No product found.'))),
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

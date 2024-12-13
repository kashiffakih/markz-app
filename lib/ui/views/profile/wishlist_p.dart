import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/product.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/product_pr.dart';
import 'package:sales_app/core/providers/wish_list_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/products/product_id_p.dart';

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
      await Provider.of<ProductModel>(context, listen: false)
          .getAllProducts(productId);
    });
  }

  int activeIndex = -1;
  int sizeActiveIndex = -1;

  bool isActive = false;
  bool isSizeActive = false;
  bool isPageLoading = false;
  double discountPrice = 0.0;
  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
  };
  @override
  Widget build(BuildContext context) {
    final WishListModel _wishListModel = Provider.of<WishListModel>(context);
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final ProductModel _productModel = Provider.of<ProductModel>(context);
    final ConfigModel _configModel = locator<ConfigModel>();
    TextEditingController _controller = TextEditingController();
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
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
                margin: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    int.parse(_wishListModel.wishLists![index]
                                        .product!.productPrices![0].offerPrice
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
                                        _configModel.apiConfig['mediaURL'] +
                                            _wishListModel
                                                .wishLists![index]
                                                .product!
                                                .productImages!
                                                .first!
                                                .imagepath
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
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                _wishListModel.wishLists![index]
                                                    .product!.name
                                                    .toString(),
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff909090),
                                                ),
                                              ),
                                            ),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                    text: 'Total Price',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[500]),
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
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      if (discountPrice != 0.0)
                                                        WidgetSpan(
                                                          child: SizedBox(
                                                              width:
                                                                  10), // Adjust the width as needed
                                                        ),
                                                      if (discountPrice != 0.0)
                                                        TextSpan(
                                                            text:
                                                                '( ${discountPrice.round()}% Off)',
                                                            style: TextStyle(
                                                                fontSize: 12,
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
                                              alignment: Alignment.centerLeft,
                                              child: InkWell(
                                                onTap: () async {
                                                  List<ProductImages>
                                                      productImages = [];
                                                  List<ProductPack>
                                                      productPacks = [];

                                                  productImages = _wishListModel
                                                      .wishLists![index]
                                                      .product!
                                                      .productImages!;
                                                  productPacks = _wishListModel
                                                      .wishLists![index]
                                                      .product!
                                                      .productPacks!;
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.4,
                                                        child: StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              StateSetter
                                                                  modalSetState) {
                                                            // Re-filter productPacks based on activeIndex
                                                            List<
                                                                ProductPack> filteredProductPacks = (activeIndex !=
                                                                    -1)
                                                                ? productPacks
                                                                    .where((element) =>
                                                                        element
                                                                            .unitId ==
                                                                        productImages[activeIndex]
                                                                            .unit!
                                                                            .id)
                                                                    .toList()
                                                                : productPacks; // If no product image selected, show all packs

                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                              child: Column(
                                                                children: [
                                                                  // Select Variant Section
                                                                  SizedBox(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.4,
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                        Text(
                                                                          'Select Variant:',
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Urbanist',
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            height:
                                                                                1.2,
                                                                            letterSpacing:
                                                                                -0.36,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                        SizedBox(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              50,
                                                                          child:
                                                                              ListView.builder(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            itemCount:
                                                                                productImages.length,
                                                                            itemBuilder:
                                                                                (BuildContext context, int index) {
                                                                              bool isActive = index == activeIndex;

                                                                              return Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    child: TextButton(
                                                                                      onPressed: () {
                                                                                        modalSetState(() {
                                                                                          activeIndex = index; // Update the selected product image
                                                                                          sizeActiveIndex = -1;
                                                                                          _CartData['flavour'] = productImages[index].unit!.name.toString();
                                                                                        });
                                                                                      },
                                                                                      style: TextButton.styleFrom(
                                                                                        padding: EdgeInsets.zero,
                                                                                        backgroundColor: isActive ? Colors.black : null,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(30.0),
                                                                                        ),
                                                                                      ),
                                                                                      child: Container(
                                                                                        width: MediaQuery.of(context).size.width * 0.3,
                                                                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(30.0),
                                                                                            side: BorderSide(
                                                                                              color: Colors.black,
                                                                                              width: 1.0,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            productImages[index].unit!.name.toString(),
                                                                                            style: MyGoogleFontStyle(
                                                                                              fontFamily: 'Urbanist',
                                                                                              fontSize: 12,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              height: 1.2,
                                                                                              letterSpacing: -0.36,
                                                                                              color: isActive ? Colors.white : Colors.black,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 15),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                        // Select Size Section
                                                                        Text(
                                                                          'Select Size:',
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Urbanist',
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            height:
                                                                                1.2,
                                                                            letterSpacing:
                                                                                -0.36,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                        SizedBox(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              50,
                                                                          child:
                                                                              ListView.builder(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            itemCount:
                                                                                filteredProductPacks.length, // Use filtered product packs
                                                                            itemBuilder:
                                                                                (BuildContext context, int index) {
                                                                              bool isSizeActive = index == sizeActiveIndex;

                                                                              return Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    child: TextButton(
                                                                                      onPressed: () {
                                                                                        modalSetState(() {
                                                                                          sizeActiveIndex = index; // Update the selected size
                                                                                          _CartData['pack'] = filteredProductPacks[index].id;
                                                                                          _CartData['kindOfFlower'] = filteredProductPacks[index].value.toString();
                                                                                        });
                                                                                      },
                                                                                      style: TextButton.styleFrom(
                                                                                        padding: EdgeInsets.zero,
                                                                                        backgroundColor: isSizeActive ? Colors.black : null,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(30.0),
                                                                                        ),
                                                                                      ),
                                                                                      child: Container(
                                                                                        width: MediaQuery.of(context).size.width * 0.3,
                                                                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                        decoration: ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(30.0),
                                                                                            side: BorderSide(
                                                                                              color: Colors.black,
                                                                                              width: 1.0,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            filteredProductPacks[index].value.toString(),
                                                                                            style: MyGoogleFontStyle(
                                                                                              fontFamily: 'Urbanist',
                                                                                              fontSize: 12,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              height: 1.2,
                                                                                              letterSpacing: -0.36,
                                                                                              color: isSizeActive ? Colors.white : Colors.black,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 15),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            print(_CartData);
                                                                            setState(() {
                                                                              isPageLoading = true;
                                                                            });
                                                                            bool
                                                                                type =
                                                                                true;

                                                                            await _addToCartModel.getAddToCart(
                                                                                _wishListModel.wishLists![index].product!.id,
                                                                                type,
                                                                                _CartData);

                                                                            setState(() {
                                                                              // productImages = [];
                                                                              // productPacks = [];
                                                                              isPageLoading = false;
                                                                              _wishListModel.getWishLists('');
                                                                              Navigator.pop(context);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Container(
                                                                              padding: EdgeInsets.fromLTRB(13, 4, 14, 6),
                                                                              width: 160,
                                                                              height: 50,
                                                                              decoration: BoxDecoration(
                                                                                color: Color(0xff000000),
                                                                                borderRadius: BorderRadius.circular(5),
                                                                              ),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                                                                    child: isPageLoading == false
                                                                                        ? Text(
                                                                                            'Add to Cart',
                                                                                            style: MyGoogleFontStyle(
                                                                                              fontFamily: 'Poppins',
                                                                                              fontSize: 15,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              color: Color(0xffffffff),
                                                                                            ),
                                                                                          )
                                                                                        : CircularProgressIndicator(),
                                                                                  ),
                                                                                  Image.asset(
                                                                                    'assets/images/shopping-bag-03-YoY.png',
                                                                                    width: 18,
                                                                                    height: 15,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  );

                                                  // bool type = true;
                                                  // Map<String, dynamic>
                                                  //     _CartData = {
                                                  //   'kindOfFlower': '',
                                                  //   'flavour': '',
                                                  //   'writeOnCake': '',
                                                  // };
                                                  // await _addToCartModel
                                                  //     .getAddToCart(
                                                  //         _wishListModel
                                                  //             .wishLists![
                                                  //                 index]
                                                  //             .product!
                                                  //             .id,
                                                  //         type,
                                                  //         _CartData);
                                                  // setState(() {
                                                  //   _wishListModel
                                                  //       .getWishLists('');
                                                  // });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      13, 4, 14, 6),
                                                  width: 100,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff000000),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 5, 0),
                                                        child: Text(
                                                          'Add to Cart',
                                                          style:
                                                              MyGoogleFontStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                .wishLists![index].product!.id);
                                      },
                                      icon: Icon(Icons.close_rounded),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 50,
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
              // Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: Container(
              //     child: Column(
              //       children: [
              //         if (_wishListModel.wishLists!.length != 0)
              //           Align(
              //             alignment: Alignment.bottomCenter,
              //             child: Container(
              //               margin: EdgeInsets.fromLTRB(0.89, 0, 0, 0),
              //               child: TextButton(
              //                 onPressed: () async {
              //                   await _wishListModel.addAllToCart();
              //                   setState(() {
              //                     _wishListModel.getWishLists('');
              //                   });
              //                 },
              //                 style: TextButton.styleFrom(
              //                   padding: EdgeInsets.zero,
              //                 ),
              //                 child: Container(
              //                   width: 321,
              //                   height: 53,
              //                   decoration: BoxDecoration(
              //                     color: Color(0xff1e1e1e),
              //                     borderRadius: BorderRadius.circular(10),
              //                   ),
              //                   child: Center(
              //                     child: Text(
              //                       'Add all to my cart',
              //                       style: MyGoogleFontStyle(
              //                         fontFamily: 'Urbanist',
              //                         fontWeight: FontWeight.w700,
              //                         color: Color(0xffffffff),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //       ],
              //     ),
              //   ),
              // ),

              // if (_wishListModel.wishLists!.length == 0)
              // Container(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         SizedBox(
              //           height: MediaQuery.of(context).size.height - 530,
              //         ),
              //         Text(
              //           'Add More Items',
              //           style: MyGoogleFontStyle(
              //             fontFamily: 'Urbanist',
              //             fontWeight: FontWeight.w700,
              //             color: Color(0xff000000),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         Container(
              //           width: MediaQuery.of(context).size.width,
              //           height: MediaQuery.of(context).size.height * 0.4,
              //           child: Row(
              //             children: [
              //               Expanded(
              //                 child: _productModel.productsLoader
              //                     ? Center(child: LinearProgressIndicator())
              //                     : ListView.builder(
              //                         // padding:
              //                         //     const EdgeInsets.only(left: 5, right: 8),
              //                         scrollDirection: Axis.horizontal,
              //                         shrinkWrap: true,
              //                         itemCount:
              //                             _productModel.products!.length,
              //                         itemBuilder: (context, index) {
              //                           return Padding(
              //                             padding: const EdgeInsets.symmetric(
              //                                 horizontal: 10),
              //                             child: Container(
              //                               width: MediaQuery.of(context)
              //                                       .size
              //                                       .width *
              //                                   0.4,
              //                               height: MediaQuery.of(context)
              //                                       .size
              //                                       .height *
              //                                   0.45,
              //                               decoration: BoxDecoration(
              //                                 borderRadius:
              //                                     BorderRadius.circular(15),
              //                               ),
              //                               child: Column(
              //                                 crossAxisAlignment:
              //                                     CrossAxisAlignment.center,
              //                                 children: [
              //                                   InkWell(
              //                                     onTap: () {
              //                                       Navigator.of(context)
              //                                           .push(
              //                                         MaterialPageRoute(
              //                                           builder: (context) =>
              //                                               ProductIdPage(
              //                                                   arguments: {
              //                                                 'product': _productModel
              //                                                     .products![
              //                                                         index]
              //                                                     .toJson(),
              //                                                 'product_images':
              //                                                     _productModel
              //                                                         .products![
              //                                                             index]
              //                                                         .productImages
              //                                               }),
              //                                         ),
              //                                       );
              //                                     },
              //                                     child: Container(
              //                                       margin:
              //                                           EdgeInsets.fromLTRB(
              //                                               0 * fem,
              //                                               0 * fem,
              //                                               0 * fem,
              //                                               5 * fem),
              //                                       padding:
              //                                           EdgeInsets.fromLTRB(
              //                                               106 * fem,
              //                                               13 * fem,
              //                                               14 * fem,
              //                                               15 * fem),
              //                                       width:
              //                                           MediaQuery.of(context)
              //                                                   .size
              //                                                   .width *
              //                                               0.4,
              //                                       height:
              //                                           MediaQuery.of(context)
              //                                                   .size
              //                                                   .height *
              //                                               0.26,
              //                                       decoration: BoxDecoration(
              //                                         borderRadius:
              //                                             BorderRadius
              //                                                 .circular(15),
              //                                         image: DecorationImage(
              //                                           fit: BoxFit.contain,
              //                                           image: NetworkImage(_configModel
              //                                                       .apiConfig[
              //                                                   'mediaURL'] +
              //                                               _productModel
              //                                                   .products![
              //                                                       index]
              //                                                   .productImages
              //                                                   ?.first
              //                                                   .imagepath
              //                                                   .toString()),
              //                                         ),
              //                                       ),
              //                                       child: InkWell(
              //                                         onTap: () async {
              //                                           await _wishListModel
              //                                               .getWishLists(
              //                                                   _productModel
              //                                                       .products![
              //                                                           index]
              //                                                       .id);
              //                                         },
              //                                         child: _wishListModel
              //                                                 .wishListLoader
              //                                             ? Align(
              //                                                 alignment:
              //                                                     Alignment
              //                                                         .topRight,
              //                                                 child: Icon(Icons
              //                                                     .favorite_border_outlined))
              //                                             : _wishListModel
              //                                                         .wishLists!
              //                                                         .where((wishList) =>
              //                                                             wishList.productId == _productModel.products![index].id &&
              //                                                             wishList.userId ==
              //                                                                 _configModel
              //                                                                     .user.id)
              //                                                         .toList()
              //                                                         .length ==
              //                                                     0
              //                                                 ? Align(
              //                                                     alignment:
              //                                                         Alignment
              //                                                             .topRight,
              //                                                     child: Icon(Icons
              //                                                         .favorite_border_outlined))
              //                                                 : Align(
              //                                                     alignment:
              //                                                         Alignment.topRight,
              //                                                     child: Icon(
              //                                                       Icons
              //                                                           .favorite_outlined,
              //                                                       color: Colors
              //                                                           .red,
              //                                                     )),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   SizedBox(
              //                                     height: 10,
              //                                   ),
              //                                   InkWell(
              //                                     onTap: () {
              //                                       Navigator.of(context).push(
              //                                           MaterialPageRoute(
              //                                               builder: (context) =>
              //                                                   ProductIdPage(
              //                                                       arguments: {
              //                                                         'product': _productModel
              //                                                             .products![index]
              //                                                             .toJson(),
              //                                                         'category': _productModel
              //                                                             .products![index]
              //                                                             .category!
              //                                                             .name
              //                                                             .toString(),
              //                                                       })));
              //                                     },
              //                                     child: Container(
              //                                       child: Text(
              //                                         _productModel
              //                                             .products![index]
              //                                             .name
              //                                             .toString(),
              //                                         textAlign:
              //                                             TextAlign.center,
              //                                         style:
              //                                             MyGoogleFontStyle(
              //                                           fontFamily:
              //                                               'Urbanist',
              //                                           fontSize: 15,
              //                                           fontWeight:
              //                                               FontWeight.w700,
              //                                           color:
              //                                               Color(0xff000000),
              //                                         ),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     child: _productModel
              //                                                 .products![
              //                                                     index]
              //                                                 .productPrices![
              //                                                     0]
              //                                                 .offerPrice !=
              //                                             0
              //                                         ? Text.rich(
              //                                             TextSpan(children: [
              //                                             new TextSpan(
              //                                               text:
              //                                                   'RS. ${_productModel.products![index].productPrices![0].price.toString()}',
              //                                               style:
              //                                                   new TextStyle(
              //                                                 color:
              //                                                     Colors.grey,
              //                                                 decoration:
              //                                                     TextDecoration
              //                                                         .lineThrough,
              //                                               ),
              //                                             ),
              //                                             new TextSpan(
              //                                               text:
              //                                                   ' RS.${_productModel.products![index].productPrices![0].offerPrice.toString()}',
              //                                             ),
              //                                           ]))
              //                                         : Text(
              //                                             _productModel
              //                                                     .products![
              //                                                         index]
              //                                                     .productPrices![
              //                                                         0]
              //                                                     .price
              //                                                     .toString() +
              //                                                 " " +
              //                                                 'RS',
              //                                             style:
              //                                                 MyGoogleFontStyle(
              //                                               fontFamily:
              //                                                   'Poppins',
              //                                               fontSize: 13,
              //                                               fontWeight:
              //                                                   FontWeight
              //                                                       .w500,
              //                                               height: 1.5,
              //                                               letterSpacing:
              //                                                   -0.2190869331,
              //                                               color: Color(
              //                                                   0x99000000),
              //                                             ),
              //                                           ),
              //                                   ),
              //                                   if (discountPrice != 0.0)
              //                                     Center(
              //                                       child: Text(
              //                                         '( ${discountPrice.round()}% Off)',
              //                                         style:
              //                                             MyGoogleFontStyle(
              //                                           fontFamily: 'Poppins',
              //                                           fontSize: 12,
              //                                           fontWeight:
              //                                               FontWeight.bold,
              //                                           color:
              //                                               Color(0x99000000),
              //                                         ),
              //                                       ),
              //                                     ),
              //                                 ],
              //                               ),
              //                             ),
              //                           );
              //                         },
              //                       ),
              //               )
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
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

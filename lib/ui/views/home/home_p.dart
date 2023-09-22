import 'package:flutter/material.dart';
import 'package:icon_forest/don_icons.dart';
import 'package:icon_forest/iconoir.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/product_pr.dart';
import 'package:sales_app/core/providers/wish_list_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/products/product_id_p.dart';
import 'package:sales_app/ui/views/products/products_p.dart';
import 'package:sales_app/ui/widgets/drawer_w.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // OverlayEntry? sideSheetOverlayEntry;
  // final sideSheetOverlayLayerLink = LayerLink();
  // bool isSidebarShown = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductModel>(context, listen: false).getBanners();
    var productId = '';
    Provider.of<WishListModel>(context, listen: false).getWishLists(productId);
  }

  // void showSideSheet() {
  //   final sideSheetOverlay = Overlay.of(context)!;
  //   sideSheetOverlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       height: MediaQuery.of(context).size.height,
  //       child: isSidebarShown
  //           ? CompositedTransformFollower(
  //               link: sideSheetOverlayLayerLink,
  //               child: TweenAnimationBuilder(
  //                 tween: Tween<double>(begin: 150, end: 300),
  //                 duration: const Duration(milliseconds: 300),
  //                 builder: (BuildContext context, double size, Widget? child) {
  //                   return Material(
  //                     child: SafeArea(
  //                       child: Container(
  //                           width: size,
  //                           padding: const EdgeInsets.all(10.0),
  //                           decoration: BoxDecoration(
  //                             color: Theme.of(context).colorScheme.surface,
  //                           ),
  //                           child: Column(
  //                             children: [
  //                               Row(
  //                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                 children: [
  //                                   InkWell(
  //                                     onTap: () {
  //                                       setState(() {
  //                                         isSidebarShown = false;
  //                                         showSideSheet();
  //                                       });
  //                                     },
  //                                     onHover: (value) {},
  //                                     child: const Icon(
  //                                       Icons.close,
  //                                       color: Colors.redAccent,
  //                                       size: 25.0,
  //                                     ),
  //                                   )
  //                                 ],
  //                               ),
  //                               Column(
  //                                 children: [
  //                                   Container(
  //                                     child: Text(
  //                                       "Custom Side Sheet",
  //                                       overflow: TextOverflow.ellipsis,
  //                                       style: const TextStyle(
  //                                           color: Colors.blueGrey),
  //                                     ),
  //                                   ),
  //                                   const Divider(
  //                                     height: 5.0,
  //                                     color: Colors.black,
  //                                   ),
  //                                   Container(
  //                                     child: Row(children: [
  //                                       Icon(
  //                                         Icons.dashboard,
  //                                         size: 25.0,
  //                                         color: Colors.blueGrey,
  //                                       ),
  //                                       Text(
  //                                         "Home",
  //                                         overflow: TextOverflow.ellipsis,
  //                                         style: TextStyle(
  //                                             color: Colors.blueGrey,
  //                                             fontSize: 25.0,
  //                                             fontWeight: FontWeight.w300),
  //                                       )
  //                                     ]),
  //                                   )
  //                                 ],
  //                               )
  //                             ],
  //                           )),
  //                     ),
  //                   );
  //                 },
  //               ))
  //           : SizedBox.shrink(),
  //     ),
  //   );
  //   sideSheetOverlay.insert(sideSheetOverlayEntry!);
  // }
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final ConfigModel _configModel = locator<ConfigModel>();
    final ProductModel _productModel = Provider.of<ProductModel>(context);
    final WishListModel _wishListModel = Provider.of<WishListModel>(context);
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);

    var images = [
      _productModel.banners?['banner_path_1'] != null
          ? _configModel.apiConfig['mediaURL'] +
              _productModel.banners!['banner_path_1'].toString()
          : null,
      _productModel.banners?['banner_path_2'] != null
          ? _configModel.apiConfig['mediaURL'] +
              _productModel.banners!['banner_path_2'].toString()
          : null,
      _productModel.banners?['banner_path_3'] != null
          ? _configModel.apiConfig['mediaURL'] +
              _productModel.banners!['banner_path_3'].toString()
          : null,
    ]
        .where((imageUrl) => imageUrl != null)
        .map((imageUrl) => imageUrl!)
        .toList();

    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      key: _key,
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Container(
                // homedashboardLCW (318:1931)
                padding:
                    EdgeInsets.fromLTRB(0 * fem, 30 * fem, 0 * fem, 8 * fem),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 247 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0 * fem,
                            top: 67 * fem,
                            child: SizedBox(
                                width: 360 * fem,
                                height: 180 * fem,
                                child: PageView.builder(
                                    itemCount: images.length,
                                    pageSnapping: true,
                                    itemBuilder: (context, pagePosition) {
                                      return Container(
                                          margin: EdgeInsets.all(10),
                                          child: Image.network(
                                            images[pagePosition],
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          ));
                                    })),
                          ),
                          SizedBox(
                            height: 210,
                          ),
                          Positioned(
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                  5 * fem, 12.6 * fem, 10.64 * fem, 5 * fem),
                              width: 460 * fem,
                              height: 71.04 * fem,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.fromLTRB(
                                    //     0 * fem, 0 * fem, 0 * fem, 8.21 * fem),
                                    height: double.infinity,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(5 * fem,
                                              2 * fem, 0 * fem, 4.7 * fem),
                                          width: 34.22 * fem,
                                          height: 60 * fem,
                                          child: Image.asset(
                                            'assets/images/pinewrapslogo-1-9g4.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          width: 200 * fem,
                                          height: 39.83 * fem,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0 * fem,
                                                top: 0 * fem,
                                                child: Align(
                                                  child: SizedBox(
                                                    width: 78 * fem,
                                                    height: 27 * fem,
                                                    child: Text(
                                                      'Welcome to',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            10.9245996475 *
                                                                ffem,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 1.5000000436 *
                                                            ffem /
                                                            fem,
                                                        color:
                                                            Color(0xff303030),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0 * fem,
                                                top: 11.8349609375 * fem,
                                                child: Align(
                                                  child: SizedBox(
                                                      width: 120 * fem,
                                                      height: 25 * fem,
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0 * fem,
                                                                2 * fem,
                                                                0 * fem,
                                                                4.7 * fem),
                                                        width: 100 * fem,
                                                        height: 70 * fem,
                                                        child: Image.asset(
                                                          'assets/images/NewPineWrapsText.jpeg',
                                                          height: 70,
                                                          width: 100,
                                                          // 'assets/images/NewPineWrapsText.jpeg',
                                                          // fit: BoxFit.fill,
                                                        ),
                                                      )
                                                      // Text(
                                                      //   'PINEWRAPS',
                                                      //   style: MyGoogleFontStyle(
                                                      //     fontFamily: 'PT Serif Regular 400 Italy',
                                                      //     fontSize:
                                                      //         18.2076663971 *
                                                      //             ffem,
                                                      //     fontWeight:
                                                      //         FontWeight.w400,
                                                      //     height: 1.5000000524 *
                                                      //         ffem /
                                                      //         fem,
                                                      //     color:
                                                      //         Color(0xff303030),
                                                      //   ),
                                                      // ),
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
                                    height: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/notificationPage');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              'assets/images/vector-afp.png',
                                              width: 18.58 * fem,
                                              height: 18.58 * fem,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _key.currentState!.openDrawer();
                                          },
                                          child: Icon(
                                            Icons.menu_sharp,
                                            size: 30.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
            Container(
              child: Center(
                child: Image.asset(
                  'assets/images/NewArrivals.png',
                  width: 500.58 * fem,
                  height: 60.58 * fem,
                ),
              ),
            ),
            _productModel.productsLoader
                ? LinearProgressIndicator()
                : SizedBox(
                    height: 320,
                    child: _productModel.productsLoader
                        ? SizedBox(
                            // height: 20,
                            child: Center(child: Text('No new arrivals')),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(left: 5, right: 8),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: _productModel.products!.length,
                            itemBuilder: (context, index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 8),
                                    child: Container(
                                      // group8949Yce (318:1997)
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
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductIdPage(
                                                              arguments: {
                                                                'product':
                                                                    _productModel
                                                                        .products![
                                                                            index]
                                                                        .toJson()
                                                              })));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem,
                                                  0 * fem,
                                                  0 * fem,
                                                  5 * fem),
                                              padding: EdgeInsets.fromLTRB(
                                                  106 * fem,
                                                  13 * fem,
                                                  14 * fem,
                                                  15 * fem),
                                              width: double.infinity,
                                              height: 193 * fem,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15 * fem),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      _configModel.apiConfig[
                                                              'mediaURL'] +
                                                          _productModel
                                                              .products![index]
                                                              .imagepath1
                                                              .toString()),
                                                ),
                                              ),
                                              child: InkWell(
                                                onTap: () async {
                                                  await _wishListModel
                                                      .getWishLists(
                                                          _productModel
                                                              .products![index]
                                                              .id);
                                                },
                                                child: _wishListModel
                                                        .wishListLoader
                                                    ? Align(
                                                        // vectorRZx (318:2001)
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: SizedBox(
                                                          width: 25 * fem,
                                                          height: 22.4 * fem,
                                                          child: Image.asset(
                                                            'assets/images/vector-wXc.png',
                                                            width: 25 * fem,
                                                            height: 22.4 * fem,
                                                          ),
                                                        ),
                                                      )
                                                    : _wishListModel.wishLists!
                                                                .where((wishList) =>
                                                                    wishList.productId ==
                                                                        _productModel
                                                                            .products![
                                                                                index]
                                                                            .id &&
                                                                    wishList.userId ==
                                                                        _configModel
                                                                            .user
                                                                            .id)
                                                                .toList()
                                                                .length ==
                                                            0
                                                        ? Align(
                                                            // vectorRZx (318:2001)
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: SizedBox(
                                                              width: 25 * fem,
                                                              height:
                                                                  22.4 * fem,
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/vector-yse.png',
                                                                width: 25 * fem,
                                                                height:
                                                                    22.4 * fem,
                                                              ),
                                                            ),
                                                          )
                                                        : Align(
                                                            // vectorRZx (318:2001)
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: SizedBox(
                                                              width: 25 * fem,
                                                              height:
                                                                  22.4 * fem,
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/vector-wXc.png',
                                                                width: 25 * fem,
                                                                height:
                                                                    22.4 * fem,
                                                              ),
                                                            ),
                                                          ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductIdPage(
                                                              arguments: {
                                                                'product': _productModel
                                                                    .products![
                                                                        index]
                                                                    .toJson(),
                                                                'category': _productModel
                                                                    .products![
                                                                        index]
                                                                    .category!
                                                                    .name
                                                                    .toString()
                                                              })));
                                            },
                                            child: Container(
                                              // shadechocolatecake3pc6 (318:2002)
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem,
                                                  6 * fem,
                                                  0 * fem,
                                                  4 * fem),
                                              constraints: BoxConstraints(
                                                maxWidth: 123 * fem,
                                              ),
                                              child: Text(
                                                _productModel
                                                    .products![index].name
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
                                            // 5H8 (318:2003)
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                0 * fem, 1 * fem, 0 * fem),
                                            child: Text(
                                              _productModel
                                                      .products![index]
                                                      .productPrices![0]
                                                      .offerPrice
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
                                  ),
                                ],
                              );
                            }),
                  ),
            Container(
              height: 20,
              child: Center(
                child: Image.asset(
                  'assets/images/ShopByCategory.png',
                  width: 500.58 * fem,
                  height: 60.58 * fem,
                ),
              ),
            ),
            Container(
              width: 345 * fem,
              height: 435,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ..._productModel.categories!
                      .map(
                        (_category) => Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProductsPage(arguments: {
                                        'categoryId': _category['id'],
                                        'subCategory':
                                            _category['sub_categories'],
                                        'category': _category['name'].toString()
                                      })));
                            },
                            child: Container(
                              width: 344 * fem,
                              height: 110 * fem,
                              child: Stack(
                                children: [
                                  Positioned(
                                    // image24Suc (318:1963)
                                    left: 0 * fem,
                                    top: 0 * fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 344 * fem,
                                        height: 106.69 * fem,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10 * fem),
                                          child: Image.network(
                                            _configModel.apiConfig['mediaURL'] +
                                                _category['imagepath']
                                                    .toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // rectangle2422kfQ (318:1964)
                                    left: 0 * fem,
                                    top: 0 * fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 344 * fem,
                                        height: 107 * fem,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                10.1176462173 * fem),
                                            gradient: _category['id'] == 2
                                                ? LinearGradient(
                                                    begin: Alignment(1, 0.138),
                                                    end: Alignment(-1, 0.128),
                                                    colors: <Color>[
                                                      Color(0x99000000),
                                                      Color(0x00d9d9d9)
                                                    ],
                                                    stops: <double>[0, 1],
                                                  )
                                                : LinearGradient(
                                                    begin: Alignment(-1, 0.138),
                                                    end: Alignment(1, 0.128),
                                                    colors: <Color>[
                                                      Color(0x99000000),
                                                      Color(0x00d9d9d9)
                                                    ],
                                                    stops: <double>[0, 1],
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_category['id'] != 2)
                                    Positioned(
                                      left: 22 * fem,
                                      top: 39.5 * fem,
                                      child: Container(
                                        width: 200 * fem,
                                        height: 48.31 * fem,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 0 * fem,
                                              top: 0 * fem,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 200 * fem,
                                                  height: 30 * fem,
                                                  child: Text(
                                                    _category['name'],
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize:
                                                          18.3132514954 * ffem,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.5 * ffem / fem,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 2.7470703125 * fem,
                                              top: 24.3071899414 * fem,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 38 * fem,
                                                  height: 14 * fem,
                                                  child: Text(
                                                    _category['products']
                                                            .length
                                                            .toString() +
                                                        ' Items',
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize:
                                                          9.1566257477 * ffem,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.5 * ffem / fem,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (_category['id'] == 2)
                                    Positioned(
                                      left: 250 * fem,
                                      top: 33.5 * fem,
                                      child: Container(
                                        width: 71 * fem,
                                        height: 38.31 * fem,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 0 * fem,
                                              top: 0 * fem,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 71 * fem,
                                                  height: 28 * fem,
                                                  child: Text(
                                                    _category['name'],
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize:
                                                          18.3132514954 * ffem,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.5 * ffem / fem,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 2.7470703125 * fem,
                                              top: 24.3071899414 * fem,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 38 * fem,
                                                  height: 14 * fem,
                                                  child: Text(
                                                    _category['products']
                                                            .length
                                                            .toString() +
                                                        ' Items',
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize:
                                                          9.1566257477 * ffem,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.5 * ffem / fem,
                                                      color: Color(0xffffffff),
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
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // group81Wvi (318:1936)
              width: double.infinity,
              height: 150 * fem,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5 * fem),
              ),
              child: Stack(
                children: [
                  Positioned(
                    // rectangle45ELv (318:1937)
                    left: 0 * fem,
                    top: 0 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 360 * fem,
                        height: 150 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5 * fem),
                            color: Color(0x33eecf56),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // group46Ler (318:1938)
                    left: 268.130859375 * fem,
                    top: 84.827545166 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 81.72 * fem,
                        height: 65.17 * fem,
                        child: Image.asset(
                          'assets/images/group-46.png',
                          width: 81.72 * fem,
                          height: 65.17 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse25pa2 (318:1944)
                    left: 324.5180664062 * fem,
                    top: 15.5172424316 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 5.34 * fem,
                        height: 5.17 * fem,
                        child: Image.asset(
                          'assets/images/ellipse-25.png',
                          width: 5.34 * fem,
                          height: 5.17 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse32Kmg (318:1945)
                    left: 2.1362304688 * fem,
                    top: 37.2411804199 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 8.82 * fem,
                        height: 8.54 * fem,
                        child: Image.asset(
                          'assets/images/ellipse-32.png',
                          width: 8.82 * fem,
                          height: 8.54 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse27Edk (318:1946)
                    left: 334.1323242188 * fem,
                    top: 26.8965454102 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 11.75 * fem,
                        height: 11.38 * fem,
                        child: Image.asset(
                          'assets/images/ellipse-27.png',
                          width: 11.75 * fem,
                          height: 11.38 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse33MyG (318:1947)
                    left: 16.0239257812 * fem,
                    top: 2.0690307617 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 16.38 * fem,
                        height: 15.86 * fem,
                        child: Image.asset(
                          'assets/images/ellipse-33.png',
                          width: 16.38 * fem,
                          height: 15.86 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse26UY6 (318:1948)
                    left: 311.69921875 * fem,
                    top: 41.3793029785 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 18.16 * fem,
                        height: 17.59 * fem,
                        child: Image.asset(
                          'assets/images/ellipse-26.png',
                          width: 18.16 * fem,
                          height: 17.59 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse34PQA (318:1949)
                    left: 329.859375 * fem,
                    top: 66.2068786621 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 14.96 * fem,
                        height: 14.48 * fem,
                        child: Image.asset(
                          'assets/images/ellipse-34.png',
                          width: 14.96 * fem,
                          height: 14.48 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse35WUn (318:1950)
                    left: 290.333984375 * fem,
                    top: 66.2068786621 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 11.75 * fem,
                        height: 11.38 * fem,
                        child: Image.asset(
                          'assets/images/ellipse-34.png',
                          width: 11.75 * fem,
                          height: 11.38 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // inviteafriendandearnplantifyre (318:1951)
                    left: 24.5698242188 * fem,
                    top: 18.6206817627 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 252 * fem,
                        height: 60 * fem,
                        child: Text(
                          'Invite a Friend and earn Plantify rewards',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Philosopher',
                            fontSize: 24 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.2400000095 * ffem / fem,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // redeemthemtogetinstantdiscount (318:1952)
                    left: 28.8427734375 * fem,
                    top: 95.1724243164 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 135 * fem,
                        height: 30 * fem,
                        child: Text(
                          'Redeem them to get instant discounts',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.1538461538 * ffem / fem,
                            color: Color(0xff888888),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // rectangle59cAS (318:1953)
                    left: 190.1484375 * fem,
                    top: 95.1724243164 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 64.09 * fem,
                        height: 31.03 * fem,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5 * fem),
                              color: Color(0xffeecf56),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // invite6rJ (318:1954)
                    left: 202.9672851562 * fem,
                    top: 99.655166626 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 37 * fem,
                        height: 20 * fem,
                        child: Text(
                          'Invite',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.5 * ffem / fem,
                            color: Color(0xffffffff),
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

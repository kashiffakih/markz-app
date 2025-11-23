import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/core/providers/wish_list_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/products/product_id_p.dart';
import 'package:aadab/ui/views/products/products_p.dart';
import 'package:aadab/ui/views/products/shops_p.dart';
import 'package:aadab/ui/widgets/drawer_w.dart';
import 'package:badges/badges.dart' as badges;

class HomeCopyPage extends StatefulWidget {
  const HomeCopyPage({Key? key}) : super(key: key);

  @override
  State<HomeCopyPage> createState() => _HomeCopyPageState();
}

class _HomeCopyPageState extends State<HomeCopyPage> {
  TextEditingController _controller = TextEditingController();
  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': ''
  };
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ProductModel>(context, listen: false).getProduct();
      await Provider.of<ProductModel>(context, listen: false).getBanners();
      var productId = '';
      await Provider.of<WishListModel>(context, listen: false)
          .getWishLists(productId);
      await Provider.of<ProductModel>(context, listen: false).getCategories();
      Provider.of<AddToCartModel>(context, listen: false)
          .getAddToCart(productId, '', _CartData);
    });
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final ConfigModel _configModel = locator<ConfigModel>();
    final ProductModel _productModel = Provider.of<ProductModel>(context);
    final WishListModel _wishListModel = Provider.of<WishListModel>(context);
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    double discountPrice = 0.0;
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
      _productModel.banners?['banner_path_4'] != null
          ? _configModel.apiConfig['mediaURL'] +
              _productModel.banners!['banner_path_4'].toString()
          : null,
      _productModel.banners?['banner_path_5'] != null
          ? _configModel.apiConfig['mediaURL'] +
              _productModel.banners!['banner_path_5'].toString()
          : null,
      _productModel.banners?['banner_path_6'] != null
          ? _configModel.apiConfig['mediaURL'] +
              _productModel.banners!['banner_path_6'].toString()
          : null,
      _productModel.banners?['banner_path_11'] != null
          ? _configModel.apiConfig['mediaURL'] +
              _productModel.banners!['banner_path_11'].toString()
          : null,
      _productModel.banners?['banner_path_12'] != null
          ? _configModel.apiConfig['mediaURL'] +
              _productModel.banners!['banner_path_12'].toString()
          : null,
      _productModel.banners?['banner_path_13'] != null
          ? _configModel.apiConfig['mediaURL'] +
              _productModel.banners!['banner_path_13'].toString()
          : null,
    ]
        .where((imageUrl) => imageUrl != null)
        .map((imageUrl) => imageUrl!)
        .toList();
    var cartCount = 0;
    setState(() {
      cartCount = _addToCartModel.addToCarts == null
          ? 0
          : _addToCartModel.addToCarts!.length;
    });

    return Scaffold(
      key: _key,
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner
            Container(
              width: double.infinity,
              child: Container(
                padding:
                    EdgeInsets.fromLTRB(0.w, 30.w, 0.w, 8.w),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 247.w,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0.w,
                            top: 67.w,
                            child: SizedBox(
                                width: 360.w,
                                height: 180.w,
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
                            left: 0.w,
                            top: 0.w,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                  5.w, 12.6.w, 10.64.w, 5.w),
                              width: 460.w,
                              height: 71.04.w,
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  Container(
                                    width: 320,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center, // Center vertically
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
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
                                                color: Colors.black
                                                    .withOpacity(0.6),
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
                                  const SizedBox(width: 20),
                                  Container(
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
                                          'assets/images/filter.png',
                                          height: 20,
                                          fit: BoxFit.cover,
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
            // End Banner

            // New Arrivals
            Container(
              child: Center(
                child: Image.asset(
                  'assets/images/NewArrivals.png',
                  width: 500.58.w,
                  height: 60.58.w,
                ),
              ),
            ),
            _productModel.productsLoader
                ? LinearProgressIndicator()
                : SizedBox(
                    height: 310,
                    child: _productModel.productsLoader
                        ? SizedBox(
                            child: Center(child: Text('No new arrivals')),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(left: 5, right: 8),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: _productModel.products!.length,
                            itemBuilder: (context, index) {
                              // if (_configModel.user!.roles![0].name ==
                              //     'Distributor') {
                              //   discountPrice = (int.parse(_productModel
                              //               .products![index]
                              //               .productPrices![0]
                              //               .distributorPrice
                              //               .toString()) -
                              //           int.parse(_productModel
                              //               .products![index]
                              //               .productPrices![0]
                              //               .distributorOfferPrice
                              //               .toString())) /
                              //       int.parse(_productModel.products![index]
                              //           .productPrices![0].distributorPrice
                              //           .toString()) *
                              //       100;
                              // } else {
                              //   discountPrice = (int.parse(_productModel
                              //               .products![index]
                              //               .productPrices![0]
                              //               .price
                              //               .toString()) -
                              //           int.parse(_productModel.products![index]
                              //               .productPrices![0].offerPrice
                              //               .toString())) /
                              //       int.parse(_productModel.products![index]
                              //           .productPrices![0].price
                              //           .toString()) *
                              //       100;
                              // }

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 8),
                                    child: Container(
                                      // group8949Yce (318:1997)
                                      width: 145.w,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.w),
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
                                                                'product': _productModel
                                                                    .products![
                                                                        index]
                                                                    .toJson(),
                                                                'product_images':
                                                                    _productModel
                                                                        .products![
                                                                            index]
                                                                        .productImages
                                                              })));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0.w,
                                                  0.w,
                                                  0.w,
                                                  5.w),
                                              padding: EdgeInsets.fromLTRB(
                                                  106.w,
                                                  13.w,
                                                  14.w,
                                                  15.w),
                                              width: double.infinity,
                                              height: 193.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.w),
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
                                                          width: 25.w,
                                                          height: 22.4.w,
                                                          child: Image.asset(
                                                            'assets/images/vector-wXc.png',
                                                            width: 25.w,
                                                            height: 22.4.w,
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
                                                                            .user!
                                                                            .id)
                                                                .toList()
                                                                .length ==
                                                            0
                                                        ? Align(
                                                            // vectorRZx (318:2001)
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: SizedBox(
                                                              width: 25.w,
                                                              height:
                                                                  22.4.w,
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/vector-yse.png',
                                                                width: 25.w,
                                                                height:
                                                                    22.4.w,
                                                              ),
                                                            ),
                                                          )
                                                        : Align(
                                                            // vectorRZx (318:2001)
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: SizedBox(
                                                              width: 25.w,
                                                              height:
                                                                  22.4.w,
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/vector-wXc.png',
                                                                width: 25.w,
                                                                height:
                                                                    22.4.w,
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
                                                                    .toString(),
                                                              })));
                                            },
                                            child: Container(
                                              // shadechocolatecake3pc6 (318:2002)
                                              margin: EdgeInsets.fromLTRB(
                                                  0.w,
                                                  6.w,
                                                  0.w,
                                                  4.w),
                                              constraints: BoxConstraints(
                                                maxWidth: 123.w,
                                              ),
                                              child: Text(
                                                _productModel
                                                    .products![index].name
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.2,
                                                  letterSpacing: -0.3.w,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                              // 5H8 (318:2003)
                                              margin: EdgeInsets.fromLTRB(
                                                  0.w,
                                                  0.w,
                                                  1.w,
                                                  0.w),
                                              child: _productModel
                                                          .products![index]
                                                          .productPrices![0]
                                                          .offerPrice !=
                                                      0
                                                  ? Text.rich(
                                                      TextSpan(children: [
                                                      new TextSpan(
                                                        text:
                                                            'RS. ${_productModel.products![index].productPrices![0].price.toString()}',
                                                        style: new TextStyle(
                                                          color: Colors.grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      ),
                                                      new TextSpan(
                                                        text:
                                                            ' RS.${_productModel.products![index].productPrices![0].offerPrice.toString()}',
                                                      ),
                                                    ]))
                                                  : Text(
                                                      _productModel
                                                              .products![index]
                                                              .productPrices![0]
                                                              .price
                                                              .toString() +
                                                          " " +
                                                          'RS',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.5,
                                                        letterSpacing:
                                                            -0.2190869331,
                                                        color:
                                                            Color(0x99000000),
                                                      ),
                                                    )

                                              // Text(
                                              //   _productModel
                                              //           .products![index]
                                              //           .productPrices![0]
                                              //           .offerPrice
                                              //           .toString() +
                                              //       ' ' +
                                              //       'RS',
                                              //   style: MyGoogleFontStyle(
                                              //     fontFamily: 'Poppins',
                                              //     fontSize: 13.sp,
                                              //     fontWeight: FontWeight.w500,
                                              //     height: 1.5,
                                              //     letterSpacing:
                                              //         -0.2190869331.w,
                                              //     color: Color(0x99000000),
                                              //   ),
                                              // ),
                                              ),
                                          if (discountPrice != 0.0)
                                            Center(
                                              child: Text(
                                                '( ${discountPrice.round()}% Off)',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  // height: 1.5,
                                                  // letterSpacing:
                                                  //     -0.2190869331.w,
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
            // End New Arrivals

            // Category
            Container(
              height: 20,
              child: Center(
                child: Image.asset(
                  'assets/images/ShopByCategory.png',
                  width: 500.58.w,
                  height: 60.58.w,
                ),
              ),
            ),
            Container(
              width: 345.w,
              // height: 600,
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
                              width: 344.w,
                              height: 110.w,
                              child: Stack(
                                children: [
                                  Positioned(
                                    // image24Suc (318:1963)
                                    left: 0.w,
                                    top: 0.w,
                                    child: Align(
                                      child: SizedBox(
                                        width: 344.w,
                                        height: 106.69.w,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.w),
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
                                    left: 0.w,
                                    top: 0.w,
                                    child: Align(
                                      child: SizedBox(
                                        width: 344.w,
                                        height: 107.w,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                10.1176462173.w),
                                            gradient: _category['id'] % 2 == 0
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
                                  if (_category['id'] % 2 != 0)
                                    Positioned(
                                      left: 22.w,
                                      top: 39.5.w,
                                      child: Container(
                                        width: 200.w,
                                        height: 48.31.w,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 0.w,
                                              top: 0.w,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 200.w,
                                                  height: 30.w,
                                                  child: Text(
                                                    _category['name'],
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize:
                                                          18.3132514954.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.5,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 2.7470703125.w,
                                              top: 24.3071899414.w,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 38.w,
                                                  height: 14.w,
                                                  child: Text(
                                                    _category['products']
                                                            .length
                                                            .toString() +
                                                        ' Items',
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize:
                                                          9.1566257477.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.5,
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
                                  if (_category['id'] % 2 == 0)
                                    Positioned(
                                      left: 250.w,
                                      top: 33.5.w,
                                      child: Container(
                                        width: 71.w,
                                        height: 38.31.w,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 0.w,
                                              top: 0.w,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 71.w,
                                                  height: 28.w,
                                                  child: Text(
                                                    _category['name'],
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize:
                                                          18.3132514954.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.5,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 2.7470703125.w,
                                              top: 24.3071899414.w,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 38.w,
                                                  height: 14.w,
                                                  child: Text(
                                                    _category['products']
                                                            .length
                                                            .toString() +
                                                        ' Items',
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize:
                                                          9.1566257477.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.5,
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
            // End Category

            // Last Banner
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 180.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0.w,
                    top: 0.w,
                    child: Align(
                      child: SizedBox(
                        width: 360.w,
                        height: 150.w,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.w),
                            color: Color(0x33eecf56),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // group46Ler (318:1938)
                    left: 268.130859375.w,
                    top: 84.827545166.w,
                    child: Align(
                      child: SizedBox(
                        width: 81.72.w,
                        height: 65.17.w,
                        child: Image.asset(
                          'assets/images/group-46.png',
                          width: 81.72.w,
                          height: 65.17.w,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse25pa2 (318:1944)
                    left: 324.5180664062.w,
                    top: 15.5172424316.w,
                    child: Align(
                      child: SizedBox(
                        width: 5.34.w,
                        height: 5.17.w,
                        child: Image.asset(
                          'assets/images/ellipse-25.png',
                          width: 5.34.w,
                          height: 5.17.w,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse32Kmg (318:1945)
                    left: 2.1362304688.w,
                    top: 37.2411804199.w,
                    child: Align(
                      child: SizedBox(
                        width: 8.82.w,
                        height: 8.54.w,
                        child: Image.asset(
                          'assets/images/ellipse-32.png',
                          width: 8.82.w,
                          height: 8.54.w,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse27Edk (318:1946)
                    left: 334.1323242188.w,
                    top: 26.8965454102.w,
                    child: Align(
                      child: SizedBox(
                        width: 11.75.w,
                        height: 11.38.w,
                        child: Image.asset(
                          'assets/images/ellipse-27.png',
                          width: 11.75.w,
                          height: 11.38.w,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse33MyG (318:1947)
                    left: 16.0239257812.w,
                    top: 2.0690307617.w,
                    child: Align(
                      child: SizedBox(
                        width: 16.38.w,
                        height: 15.86.w,
                        child: Image.asset(
                          'assets/images/ellipse-33.png',
                          width: 16.38.w,
                          height: 15.86.w,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse26UY6 (318:1948)
                    left: 311.69921875.w,
                    top: 41.3793029785.w,
                    child: Align(
                      child: SizedBox(
                        width: 18.16.w,
                        height: 17.59.w,
                        child: Image.asset(
                          'assets/images/ellipse-26.png',
                          width: 18.16.w,
                          height: 17.59.w,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse34PQA (318:1949)
                    left: 329.859375.w,
                    top: 66.2068786621.w,
                    child: Align(
                      child: SizedBox(
                        width: 14.96.w,
                        height: 14.48.w,
                        child: Image.asset(
                          'assets/images/ellipse-34.png',
                          width: 14.96.w,
                          height: 14.48.w,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse35WUn (318:1950)
                    left: 290.333984375.w,
                    top: 66.2068786621.w,
                    child: Align(
                      child: SizedBox(
                        width: 11.75.w,
                        height: 11.38.w,
                        child: Image.asset(
                          'assets/images/ellipse-34.png',
                          width: 11.75.w,
                          height: 11.38.w,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // inviteafriendandearnplantifyre (318:1951)
                    left: 24.5698242188.w,
                    top: 18.6206817627.w,
                    child: Align(
                      child: SizedBox(
                        width: 252.w,
                        height: 60.w,
                        child: Text(
                          'Invite a Friend and earn Plantify rewards',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Philosopher',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.2400000095,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // redeemthemtogetinstantdiscount (318:1952)
                    left: 28.8427734375.w,
                    top: 95.1724243164.w,
                    child: Align(
                      child: SizedBox(
                        width: 135.w,
                        height: 30.w,
                        child: Text(
                          'Redeem them to get instant discounts',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.1538461538,
                            color: Color(0xff888888),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // rectangle59cAS (318:1953)
                    left: 190.1484375.w,
                    top: 95.1724243164.w,
                    child: Align(
                      child: SizedBox(
                        width: 64.09.w,
                        height: 31.03.w,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.w),
                              color: Color(0xffeecf56),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // invite6rJ (318:1954)
                    left: 202.9672851562.w,
                    top: 99.655166626.w,
                    child: Align(
                      child: SizedBox(
                        width: 37.w,
                        height: 20.w,
                        child: Text(
                          'Invite',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // End Last Banner
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: 360,
        height: 70,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.50, color: Color(0xFFC7B456)),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 6,
            )
          ],
        ),
        child: BottomNavigationBar(
          elevation: 10,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(255, 249, 245, 225),
          // backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: (value) async {
            if (value == 0) {
              Navigator.pushNamed(context, '/homePage');
            }
            if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ShopsPage(initialText: ''), // Pass initialText if needed
                ),
              );
              // Navigator.pushNamed(context, '/shopsPage');
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
            if (value == 4) {
              Navigator.pushNamed(context, '/notificationPage');
            }
          },
          items: [
            BottomNavigationBarItem(
              label: 'HOME',
              icon: Image.asset(
                'assets/images/home-icon.png',
                width: 23,
                height: 23,
              ),
              // icon: Icon(DonIcons.wap_home, size: 23),
            ),
            BottomNavigationBarItem(
                label: 'CATEGORY',
                icon: Image.asset(
                  'assets/images/category-icon.png',
                  width: 23,
                  height: 23,
                )),
            BottomNavigationBarItem(
              label: 'CART',
              icon: badges.Badge(
                badgeContent: Text(
                  cartCount.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: Image.asset(
                  'assets/images/cart-icon.png',
                  width: 23,
                  height: 23,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: 'PROFILE',
              icon: Image.asset(
                'assets/images/user-profile-icon.png',
                width: 23,
                height: 23,
              ),
            ),
            BottomNavigationBarItem(
              label: 'NOTIFS',
              icon: Image.asset(
                'assets/images/notification-icon.png',
                width: 23,
                height: 23,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

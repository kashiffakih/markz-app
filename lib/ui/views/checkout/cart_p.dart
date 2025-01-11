import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:get_ip_address/get_ip_address.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/user_address.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/coupon_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/core/providers/product_pr.dart';
import 'package:sales_app/core/providers/user_wallet_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/products/shops_p.dart';
import 'package:sales_app/ui/views/profile/address_p.dart';
import 'package:sales_app/ui/views/promocodes/promocodes_p.dart';

import '../../../core/providers/wish_list_pr.dart';
import '../products/product_id_p.dart';

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
  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': ''
  };
  String usedCoupon = '';

  // bool type = true;
  @override
  void initState() {
    super.initState();
    var productId = '';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_CartData.isNotEmpty || _CartData != null) {
        await Provider.of<AddToCartModel>(context, listen: false)
            .getAddToCart('', '', _CartData);
      }

      if (widget.arguments?['product']['category_id'] != null) {
        await Provider.of<ProductModel>(context, listen: false)
            .getCategoryWiseProduct(
                widget.arguments?['product']['category_id']);
      }

      await Provider.of<OrderModel>(context, listen: false).getOrder();

      await Provider.of<UserWalletModel>(context, listen: false)
          .getMyUserWallets();

      await Provider.of<WishListModel>(context, listen: false)
          .getWishLists(productId);
    });
    initPlatformState();
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String? identifier = '';

  Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        _deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }
    } on PlatformException {
      _deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    // identifier = _deviceData['id'] + '@' + _deviceData['model'] + 'gmail.com';
    identifier = _deviceData['id'] + '@gmail.com';
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      // 'displaySizeInches':
      //     ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      // 'displayWidthPixels': build.displayMetrics.widthPx,
      // 'displayWidthInches': build.displayMetrics.widthInches,
      // 'displayHeightPixels': build.displayMetrics.heightPx,
      // 'displayHeightInches': build.displayMetrics.heightInches,
      // 'displayXDpi': build.displayMetrics.xDpi,
      // 'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }

  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> paymentOptions = [
    {
      "name": 'CoD (Not available)',
      "icon": "assets/images/cash-on-delivery-logo-free-png.webp",
    },
    {
      "name": "Google Pay",
      "icon":
          "assets/images/pngtree-google-pay-payment-software-vector-png-image_12256718.png",
    },
    {
      "name": "PhonePe",
      "icon": "assets/images/PhonePe-Logo.wine.png",
    }
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
    final ProductModel _productModel = Provider.of<ProductModel>(context);
    final WishListModel _wishListModel = Provider.of<WishListModel>(context);

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

    double discountPrice = 0.0;

    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/homePage');
          return false;
        },
        child: SafeArea(
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
                                const SizedBox(width: 5),
                                Container(
                                  width: 268,
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
                                              const EdgeInsets.only(top: 1.0),
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
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                530,
                                          ),
                                          Text(
                                            'Add More Items',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: _productModel
                                                          .productsLoader
                                                      ? Center(
                                                          child:
                                                              LinearProgressIndicator())
                                                      : ListView.builder(
                                                          // padding:
                                                          //     const EdgeInsets.only(left: 5, right: 8),
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              _productModel
                                                                  .products!
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.4,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.45,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .push(
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ProductIdPage(arguments: {
                                                                              'product': _productModel.products![index].toJson(),
                                                                              'product_images': _productModel.products![index].productImages
                                                                            }),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            0 * fem,
                                                                            0 * fem,
                                                                            0 * fem,
                                                                            5 * fem),
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            106 *
                                                                                fem,
                                                                            13 *
                                                                                fem,
                                                                            14 *
                                                                                fem,
                                                                            15 *
                                                                                fem),
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.4,
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.26,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15),
                                                                          image:
                                                                              DecorationImage(
                                                                            fit:
                                                                                BoxFit.contain,
                                                                            image:
                                                                                NetworkImage(_configModel.apiConfig['mediaURL'] + _productModel.products![index].productImages?.first.imagepath.toString()),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            await _wishListModel.getWishLists(_productModel.products![index].id);
                                                                          },
                                                                          child: _wishListModel.wishListLoader
                                                                              ? Align(alignment: Alignment.topRight, child: Icon(Icons.favorite_border_outlined))
                                                                              : _wishListModel.wishLists!.where((wishList) => wishList.productId == _productModel.products![index].id && wishList.userId == _configModel.user!.id).toList().length == 0
                                                                                  ? Align(alignment: Alignment.topRight, child: Icon(Icons.favorite_border_outlined))
                                                                                  : Align(
                                                                                      alignment: Alignment.topRight,
                                                                                      child: Icon(
                                                                                        Icons.favorite_outlined,
                                                                                        color: Colors.red,
                                                                                      )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context).push(MaterialPageRoute(
                                                                            builder: (context) => ProductIdPage(arguments: {
                                                                                  'product': _productModel.products![index].toJson(),
                                                                                  'category': _productModel.products![index].category!.name.toString(),
                                                                                })));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          _productModel
                                                                              .products![index]
                                                                              .name
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Urbanist',
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color:
                                                                                Color(0xff000000),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: _productModel.products![index].productPrices![0].offerPrice !=
                                                                              0
                                                                          ? Text.rich(
                                                                              TextSpan(children: [
                                                                              new TextSpan(
                                                                                text: 'RS. ${_productModel.products![index].productPrices![0].price.toString()}',
                                                                                style: new TextStyle(
                                                                                  color: Colors.grey,
                                                                                  decoration: TextDecoration.lineThrough,
                                                                                ),
                                                                              ),
                                                                              new TextSpan(
                                                                                text: ' RS.${_productModel.products![index].productPrices![0].offerPrice.toString()}',
                                                                              ),
                                                                            ]))
                                                                          : Text(
                                                                              _productModel.products![index].productPrices![0].price.toString() + " " + 'RS',
                                                                              style: MyGoogleFontStyle(
                                                                                fontFamily: 'Poppins',
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500,
                                                                                height: 1.5,
                                                                                letterSpacing: -0.2190869331,
                                                                                color: Color(0x99000000),
                                                                              ),
                                                                            ),
                                                                    ),
                                                                    if (discountPrice !=
                                                                        0.0)
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          '( ${discountPrice.round()}% Off)',
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Color(0x99000000),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                  itemCount: _addToCartModel.addToCarts!.length,
                                  itemBuilder: (BuildContext context, index) {
                                    // print(
                                    //     'cart Count: ${_addToCartModel.addToCarts!.first.userId}');
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
                                    // print(_addToCartModel
                                    //     .addToCarts![index].product
                                    //     .where((image) =>
                                    //         image.unit!.name ==
                                    //         _addToCartModel
                                    //             .addToCarts![index].flavour)
                                    //     .toList()
                                    //     .first
                                    //     .imagepath);
                                    Map<String, dynamic> _cartData =
                                        _addToCartModel.addToCarts![index]
                                            .toJson();
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductIdPage(
                                                                  arguments: {
                                                                    'product': _addToCartModel
                                                                        .addToCarts![
                                                                            index]
                                                                        .product!
                                                                        .toJson(),
                                                                    'product_images': _addToCartModel
                                                                        .addToCarts![
                                                                            index]
                                                                        .product!
                                                                        .productImages
                                                                  })));
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 10, 0),
                                                  child: Center(
                                                    child: Image.network(
                                                      _configModel.apiConfig[
                                                              'mediaURL'] +
                                                          _addToCartModel
                                                              .addToCarts![
                                                                  index]
                                                              .product!
                                                              .productImages!
                                                              .where((image) =>
                                                                  image.unit!
                                                                      .name ==
                                                                  _addToCartModel
                                                                      .addToCarts![
                                                                          index]
                                                                      .flavour)
                                                              .toList()[0]
                                                              .imagepath
                                                              .toString(),
                                                      // 'assets/images/mask-group-HvE.png',
                                                      fit: BoxFit.contain,
                                                      // width: 120,
                                                      // height: 150,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 8,
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
                                                        color:
                                                            Color(0xff909090),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: _addToCartModel
                                                                  .addToCarts![
                                                                      index]
                                                                  .product!
                                                                  .productPrices![
                                                                      0]
                                                                  .offerPrice !=
                                                              0
                                                          ? Row(
                                                              children: [
                                                                Text.rich(
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
                                                                      ]),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                if (discountPrice !=
                                                                    0.0)
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
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
                                                              ],
                                                            )
                                                          : Row(
                                                              children: [
                                                                Text(
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
                                                                ),
                                                                if (discountPrice !=
                                                                    0.0)
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
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
                                                              ],
                                                            )),
                                                  Row(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Size: ${_addToCartModel.addToCarts![index].kindOfFlower}',
                                                          style:
                                                              MyGoogleFontStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            'Colour: ${_addToCartModel.addToCarts![index].flavour}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                MyGoogleFontStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Align(
                                                  //   alignment:
                                                  //       Alignment.centerLeft,
                                                  //   child: Row(
                                                  //     children: [
                                                  //       Icon(
                                                  //         Icons.star,
                                                  //         color: Colors.amber,
                                                  //       ),
                                                  //       Text(
                                                  //         ' ( ${(_addToCartModel.addToCarts![index].product!.reviews == null ? 0 : _addToCartModel.addToCarts![index].product!.reviews?.length)} ratings )',
                                                  //         style: TextStyle(
                                                  //             fontSize: 12),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
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
                                                                    _cartData);
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
                                                                color: Colors
                                                                    .black),
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
                                                                    _cartData);
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
                                                                Icons.add,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
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
                                  },
                                ),
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
                          usedCoupon == ''
                              ? Form(
                                  key: _formKey,
                                  child: Row(children: [
                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Color(0xffe3e3e3)),
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
                                            hintStyle: TextStyle(
                                                color: Color(0x3f000000)),
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

                                          await _couponModel
                                              .verifyCoupon(coupon);
                                          // print(_couponModel.coupons![0].minOrderValue);
                                          if (_couponModel.coupons != null &&
                                              _couponModel
                                                  .coupons!.isNotEmpty) {
                                            final firstCoupon =
                                                _couponModel.coupons![0];
                                            final cartTotal = int.parse(
                                                _addToCartModel.cartTotal
                                                    .toString());

                                            if (firstCoupon.minOrderValue! <
                                                cartTotal) {
                                              setState(() {
                                                couponValue = double.parse(
                                                        firstCoupon.value
                                                            .toString())
                                                    .toInt();
                                                couponId =
                                                    firstCoupon.id.toString();
                                              });
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
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
                                                        BorderRadius.circular(
                                                            20)),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                )
                              : Text('Coupon Applied: ${usedCoupon}'),

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

                              setState(() {
                                usedCoupon = firstCoupon.name.toString();
                              });

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
                                      MediaQuery.of(context).size.height * 0.68,
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
                                        if (address.id != null)
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
                                                  "${_configModel.user!.firstName.toString()} [ ${address.label.toString()}]",
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
                                                  (address.fullName != null
                                                          ? address.fullName
                                                              .toString()
                                                          : '') +
                                                      ', ' +
                                                      (address.phone != null
                                                          ? address.phone
                                                              .toString()
                                                          : '') +
                                                      ', ' +
                                                      (address.altPhone != null
                                                          ? address.altPhone
                                                              .toString()
                                                          : '') +
                                                      ', ' +
                                                      (address.add1 != null
                                                          ? address.add1
                                                              .toString()
                                                          : '') +
                                                      ', ' +
                                                      (address.add2 != null
                                                          ? address.add2
                                                              .toString()
                                                          : '') +
                                                      ', ' +
                                                      (address.add3 != null
                                                          ? address.add3
                                                              .toString()
                                                          : '') +
                                                      ',' +
                                                      (address.state != null
                                                          ? address.state
                                                              .toString()
                                                          : '') +
                                                      ', ' +
                                                      ', ' +
                                                      (address.city != null
                                                          ? address.city
                                                              .toString()
                                                          : '') +
                                                      ', ' +
                                                      (address.pincode != null
                                                          ? address.pincode
                                                              .toString()
                                                          : '') +
                                                      '.',
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff909090),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (address.id == null)
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
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              100,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  _payment[
                                                                      'name'],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 50,
                                                                child:
                                                                    Image.asset(
                                                                  _payment[
                                                                      'icon'],
                                                                  height: 50,
                                                                  width: 50,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        value: _payment['name'],
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
                                          margin: EdgeInsets.only(
                                            top: 5,
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
                                                            .user!
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
                                                            .user!
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
                                                                    .user!
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
                                                      'Rewards (-)',
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
                                                    'RS ${(_userWaletModel.totaRemainingPoint ~/ 3)}',
                                                    // Division by 3 directly
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
                                                                    .user!
                                                                    .companies![
                                                                        0]
                                                                    .deliveryCharges
                                                                    .toString()) +
                                                                (int.parse(_addToCartModel
                                                                        .cartTotal
                                                                        .toString()) /
                                                                    100 *
                                                                    int.parse(_configModel
                                                                        .user!
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
                                  height: 10,
                                ),
                                address.id != null
                                    ? Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0.89, 0, 0, 0),
                                          child: TextButton(
                                            onPressed: () async {
                                              // print(paymentOption);
                                              if (paymentOption == '') {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: Text(
                                                        'Please select payment type.'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Ok'),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                var orderCost = (int.parse(
                                                            _addToCartModel
                                                                .cartTotal
                                                                .toString()) +
                                                        int.parse(_configModel
                                                            .user!
                                                            .companies![0]
                                                            .deliveryCharges
                                                            .toString()) +
                                                        (int.parse(_addToCartModel
                                                                .cartTotal
                                                                .toString()) /
                                                            100 *
                                                            int.parse(_configModel
                                                                .user!
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
                                                    await _orderModel
                                                        .placedOrder(
                                                  _addToCartModel.addToCarts!
                                                      .toList(),
                                                  _addToCartModel.cartTotal
                                                      .toString(),
                                                  addressId,
                                                  isGift,
                                                  userWalletUsed,
                                                  couponId.toString(),
                                                  paymentOption,
                                                  "deliveryMethod",
                                                  couponValue.toString(),
                                                );
                                                if (response == true) {
                                                  Navigator.pushNamed(
                                                      context, '/successPage');
                                                }
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
                                                  'Pay/Continue',
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
                                      ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Add More Items',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 190,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: _productModel
                                                      .categoryWiseproductsLoader
                                                  ? Center(
                                                      child:
                                                          LinearProgressIndicator())
                                                  : ListView.builder(
                                                      itemCount: _productModel
                                                          .categoryWiseproducts!
                                                          .length,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                                  index) =>
                                                              InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ProductIdPage(
                                                                          arguments: {
                                                                            'product':
                                                                                _productModel.categoryWiseproducts![index].toJson(),
                                                                            'product_images':
                                                                                _productModel.categoryWiseproducts![index].productImages
                                                                          })));
                                                        },
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              // margin: EdgeInsets.fromLTRB(
                                                              //     0, 0, 0, 0),
                                                              width: 170,
                                                              height: 320,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height: 140,
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Positioned(
                                                                          // frame9SvA (318:2815)
                                                                          left:
                                                                              0,
                                                                          top:
                                                                              0,
                                                                          child:
                                                                              Container(
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                106,
                                                                                13,
                                                                                14,
                                                                                13),
                                                                            width:
                                                                                145,
                                                                            height:
                                                                                133,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              color: Color(0x0c000000),
                                                                              image: DecorationImage(
                                                                                fit: BoxFit.cover,
                                                                                image: NetworkImage(_configModel.apiConfig['mediaURL'] + _productModel.categoryWiseproducts![index].imagepath1.toString()
                                                                                    // 'assets/images/shades-chocolate-cake-3-1-2-1-bg.png',
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () async {
                                                                                await _wishListModel.getWishLists(_productModel.categoryWiseproducts![index].id);
                                                                              },
                                                                              child: _wishListModel.wishLists!.where((wishList) => wishList.productId == _productModel.categoryWiseproducts![index].id && wishList.userId == _configModel.user!.id).toList().length == 0
                                                                                  ? Align(alignment: Alignment.topRight, child: Icon(Icons.favorite_border_outlined))
                                                                                  : Align(
                                                                                      alignment: Alignment.topRight,
                                                                                      child: Icon(
                                                                                        Icons.favorite_outlined,
                                                                                        color: Colors.red,
                                                                                      )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                      _productModel
                                                                          .categoryWiseproducts![
                                                                              index]
                                                                          .name
                                                                          .toString(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          MyGoogleFontStyle(
                                                                        fontFamily:
                                                                            'Urbanist',
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        height:
                                                                            1.2,
                                                                        letterSpacing:
                                                                            -0.3,
                                                                        color: Color(
                                                                            0xff000000),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.of(context).push(MaterialPageRoute(
                                                                          builder: (context) => ProductIdPage(arguments: {
                                                                                'product': _productModel.categoryWiseproducts![index].toJson(),
                                                                                'product_images': _productModel.categoryWiseproducts![index].productImages
                                                                              })));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      child: _productModel.categoryWiseproducts![index].productPrices![0].offerPrice !=
                                                                              0
                                                                          ? Text.rich(
                                                                              TextSpan(children: [
                                                                              new TextSpan(
                                                                                text: 'RS. ${_productModel.categoryWiseproducts![index].productPrices![0].price.toString()}',
                                                                                style: new TextStyle(
                                                                                  color: Colors.grey,
                                                                                  decoration: TextDecoration.lineThrough,
                                                                                ),
                                                                              ),
                                                                              new TextSpan(
                                                                                text: ' RS.${_productModel.categoryWiseproducts![index].productPrices![0].offerPrice.toString()}',
                                                                              ),
                                                                            ]))
                                                                          : Text(
                                                                              _productModel.categoryWiseproducts![index].productPrices![0].price.toString() + " " + 'RS',
                                                                              style: MyGoogleFontStyle(
                                                                                fontFamily: 'Poppins',
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500,
                                                                                height: 1.5,
                                                                                letterSpacing: -0.2190869331,
                                                                                color: Color(0x99000000),
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
                                                    ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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

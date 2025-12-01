import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:aadab/core/models/payment_response.dart';
import 'package:aadab/core/services/phonepe_s.dart';
import 'package:aadab/core/services/product_s.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:get_ip_address/get_ip_address.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/user_address.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/coupon_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/order_pr.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/core/providers/user_wallet_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/products/shops_p.dart';
import 'package:aadab/ui/views/profile/address_p.dart';
import 'package:aadab/ui/views/promocodes/promocodes_p.dart';

import '../../../core/providers/wish_list_pr.dart';
import '../products/product_id_p.dart';

class CartPage extends StatefulWidget {
  final isProfile;
  final arguments;

  const CartPage({Key? key, this.arguments, this.isProfile}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String coupon = '';
  String couponId = '';
  bool buttonLoading = false;
  int? loadingItemIndex; // Which cart item is loading
  String? quantityLoadingAction; // 'increment' or 'decrement'
  bool couponValidationLoading = false;
  double couponValue = 0;
  UserAddress address = UserAddress();
  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': '',
    'is_add_to_cart': false
  };
  String usedCoupon = '';
  int useWalletPoint = 0;
  bool _isLoading = true;

  final PhonePeService _phonePeService = locator<PhonePeService>();
  String result = "";

  // Method to validate coupon against current cart total
  Future<void> _validateAppliedCoupon() async {
    if (usedCoupon.isNotEmpty && couponValue > 0) {
      setState(() {
        couponValidationLoading = true;
      });
      final AddToCartModel _addToCartModel =
          Provider.of<AddToCartModel>(context, listen: false);
      final CouponModel _couponModel =
          Provider.of<CouponModel>(context, listen: false);

      // Get current cart total
      final cartTotal = int.parse(_addToCartModel.cartTotal.toString());

      // Re-verify the coupon to get updated data
      await _couponModel.verifyCoupon(usedCoupon);

      // Check if we have coupon data and validate minimum amount
      if (_couponModel.coupons != null && _couponModel.coupons!.isNotEmpty) {
        final appliedCoupon = _couponModel.coupons!.first;

        // If cart total is less than minimum order value, remove coupon
        if (appliedCoupon.minOrderValue! >= cartTotal) {
          setState(() {
            usedCoupon = '';
            couponValue = 0;
            couponId = '';
            coupon = '';
          });

          // Show message to user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Coupon removed as cart total is less than minimum amount of RS ${appliedCoupon.minOrderValue}'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }

      setState(() {
        couponValidationLoading = false;
      });
    }
  }

  // Method to recalculate rewards points based on current cart total
  Future<void> _recalculateRewards() async {
    final AddToCartModel _addToCartModel =
        Provider.of<AddToCartModel>(context, listen: false);
    final UserWalletModel _userWalletModel =
        Provider.of<UserWalletModel>(context, listen: false);

    // Only recalculate if rewards are currently being used
    if (useWalletPoint > 0) {
      setState(() {
        // Calculate 25% of item total after coupon discount
        final cartTotal = int.parse(_addToCartModel.cartTotal.toString());
        // Calculate using new method: item total = cartTotal / 105 * 100
        final itemTotal = (cartTotal / 105) * 100;
        // Item total is already calculated after coupon discount
        final cartAfterCoupon = itemTotal;

        final calculatedPoints = (cartAfterCoupon * 0.25).round();
        final availablePoints = _userWalletModel.totaRemainingPoint;
        useWalletPoint = calculatedPoints > availablePoints
            ? availablePoints
            : calculatedPoints;
      });
    }
  }
  // bool type = true;

  Payment? payment;

  @override
  void initState() {
    initializePhonePe();
    _loadData();
    super.initState();
  }

  void initializePhonePe() async {
    try {
      await _phonePeService.initializePhonePe();
      setState(() {
        result = "PhonePe SDK Initialized";
      });
    } catch (error) {
      setState(() {
        result = "Error Initializing SDK: $error";
      });
    }

    print('Check $result');
  }

  // Helper method to get available quantity for a cart item
  Future<int> _getAvailableQty(cartItem) async {
    try {
      debugPrint(
          '_getAvailableQty: Fetching for productId=${cartItem.productId}, pack=${cartItem.pack}');
      final productService = locator<ProductService>();
      final product =
          await productService.getProductById(cartItem.productId ?? 0);

      if (product != null &&
          product.productPacks != null &&
          product.productPacks!.isNotEmpty) {
        debugPrint(
            '_getAvailableQty: Found ${product.productPacks!.length} packs');
        try {
          final matchingPack = product.productPacks!.firstWhere(
            (pack) => pack.id.toString() == cartItem.pack,
          );
          debugPrint(
              '_getAvailableQty: Found matching pack with qty=${matchingPack.qty}');
          return matchingPack.qty ?? 0;
        } catch (e) {
          debugPrint(
              '_getAvailableQty: No matching pack found, using first pack');
          if (product.productPacks!.isNotEmpty) {
            return product.productPacks!.first.qty ?? 0;
          }
        }
      }
      debugPrint(
          '_getAvailableQty: Falling back to product qty=${cartItem.product?.qty}');
      return cartItem.product?.qty ?? 0;
    } catch (e) {
      debugPrint('_getAvailableQty ERROR: $e');
      return 0;
    }
  }

  Future<void> _startTransaction(int amount, String mobileNumber,
      Map<String, dynamic> payload, BuildContext context) async {
    debugPrint("PhonePe V2 Transaction initiated");

    setState(() {
      _isLoading = true;
    });

    // try {
    // Generate unique merchant order ID as per V2 documentation
    final merchantOrderId = DateTime.now().millisecondsSinceEpoch.toString();

    debugPrint("PhonePe V2 Transaction Details:");
    debugPrint("Amount: ${amount * 100} paisa");
    debugPrint("Merchant Order ID: $merchantOrderId");

    // Start transaction using V2 documentation compliant method
    payment = await _phonePeService.startTransaction(
      merchantOrderId: merchantOrderId,
      // amount: 100, // Amount in paisa as per docs
      amount: amount * 100, // Amount in paisa as per docs
    );

    debugPrint("Transaction completed with state: ${payment?.state}");

    if (payment?.state == 'COMPLETED') {
      payload['transaction_id'] = payment?.transactionId.toString();
      payload['payment_type'] = payment?.paymentInstrument?.type.toString();
      payload['account_type'] =
          payment?.paymentInstrument?.accountType.toString();
      payload['merchant_transaction_id'] =
          payment?.merchantTransactionId.toString();
      payload['merchant_id'] = payment?.merchantId.toString();
      payload['utr'] = payment?.paymentInstrument?.utr.toString();

      // print(payload);
      final AddToCartModel _addToCartModel =
          Provider.of<AddToCartModel>(context, listen: false);
      final OrderModel _orderModel =
          Provider.of<OrderModel>(context, listen: false);

      // Create payment details string with transaction info
      String paymentDetails =
          'Online Payment - Transaction ID: ${payment!.transactionId}';
      if (payment!.transactionId != null) {
        paymentDetails += ', Order ID: ${payment!.transactionId}';
      }

      bool orderResponse = await _orderModel.placedOrder(
        _addToCartModel.addToCarts!.toList(),
        payload['cartTotal'],
        payload['addressId'],
        payload['isGift'],
        payload['useWalletPoint'],
        payload['couponId'],
        paymentDetails,
        payload['deliveryMethod'],
        payload['couponValue'],
        payload['gstAmount'],
      );

      setState(() {
        _isLoading = false;
      });
      if (orderResponse == true) {
        Navigator.pushNamed(context, '/successPage');
      }
    } else if (payment?.state == 'PENDING') {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text("Payment Pending"),
            content: Text(
                "Your payment is being processed. You will receive a confirmation shortly. Check your order status in the app."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        },
      );
    } else if (payment?.state == 'FAILED' || payment?.state == 'FAILURE') {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text("Payment Failed"),
            content: Text(
                "Payment failed: ${payment?.state}. Please try again or contact support."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        },
      );
    } else {
      // Handle unknown or other states
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text("Transaction Status"),
            content: Text(
                "Transaction status: ${payment?.state ?? 'Unknown'}. Please check your order status or contact support."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        },
      );
      // .then((_) {
      //   Navigator.pop(context);
      //   Navigator.pushNamed(
      //     context,
      //     '/bookingReview',
      //     arguments: {"payloadData": widget.payload['payloadData']},
      //   );
      // });
    }
  }

  Future<void> _loadData() async {
    try {
      var productId = '';

      // Load all required data
      await Provider.of<AddToCartModel>(context, listen: false)
          .getAddToCart('', '', _CartData);

      debugPrint('Category Id ${widget.arguments?['product']}');

      await Provider.of<ProductModel>(context, listen: false)
          .getAllProducts('');

      await Provider.of<OrderModel>(context, listen: false).getOrder();

      await Provider.of<UserWalletModel>(context, listen: false)
          .getMyUserWallets();

      await Provider.of<WishListModel>(context, listen: false)
          .getWishLists(productId);

      // Update calculations after data is loaded
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Calculate 25% of item total after coupon discount
          final addToCartModel =
              Provider.of<AddToCartModel>(context, listen: false);
          final cartTotal = int.parse(addToCartModel.cartTotal.toString());
          // Calculate GST on cart total after applying coupon discount
          final cartTotalAfterCoupon = cartTotal - couponValue;
          // Calculate using new method: item total = cartTotalAfterCoupon / 105 * 100
          final itemTotal = (cartTotalAfterCoupon / 105) * 100;
          // Item total is already calculated after coupon discount
          final cartAfterCoupon = itemTotal;

          final calculatedPoints = (cartAfterCoupon * 0.25).round();
          final availablePoints =
              Provider.of<UserWalletModel>(context, listen: false)
                  .totaRemainingPoint;
          useWalletPoint = calculatedPoints > availablePoints
              ? availablePoints
              : calculatedPoints;
        });
      }
    } catch (e) {
      debugPrint('Error loading cart data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show error message if it's a network error
        if (e.toString().contains('SocketException') ||
            e.toString().contains('Connection') ||
            e.toString().contains('Failed host lookup')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('No internet connection. Please check your network.'),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _loadData();
                },
              ),
            ),
          );
        }
      }
    }
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
      "name": 'Cash on Delivery',
      "icon": "assets/images/cash-on-delivery-logo-free-png.webp",
    },
    {
      "name": "UPI - Online",
      "icon": "assets/images/PhonePe-Logo.wine.png",
    }
  ];

  var paymentOption = '';

  bool isGift = false;

  // Store order details for Razorpay
  Map<String, dynamic> _orderDetails = {};

  // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   // Payment success, now place the order
  //   debugPrint('Payment Success: ${response.paymentId}');
  //   debugPrint('Payment Order ID: ${response.orderId}');
  //   debugPrint('Payment Signature: ${response.signature}');

  //   final AddToCartModel _addToCartModel =
  //       Provider.of<AddToCartModel>(context, listen: false);
  //   final OrderModel _orderModel =
  //       Provider.of<OrderModel>(context, listen: false);

  //   // Create payment details string with transaction info
  //   String paymentDetails =
  //       'Online Payment - Transaction ID: ${response.paymentId}';
  //   if (response.orderId != null) {
  //     paymentDetails += ', Order ID: ${response.orderId}';
  //   }

  //   bool orderResponse = await _orderModel.placedOrder(
  //     _addToCartModel.addToCarts!.toList(),
  //     _orderDetails['cartTotal'],
  //     _orderDetails['addressId'],
  //     _orderDetails['isGift'],
  //     _orderDetails['useWalletPoint'],
  //     _orderDetails['couponId'],
  //     paymentDetails,
  //     _orderDetails['deliveryMethod'],
  //     _orderDetails['couponValue'],
  //   );

  //   if (orderResponse == true) {
  //     Navigator.pushNamed(context, '/successPage');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while data is being loaded
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFEF9), Color(0xFFFFFDF7), Colors.white],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFEED056).withOpacity(0.15),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFEED056)),
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Loading...',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff232323),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final AddToCartModel _addToCartModel =
        Provider.of<AddToCartModel>(context, listen: false);
    final ConfigModel _configModel = locator<ConfigModel>();
    final OrderModel _orderModel =
        Provider.of<OrderModel>(context, listen: false);
    final CouponModel _couponModel =
        Provider.of<CouponModel>(context, listen: false);
    final UserWalletModel _userWaletModel =
        Provider.of<UserWalletModel>(context, listen: false);
    final ProductModel _productModel =
        Provider.of<ProductModel>(context, listen: false);
    final WishListModel _wishListModel =
        Provider.of<WishListModel>(context, listen: false);

    // Initialize address data after loading is complete
    if (_orderModel.orders.isNotEmpty && address.add1 == null) {
      address = _orderModel.orders[0].address ?? UserAddress();
    }
    if (widget.arguments != null && widget.arguments['address'] != null) {
      address = UserAddress.fromJson(widget.arguments['address']);
    }

    double discountPrice = 0.0;
    return WillPopScope(
      onWillPop: () async {
        if (widget.isProfile != null && widget.isProfile['isProfile'] == true) {
          Navigator.pushReplacementNamed(context, '/profilePage');
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFEF9), Color(0xFFFFFDF7), Colors.white],
            ),
          ),
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
                                      fontSize: 20.0.sp,
                                      fontWeight: FontWeight.w700,
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
                                      if (widget.isProfile != null &&
                                          widget.isProfile['isProfile'] ==
                                              true) {
                                        Navigator.pushReplacementNamed(
                                            context, '/profilePage');
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.0.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFFEED056)
                                                .withOpacity(0.15),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        size: 16.0.sp,
                                        color: const Color(0xffEED056),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                ],
                              )
                            ],
                          ),
                        ),
                        // Body
                        Container(
                          width: 1.0.sw - 50,
                          // height: 1.0.sh - 250,
                          child: _addToCartModel.addToCarts!.isEmpty
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      child:
                                          Center(child: Text('Cart is empty')),
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
                                                        : (_productModel.allProducts ==
                                                                    null ||
                                                                _productModel
                                                                    .allProducts!
                                                                    .isEmpty)
                                                            ? Center(
                                                                child: Text(
                                                                  'No products available',
                                                                  style:
                                                                      MyGoogleFontStyle(
                                                                    fontFamily:
                                                                        'Urbanist',
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              )
                                                            : ListView.builder(
                                                                // padding:
                                                                //     const EdgeInsets.only(left: 5, right: 8),
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: _productModel
                                                                        .allProducts
                                                                        ?.length ??
                                                                    0,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    child:
                                                                        Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.4,
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.45,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.of(context).push(
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => ProductIdPage(arguments: {
                                                                                    'product': _productModel.allProducts?[index].toJson(),
                                                                                    'product_images': _productModel.allProducts?[index].productImages
                                                                                  }),
                                                                                ),
                                                                              );
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              margin: EdgeInsets.fromLTRB(0.0.w, 0.0.w, 0.0.w, 5.0.w),
                                                                              padding: EdgeInsets.fromLTRB(106.0.w, 13.0.w, 14.0.w, 15.0.w),
                                                                              width: 0.4.sw,
                                                                              height: 0.26.sh,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15),
                                                                                image: DecorationImage(
                                                                                  fit: BoxFit.contain,
                                                                                  image: NetworkImage(_configModel.apiConfig['mediaURL'] + ((_productModel.allProducts?[index].productImages?.isNotEmpty ?? false) ? _productModel.allProducts![index].productImages!.first.imagepath?.toString() ?? '' : '')),
                                                                                ),
                                                                              ),
                                                                              child: InkWell(
                                                                                onTap: () async {
                                                                                  if (_configModel.user != null) {
                                                                                    await _wishListModel.getWishLists(_productModel.allProducts?[index].id);
                                                                                    setState(() {});
                                                                                  } else {
                                                                                    // Show login required dialog
                                                                                    showDialog(
                                                                                      context: context,
                                                                                      builder: (context) => AlertDialog(
                                                                                        title: Text('Login Required'),
                                                                                        content: Text('Please login to add items to wishlist'),
                                                                                        actions: [
                                                                                          TextButton(
                                                                                            onPressed: () => Navigator.pop(context),
                                                                                            child: Text('OK'),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                },
                                                                                child: _wishListModel.wishListLoader
                                                                                    ? Align(alignment: Alignment.topRight, child: Icon(Icons.favorite_border_outlined))
                                                                                    : _wishListModel.wishLists?.where((wishList) => wishList.productId == _productModel.allProducts?[index].id && wishList.userId == _configModel.user?.id).toList().length == 0
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
                                                                                        'product': _productModel.allProducts?[index].toJson(),
                                                                                        'category': _productModel.allProducts?[index].category?.name?.toString() ?? '',
                                                                                      })));
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              child: Text(
                                                                                _productModel.allProducts?[index].name ?? ''.toString(),
                                                                                textAlign: TextAlign.center,
                                                                                style: MyGoogleFontStyle(
                                                                                  fontFamily: 'Urbanist',
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.w700,
                                                                                  color: Color(0xff000000),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            child: (_productModel.allProducts?[index].productPrices?[0].offerPrice ?? 0) != 0
                                                                                ? Text.rich(TextSpan(children: [
                                                                                    new TextSpan(
                                                                                      text: 'RS. ${_productModel.allProducts?[index].productPrices?[0].price?.toString() ?? '0'}',
                                                                                      style: new TextStyle(
                                                                                        color: Colors.grey,
                                                                                        decoration: TextDecoration.lineThrough,
                                                                                      ),
                                                                                    ),
                                                                                    new TextSpan(
                                                                                      text: ' RS.${_productModel.allProducts?[index].productPrices?[0].offerPrice?.toString() ?? '0'}',
                                                                                    ),
                                                                                  ]))
                                                                                : Text(
                                                                                    (_productModel.allProducts?[index].productPrices?[0].price?.toString() ?? '0') + " " + 'RS',
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
                                                                              child: Text(
                                                                                '( ${discountPrice.round()}% Off)',
                                                                                style: MyGoogleFontStyle(
                                                                                  fontFamily: 'Poppins',
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Color(0x99000000),
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
                                  height: 1.0.sh *
                                      (0.23 *
                                          (_addToCartModel.addToCarts!.length <
                                                  2
                                              ? _addToCartModel
                                                  .addToCarts!.length
                                              : 2)),
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        _addToCartModel.addToCarts!.length,
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
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8.0.w, horizontal: 4.0.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0.r),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFFEED056)
                                                  .withOpacity(0.12),
                                              blurRadius: 20,
                                              spreadRadius: 2,
                                              offset: const Offset(0, 6),
                                            ),
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(12.0.w),
                                          child: Row(
                                            children: [
                                              InkWell(
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
                                                  width: 100.0.w,
                                                  height: 120.0.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0.r),
                                                    color:
                                                        const Color(0x0c000000),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0.r),
                                                    child: Builder(
                                                      builder: (context) {
                                                        final product =
                                                            _addToCartModel
                                                                .addToCarts![
                                                                    index]
                                                                .product!;
                                                        final matchingImages = product
                                                            .productImages!
                                                            .where((image) =>
                                                                image.unit
                                                                    ?.name ==
                                                                _addToCartModel
                                                                    .addToCarts![
                                                                        index]
                                                                    .flavour)
                                                            .toList();

                                                        final imageUrl = matchingImages
                                                                .isNotEmpty
                                                            ? _configModel
                                                                        .apiConfig[
                                                                    'mediaURL'] +
                                                                matchingImages[
                                                                        0]
                                                                    .imagepath
                                                                    .toString()
                                                            : (product
                                                                    .productImages!
                                                                    .isNotEmpty
                                                                ? _configModel
                                                                            .apiConfig[
                                                                        'mediaURL'] +
                                                                    product
                                                                        .productImages!
                                                                        .first
                                                                        .imagepath
                                                                        .toString()
                                                                : '');

                                                        return Image.network(
                                                          imageUrl,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Icon(Icons.image,
                                                                  size: 50,
                                                                  color: Colors
                                                                      .grey),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 12.0.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _addToCartModel
                                                          .addToCarts![index]
                                                          .product!
                                                          .name
                                                          .toString(),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontSize: 14.0.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff000000),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4.0.h),
                                                    if (_addToCartModel
                                                        .addToCarts![index]
                                                        .product!
                                                        .productPrices!
                                                        .isNotEmpty)
                                                      _addToCartModel
                                                                      .addToCarts![
                                                                          index]
                                                                      .product!
                                                                      .productPrices![
                                                                          0]
                                                                      .offerPrice !=
                                                                  null &&
                                                              _addToCartModel
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
                                                                      TextSpan(
                                                                        text:
                                                                            '₹${_addToCartModel.addToCarts![index].product!.productPrices![0].price}',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.grey,
                                                                          decoration:
                                                                              TextDecoration.lineThrough,
                                                                          fontSize:
                                                                              13.0.sp,
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' ₹${_addToCartModel.addToCarts![index].product!.productPrices![0].offerPrice}',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              const Color(0x99000000),
                                                                          fontSize:
                                                                              13.0.sp,
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                if (discountPrice !=
                                                                    0.0) ...[
                                                                  SizedBox(
                                                                      width: 6.0
                                                                          .w),
                                                                  Text(
                                                                    '(${discountPrice.round()}% Off)',
                                                                    style:
                                                                        MyGoogleFontStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          13.0.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: const Color(
                                                                          0x99000000),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ],
                                                            )
                                                          : Text(
                                                              '₹${_addToCartModel.addToCarts![index].product!.productPrices![0].price}',
                                                              style:
                                                                  MyGoogleFontStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize:
                                                                    13.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: const Color(
                                                                    0x99000000),
                                                              ),
                                                            ),
                                                    SizedBox(height: 6.0.h),
                                                    Wrap(
                                                      spacing: 8.0.w,
                                                      runSpacing: 4.0.h,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8.0.w,
                                                                  vertical:
                                                                      4.0.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFFFFFEF9),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6.0.r),
                                                            border: Border.all(
                                                                color: Color(
                                                                        0xFFEED056)
                                                                    .withOpacity(
                                                                        0.3)),
                                                          ),
                                                          child: Text(
                                                            'Size: ${_addToCartModel.addToCarts![index].kindOfFlower}',
                                                            style:
                                                                MyGoogleFontStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 11.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xff606060),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8.0.w,
                                                                  vertical:
                                                                      4.0.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFFFFFEF9),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6.0.r),
                                                            border: Border.all(
                                                                color: Color(
                                                                        0xFFEED056)
                                                                    .withOpacity(
                                                                        0.3)),
                                                          ),
                                                          child: Text(
                                                            'Colour: ${_addToCartModel.addToCarts![index].flavour}',
                                                            style:
                                                                MyGoogleFontStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 11.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xff606060),
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
                                                    SizedBox(height: 8.0.h),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFFF5F5F5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0.r),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: loadingItemIndex !=
                                                                        null
                                                                    ? null
                                                                    : () async {
                                                                        setState(
                                                                            () {
                                                                          loadingItemIndex =
                                                                              index;
                                                                          quantityLoadingAction =
                                                                              'decrement';
                                                                        });

                                                                        bool
                                                                            minus =
                                                                            false;
                                                                        _cartData['is_add_to_cart'] =
                                                                            true;
                                                                        await _addToCartModel.getAddToCart(
                                                                            _addToCartModel.addToCarts![index].product!.id,
                                                                            minus,
                                                                            _cartData);
                                                                        setState(
                                                                            () {});
                                                                        await _validateAppliedCoupon();
                                                                        await _recalculateRewards();

                                                                        setState(
                                                                            () {
                                                                          loadingItemIndex =
                                                                              null;
                                                                          quantityLoadingAction =
                                                                              null;
                                                                        });
                                                                      },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(8.0
                                                                              .w),
                                                                  child: (loadingItemIndex ==
                                                                              index &&
                                                                          quantityLoadingAction ==
                                                                              'decrement')
                                                                      ? SizedBox(
                                                                          width:
                                                                              16.0.w,
                                                                          height:
                                                                              16.0.w,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            strokeWidth:
                                                                                2,
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(Color(0xFFEED056)),
                                                                          ),
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .remove,
                                                                          size: 18.0
                                                                              .sp,
                                                                          color:
                                                                              Colors.black87),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            12.0.w),
                                                                child: Text(
                                                                  _addToCartModel
                                                                      .addToCarts![
                                                                          index]
                                                                      .qty
                                                                      .toString(),
                                                                  style:
                                                                      MyGoogleFontStyle(
                                                                    fontFamily:
                                                                        'Urbanist',
                                                                    fontSize:
                                                                        14.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                              FutureBuilder<
                                                                  int>(
                                                                future: _getAvailableQty(
                                                                    _addToCartModel
                                                                            .addToCarts![
                                                                        index]),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  final currentQty =
                                                                      _addToCartModel
                                                                              .addToCarts![index]
                                                                              .qty ??
                                                                          0;
                                                                  final availableQty =
                                                                      snapshot.data ??
                                                                          0;

                                                                  debugPrint(
                                                                      'FutureBuilder: currentQty=$currentQty, availableQty=$availableQty, snapshot.hasData=${snapshot.hasData}');

                                                                  // Hide plus button if qty limit reached
                                                                  if (availableQty >
                                                                          0 &&
                                                                      currentQty >=
                                                                          availableQty) {
                                                                    debugPrint(
                                                                        'FutureBuilder: HIDING plus button (limit reached)');
                                                                    return SizedBox(
                                                                        width: 34.0
                                                                            .w); // Empty space to maintain layout
                                                                  }

                                                                  return InkWell(
                                                                    onTap: loadingItemIndex !=
                                                                            null
                                                                        ? null
                                                                        : () async {
                                                                            // Check available quantity before incrementing
                                                                            final cartItem =
                                                                                _addToCartModel.addToCarts![index];
                                                                            final currentQty =
                                                                                cartItem.qty ?? 0;

                                                                            setState(() {
                                                                              loadingItemIndex = index;
                                                                              quantityLoadingAction = 'increment';
                                                                            });

                                                                            // Fetch fresh product data with packs
                                                                            final productService =
                                                                                locator<ProductService>();
                                                                            final product =
                                                                                await productService.getProductById(cartItem.productId ?? 0);

                                                                            int availableQty =
                                                                                0;
                                                                            if (product != null &&
                                                                                product.productPacks != null &&
                                                                                product.productPacks!.isNotEmpty) {
                                                                              // Find the matching pack based on cart item's pack ID
                                                                              try {
                                                                                final matchingPack = product.productPacks!.firstWhere(
                                                                                  (pack) => pack.id.toString() == cartItem.pack,
                                                                                );
                                                                                availableQty = matchingPack.qty ?? 0;
                                                                              } catch (e) {
                                                                                // If no matching pack found, use first pack or product qty
                                                                                if (product.productPacks!.isNotEmpty) {
                                                                                  availableQty = product.productPacks!.first.qty ?? 0;
                                                                                } else {
                                                                                  availableQty = product.qty ?? 0;
                                                                                }
                                                                              }
                                                                            } else {
                                                                              // Fallback to product qty if no packs
                                                                              availableQty = cartItem.product?.qty ?? 0;
                                                                            }

                                                                            debugPrint('Increment check: current=$currentQty, available=$availableQty, pack=${cartItem.pack}');

                                                                            // Check if available quantity is set and if limit reached
                                                                            if (availableQty > 0 &&
                                                                                currentQty >= availableQty) {
                                                                              setState(() {
                                                                                loadingItemIndex = null;
                                                                                quantityLoadingAction = null;
                                                                              });
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(
                                                                                  content: Text('Maximum available quantity is $availableQty'),
                                                                                  backgroundColor: Colors.orange,
                                                                                  duration: Duration(seconds: 2),
                                                                                ),
                                                                              );
                                                                              return;
                                                                            }

                                                                            bool
                                                                                type =
                                                                                true;
                                                                            _cartData['is_add_to_cart'] =
                                                                                true;
                                                                            await _addToCartModel.getAddToCart(
                                                                                _addToCartModel.addToCarts![index].product!.id,
                                                                                type,
                                                                                _cartData);
                                                                            setState(() {});
                                                                            await _validateAppliedCoupon();
                                                                            await _recalculateRewards();

                                                                            setState(() {
                                                                              loadingItemIndex = null;
                                                                              quantityLoadingAction = null;
                                                                            });
                                                                          },
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets
                                                                          .all(8.0
                                                                              .w),
                                                                      child: (loadingItemIndex == index &&
                                                                              quantityLoadingAction ==
                                                                                  'increment')
                                                                          ? SizedBox(
                                                                              width: 16.0.w,
                                                                              height: 16.0.w,
                                                                              child: CircularProgressIndicator(
                                                                                strokeWidth: 2,
                                                                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEED056)),
                                                                              ),
                                                                            )
                                                                          : Icon(
                                                                              Icons.add,
                                                                              size: 18.0.sp,
                                                                              color: Colors.black87),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                        width: 1.0.sw - 50,
                        child: Column(
                          children: [
                            // if (couponValue == '')
                            // Show applied coupon if exists
                            if (usedCoupon.isNotEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Coupon Applied: $usedCoupon (RS $couponValue)',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff1e1e1e),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          usedCoupon = '';
                                          couponValue = 0;
                                          couponId = '';
                                          coupon = '';
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Color(0xffe3e3e3),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          'Remove',
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // Show form if no coupon
                            if (usedCoupon.isEmpty)
                              Form(
                                key: _formKey,
                                child: Row(children: [
                                  Expanded(
                                    flex: 8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                                      onTap: buttonLoading
                                          ? null
                                          : () async {
                                              setState(() {
                                                buttonLoading = true;
                                              });

                                              _formKey.currentState!.save();

                                              await _couponModel
                                                  .verifyCoupon(coupon);
                                              // print(_couponModel.coupons![0].minOrderValue);
                                              if (_couponModel.coupons !=
                                                      null &&
                                                  _couponModel
                                                      .coupons!.isNotEmpty) {
                                                final firstCoupon =
                                                    _couponModel.coupons![0];
                                                final cartTotal = int.parse(
                                                    _addToCartModel.cartTotal
                                                        .toString());

                                                // Check coupon usage count
                                                final orderModel =
                                                    Provider.of<OrderModel>(
                                                        context,
                                                        listen: false);
                                                final usageCount =
                                                    await orderModel
                                                        .getCouponUsageCount(
                                                            firstCoupon.id
                                                                .toString());

                                                if (firstCoupon.noPerUser !=
                                                        null &&
                                                    firstCoupon.noPerUser! >
                                                        0 &&
                                                    usageCount >=
                                                        firstCoupon
                                                            .noPerUser!) {
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
                                                          "Coupon Usage Limit Reached"),
                                                      content: Text(
                                                          "You have already used this coupon ${firstCoupon.noPerUser} time${firstCoupon.noPerUser! > 1 ? 's' : ''}. This is the maximum allowed per user."),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('Ok'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else if (firstCoupon
                                                        .minOrderValue! <
                                                    cartTotal) {
                                                  setState(() {
                                                    // Calculate item total (cart total without GST)
                                                    final itemTotal =
                                                        (cartTotal / 105) * 100;

                                                    // Check coupon type and calculate value accordingly
                                                    final couponType =
                                                        firstCoupon.type
                                                            ?.toLowerCase()
                                                            .trim();
                                                    final isPercentage =
                                                        couponType ==
                                                                'percentage' ||
                                                            couponType ==
                                                                'percent' ||
                                                            couponType == '%';

                                                    if (isPercentage) {
                                                      // Calculate percentage of item total
                                                      final percentageValue =
                                                          double.parse(firstCoupon
                                                                  .value
                                                                  .toString()) /
                                                              100;
                                                      couponValue = itemTotal *
                                                          percentageValue;
                                                    } else {
                                                      // Flat discount - use value directly
                                                      couponValue =
                                                          double.parse(
                                                              firstCoupon.value
                                                                  .toString());
                                                    }
                                                    couponId = firstCoupon.id
                                                        .toString();
                                                    usedCoupon = firstCoupon
                                                        .name
                                                        .toString();
                                                  });
                                                } else {
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
                                                        "Coupon Cannot Be Applied",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      content: Text(
                                                        "This coupon requires a minimum cart total of RS ${firstCoupon.minOrderValue.toString()}. Your current cart total is RS ${cartTotal.toString()}. Please add more items to use this coupon.",
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                              'Understood'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    title:
                                                        Text("Invalid coupon."),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }

                                              setState(() {
                                                buttonLoading = false;
                                              });
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
                                          child: buttonLoading
                                              ? SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Text(
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
                                try {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PromocodesPage()),
                                  );

                                  if (result != null &&
                                      result['name'] != null) {
                                    setState(() {
                                      buttonLoading = true;
                                    });

                                    await _couponModel
                                        .verifyCoupon(result['name']);

                                    if (_couponModel.coupons != null &&
                                        _couponModel.coupons!.isNotEmpty) {
                                      final firstCoupon =
                                          _couponModel.coupons![0];
                                      final cartTotal = int.parse(
                                          _addToCartModel.cartTotal.toString());

                                      // Check coupon usage count
                                      final orderModel =
                                          Provider.of<OrderModel>(context,
                                              listen: false);
                                      final usageCount =
                                          await orderModel.getCouponUsageCount(
                                              firstCoupon.id.toString());

                                      if (firstCoupon.noPerUser != null &&
                                          firstCoupon.noPerUser! > 0 &&
                                          usageCount >=
                                              firstCoupon.noPerUser!) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            title: Text(
                                                "Coupon Usage Limit Reached"),
                                            content: Text(
                                                "You have already used this coupon ${firstCoupon.noPerUser} time${firstCoupon.noPerUser! > 1 ? 's' : ''}. This is the maximum allowed per user."),
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
                                      } else if (firstCoupon.minOrderValue! <
                                          cartTotal) {
                                        // Combine all setState calls into one
                                        setState(() {
                                          usedCoupon =
                                              firstCoupon.name.toString();

                                          // Calculate item total (cart total without GST)
                                          final itemTotal =
                                              (cartTotal / 105) * 100;

                                          // Check coupon type and calculate value accordingly
                                          final couponType = firstCoupon.type
                                              ?.toLowerCase()
                                              .trim();
                                          final isPercentage =
                                              couponType == 'percentage' ||
                                                  couponType == 'percent' ||
                                                  couponType == '%';

                                          if (isPercentage) {
                                            // Calculate percentage of item total
                                            final percentageValue =
                                                double.parse(firstCoupon.value
                                                        .toString()) /
                                                    100;
                                            couponValue =
                                                itemTotal * percentageValue;
                                          } else {
                                            // Flat discount - use value directly
                                            couponValue = double.parse(
                                                firstCoupon.value.toString());
                                          }
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
                                              "Coupon Cannot Be Applied",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            content: Text(
                                              "This coupon requires a minimum cart total of RS ${firstCoupon.minOrderValue.toString()}. Your current cart total is RS ${cartTotal.toString()}. Please add more items to use this coupon.",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Understood'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('No valid coupon found'),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Error applying coupon: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }

                                setState(() {
                                  buttonLoading = false;
                                });
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
                                    height: 0.75.sh,
                                    // height: 480,
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
                                              onTap: () async {
                                                final result = await Navigator
                                                        .of(context)
                                                    .push(MaterialPageRoute(
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

                                                if (result != null &&
                                                    result['address'] != null) {
                                                  print(
                                                      'Received address from selection: ${result['address']}');
                                                  setState(() {
                                                    address =
                                                        UserAddress.fromJson(
                                                            result['address']);
                                                  });
                                                  print(
                                                      'Address ID after setting: ${address.id}');
                                                }
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
                                                onPressed: () async {
                                                  // _addToCartModel
                                                  // .cartTotal
                                                  final result = await Navigator
                                                          .of(context)
                                                      .push(MaterialPageRoute(
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

                                                  if (result != null &&
                                                      result['address'] !=
                                                          null) {
                                                    print(
                                                        'Received address from selection: ${result['address']}');
                                                    setState(() {
                                                      address =
                                                          UserAddress.fromJson(
                                                              result[
                                                                  'address']);
                                                    });
                                                    print(
                                                        'Address ID after setting: ${address.id}');
                                                  }
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
                                                              // SizedBox(
                                                              //   height: 50,
                                                              //   child:
                                                              //       Image.asset(
                                                              //     _payment[
                                                              //         'icon'],
                                                              //     height: 50,
                                                              //     width: 50,
                                                              //   ),
                                                              // ),
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
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context); // Close the dialog first

                                                            final result = await Navigator
                                                                    .of(context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            AddressPage(arguments: {
                                                                              'cartTotal': _addToCartModel.cartTotal.toString(),
                                                                              'cartItems': _addToCartModel.addToCarts,
                                                                              'couponValue': couponValue,
                                                                              'isAddress': true
                                                                            })));

                                                            if (result !=
                                                                    null &&
                                                                result['address'] !=
                                                                    null) {
                                                              print(
                                                                  'Received address from selection: ${result['address']}');
                                                              setState(() {
                                                                address = UserAddress
                                                                    .fromJson(
                                                                        result[
                                                                            'address']);
                                                              });
                                                              print(
                                                                  'Address ID after setting: ${address.id}');
                                                            }
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
                                          width: 1.0.sw - 50,
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
                                                      'Item total',
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
                                                        (((int.parse(_addToCartModel
                                                                    .cartTotal
                                                                    .toString()) /
                                                                105 *
                                                                100))
                                                            .toStringAsFixed(
                                                                2)),
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
                                                    'RS ${double.tryParse(_configModel.user?.companies?[0].deliveryCharges?.toString() ?? '0')?.toStringAsFixed(2) ?? '0'}',
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
                                              if (address.state ==
                                                  'Maharashtra')
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'SGST 2.5%',
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily:
                                                              'Urbanist',
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
                                                          (() {
                                                            // Calculate SGST using reverse calculation (2.5%)
                                                            int cartTotal = int.parse(
                                                                _addToCartModel
                                                                    .cartTotal
                                                                    .toString());
                                                            // Calculate GST on cart total after applying discounts
                                                            double
                                                                cartTotalAfterDiscounts =
                                                                cartTotal -
                                                                    couponValue -
                                                                    useWalletPoint;
                                                            // Calculate using new method: item total = cartTotalAfterDiscounts / 105 * 100
                                                            double itemTotal =
                                                                (cartTotalAfterDiscounts /
                                                                        105) *
                                                                    100;
                                                            // GST = Cart Total After Discounts - Item Total
                                                            double gstAmount =
                                                                cartTotalAfterDiscounts -
                                                                    itemTotal;
                                                            double sgstAmount =
                                                                gstAmount / 2;
                                                            // SGST fixed at 2.5% of original cart total
                                                            return sgstAmount
                                                                .toStringAsFixed(
                                                                    2);
                                                          }()),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff303030),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              if (address.state ==
                                                  'Maharashtra')
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              if (address.state ==
                                                  'Maharashtra')
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'CGST 2.5%',
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily:
                                                              'Urbanist',
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
                                                          (() {
                                                            // Calculate CGST using reverse calculation (2.5%)
                                                            int cartTotal = int.parse(
                                                                _addToCartModel
                                                                    .cartTotal
                                                                    .toString());
                                                            // Calculate GST on cart total after applying discounts
                                                            double
                                                                cartTotalAfterDiscounts =
                                                                cartTotal -
                                                                    couponValue -
                                                                    useWalletPoint;
                                                            // Calculate using new method: item total = cartTotalAfterDiscounts / 105 * 100
                                                            double itemTotal =
                                                                (cartTotalAfterDiscounts /
                                                                        105) *
                                                                    100;
                                                            // GST = Cart Total After Discounts - Item Total
                                                            double gstAmount =
                                                                cartTotalAfterDiscounts -
                                                                    itemTotal;
                                                            double cgstAmount =
                                                                gstAmount / 2;
                                                            // CGST fixed at 2.5% of original cart total
                                                            return cgstAmount
                                                                .toStringAsFixed(
                                                                    2);
                                                          }()),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff303030),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              if (address.state !=
                                                  'Maharashtra')
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'IGST 5%',
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily:
                                                              'Urbanist',
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
                                                          (() {
                                                            // Calculate IGST using reverse calculation (5%)
                                                            int cartTotal = int.parse(
                                                                _addToCartModel
                                                                    .cartTotal
                                                                    .toString());
                                                            // Calculate using new method: item total = cartTotal / 105 * 100
                                                            double
                                                                itemTotalCalc =
                                                                (cartTotal /
                                                                        105) *
                                                                    100;
                                                            // GST = Cart Total - Item Total
                                                            double gstAmount =
                                                                cartTotal -
                                                                    itemTotalCalc;
                                                            double igstAmount =
                                                                gstAmount; // For IGST states, IGST = full GST
                                                            return igstAmount
                                                                .toStringAsFixed(
                                                                    2);
                                                          }()),
                                                      // (5 *
                                                      //         int.parse(_addToCartModel
                                                      //             .cartTotal
                                                      //             .toString()) /
                                                      //         100)
                                                      // .toString(),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff303030),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              if (_configModel
                                                      .user
                                                      ?.companies?[0]
                                                      .packagingCharges !=
                                                  null)
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Packaging Charges',
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xff909090),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'RS ${_configModel.user?.companies?[0].packagingCharges!.toStringAsFixed(2)}',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff303030),
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
                                                        couponValue
                                                            .toStringAsFixed(2),
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
                                              // if (_userWaletModel
                                              //         .totaRemainingPoint !=
                                              //     0)
                                              SizedBox(
                                                height: 10,
                                              ),
                                              // if (_userWaletModel
                                              //         .totaRemainingPoint !=
                                              //     0)

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
                                                  if (useWalletPoint != 0)
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          useWalletPoint = 0;
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
                                                  if (useWalletPoint == 0)
                                                    InkWell(
                                                      onTap: () async {
                                                        await _userWaletModel
                                                            .getMyUserWallets();
                                                        setState(() {
                                                          // Calculate 25% of item total after coupon discount
                                                          final addToCartModel =
                                                              Provider.of<
                                                                      AddToCartModel>(
                                                                  context,
                                                                  listen:
                                                                      false);
                                                          final cartTotal =
                                                              int.parse(
                                                                  addToCartModel
                                                                      .cartTotal
                                                                      .toString());
                                                          // Calculate using new method: item total = cartTotal / 105 * 100
                                                          final itemTotal =
                                                              (cartTotal /
                                                                      105) *
                                                                  100;
                                                          // Item total is already calculated after discounts, so use it directly
                                                          final cartAfterCoupon =
                                                              itemTotal;

                                                          final calculatedPoints =
                                                              (cartAfterCoupon *
                                                                      0.25)
                                                                  .round();
                                                          final availablePoints =
                                                              _userWaletModel
                                                                  .totaRemainingPoint;
                                                          useWalletPoint =
                                                              calculatedPoints >
                                                                      availablePoints
                                                                  ? availablePoints
                                                                  : calculatedPoints;
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
                                                    'RS ${(useWalletPoint).toStringAsFixed(2)}',
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
                                                        (() {
                                                          // cartTotal already includes GST (Item Total + 5% GST)
                                                          int cartTotal = int.parse(
                                                              _addToCartModel
                                                                  .cartTotal
                                                                  .toString());

                                                          // Get delivery and packaging charges
                                                          double
                                                              deliveryCharges =
                                                              double.tryParse(_configModel
                                                                          .user
                                                                          ?.companies?[
                                                                              0]
                                                                          .deliveryCharges
                                                                          ?.toString() ??
                                                                      '0') ??
                                                                  0;
                                                          double
                                                              packagingCharges =
                                                              double.tryParse(_configModel
                                                                          .user
                                                                          ?.companies?[
                                                                              0]
                                                                          .packagingCharges
                                                                          ?.toString() ??
                                                                      '0') ??
                                                                  0;

                                                          // Total = Cart Total (includes GST) + Delivery + Packaging - Coupon - Rewards
                                                          double total = cartTotal +
                                                              deliveryCharges +
                                                              packagingCharges -
                                                              couponValue -
                                                              useWalletPoint;
                                                          return total
                                                              .toStringAsFixed(
                                                                  2);
                                                        }()),
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
                                                if (paymentOption == '') {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
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
                                                  var addressId = address.id;

                                                  // Calculate gstAmount before payment processing
                                                  int cartTotalForGst =
                                                      int.parse(_addToCartModel
                                                          .cartTotal
                                                          .toString());
                                                  double
                                                      cartTotalAfterDiscountsForGst =
                                                      cartTotalForGst -
                                                          couponValue -
                                                          useWalletPoint;
                                                  double itemTotalForGst =
                                                      (cartTotalAfterDiscountsForGst /
                                                              105) *
                                                          100;
                                                  double gstAmount =
                                                      cartTotalAfterDiscountsForGst -
                                                          itemTotalForGst;

                                                  // Payment processing

                                                  if (paymentOption ==
                                                      'UPI - Online') {
                                                    // Prepare payload data for the transaction
                                                    Map<String, dynamic>
                                                        payloadData = {
                                                      'cartItems':
                                                          _addToCartModel
                                                              .addToCarts!
                                                              .toList(),
                                                      'cartTotal':
                                                          _addToCartModel
                                                              .cartTotal
                                                              .toString(),
                                                      'addressId': addressId,
                                                      'isGift': isGift,
                                                      'useWalletPoint':
                                                          useWalletPoint,
                                                      'couponId':
                                                          couponId.toString(),
                                                      'deliveryMethod':
                                                          "deliveryMethod",
                                                      'couponValue': couponValue
                                                          .toString(),
                                                    };

                                                    // Add gstAmount to payloadData for online payment
                                                    payloadData['gstAmount'] =
                                                        gstAmount
                                                            .toStringAsFixed(2);

                                                    // Calculate the amount to be paid
                                                    double itemTotal =
                                                        itemTotalForGst;
                                                    double sgstAmount =
                                                        gstAmount / 2;
                                                    double cgstAmount =
                                                        gstAmount / 2;

                                                    int deliveryCharges = _configModel
                                                                .user!
                                                                .companies![0]
                                                                .deliveryCharges ==
                                                            null
                                                        ? 0
                                                        : int.parse(_configModel
                                                            .user!
                                                            .companies![0]
                                                            .deliveryCharges
                                                            .toString());
                                                    int packagingCharges = _configModel
                                                                .user!
                                                                .companies![0]
                                                                .packagingCharges ==
                                                            null
                                                        ? 0
                                                        : int.parse(_configModel
                                                            .user!
                                                            .companies![0]
                                                            .packagingCharges
                                                            .toString());

                                                    // Calculate total amount
                                                    double
                                                        amountAfterDiscounts =
                                                        itemTotal;
                                                    double taxAmount =
                                                        sgstAmount + cgstAmount;
                                                    double totalAmount =
                                                        amountAfterDiscounts +
                                                            deliveryCharges +
                                                            packagingCharges +
                                                            taxAmount;

                                                    int minumumPayable =
                                                        totalAmount.round();
                                                    String mobileNumber =
                                                        _configModel.user!.phone
                                                            .toString();

                                                    // Start PhonePe transaction
                                                    _startTransaction(
                                                        minumumPayable,
                                                        mobileNumber,
                                                        payloadData,
                                                        context);
                                                  } else {
                                                    // Cash on Delivery
                                                    bool response =
                                                        await _orderModel
                                                            .placedOrder(
                                                      _addToCartModel
                                                          .addToCarts!
                                                          .toList(),
                                                      _addToCartModel.cartTotal
                                                          .toString(),
                                                      addressId,
                                                      isGift,
                                                      useWalletPoint,
                                                      couponId.toString(),
                                                      'Cash on Delivery',
                                                      "deliveryMethod",
                                                      couponValue.toString(),
                                                      gstAmount
                                                          .toStringAsFixed(2),
                                                    );

                                                    if (response == true) {
                                                      Navigator.pushNamed(
                                                          context,
                                                          '/successPage');
                                                    }
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
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                fontSize: 16,
                                                color: Colors.red),
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
                                          width: 1.0.sw,
                                          height: 0.35.sh,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: _productModel
                                                        .productsLoader
                                                    ? Center(
                                                        child:
                                                            LinearProgressIndicator())
                                                    : (_productModel.allProducts ==
                                                                null ||
                                                            _productModel
                                                                .allProducts!
                                                                .isEmpty)
                                                        ? Center(
                                                            child: Text(
                                                              'No products available',
                                                              style:
                                                                  MyGoogleFontStyle(
                                                                fontFamily:
                                                                    'Urbanist',
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          )
                                                        : ListView.builder(
                                                            // padding:
                                                            //     const EdgeInsets.only(left: 5, right: 8),
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            shrinkWrap: true,
                                                            itemCount: _productModel
                                                                    .allProducts
                                                                    ?.length ??
                                                                0,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                child:
                                                                    Container(
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
                                                                        BorderRadius.circular(
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
                                                                              builder: (context) => ProductIdPage(arguments: {
                                                                                'product': _productModel.allProducts?[index].toJson(),
                                                                                'product_images': _productModel.allProducts?[index].productImages
                                                                              }),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              0.0.w,
                                                                              0.0.w,
                                                                              0.0.w,
                                                                              5.0.w),
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              106.0.w,
                                                                              13.0.w,
                                                                              14.0.w,
                                                                              15.0.w),
                                                                          width:
                                                                              0.4.sw,
                                                                          height:
                                                                              0.26.sh,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                            image:
                                                                                DecorationImage(
                                                                              fit: BoxFit.contain,
                                                                              image: NetworkImage(_configModel.apiConfig['mediaURL'] + ((_productModel.allProducts?[index].productImages?.isNotEmpty ?? false) ? _productModel.allProducts![index].productImages!.first.imagepath?.toString() ?? '' : '')),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              if (_configModel.user != null) {
                                                                                await _wishListModel.getWishLists(_productModel.allProducts?[index].id);
                                                                                setState(() {});
                                                                              } else {
                                                                                // Show login required dialog
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (context) => AlertDialog(
                                                                                    title: Text('Login Required'),
                                                                                    content: Text('Please login to add items to wishlist'),
                                                                                    actions: [
                                                                                      TextButton(
                                                                                        onPressed: () => Navigator.pop(context),
                                                                                        child: Text('OK'),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              }
                                                                            },
                                                                            child: _wishListModel.wishListLoader
                                                                                ? Align(alignment: Alignment.topRight, child: Icon(Icons.favorite_border_outlined))
                                                                                : _wishListModel.wishLists?.where((wishList) => wishList.productId == _productModel.allProducts?[index].id && wishList.userId == _configModel.user?.id).toList().length == 0
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
                                                                                    'product': _productModel.allProducts?[index].toJson(),
                                                                                    'category': _productModel.allProducts?[index].category?.name?.toString() ?? '',
                                                                                  })));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Text(
                                                                            _productModel.allProducts![index].name.toString(),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                MyGoogleFontStyle(
                                                                              fontFamily: 'Urbanist',
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Color(0xff000000),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child: ((_productModel.allProducts?[index].productPrices?.isNotEmpty ?? false) &&
                                                                                (_productModel.allProducts![index].productPrices![0].offerPrice ?? 0) != 0)
                                                                            ? Text.rich(TextSpan(children: [
                                                                                new TextSpan(
                                                                                  text: 'RS. ${_productModel.allProducts![index].productPrices![0].price?.toString() ?? '0'}',
                                                                                  style: new TextStyle(
                                                                                    color: Colors.grey,
                                                                                    decoration: TextDecoration.lineThrough,
                                                                                  ),
                                                                                ),
                                                                                new TextSpan(
                                                                                  text: ' RS.${_productModel.allProducts![index].productPrices![0].offerPrice?.toString() ?? '0'}',
                                                                                ),
                                                                              ]))
                                                                            : Text(
                                                                                (_productModel.allProducts?[index].productPrices?.isNotEmpty ?? false) ? (_productModel.allProducts![index].productPrices![0].price?.toString() ?? '0') + " " + 'RS' : '0 RS',
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
                                                                              fontFamily: 'Poppins',
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Color(0x99000000),
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
      ),
    );
  }
}

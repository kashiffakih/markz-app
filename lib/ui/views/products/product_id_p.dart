import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/product.dart';
import 'package:aadab/core/models/add_to_cart.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/core/providers/wish_list_pr.dart';
import 'package:aadab/core/services/product_s.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/checkout/cart_p.dart';
import 'package:aadab/ui/views/products/shops_p.dart';
import 'package:aadab/ui/widgets/image_zoom_w.dart';
import 'package:aadab/core/providers/product_notification_pr.dart';
import 'package:aadab/ui/widgets/login_required_popup.dart';
import 'package:aadab/ui/widgets/common_product_card.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'package:badges/badges.dart' as badges;

class ProductIdPage extends StatefulWidget {
  final arguments;

  const ProductIdPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<ProductIdPage> createState() => _ProductIdPageState();
}

class _ProductIdPageState extends State<ProductIdPage> {
  List<Map<String, dynamic>> _sizes = [];
  List<Map<String, dynamic>> _prices = [];
  List<dynamic> productDisplayImages = [];
  List<dynamic> updateProductDisplayImages = [];
  String unitName = '';
  String size = '';
  String _productPoints = '';
  int activeIndex = -1;
  int cartCount = 0;
  double discountPrice = 0.0;
  bool _isLoading = true;
  String? _errorMessage;
  int currentPackQty = 0;
  Map<String, dynamic>? _freshProductData; // Fresh product data from API
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  Map<String, dynamic> _cartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': '',
    'is_add_to_cart': false
  };

  void _sortSizesList(List<Map<String, dynamic>> list) {
    list.sort((a, b) {
      final valA = a['value']?.toString().trim() ?? '';
      final valB = b['value']?.toString().trim() ?? '';

      // Extract number from value string if present (e.g. '6', '28', '38 (L)', 'Size 7')
      double? extractNum(String str) {
        final match = RegExp(r'\d+(\.\d+)?').firstMatch(str);
        if (match != null) {
          return double.tryParse(match.group(0)!);
        }
        return null;
      }

      final numA = extractNum(valA);
      final numB = extractNum(valB);

      if (numA != null && numB != null) {
        if (numA != numB) {
          return numA.compareTo(numB);
        }
      }

      // Standard clothing/shoe sizes ranking
      final sizeOrder = {
        'XXS': 1,
        'XS': 2,
        'S': 3,
        'M': 4,
        'L': 5,
        'XL': 6,
        'XXL': 7,
        '2XL': 7,
        'XXXL': 8,
        '3XL': 8,
        '4XL': 9,
        '5XL': 10,
        'FREE SIZE': 100,
      };

      final rankA = sizeOrder[valA.toUpperCase()];
      final rankB = sizeOrder[valB.toUpperCase()];

      if (rankA != null && rankB != null) {
        return rankA.compareTo(rankB);
      } else if (rankA != null) {
        return -1;
      } else if (rankB != null) {
        return 1;
      }

      if (numA != null) return -1;
      if (numB != null) return 1;

      return valA.compareTo(valB);
    });
  }

  // Global keys for description sections to maintain state
  final _smallDescKey = GlobalKey();
  final _descKey = GlobalKey();
  final _desc1Key = GlobalKey();
  final _desc2Key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  // Helper method to get product data (fresh from API or from arguments)
  Map<String, dynamic> get _productData =>
      _freshProductData ?? widget.arguments!['product'];

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final configModel = locator<ConfigModel>();
    final productId = widget.arguments!['product']['id'];
    final addToCartModel = context.read<AddToCartModel>();
    final wishListModel = context.read<WishListModel>();
    final productModel = context.read<ProductModel>();
    final productService = locator<ProductService>();

    await Future.wait<void>([
      // Fetch fresh product data from API in parallel
      productService.getProductById(productId).then((freshProduct) {
        if (freshProduct != null) {
          _freshProductData = freshProduct.toJson();
        }
      }).catchError((e) {
        debugPrint('Error fetching fresh product data: $e');
      }),

      if (configModel.user != null)
        addToCartModel.getAddToCart(productId, '', _cartData),
      if (configModel.user != null) wishListModel.getWishLists(''),
    ]);

    // Fetch related products in background
    productModel
        .getCategoryWiseProduct(_productData['category_id'] ?? '', '')
        .catchError((e) {
      debugPrint('Error fetching category wise product: $e');
    });

    setState(() {
      _initializeProductData();
      _isLoading = false;
    });
  }

  void _initializeProductData() {
    // Use fresh product images if available, otherwise fall back to arguments
    final freshImages = _productData['product_images'];
    if (freshImages != null && freshImages is List && freshImages.isNotEmpty) {
      productDisplayImages = freshImages;
    } else {
      productDisplayImages =
          widget.arguments?['product_images']?.toList() ?? [];
    }

    // Get all product packs from fresh data
    final allPacks = _productData['product_packs'] ?? [];

    // Initialize unitName from product images or first pack
    if (productDisplayImages.isNotEmpty) {
      // Handle both Map and object types for product images
      final firstImage = productDisplayImages[0];
      if (firstImage is Map) {
        unitName = firstImage['unit']?['name']?.toString() ?? '';
      } else {
        unitName = firstImage.unit?.name ?? '';
      }
      _cartData['flavour'] = unitName;
    } else if (allPacks.isNotEmpty) {
      // If no product images, use the first pack's unit
      unitName = allPacks[0]['unit']?['name']?.toString() ?? '';
      _cartData['flavour'] = unitName;
    }

    // Filter sizes by unitName, or use all packs if unitName is empty
    _sizes = unitName.isNotEmpty
        ? allPacks.where((pack) => pack['unit']?['name'] == unitName).toList()
        : allPacks.toList();

    _sortSizesList(_sizes);

    if (_sizes.isNotEmpty) {
      _cartData['kindOfFlower'] = _sizes[0]['value']?.toString() ?? '';
      _cartData['pack'] = _sizes[0]['id']?.toString() ?? '';
      size = _sizes[0]['value']?.toString() ?? '';
      _productPoints = _sizes[0]['points']?.toString() ?? '';
      activeIndex = 0; // Pre-select the first size
      currentPackQty =
          _sizes[0]['qty'] ?? 0; // Initialize quantity from fresh data

      // Get prices for the selected pack from fresh data
      _prices = _productData['product_prices']
              ?.where((price) => price['product_pack_id'] == _sizes[0]['id'])
              ?.toList() ??
          [];

      if (_prices.isNotEmpty) {
        final effective = _getEffectivePrices(_prices[0]);
        final price = effective['price']!;
        final offerPrice = effective['offer_price']!;

        if (price > 0 && offerPrice > 0 && offerPrice < price) {
          discountPrice = ((price - offerPrice) / price * 100);
        }
      }
    }

    cartCount = context.read<AddToCartModel>().addToCarts?.length ?? 0;
  }

  Map<String, double> _getEffectivePrices(Map<String, dynamic> priceData) {
    final configModel = context.read<ConfigModel>();
    final isDistributor = configModel.activeRole == 'Distributor';

    double price = 0;
    double offerPrice = 0;

    if (isDistributor) {
      double? distPrice =
          double.tryParse(priceData['distributor_price']?.toString() ?? '');
      double? distOfferPrice = double.tryParse(
          priceData['distributor_offer_price']?.toString() ?? '');

      if (distPrice != null && distPrice > 0) {
        price = distPrice;
        if (distOfferPrice != null && distOfferPrice > 0) {
          offerPrice = distOfferPrice;
        }
      }
    } else {
      price = double.tryParse(priceData['price']?.toString() ?? '0') ?? 0;
      offerPrice =
          double.tryParse(priceData['offer_price']?.toString() ?? '0') ?? 0;
    }

    return {'price': price, 'offer_price': offerPrice};
  }

  int _getTotalReviewsCount(Product? product) {
    if (product == null) return 0;

    // Count reviews from product packs only
    int packReviews = 0;
    if (product.productPacks != null) {
      for (var pack in product.productPacks!) {
        packReviews += pack.reviews?.length ?? 0;
      }
    }

    // Use totalReviews if available from API, otherwise calculate
    return product.totalReviews ?? packReviews;
  }

  void _handleNotifyMe() async {
    final ProductNotificationModel _notificationModel =
        context.read<ProductNotificationModel>();
    final _configModel = locator<ConfigModel>();
    final _qtyController = TextEditingController(text: "1");
    // Form key for validation
    final _notifyFormKey = GlobalKey<FormState>();

    // Check if user is logged in
    if (_configModel.user == null) {
      showDialog(
        context: context,
        builder: (context) => LoginRequiredPopupWidget(),
      );
      return;
    }

    // Input Dialog
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0.r)),
        title: Text('Notify me when available',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How many quantity required?',
                style: TextStyle(fontSize: 14.sp)),
            SizedBox(height: 10.h),
            Form(
              key: _notifyFormKey,
              child: TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Qty',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter qty';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Invalid qty';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFC7B456),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (_notifyFormKey.currentState!.validate()) {
                Navigator.pop(dialogContext); // Close input dialog

                int qty = int.parse(_qtyController.text);
                int productId = widget.arguments!['product']['id'];
                int productPackId = int.tryParse(_cartData['pack'] ?? '0') ?? 0;

                if (productPackId == 0 && _sizes.isNotEmpty) {
                  productPackId = _sizes[0]['id'] ?? 0;
                }

                // Call provider method
                final result = await _notificationModel.storeNotification(
                  productId: productId,
                  productPackId: productPackId,
                  qty: qty,
                );

                if (mounted) {
                  if (result['success']) {
                    // Success "Thank You" Popup
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0.r)),
                        title: Text('Thank You',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp)),
                        content: Text(
                            'We will notify you when this product is back in stock.',
                            style: TextStyle(fontSize: 14.sp)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK',
                                style: TextStyle(
                                    color: Color(0xFFC7B456),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp)),
                          )
                        ],
                      ),
                    );
                  } else {
                    // Error Popup
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0.r)),
                        title: Text('Error',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp)),
                        content: Text(result['message'],
                            style: TextStyle(fontSize: 14.sp)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK',
                                style: TextStyle(
                                    color: Color(0xFFC7B456),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp)),
                          )
                        ],
                      ),
                    );
                  }
                }
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configModel = locator<ConfigModel>();
    final productModel = context.watch<ProductModel>();
    final addToCartModel = context.watch<AddToCartModel>();
    final wishListModel = context.watch<WishListModel>();

    // Use fresh product data from API if available
    final product = _freshProductData != null
        ? Product.fromJson(_freshProductData!)
        : (widget.arguments?['product'] != null
            ? Product.fromJson(widget.arguments!['product'])
            : null);

    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFEF9),
                Color(0xFFFFFDF7),
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              width: 1.0.sw,
              height: 1.0.sh,
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
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
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
                      'Loading Product...',
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
          ),
        ),
      );
    }

    if (_errorMessage != null || product == null) {
      return Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: 1.0.sw,
            height: 1.0.sh,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage ?? 'Product data not available.',
                    style: const TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 16.0.w),
                  ElevatedButton(
                    onPressed: _fetchInitialData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final disImages = updateProductDisplayImages.isNotEmpty
        ? updateProductDisplayImages
        : productDisplayImages;
    final imageProduct = [
      if (disImages.isNotEmpty) ...[
        disImages[0].imagepath?.toString() ?? '',
        disImages[0].imagepath2?.toString() ?? '',
        disImages[0].imagepath3?.toString() ?? '',
        disImages[0].imagepath4?.toString() ?? '',
      ]
    ].where((img) => img.isNotEmpty).toList();

    final PageController sliderController = PageController();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFEF9),
              Color(0xFFFFFDF7),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _fetchInitialData,
            child: SingleChildScrollView(
              child: Container(
                width: 1.0.sw,
                constraints: BoxConstraints(minHeight: 1.0.sh),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFEED056),
                              Color(0xFFF6E27F),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.r),
                            bottomRight: Radius.circular(30.r),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 25.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.arrow_back_ios_new,
                                      size: 16.0.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.0.w),
                                Text(
                                  'Product Details',
                                  textAlign: TextAlign.center,
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 20.0.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12.0.w),
                                InkWell(
                                  onTap: () {
                                    if (configModel.user == null) {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            LoginRequiredPopupWidget(),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CartPage(
                                              isProfile: {'isProfile': false}),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10.0.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: badges.Badge(
                                      badgeContent: Text(
                                        cartCount.toString(),
                                        style: TextStyle(
                                          color: Color(0xFFEED056),
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      badgeStyle: badges.BadgeStyle(
                                        badgeColor: Colors.white,
                                        padding: EdgeInsets.all(6),
                                      ),
                                      child: Icon(
                                        Icons.shopping_cart_outlined,
                                        size: 20.0.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30.0.w),
                            Container(
                              height: 45.0.w,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0.w, vertical: 4.0.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Color(0xFF909090),
                                    size: 20.0.sp,
                                  ),
                                  SizedBox(width: 10.0.w),
                                  Expanded(
                                    child: TextFormField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      controller: _searchController,
                                      onChanged: (value) {
                                        if (_debounce?.isActive ?? false)
                                          _debounce!.cancel();
                                        _debounce = Timer(
                                            const Duration(milliseconds: 500),
                                            () {
                                          if (value.length % 3 == 0 &&
                                              value.isNotEmpty) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ShopsPage(
                                                    initialText: value),
                                              ),
                                            );
                                          }
                                        });
                                      },
                                      decoration: InputDecoration(
                                        isCollapsed: true,
                                        hintText: 'Search products...',
                                        hintStyle: TextStyle(
                                          color: Color(0xFFAAAAAA),
                                          fontSize: 14.0.sp,
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: TextStyle(
                                        color: Color(0xff232323),
                                        fontSize: 14.0.sp,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0.h),

                      // Product Content
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image Slider
                            Stack(
                              children: [
                                SizedBox(
                                  width: 1.0.sw,
                                  height: 350.0.w,
                                  child: imageProduct.isEmpty
                                      ? const Center(
                                          child: Text('No images available'))
                                      : PageView.builder(
                                          itemCount: imageProduct.length,
                                          controller: sliderController,
                                          pageSnapping: true,
                                          itemBuilder: (context, pagePosition) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageScreen(
                                                      image:
                                                          '${configModel.apiConfig['mediaURL']}${imageProduct[pagePosition]}',
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Image.network(
                                                '${configModel.apiConfig['mediaURL']}${imageProduct[pagePosition]}',
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(Icons.error),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                                Positioned(
                                  top: 16.0.w,
                                  right: 16.0.w,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (configModel.user == null) {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  LoginRequiredPopupWidget(),
                                            );
                                          } else {
                                            await wishListModel.getWishLists(
                                                widget.arguments!['product']
                                                    ['id']);
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10.0.w),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.95),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFFEED056)
                                                    .withOpacity(0.2),
                                                blurRadius: 12,
                                                offset: Offset(0, 4),
                                              ),
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.08),
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: wishListModel.wishListLoader
                                              ? SizedBox(
                                                  width: 20.0.sp,
                                                  height: 20.0.sp,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Color(0xFFEED056)),
                                                  ),
                                                )
                                              : Icon(
                                                  wishListModel.wishLists?.any((wishList) =>
                                                              wishList.productId ==
                                                                  widget.arguments![
                                                                          'product']
                                                                      ['id'] &&
                                                              wishList.userId ==
                                                                  configModel
                                                                      .user
                                                                      ?.id) ??
                                                          false
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: wishListModel.wishLists?.any((wishList) =>
                                                              wishList.productId ==
                                                                  widget.arguments![
                                                                          'product']
                                                                      ['id'] &&
                                                              wishList.userId ==
                                                                  configModel
                                                                      .user
                                                                      ?.id) ??
                                                          false
                                                      ? Colors.red
                                                      : Color(0xFF909090),
                                                  size: 22.0.sp,
                                                ),
                                        ),
                                      ),
                                      SizedBox(width: 12.0.w),
                                      InkWell(
                                        onTap: () {
                                          Share.share(
                                            'Check out this product: ${product.name ?? ''}\n\nDescription: ${product.description ?? ''}\n\nLink: ${configModel.apiConfig['mediaURL']}${product.imagepath1 ?? ''}',
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10.0.w),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.95),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFFEED056)
                                                    .withOpacity(0.2),
                                                blurRadius: 12,
                                                offset: Offset(0, 4),
                                              ),
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.08),
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.share,
                                            color: Color(0xFF232323),
                                            size: 22.0.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 325.0.w,
                                  child: Container(
                                    width: 1.0.sw,
                                    height: 41.0.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0.w),
                                        topRight: Radius.circular(30.0.w),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0.w),
                                child: SmoothPageIndicator(
                                  controller: sliderController,
                                  count: imageProduct.length,
                                  effect: ExpandingDotsEffect(
                                    dotHeight: 6.0.w,
                                    dotWidth: 6.0.w,
                                    activeDotColor: Color(0xFFC7B456),
                                    dotColor: Color(0xFFE0E0E0),
                                    expansionFactor: 4,
                                    spacing: 6.0.w,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0.w),
                            // Thumbnail Images
                            SizedBox(
                              height: 90.0.w,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.0.w),
                                itemCount: productDisplayImages.length,
                                itemBuilder: (context, index) {
                                  final imageItem = productDisplayImages[index];
                                  String? name;
                                  String? imagePath;

                                  if (imageItem is Map) {
                                    name =
                                        imageItem['unit']?['name']?.toString();
                                    imagePath = imageItem['imagepath'];
                                  } else {
                                    name = (imageItem as dynamic)
                                        .unit
                                        ?.name
                                        ?.toString();
                                    imagePath =
                                        (imageItem as dynamic).imagepath;
                                  }

                                  final isSelected = unitName == name;

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        unitName = name ?? '';
                                        _cartData['flavour'] = unitName;

                                        // Helper for filtering logic
                                        bool filterImage(dynamic img) {
                                          String? n;
                                          if (img is Map) {
                                            n = img['unit']?['name']
                                                ?.toString();
                                          } else {
                                            n = (img as dynamic)
                                                .unit
                                                ?.name
                                                ?.toString();
                                          }
                                          return n == unitName;
                                        }

                                        updateProductDisplayImages = widget
                                                .arguments?['product_images']
                                                ?.where(filterImage)
                                                .toList() ??
                                            [];

                                        _sizes = widget.arguments?['product']
                                                    ?['product_packs']
                                                ?.where((pack) =>
                                                    pack['unit']?['name'] ==
                                                    unitName)
                                                ?.toList() ??
                                            [];
                                        _sortSizesList(_sizes);
                                        activeIndex = 0;
                                        _cartData['kindOfFlower'] = _sizes
                                                .isNotEmpty
                                            ? _sizes[0]['value']?.toString() ??
                                                ''
                                            : '';
                                        _cartData['pack'] = _sizes.isNotEmpty
                                            ? _sizes[0]['id']?.toString() ?? ''
                                            : '';
                                        currentPackQty = _sizes.isNotEmpty
                                            ? _sizes[0]['qty'] ?? 0
                                            : 0;
                                        _prices = widget.arguments?['product']
                                                    ?['product_prices']
                                                ?.where((price) =>
                                                    price['product_pack_id'] ==
                                                    _sizes[0]['id'])
                                                ?.toList() ??
                                            [];
                                        _productPoints = _sizes.isNotEmpty
                                            ? _sizes[0]['points']?.toString() ??
                                                ''
                                            : '';

                                        discountPrice = 0.0;
                                        if (_prices.isNotEmpty) {
                                          final effective =
                                              _getEffectivePrices(_prices[0]);
                                          final price = effective['price']!;
                                          final offerPrice =
                                              effective['offer_price']!;

                                          if (price > 0 &&
                                              offerPrice > 0 &&
                                              offerPrice < price) {
                                            discountPrice =
                                                ((price - offerPrice) /
                                                    price *
                                                    100);
                                          }
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 12.0.w),
                                      width: 70.0.w,
                                      height: 90.0.w,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        border: isSelected
                                            ? Border.all(
                                                color: Color(0xFFC7B456),
                                                width: 2.0.w)
                                            : Border.all(
                                                color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(12.0.w),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: Color(0xFFEED056)
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 4),
                                                )
                                              ]
                                            : [],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(9.0.w),
                                        child: imagePath != null
                                            ? Image.network(
                                                '${configModel.apiConfig['mediaURL']}$imagePath',
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(Icons.error),
                                              )
                                            : const Center(
                                                child: Text('No Image')),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            // Product Details
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name ?? 'Unnamed Product',
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Urbanist',
                                                fontSize: 19.0.sp,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xff000000),
                                              ),
                                            ),
                                            SizedBox(height: 8.0.w),
                                            Row(
                                              children: [
                                                if (product.rating != null &&
                                                    product.rating != '0')
                                                  RatingBar.builder(
                                                    itemSize: 15.0.sp,
                                                    initialRating:
                                                        double.tryParse(product
                                                                    .rating ??
                                                                '0.0') ??
                                                            0.0,
                                                    direction: Axis.horizontal,
                                                    itemCount: 5,
                                                    allowHalfRating: true,
                                                    ignoreGestures: true,
                                                    itemBuilder: (context, _) =>
                                                        const Icon(Icons.star,
                                                            color:
                                                                Colors.amber),
                                                    onRatingUpdate:
                                                        (double value) {},
                                                  ),
                                                Text(
                                                  '(${_getTotalReviewsCount(product)} Review${_getTotalReviewsCount(product) == 1 ? '' : 's'})',
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 10.0.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xff000000),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.w),
                                            // [MOVED PRICE SECTION]
                                            Builder(builder: (context) {
                                              final effective =
                                                  _prices.isNotEmpty
                                                      ? _getEffectivePrices(
                                                          _prices[0])
                                                      : {
                                                          'price': 0.0,
                                                          'offer_price': 0.0
                                                        };
                                              final price = effective['price'];
                                              final offerPrice =
                                                  effective['offer_price'];

                                              return (price != null &&
                                                      price > 0 &&
                                                      offerPrice != null &&
                                                      offerPrice > 0 &&
                                                      offerPrice < price)
                                                  ? Wrap(
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          '₹$offerPrice',
                                                          style:
                                                              MyGoogleFontStyle(
                                                            fontFamily:
                                                                'Urbanist',
                                                            fontSize: 24.0.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(width: 8.w),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 4.h),
                                                          child: Text(
                                                            '₹$price',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[500],
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              fontSize: 14.0.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        if (discountPrice !=
                                                            0.0) ...[
                                                          SizedBox(width: 8.w),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        6.w,
                                                                    vertical:
                                                                        2.h),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        4.h),
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      0xFF4CAF50),
                                                                  Color(
                                                                      0xFF388E3C)
                                                                ],
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.r),
                                                            ),
                                                            child: Text(
                                                              '${discountPrice.round()}% OFF',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    10.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    )
                                                  : Text(
                                                      (price != null &&
                                                              price > 0)
                                                          ? '₹$price'
                                                          : 'Price not available',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontSize: 24.0.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    );
                                            }),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 20.0.w),
                                      Column(
                                        children: [
                                          if (_prices.isNotEmpty &&
                                              ((_getEffectivePrices(_prices[0])[
                                                          'price'] ??
                                                      0) >
                                                  0) &&
                                              (addToCartModel.addToCarts
                                                      ?.where((cart) =>
                                                          cart.productId ==
                                                              widget.arguments![
                                                                      'product']
                                                                  ['id'] &&
                                                          cart.flavour ==
                                                              unitName &&
                                                          cart.kindOfFlower ==
                                                              size)
                                                      .isEmpty ??
                                                  true) &&
                                              currentPackQty > 0)
                                            TextButton(
                                              onPressed: () async {
                                                if (configModel.user == null) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        LoginRequiredPopupWidget(),
                                                  );
                                                } else if (_cartData[
                                                        'kindOfFlower'] ==
                                                    '') {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0.w)),
                                                      title: const Text(
                                                          'Kindly choose a size.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text(
                                                            'Ok',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    16.0.sp),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else if (_cartData[
                                                        'flavour'] ==
                                                    '') {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0.w)),
                                                      title: const Text(
                                                          'Kindly choose a colour.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text(
                                                            'Ok',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    16.0.sp),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  _cartData['points'] =
                                                      _productPoints;

                                                  // Set product price safely
                                                  if (_prices.isNotEmpty) {
                                                    final effective =
                                                        _getEffectivePrices(
                                                            _prices[0]);
                                                    final offerPrice =
                                                        effective[
                                                            'offer_price'];
                                                    final price =
                                                        effective['price'];

                                                    _cartData['product_price'] =
                                                        (offerPrice != null &&
                                                                offerPrice != 0)
                                                            ? offerPrice
                                                                .toString()
                                                            : (price?.toString() ??
                                                                '0');
                                                  } else {
                                                    _cartData['product_price'] =
                                                        '0';
                                                  }
                                                  _cartData['is_add_to_cart'] =
                                                      true;

                                                  // print(
                                                  //     'Check Add cart $_cartData');
                                                  await addToCartModel
                                                      .getAddToCart(
                                                          widget.arguments![
                                                              'product']['id'],
                                                          true,
                                                          _cartData);
                                                  setState(() {
                                                    cartCount = addToCartModel
                                                            .addToCarts
                                                            ?.length ??
                                                        0;
                                                  });
                                                }
                                              },
                                              style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero),
                                              child: Container(
                                                width: 90.0.w,
                                                height: 36.0.w,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFFEED056),
                                                      Color(0xFFC7B456),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0.r),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFFEED056)
                                                          .withOpacity(0.4),
                                                      offset:
                                                          const Offset(0, 4),
                                                      blurRadius: 12,
                                                    ),
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      offset:
                                                          const Offset(0, 2),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'ADD',
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Urbanist',
                                                      fontSize: 13.0.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (_prices.isNotEmpty &&
                                              ((_getEffectivePrices(_prices[0])[
                                                          'price'] ??
                                                      0) >
                                                  0) &&
                                              (addToCartModel.addToCarts
                                                      ?.where((cart) =>
                                                          cart.productId ==
                                                              widget.arguments![
                                                                      'product']
                                                                  ['id'] &&
                                                          cart.flavour ==
                                                              unitName &&
                                                          cart.kindOfFlower ==
                                                              size)
                                                      .isNotEmpty ??
                                                  false) &&
                                              currentPackQty > 0)
                                            Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () async {
                                                    if (_cartData[
                                                                'kindOfFlower'] ==
                                                            '' ||
                                                        _cartData['flavour'] ==
                                                            '') {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0.w)),
                                                          title: Text(
                                                            _cartData['kindOfFlower'] ==
                                                                        '' &&
                                                                    _cartData[
                                                                            'flavour'] !=
                                                                        ''
                                                                ? 'Kindly choose size.'
                                                                : _cartData['flavour'] ==
                                                                            '' &&
                                                                        _cartData['kindOfFlower'] !=
                                                                            ''
                                                                    ? 'Kindly choose colour.'
                                                                    : 'Kindly choose colour and size.',
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Text(
                                                                'Ok',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0.sp),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      _cartData[
                                                              'is_add_to_cart'] =
                                                          true;
                                                      await addToCartModel
                                                          .getAddToCart(
                                                              widget.arguments![
                                                                      'product']
                                                                  ['id'],
                                                              false,
                                                              _cartData);
                                                      setState(() {
                                                        cartCount =
                                                            addToCartModel
                                                                    .addToCarts
                                                                    ?.length ??
                                                                0;
                                                      });
                                                    }
                                                  },
                                                  style: TextButton.styleFrom(
                                                      padding: EdgeInsets.zero),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.all(6.0.w),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Color(0xFFEED056)
                                                            .withOpacity(0.5),
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0.r),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Color(0xFFEED056)
                                                                  .withOpacity(
                                                                      0.15),
                                                          blurRadius: 8,
                                                          offset: Offset(0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Icon(Icons.remove,
                                                        color:
                                                            Color(0xFF232323),
                                                        size: 18.0.sp),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0.w),
                                                  child: Builder(
                                                    builder: (context) {
                                                      final currentCartQty =
                                                          addToCartModel
                                                                  .addToCarts
                                                                  ?.firstWhere(
                                                                    (cart) =>
                                                                        cart.productId ==
                                                                            widget.arguments!['product'][
                                                                                'id'] &&
                                                                        cart.flavour ==
                                                                            unitName &&
                                                                        cart.kindOfFlower ==
                                                                            size,
                                                                    orElse: () =>
                                                                        AddToCartModel()
                                                                            .addToCarts!
                                                                            .first,
                                                                  )
                                                                  .qty ??
                                                              0;
                                                      return Text(
                                                        currentCartQty
                                                            .toString(),
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 14.0.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color(
                                                              0xff1e1e1e),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Builder(
                                                  builder: (context) {
                                                    final currentCartQty =
                                                        addToCartModel
                                                                .addToCarts
                                                                ?.firstWhere(
                                                                  (cart) =>
                                                                      cart.productId ==
                                                                          widget.arguments!['product']
                                                                              [
                                                                              'id'] &&
                                                                      cart.flavour ==
                                                                          unitName &&
                                                                      cart.kindOfFlower ==
                                                                          size,
                                                                  orElse: () =>
                                                                      AddToCartModel()
                                                                          .addToCarts!
                                                                          .first,
                                                                )
                                                                .qty ??
                                                            0;

                                                    // Hide plus button when current quantity reaches available stock
                                                    if (currentCartQty >=
                                                        currentPackQty) {
                                                      return SizedBox.shrink();
                                                    }

                                                    return TextButton(
                                                      onPressed: () async {
                                                        if (_cartData[
                                                                    'kindOfFlower'] ==
                                                                '' ||
                                                            _cartData[
                                                                    'flavour'] ==
                                                                '') {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0.w)),
                                                              title: Text(
                                                                _cartData['kindOfFlower'] ==
                                                                            '' &&
                                                                        _cartData['flavour'] !=
                                                                            ''
                                                                    ? 'Kindly choose size.'
                                                                    : _cartData['flavour'] ==
                                                                                '' &&
                                                                            _cartData['kindOfFlower'] !=
                                                                                ''
                                                                        ? 'Kindly choose colour.'
                                                                        : 'Kindly choose colour and size.',
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  child: Text(
                                                                    'Ok',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16.0.sp),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        } else {
                                                          _cartData[
                                                                  'is_add_to_cart'] =
                                                              true;
                                                          await addToCartModel
                                                              .getAddToCart(
                                                                  widget.arguments![
                                                                          'product']
                                                                      ['id'],
                                                                  true,
                                                                  _cartData);
                                                          setState(() {
                                                            cartCount = addToCartModel
                                                                    .addToCarts
                                                                    ?.length ??
                                                                0;
                                                          });
                                                        }
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero),
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            6.0.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Color(0xFFEED056),
                                                              Color(0xFFC7B456),
                                                            ],
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0.r),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Color(
                                                                      0xFFEED056)
                                                                  .withOpacity(
                                                                      0.3),
                                                              blurRadius: 8,
                                                              offset:
                                                                  Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Icon(Icons.add,
                                                            color: Colors.white,
                                                            size: 18.0.sp),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          currentPackQty > 0
                                              ? Text(
                                                  'Available in stock ($currentPackQty)',
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 12.0.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        const Color(0xff000000),
                                                  ),
                                                )
                                              : Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: _handleNotifyMe,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    12.w,
                                                                vertical: 6.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Color(0xFFEED056),
                                                              Color(0xFFC7B456),
                                                            ],
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.r),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              blurRadius: 4,
                                                              offset:
                                                                  Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .notifications_active_outlined,
                                                              size: 14.sp,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(
                                                                width: 5.w),
                                                            Text(
                                                              'Notify Me',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Text(
                                                      'Out of Stock',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Urbanist',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // Size Selection
                                  Padding(
                                    padding: EdgeInsets.only(
                                        // left: 25.0.w,
                                        top: 15.0.w,
                                        bottom: 5.0.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Size',
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 16.0.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff000000),
                                          ),
                                        ),
                                        SizedBox(height: 10.0.w),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 8,
                                              child: SizedBox(
                                                height: 45.0.w,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  // padding: EdgeInsets.symmetric(
                                                  //     horizontal: 5.0.w),
                                                  itemCount: _sizes.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final isActive =
                                                        index == activeIndex;
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  5.0.w),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            activeIndex = index;
                                                            _cartData[
                                                                'kindOfFlower'] = _sizes[
                                                                            index]
                                                                        [
                                                                        'value']
                                                                    ?.toString() ??
                                                                '';
                                                            _cartData[
                                                                'pack'] = _sizes[
                                                                            index]
                                                                        ['id']
                                                                    ?.toString() ??
                                                                '';
                                                            size = _sizes[index]
                                                                        [
                                                                        'value']
                                                                    ?.toString() ??
                                                                '';
                                                            currentPackQty =
                                                                _sizes[index][
                                                                        'qty'] ??
                                                                    0;
                                                            _prices = widget
                                                                    .arguments?[
                                                                        'product']
                                                                        ?[
                                                                        'product_prices']
                                                                    ?.where((price) =>
                                                                        price[
                                                                            'product_pack_id'] ==
                                                                        _sizes[index]
                                                                            [
                                                                            'id'])
                                                                    ?.toList() ??
                                                                [];
                                                            _productPoints = widget
                                                                    .arguments?[
                                                                        'product']
                                                                        ?[
                                                                        'product_packs']
                                                                    ?.where((pack) =>
                                                                        pack[
                                                                            'id'] ==
                                                                        _sizes[index]
                                                                            [
                                                                            'id'])
                                                                    ?.toList()[
                                                                        0][
                                                                        'points']
                                                                    ?.toString() ??
                                                                '';

                                                            // Calculate discount price safely
                                                            discountPrice = 0.0;
                                                            if (_prices
                                                                .isNotEmpty) {
                                                              final price = int.tryParse(
                                                                      _prices[0]['price']
                                                                              ?.toString() ??
                                                                          '0') ??
                                                                  0;
                                                              final offerPrice =
                                                                  int.tryParse(_prices[0]['offer_price']
                                                                              ?.toString() ??
                                                                          '0') ??
                                                                      0;

                                                              if (price > 0 &&
                                                                  offerPrice >
                                                                      0 &&
                                                                  offerPrice <
                                                                      price) {
                                                                discountPrice =
                                                                    ((price -
                                                                            offerPrice) /
                                                                        price *
                                                                        100);
                                                              }
                                                            }
                                                          });
                                                        },
                                                        child:
                                                            AnimatedContainer(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  200),
                                                          constraints:
                                                              BoxConstraints(
                                                                  minWidth:
                                                                      45.w),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      12.w,
                                                                  vertical:
                                                                      8.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient: isActive
                                                                ? LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xFFEED056),
                                                                      Color(
                                                                          0xFFC7B456),
                                                                    ],
                                                                    begin: Alignment
                                                                        .topLeft,
                                                                    end: Alignment
                                                                        .bottomRight,
                                                                  )
                                                                : null,
                                                            color: isActive
                                                                ? null
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.r),
                                                            border: isActive
                                                                ? null
                                                                : Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300),
                                                            boxShadow: isActive
                                                                ? [
                                                                    BoxShadow(
                                                                      color: Color(
                                                                              0xFFC7B456)
                                                                          .withOpacity(
                                                                              0.4),
                                                                      blurRadius:
                                                                          6,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              3),
                                                                    )
                                                                  ]
                                                                : null,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              _sizes[index][
                                                                          'value']
                                                                      ?.toString() ??
                                                                  '',
                                                              style:
                                                                  MyGoogleFontStyle(
                                                                fontFamily:
                                                                    'Urbanist',
                                                                fontSize:
                                                                    14.0.sp,
                                                                fontWeight: isActive
                                                                    ? FontWeight
                                                                        .bold
                                                                    : FontWeight
                                                                        .w600,
                                                                color: isActive
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black87,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 15.0.w),
                                            Expanded(
                                              flex: 2,
                                              child: InkWell(
                                                onTap: () {
                                                  if (product.sizeChartPath !=
                                                      null) {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20)),
                                                      ),
                                                      builder: (context) =>
                                                          Container(
                                                        height: 0.5.sh,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            // Header
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      16.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Size Guide',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Urbanist',
                                                                      fontSize:
                                                                          18.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () =>
                                                                        Navigator.pop(
                                                                            context),
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              8),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .grey[100],
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .close,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(
                                                                height: 1),
                                                            // Content
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              ImageScreen(
                                                                        image:
                                                                            '${configModel.apiConfig['mediaURL']}${product.sizeChartPath}',
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  padding: EdgeInsets
                                                                      .all(16.0
                                                                          .w),
                                                                  child: Image
                                                                      .network(
                                                                    '${configModel.apiConfig['mediaURL']}${product.sizeChartPath}',
                                                                    fit: BoxFit
                                                                        .contain,
                                                                    errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) =>
                                                                        const Center(
                                                                            child:
                                                                                Icon(Icons.error)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  height: 45.w,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.r),
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.straighten,
                                                        color:
                                                            Color(0xFFC7B456),
                                                        size: 20.sp,
                                                      ),
                                                      SizedBox(height: 2.w),
                                                      Text(
                                                        'Size Chart',
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              'Urbanist',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Points
                                  if (_productPoints.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0.w, top: 10.0.w),
                                      child: Text(
                                        'Earn $_productPoints points for this product',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 14.0.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFC7B456),
                                        ),
                                      ),
                                    ),
                                  // Customer Ratings
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 15.0.w, bottom: 15.0.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Customer Ratings',
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14.0.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0x99000000),
                                          ),
                                        ),
                                        SizedBox(height: 10.0.w),
                                        Builder(
                                          builder: (context) {
                                            // Use product-level ratings instead of pack-specific
                                            int totalReviewCount =
                                                _getTotalReviewsCount(product);

                                            if (product.rating != '0' &&
                                                product.rating != null)
                                              return Row(
                                                children: [
                                                  Text(
                                                    product.rating.toString(),
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14.0.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                          0x99000000),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 3.0.w),
                                                    child: const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                        size: 16),
                                                  ),
                                                  Text(
                                                    '(${totalReviewCount != 0 ? totalReviewCount : 0} ratings)',
                                                    style: TextStyle(
                                                        fontSize: 12.0.sp),
                                                  ),
                                                  const Spacer(),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                        context,
                                                        '/reviewsPage',
                                                        arguments: {
                                                          'productId': widget
                                                                  .arguments![
                                                              'product']['id'],
                                                          'is_edit': false,
                                                          'is_popup': false,
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      'View Reviews & Ratings',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 12.0.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0x99000000),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            return SizedBox.shrink();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Descriptions - Isolated widget to prevent rebuilds
                                  ProductDescriptionSection(
                                    product: product,
                                    smallDescKey: _smallDescKey,
                                    descKey: _descKey,
                                    desc1Key: _desc1Key,
                                    desc2Key: _desc2Key,
                                  ),
                                  // Add More Items
                                  Padding(
                                    padding: EdgeInsets.only(top: 20.0.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Add More Items',
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 16.0.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff000000),
                                          ),
                                        ),
                                        SizedBox(height: 10.0.w),
                                        SizedBox(
                                          height: 260.0.w,
                                          child: productModel
                                                  .categoryWiseproductsLoader
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : productModel
                                                          .categoryWiseproducts
                                                          ?.isEmpty ??
                                                      true
                                                  ? const Center(
                                                      child: Text(
                                                          'No related products available'))
                                                  : ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: productModel
                                                          .categoryWiseproducts!
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final relatedProduct =
                                                            productModel
                                                                    .categoryWiseproducts![
                                                                index];

                                                        // Calculate discount safely
                                                        double relatedDiscount =
                                                            0.0;
                                                        if (relatedProduct
                                                                .productPrices
                                                                ?.isNotEmpty ??
                                                            false) {
                                                          final configModel =
                                                              context.read<
                                                                  ConfigModel>();
                                                          final isDistributor =
                                                              configModel
                                                                      .activeRole ==
                                                                  'Distributor';
                                                          final priceObj =
                                                              relatedProduct
                                                                  .productPrices![0];

                                                          double price = double
                                                                  .tryParse(priceObj
                                                                          .price
                                                                          ?.toString() ??
                                                                      '0') ??
                                                              0;
                                                          double offerPrice =
                                                              double.tryParse(priceObj
                                                                          .offerPrice
                                                                          ?.toString() ??
                                                                      '0') ??
                                                                  0;

                                                          if (isDistributor) {
                                                            double? distPrice =
                                                                double.tryParse(priceObj
                                                                        .distributorPrice
                                                                        ?.toString() ??
                                                                    '');
                                                            double?
                                                                distOfferPrice =
                                                                double.tryParse(priceObj
                                                                        .distributorOfferPrice
                                                                        ?.toString() ??
                                                                    '');

                                                            if (distPrice !=
                                                                    null &&
                                                                distPrice > 0)
                                                              price = distPrice;
                                                            if (distOfferPrice !=
                                                                    null &&
                                                                distOfferPrice >
                                                                    0)
                                                              offerPrice =
                                                                  distOfferPrice;
                                                          }

                                                          if (price > 0 &&
                                                              offerPrice > 0 &&
                                                              offerPrice <
                                                                  price) {
                                                            relatedDiscount =
                                                                ((price -
                                                                        offerPrice) /
                                                                    price *
                                                                    100);
                                                          }
                                                        }

                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right:
                                                                      12.0.w),
                                                          child:
                                                              CommonProductCard(
                                                            product:
                                                                relatedProduct,
                                                            discountPrice:
                                                                relatedDiscount,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: configModel.user == null
          ? const SizedBox.shrink()
          : Container(
              padding: EdgeInsets.all(8.0.w),
              child: Row(
                children: [
                  Expanded(
                    // flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150,
                        height: 41,
                        child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              // await _addToCartModel
                              //     .getAddToCart(
                              //         widget.arguments![
                              //             'product']['id'],
                              //         type,
                              //         _CartData);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CartPage(isProfile: {'isProfile': false}),
                                ),
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                            decoration: BoxDecoration(
                              color: Color(0xff1e1e1e),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Image.asset(
                                    'assets/images/shopping-bag-03.png',
                                    width: 18,
                                    height: 17,
                                  ),
                                ),
                                Text(
                                  // addtocartB9Y (318:2187)
                                  'Go To Cart',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0.w),
                  Expanded(
                    child: (() {
                      bool hasValidPrice = false;
                      if (_prices.isNotEmpty) {
                        final effective = _getEffectivePrices(_prices[0]);
                        if (effective['price'] != null &&
                            effective['price']! > 0) {
                          hasValidPrice = true;
                        }
                      }
                      if (!hasValidPrice) {
                        return const SizedBox.shrink();
                      }
                      return currentPackQty <= 0
                          ? TextButton(
                              onPressed: _handleNotifyMe,
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0.w, vertical: 10.0.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC7B456),
                                  borderRadius: BorderRadius.circular(10.0.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.notifications_active_outlined,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                    SizedBox(width: 10.0.w),
                                    Text(
                                      'Notify Me',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 14.0.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : TextButton(
                              onPressed: () async {
                                // Removed currentPackQty <= 0 check as it's handled by parent ternary
                                if (_cartData['kindOfFlower'] == '' ||
                                    _cartData['flavour'] == '') {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0.r)),
                                      title: Text(
                                        _cartData['kindOfFlower'] == '' &&
                                                _cartData['flavour'] != ''
                                            ? 'Kindly choose size.'
                                            : _cartData['flavour'] == '' &&
                                                    _cartData['kindOfFlower'] !=
                                                        ''
                                                ? 'Kindly choose colour.'
                                                : 'Kindly choose colour and size.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            'Ok',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  // Check if the selected item is already in cart
                                  AddToCart? existingCartItem;
                                  try {
                                    existingCartItem =
                                        addToCartModel.addToCarts?.firstWhere(
                                      (cart) =>
                                          cart.productId ==
                                              widget.arguments!['product']
                                                  ['id'] &&
                                          cart.flavour ==
                                              _cartData['flavour'] &&
                                          cart.kindOfFlower ==
                                              _cartData['kindOfFlower'],
                                    );
                                  } catch (e) {
                                    existingCartItem = null;
                                  }

                                  if (existingCartItem == null) {
                                    // Item not in cart, show dialog to add
                                    int tempQuantity = 1;
                                    final BuildContext parentContext = context;
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) =>
                                          StatefulBuilder(
                                        builder:
                                            (dialogContext, setDialogState) =>
                                                AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20.0.r)),
                                          title: Text('Add to Cart'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'This item is not in your cart. Please select quantity:'),
                                              SizedBox(height: 10),
                                              Text(
                                                  'Maximum available: $currentPackQty',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0.sp,
                                                  )),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      if (tempQuantity > 1) {
                                                        setDialogState(() {
                                                          tempQuantity--;
                                                        });
                                                      }
                                                    },
                                                    icon: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Icon(Icons.remove,
                                                          size: 20),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: Text(
                                                      tempQuantity.toString(),
                                                      style: TextStyle(
                                                        fontSize: 18.0.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  // Hide plus button when quantity reaches available stock
                                                  if (tempQuantity <
                                                      currentPackQty)
                                                    IconButton(
                                                      onPressed: () {
                                                        if (tempQuantity <
                                                            currentPackQty) {
                                                          setDialogState(() {
                                                            tempQuantity++;
                                                          });
                                                        }
                                                      },
                                                      icon: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Icon(Icons.add,
                                                            size: 20),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(dialogContext),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0.sp),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                // Check if quantity exceeds available stock
                                                if (currentPackQty > 0 &&
                                                    tempQuantity >
                                                        currentPackQty) {
                                                  ScaffoldMessenger.of(
                                                          parentContext)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Only $currentPackQty items available in stock'),
                                                      backgroundColor:
                                                          Colors.orange,
                                                      duration:
                                                          Duration(seconds: 2),
                                                    ),
                                                  );
                                                  return;
                                                }

                                                Navigator.pop(
                                                    dialogContext); // Close dialog

                                                // Add to cart with selected quantity
                                                _cartData['points'] =
                                                    _productPoints;

                                                // Set product price safely
                                                if (_prices.isNotEmpty) {
                                                  final offerPrice =
                                                      _prices[0]['offer_price'];
                                                  final price =
                                                      _prices[0]['price'];

                                                  _cartData['product_price'] =
                                                      (offerPrice != null &&
                                                              offerPrice != 0)
                                                          ? offerPrice
                                                              .toString()
                                                          : (price?.toString() ??
                                                              '0');
                                                } else {
                                                  _cartData['product_price'] =
                                                      '0';
                                                }
                                                _cartData['is_add_to_cart'] =
                                                    true;

                                                // Pass available quantity for validation
                                                _cartData['available_qty'] =
                                                    currentPackQty;

                                                // Add item to cart with quantity
                                                // First add the item to cart
                                                await addToCartModel
                                                    .getAddToCart(
                                                        widget.arguments![
                                                            'product']['id'],
                                                        true,
                                                        _cartData);

                                                // If user selected more than 1, add additional quantities
                                                if (tempQuantity > 1) {
                                                  // Add the remaining quantity by calling the API multiple times
                                                  // The API increments by 1 each time when type=true
                                                  for (int i = 1;
                                                      i < tempQuantity;
                                                      i++) {
                                                    await addToCartModel
                                                        .getAddToCart(
                                                            widget.arguments![
                                                                    'product']
                                                                ['id'],
                                                            true,
                                                            _cartData);
                                                  }
                                                }

                                                // Navigate to cart using the parent context
                                                if (mounted) {
                                                  Navigator.push(
                                                    parentContext,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CartPage(isProfile: {
                                                        'isProfile': false
                                                      }),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Text(
                                                'Add & Proceed',
                                                style: TextStyle(
                                                    color: Color(0xFFC7B456),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0.sp),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Item already in cart, navigate directly
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CartPage(
                                            isProfile: {'isProfile': false}),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0.w, vertical: 10.0.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC7B456),
                                  borderRadius: BorderRadius.circular(10.0.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/shopping-bag-03.png',
                                      width: 18.0.w,
                                      height: 17.0.w,
                                    ),
                                    SizedBox(width: 10.0.w),
                                    Text(
                                      'Buy Now',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 14.0.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                    })(),
                  ),
                ],
              ),
            ),
    );
  }
}

// Isolated widget for product descriptions that won't rebuild on parent state changes
class ProductDescriptionSection extends StatefulWidget {
  final Product product;
  final GlobalKey smallDescKey;
  final GlobalKey descKey;
  final GlobalKey desc1Key;
  final GlobalKey desc2Key;

  const ProductDescriptionSection({
    Key? key,
    required this.product,
    required this.smallDescKey,
    required this.descKey,
    required this.desc1Key,
    required this.desc2Key,
  }) : super(key: key);

  @override
  State<ProductDescriptionSection> createState() =>
      _ProductDescriptionSectionState();
}

class _ProductDescriptionSectionState extends State<ProductDescriptionSection> {
  // Track expanded state for each section
  bool _highlightsExpanded = true;
  bool _descriptionExpanded = false;
  bool _specificationsExpanded = false;
  bool _additionalInfoExpanded = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final hasAnyDescription = product.smallDescription != null ||
        product.description != null ||
        product.description1 != null ||
        product.description2 != null;

    if (!hasAnyDescription) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.only(bottom: 16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEED056), Color(0xFFF6E27F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFEED056).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Details',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff232323),
                    ),
                  ),
                  SizedBox(height: 2.w),
                  Container(
                    height: 3.w,
                    width: 50.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFEED056),
                          Color(0xFFEED056).withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Small Description (Highlights)
        if (product.smallDescription != null)
          _buildCollapsibleCard(
            globalKey: widget.smallDescKey,
            uniqueKey: 'small_desc_${product.id}',
            data: product.smallDescription.toString(),
            icon: Icons.auto_awesome,
            title: 'Highlights',
            gradientColors: [Color(0xFFFFF8E1), Colors.white],
            isExpanded: _highlightsExpanded,
            onToggle: () =>
                setState(() => _highlightsExpanded = !_highlightsExpanded),
          ),

        // Main Description
        if (product.description != null)
          _buildCollapsibleCard(
            globalKey: widget.descKey,
            uniqueKey: 'desc_${product.id}',
            data: product.description.toString(),
            icon: Icons.info_outline,
            title: 'Description',
            gradientColors: [Color(0xFFFFFEF9), Colors.white],
            isExpanded: _descriptionExpanded,
            onToggle: () =>
                setState(() => _descriptionExpanded = !_descriptionExpanded),
          ),

        // Description 1 (Specifications)
        if (product.description1 != null)
          _buildCollapsibleCard(
            globalKey: widget.desc1Key,
            uniqueKey: 'desc1_${product.id}',
            data: product.description1.toString(),
            icon: Icons.settings_outlined,
            title: 'Specifications',
            gradientColors: [Color(0xFFF5F5F5), Colors.white],
            isExpanded: _specificationsExpanded,
            onToggle: () => setState(
                () => _specificationsExpanded = !_specificationsExpanded),
          ),

        // Description 2 (Additional Info)
        if (product.description2 != null)
          _buildCollapsibleCard(
            globalKey: widget.desc2Key,
            uniqueKey: 'desc2_${product.id}',
            data: product.description2.toString(),
            icon: Icons.add_circle_outline,
            title: 'Additional Information',
            gradientColors: [Color(0xFFFFFEF9), Colors.white],
            isExpanded: _additionalInfoExpanded,
            onToggle: () => setState(
                () => _additionalInfoExpanded = !_additionalInfoExpanded),
          ),
      ],
    );
  }

  Widget _buildCollapsibleCard({
    required GlobalKey globalKey,
    required String uniqueKey,
    required String data,
    required IconData icon,
    required String title,
    required List<Color> gradientColors,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return RepaintBoundary(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: 12.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isExpanded
                ? Color(0xFFEED056).withOpacity(0.3)
                : Color(0xFFEED056).withOpacity(0.15),
            width: isExpanded ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFEED056).withOpacity(isExpanded ? 0.12 : 0.08),
              blurRadius: isExpanded ? 20 : 16,
              offset: Offset(0, isExpanded ? 8 : 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Header (Tappable)
            InkWell(
              onTap: onToggle,
              borderRadius: isExpanded
                  ? BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                    )
                  : BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
                decoration: BoxDecoration(
                  border: isExpanded
                      ? Border(
                          bottom: BorderSide(
                            color: Color(0xFFEED056).withOpacity(0.2),
                            width: 1,
                          ),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Color(0xFFEED056)
                            .withOpacity(isExpanded ? 0.18 : 0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        icon,
                        color: Color(0xFFD4A840),
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff232323),
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      duration: Duration(milliseconds: 300),
                      turns: isExpanded ? 0.5 : 0,
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Color(0xFFEED056).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFFD4A840),
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Card Content (Collapsible)
            AnimatedCrossFade(
              duration: Duration(milliseconds: 300),
              crossFadeState: isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: EdgeInsets.all(16.w),
                child: PreservedHtmlWidget(
                  key: globalKey,
                  uniqueKey: uniqueKey,
                  data: data,
                ),
              ),
              secondChild: Container(height: 0, width: double.infinity),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget to preserve HTML content state and prevent image re-fetching
class PreservedHtmlWidget extends StatefulWidget {
  final String data;
  final String uniqueKey;

  const PreservedHtmlWidget({
    Key? key,
    required this.data,
    required this.uniqueKey,
  }) : super(key: key);

  @override
  _PreservedHtmlWidgetState createState() => _PreservedHtmlWidgetState();
}

class _PreservedHtmlWidgetState extends State<PreservedHtmlWidget>
    with AutomaticKeepAliveClientMixin {
  late Widget _cachedHtmlWidget;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Create the HTML widget ONCE during initialization
    _cachedHtmlWidget = Html(
      key: ValueKey(widget.uniqueKey),
      data: widget.data,
      style: {
        // Ensure images are displayed properly
        "img": Style(
          display: Display.block,
          margin: Margins.symmetric(vertical: 8),
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    // Always return the same cached widget instance
    return _cachedHtmlWidget;
  }
}

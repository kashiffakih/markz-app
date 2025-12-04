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
import 'package:aadab/ui/widgets/login_required_popup.dart';
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

    // Fetch fresh product data from API
    try {
      final freshProduct = await productService.getProductById(productId);
      if (freshProduct != null) {
        _freshProductData = freshProduct.toJson();
      }
    } catch (e) {
      debugPrint('Error fetching fresh product data: $e');
      // Fall back to arguments data if API fails
    }

    await Future.wait<void>([
      if (configModel.user != null)
        addToCartModel.getAddToCart(productId, '', _cartData),
      if (configModel.user != null) wishListModel.getWishLists(''),
      productModel.getCategoryWiseProduct(
          _productData['category_id'] ?? '', ''),
    ]);

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
      productDisplayImages = widget.arguments?['product_images']?.toList() ?? [];
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

    if (_sizes.isNotEmpty) {
      _cartData['kindOfFlower'] = _sizes[0]['value']?.toString() ?? '';
      _cartData['pack'] = _sizes[0]['id']?.toString() ?? '';
      size = _sizes[0]['value']?.toString() ?? '';
      _productPoints = _sizes[0]['points']?.toString() ?? '';
      activeIndex = 0; // Pre-select the first size
      currentPackQty = _sizes[0]['qty'] ?? 0; // Initialize quantity from fresh data

      // Get prices for the selected pack from fresh data
      _prices = _productData['product_prices']
              ?.where((price) => price['product_pack_id'] == _sizes[0]['id'])
              ?.toList() ??
          [];

      if (_prices.isNotEmpty) {
        final price = int.tryParse(_prices[0]['price']?.toString() ?? '0') ?? 0;
        final offerPrice =
            int.tryParse(_prices[0]['offer_price']?.toString() ?? '0') ?? 0;

        if (price > 0 && offerPrice > 0 && offerPrice < price) {
          discountPrice = ((price - offerPrice) / price * 100);
        }
      }
    }

    cartCount = context.read<AddToCartModel>().addToCarts?.length ?? 0;
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
                      // Header
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0.w, vertical: 16.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Product Details',
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff1e232c),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0.w),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pop(context),
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
                                SizedBox(width: 12.0.w),
                                Expanded(
                                  child: Container(
                                    height: 45.0.w,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0.w, vertical: 4.0.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(16.0.r),
                                      border: Border.all(
                                        color:
                                            Color(0xFFEED056).withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFFEED056)
                                              .withOpacity(0.08),
                                          blurRadius: 15,
                                          offset: Offset(0, 4),
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.search,
                                          color: Color(0xFFEED056),
                                          size: 20.0.sp,
                                        ),
                                        SizedBox(width: 10.0.w),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _searchController,
                                            onChanged: (value) {
                                              if (_debounce?.isActive ?? false)
                                                _debounce!.cancel();
                                              _debounce = Timer(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                if (value.length % 3 == 0 &&
                                                    value.isNotEmpty) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShopsPage(
                                                              initialText:
                                                                  value),
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Search products...',
                                              hintStyle: TextStyle(
                                                color: Color(0xFF909090),
                                                fontSize: 14.0.sp,
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0.sp,
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                    child: badges.Badge(
                                      badgeContent: Text(
                                        cartCount.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      badgeStyle: badges.BadgeStyle(
                                        badgeColor: Color(0xFFEED056),
                                        padding: EdgeInsets.all(4.0.w),
                                      ),
                                      child: Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Color(0xFF232323),
                                        size: 22.0.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0.w, vertical: 8.0.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20.0.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFEED056).withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: SmoothPageIndicator(
                                  controller: sliderController,
                                  count: imageProduct.length,
                                  effect: ExpandingDotsEffect(
                                    dotHeight: 8.0.w,
                                    dotWidth: 28.0.w,
                                    activeDotColor: Color(0xFFEED056),
                                    dotColor:
                                        Color(0xFFEED056).withOpacity(0.3),
                                    expansionFactor: 3.5,
                                    spacing: 6.0.w,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0.w),
                            // Thumbnail Images
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon:
                                          Icon(Icons.arrow_left, size: 24.0.sp),
                                      onPressed: () {
                                        if (productDisplayImages.isNotEmpty) {
                                          final currentIndex =
                                              productDisplayImages.indexWhere(
                                                  (image) =>
                                                      image.unit?.name ==
                                                      unitName);
                                          final newIndex = (currentIndex - 1)
                                              .clamp(
                                                  0,
                                                  productDisplayImages.length -
                                                      1);
                                          setState(() {
                                            unitName =
                                                productDisplayImages[newIndex]
                                                        .unit
                                                        ?.name
                                                        ?.toString() ??
                                                    '';
                                            _cartData['flavour'] = unitName;
                                            updateProductDisplayImages = widget
                                                    .arguments?[
                                                        'product_images']
                                                    ?.where((image) =>
                                                        image.unit?.name ==
                                                        unitName)
                                                    ?.toList() ??
                                                [];
                                            _sizes = widget
                                                    .arguments?['product']
                                                        ?['product_packs']
                                                    ?.where((pack) =>
                                                        pack['unit']?['name'] ==
                                                        unitName)
                                                    ?.toList() ??
                                                [];
                                            activeIndex =
                                                0; // Pre-select first size
                                            _cartData['kindOfFlower'] =
                                                _sizes.isNotEmpty
                                                    ? _sizes[0]['value']
                                                            ?.toString() ??
                                                        ''
                                                    : '';
                                            _cartData['pack'] = _sizes
                                                    .isNotEmpty
                                                ? _sizes[0]['id']?.toString() ??
                                                    ''
                                                : '';
                                            currentPackQty = _sizes.isNotEmpty
                                                ? _sizes[0]['qty'] ?? 0
                                                : 0;
                                            _prices = widget
                                                    .arguments?['product']
                                                        ?['product_prices']
                                                    ?.where((price) =>
                                                        price[
                                                            'product_pack_id'] ==
                                                        _sizes[0]['id'])
                                                    ?.toList() ??
                                                [];
                                            _productPoints = _sizes.isNotEmpty
                                                ? _sizes[0]['points']
                                                        ?.toString() ??
                                                    ''
                                                : '';

                                            // Calculate discount price safely
                                            discountPrice = 0.0;
                                            if (_prices.isNotEmpty) {
                                              final price = int.tryParse(
                                                      _prices[0]['price']
                                                              ?.toString() ??
                                                          '0') ??
                                                  0;
                                              final offerPrice = int.tryParse(
                                                      _prices[0]['offer_price']
                                                              ?.toString() ??
                                                          '0') ??
                                                  0;

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
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: SizedBox(
                                      height: 100.0.w,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                        itemCount: productDisplayImages.length,
                                        itemBuilder: (context, index) {
                                          final isSelected = unitName ==
                                              productDisplayImages[index]
                                                  .unit
                                                  ?.name;
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                unitName =
                                                    productDisplayImages[index]
                                                            .unit
                                                            ?.name
                                                            ?.toString() ??
                                                        '';
                                                _cartData['flavour'] = unitName;
                                                updateProductDisplayImages =
                                                    widget.arguments?[
                                                                'product_images']
                                                            ?.where((image) =>
                                                                image.unit
                                                                    ?.name ==
                                                                unitName)
                                                            ?.toList() ??
                                                        [];
                                                _sizes = widget
                                                        .arguments?['product']
                                                            ?['product_packs']
                                                        ?.where((pack) =>
                                                            pack['unit']
                                                                ?['name'] ==
                                                            unitName)
                                                        ?.toList() ??
                                                    [];
                                                activeIndex =
                                                    0; // Pre-select first size
                                                _cartData['kindOfFlower'] =
                                                    _sizes.isNotEmpty
                                                        ? _sizes[0]['value']
                                                                ?.toString() ??
                                                            ''
                                                        : '';
                                                _cartData['pack'] =
                                                    _sizes.isNotEmpty
                                                        ? _sizes[0]['id']
                                                                ?.toString() ??
                                                            ''
                                                        : '';
                                                currentPackQty =
                                                    _sizes.isNotEmpty
                                                        ? _sizes[0]['qty'] ?? 0
                                                        : 0;
                                                _prices = widget
                                                        .arguments?['product']
                                                            ?['product_prices']
                                                        ?.where((price) =>
                                                            price[
                                                                'product_pack_id'] ==
                                                            _sizes[0]['id'])
                                                        ?.toList() ??
                                                    [];
                                                _productPoints =
                                                    _sizes.isNotEmpty
                                                        ? _sizes[0]['points']
                                                                ?.toString() ??
                                                            ''
                                                        : '';
                                                // Calculate discount price safely
                                                discountPrice = 0.0;
                                                if (_prices.isNotEmpty) {
                                                  final price = int.tryParse(
                                                          _prices[0]['price']
                                                                  ?.toString() ??
                                                              '0') ??
                                                      0;
                                                  final offerPrice =
                                                      int.tryParse(_prices[0][
                                                                      'offer_price']
                                                                  ?.toString() ??
                                                              '0') ??
                                                          0;

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
                                              margin:
                                                  EdgeInsets.only(right: 8.0.w),
                                              width: 60.0.w,
                                              height: 80.0.w,
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                border: isSelected
                                                    ? Border.all(
                                                        color: Colors.black,
                                                        width: 2.0.w)
                                                    : Border.all(
                                                        color:
                                                            Colors.grey[300]!),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8.0.w),
                                              ),
                                              child: productDisplayImages[index]
                                                          .imagepath !=
                                                      null
                                                  ? Image.network(
                                                      '${configModel.apiConfig['mediaURL']}${productDisplayImages[index].imagepath}',
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          const Icon(
                                                              Icons.error),
                                                    )
                                                  : const Center(
                                                      child: Text('No Image')),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_right,
                                          size: 24.0.sp),
                                      onPressed: () {
                                        if (productDisplayImages.isNotEmpty) {
                                          final currentIndex =
                                              productDisplayImages.indexWhere(
                                                  (image) =>
                                                      image.unit?.name ==
                                                      unitName);
                                          final newIndex = (currentIndex + 1)
                                              .clamp(
                                                  0,
                                                  productDisplayImages.length -
                                                      1);
                                          setState(() {
                                            unitName =
                                                productDisplayImages[newIndex]
                                                        .unit
                                                        ?.name
                                                        ?.toString() ??
                                                    '';
                                            _cartData['flavour'] = unitName;
                                            updateProductDisplayImages = widget
                                                    .arguments?[
                                                        'product_images']
                                                    ?.where((image) =>
                                                        image.unit?.name ==
                                                        unitName)
                                                    ?.toList() ??
                                                [];
                                            _sizes = widget
                                                    .arguments?['product']
                                                        ?['product_packs']
                                                    ?.where((pack) =>
                                                        pack['unit']?['name'] ==
                                                        unitName)
                                                    ?.toList() ??
                                                [];
                                            activeIndex =
                                                0; // Pre-select first size
                                            _cartData['kindOfFlower'] =
                                                _sizes.isNotEmpty
                                                    ? _sizes[0]['value']
                                                            ?.toString() ??
                                                        ''
                                                    : '';
                                            _cartData['pack'] = _sizes
                                                    .isNotEmpty
                                                ? _sizes[0]['id']?.toString() ??
                                                    ''
                                                : '';
                                            currentPackQty = _sizes.isNotEmpty
                                                ? _sizes[0]['qty'] ?? 0
                                                : 0;
                                            _prices = widget
                                                    .arguments?['product']
                                                        ?['product_prices']
                                                    ?.where((price) =>
                                                        price[
                                                            'product_pack_id'] ==
                                                        _sizes[0]['id'])
                                                    ?.toList() ??
                                                [];
                                            _productPoints = _sizes.isNotEmpty
                                                ? _sizes[0]['points']
                                                        ?.toString() ??
                                                    ''
                                                : '';

                                            // Calculate discount price safely
                                            discountPrice = 0.0;
                                            if (_prices.isNotEmpty) {
                                              final price = int.tryParse(
                                                      _prices[0]['price']
                                                              ?.toString() ??
                                                          '0') ??
                                                  0;
                                              final offerPrice = int.tryParse(
                                                      _prices[0]['offer_price']
                                                              ?.toString() ??
                                                          '0') ??
                                                  0;

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
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 20.0.w),
                                      Column(
                                        children: [
                                          if ((addToCartModel.addToCarts
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
                                                    final offerPrice =
                                                        _prices[0]
                                                            ['offer_price'];
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
                                          if ((addToCartModel.addToCarts
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
                                          Text(
                                            currentPackQty > 0
                                                ? 'Available in stock ($currentPackQty)'
                                                : 'Out of stock',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 12.0.sp,
                                              fontWeight: FontWeight.w600,
                                              color: currentPackQty > 0
                                                  ? const Color(0xff000000)
                                                  : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Price
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0.w, top: 10.0.w),
                                    child: _prices.isNotEmpty &&
                                            (_prices[0]['offer_price'] !=
                                                    null &&
                                                _prices[0]['offer_price'] != 0)
                                        ? Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Total Price',
                                                  style: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 14.0.sp),
                                                ),
                                                WidgetSpan(
                                                    child: SizedBox(
                                                        width: 20.0.w)),
                                                TextSpan(
                                                  text:
                                                      '₹${_prices[0]['price'] ?? '0'}',
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFFC7B456),
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 18.0.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                    child: SizedBox(
                                                        width: 20.0.w)),
                                                TextSpan(
                                                  text:
                                                      '₹${_prices[0]['offer_price'] ?? '0'}',
                                                  style: TextStyle(
                                                    fontSize: 18.0.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff000000),
                                                  ),
                                                ),
                                                if (discountPrice != 0.0) ...[
                                                  WidgetSpan(
                                                      child: SizedBox(
                                                          width: 10.0.w)),
                                                  TextSpan(
                                                    text:
                                                        '(${discountPrice.round()}% Off)',
                                                    style: TextStyle(
                                                      fontSize: 16.0.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                          0xff000000),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          )
                                        : Text(
                                            _prices.isNotEmpty
                                                ? '₹${_prices[0]['price'] ?? '0'}'
                                                : 'Price not available',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 18.0.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0x99000000),
                                            ),
                                          ),
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
                                                height: 60.0.w,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.0.w),
                                                  itemCount: _sizes.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final isActive =
                                                        index == activeIndex;
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  8.0.w),
                                                      child: TextButton(
                                                        onPressed: () {
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
                                                        style: TextButton
                                                            .styleFrom(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          backgroundColor:
                                                              isActive
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0.w),
                                                          ),
                                                        ),
                                                        child: Container(
                                                          width: 50.0.w,
                                                          height: 50.0.w,
                                                          decoration:
                                                              ShapeDecoration(
                                                            shape: OvalBorder(
                                                              side: BorderSide(
                                                                  width: 0.95.w,
                                                                  color: const Color(
                                                                      0xFFDDDDDD)),
                                                            ),
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
                                                                    15.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: isActive
                                                                    ? Colors
                                                                        .white
                                                                    : const Color(
                                                                        0x99000000),
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
                                                      builder: (context) =>
                                                          InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
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
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20.0.w),
                                                          height: 200.0.w,
                                                          child: Image.network(
                                                            '${configModel.apiConfig['mediaURL']}${product.sizeChartPath}',
                                                            fit: BoxFit.contain,
                                                            errorBuilder: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/size-chart-icon.png',
                                                      width: 40.0.w,
                                                      height: 40.0.w,
                                                    ),
                                                    Text(
                                                      'Size Chart',
                                                      style: TextStyle(
                                                        fontSize: 11.0.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
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
                                    padding: EdgeInsets.only(top: 10.0.w),
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
                                                          final priceValue =
                                                              relatedProduct
                                                                  .productPrices![
                                                                      0]
                                                                  .price;
                                                          final offerPriceValue =
                                                              relatedProduct
                                                                  .productPrices![
                                                                      0]
                                                                  .offerPrice;

                                                          if (priceValue !=
                                                                  null &&
                                                              offerPriceValue !=
                                                                  null &&
                                                              offerPriceValue !=
                                                                  0) {
                                                            final price =
                                                                int.tryParse(
                                                                        priceValue
                                                                            .toString()) ??
                                                                    0;
                                                            final offerPrice =
                                                                int.tryParse(
                                                                        offerPriceValue
                                                                            .toString()) ??
                                                                    0;

                                                            if (price > 0 &&
                                                                offerPrice >
                                                                    0 &&
                                                                price >
                                                                    offerPrice) {
                                                              relatedDiscount =
                                                                  ((price -
                                                                          offerPrice) /
                                                                      price *
                                                                      100);
                                                            }
                                                          }
                                                        }
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProductIdPage(
                                                                  arguments: {
                                                                    'product':
                                                                        relatedProduct
                                                                            .toJson(),
                                                                    'product_images':
                                                                        relatedProduct
                                                                            .productImages,
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            width: 145.0.w,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right:
                                                                        12.0.w),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0.w),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.1),
                                                                  blurRadius: 5,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 2),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          145.0
                                                                              .w,
                                                                      height:
                                                                          140.0
                                                                              .w,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15.0.r),
                                                                        image:
                                                                            DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image: relatedProduct.productImages?.isNotEmpty ?? false
                                                                              ? NetworkImage('${configModel.apiConfig['mediaURL']}${relatedProduct.productImages!.first.imagepath}')
                                                                              : const AssetImage('assets/images/placeholder.png') as ImageProvider,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top:
                                                                          8.0.w,
                                                                      right:
                                                                          8.0.w,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          if (configModel.user ==
                                                                              null) {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (context) => LoginRequiredPopupWidget(),
                                                                            );
                                                                          } else {
                                                                            await wishListModel.getWishLists(relatedProduct.id);
                                                                            setState(() {});
                                                                          }
                                                                        },
                                                                        child: wishListModel.wishListLoader
                                                                            ? SizedBox(
                                                                                width: 20.0.sp,
                                                                                height: 20.0.sp,
                                                                                child: const CircularProgressIndicator(strokeWidth: 2),
                                                                              )
                                                                            : Icon(
                                                                                wishListModel.wishLists?.any((wishList) => wishList.productId == relatedProduct.id && wishList.userId == configModel.user?.id) ?? false ? Icons.favorite_outlined : Icons.favorite_border_outlined,
                                                                                color: wishListModel.wishLists?.any((wishList) => wishList.productId == relatedProduct.id && wishList.userId == configModel.user?.id) ?? false ? Colors.red : null,
                                                                                size: 20.0.sp,
                                                                              ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10.0
                                                                              .w,
                                                                      vertical:
                                                                          8.0.w),
                                                                  child: Text(
                                                                    relatedProduct
                                                                            .name ??
                                                                        'Unnamed Product',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        MyGoogleFontStyle(
                                                                      fontFamily:
                                                                          'Urbanist',
                                                                      fontSize:
                                                                          15.0.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: const Color(
                                                                          0xff000000),
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (relatedProduct
                                                                        .productPrices
                                                                        ?.isNotEmpty ??
                                                                    false)
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom:
                                                                            4.0.w),
                                                                    child: relatedProduct.productPrices![0].offerPrice !=
                                                                                null &&
                                                                            relatedProduct.productPrices![0].offerPrice !=
                                                                                0
                                                                        ? Text
                                                                            .rich(
                                                                            TextSpan(
                                                                              children: [
                                                                                TextSpan(
                                                                                  text: '₹${relatedProduct.productPrices![0].price ?? '0'}',
                                                                                  style: TextStyle(
                                                                                    color: Colors.grey,
                                                                                    decoration: TextDecoration.lineThrough,
                                                                                    fontSize: 13.0.sp,
                                                                                    fontFamily: 'Poppins',
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                                TextSpan(
                                                                                  text: ' ₹${relatedProduct.productPrices![0].offerPrice ?? '0'}',
                                                                                  style: TextStyle(
                                                                                    fontSize: 13.0.sp,
                                                                                    fontFamily: 'Poppins',
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: const Color(0x99000000),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        : Text(
                                                                            '₹${relatedProduct.productPrices![0].price ?? '0'}',
                                                                            style:
                                                                                MyGoogleFontStyle(
                                                                              fontFamily: 'Poppins',
                                                                              fontSize: 13.0.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: const Color(0x99000000),
                                                                            ),
                                                                          ),
                                                                  ),
                                                                if (relatedDiscount !=
                                                                    0.0)
                                                                  Text(
                                                                    '(${relatedDiscount.round()}% Off)',
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
                                                                // Rating and Reviews
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top: 4.0
                                                                              .w),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      relatedProduct.rating == null ||
                                                                              relatedProduct.rating ==
                                                                                  '0'
                                                                          ? Text(
                                                                              "No Rating",
                                                                              style: TextStyle(fontSize: 10.0.sp),
                                                                            )
                                                                          : RatingBar
                                                                              .builder(
                                                                              itemSize: 15.0.sp,
                                                                              initialRating: double.tryParse(relatedProduct.rating ?? '0.0') ?? 0.0,
                                                                              direction: Axis.horizontal,
                                                                              itemCount: 5,
                                                                              allowHalfRating: true,
                                                                              ignoreGestures: true,
                                                                              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                                                                              onRatingUpdate: (double value) {},
                                                                            ),
                                                                      if (relatedProduct
                                                                              .rating !=
                                                                          '0')
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: 4.0.w),
                                                                          child:
                                                                              Text(
                                                                            '(${relatedProduct.totalReviews ?? 0})',
                                                                            style:
                                                                                TextStyle(fontSize: 10.0.sp),
                                                                          ),
                                                                        ),
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
                    child: TextButton(
                      onPressed: () async {
                        if (currentPackQty <= 0) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0.r)),
                              title: Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: Colors.orange, size: 24.0.sp),
                                  SizedBox(width: 10.0.w),
                                  Expanded(
                                    child: Text(
                                      'Out of Stock',
                                      style: TextStyle(
                                        fontSize: 18.0.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                'Sorry, this product is currently out of stock. Please try selecting a different size or check back later.',
                                style: TextStyle(fontSize: 14.0.sp),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                        color: const Color(0xFFC7B456),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0.sp),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (_cartData['kindOfFlower'] == '' ||
                            _cartData['flavour'] == '') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0.r)),
                              title: Text(
                                _cartData['kindOfFlower'] == '' &&
                                        _cartData['flavour'] != ''
                                    ? 'Kindly choose size.'
                                    : _cartData['flavour'] == '' &&
                                            _cartData['kindOfFlower'] != ''
                                        ? 'Kindly choose colour.'
                                        : 'Kindly choose colour and size.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Ok',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.0.sp),
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
                                      widget.arguments!['product']['id'] &&
                                  cart.flavour == _cartData['flavour'] &&
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
                              builder: (dialogContext) => StatefulBuilder(
                                builder: (dialogContext, setDialogState) =>
                                    AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0.r)),
                                  title: Text('Add to Cart'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          'This item is not in your cart. Please select quantity:'),
                                      SizedBox(height: 10),
                                      Text('Maximum available: $currentPackQty',
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
                                                    BorderRadius.circular(5),
                                              ),
                                              child:
                                                  Icon(Icons.remove, size: 20),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                              tempQuantity.toString(),
                                              style: TextStyle(
                                                fontSize: 18.0.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          // Hide plus button when quantity reaches available stock
                                          if (tempQuantity < currentPackQty)
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
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child:
                                                    Icon(Icons.add, size: 20),
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
                                        if (currentPackQty > 0 && tempQuantity > currentPackQty) {
                                          ScaffoldMessenger.of(parentContext).showSnackBar(
                                            SnackBar(
                                              content: Text('Only $currentPackQty items available in stock'),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                          return;
                                        }

                                        Navigator.pop(
                                            dialogContext); // Close dialog

                                        // Add to cart with selected quantity
                                        _cartData['points'] = _productPoints;

                                        // Set product price safely
                                        if (_prices.isNotEmpty) {
                                          final offerPrice =
                                              _prices[0]['offer_price'];
                                          final price = _prices[0]['price'];

                                          _cartData['product_price'] =
                                              (offerPrice != null &&
                                                      offerPrice != 0)
                                                  ? offerPrice.toString()
                                                  : (price?.toString() ?? '0');
                                        } else {
                                          _cartData['product_price'] = '0';
                                        }
                                        _cartData['is_add_to_cart'] = true;

                                        // Pass available quantity for validation
                                        _cartData['available_qty'] = currentPackQty;

                                        // Add item to cart with quantity
                                        // First add the item to cart
                                        await addToCartModel.getAddToCart(
                                            widget.arguments!['product']['id'],
                                            true,
                                            _cartData);

                                        // If user selected more than 1, add additional quantities
                                        if (tempQuantity > 1) {
                                          // Add the remaining quantity by calling the API multiple times
                                          // The API increments by 1 each time when type=true
                                          for (int i = 1;
                                              i < tempQuantity;
                                              i++) {
                                            await addToCartModel.getAddToCart(
                                                widget.arguments!['product']
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
                                              builder: (context) => CartPage(
                                                  isProfile: {
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
                                builder: (context) =>
                                    CartPage(isProfile: {'isProfile': false}),
                              ),
                            );
                          }
                        }
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
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
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// Isolated widget for product descriptions that won't rebuild on parent state changes
class ProductDescriptionSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (product.smallDescription != null)
          RepaintBoundary(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.w),
              child: Card(
                elevation: 4,
                color: Colors.white,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: PreservedHtmlWidget(
                    key: smallDescKey,
                    uniqueKey: 'small_desc_${product.id}',
                    data: product.smallDescription.toString(),
                  ),
                ),
              ),
            ),
          ),
        if (product.description != null)
          RepaintBoundary(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.w),
              child: Card(
                elevation: 4,
                color: Colors.white,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: PreservedHtmlWidget(
                    key: descKey,
                    uniqueKey: 'desc_${product.id}',
                    data: product.description.toString(),
                  ),
                ),
              ),
            ),
          ),
        if (product.description1 != null)
          RepaintBoundary(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.w),
              child: Card(
                elevation: 4,
                color: Colors.white,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: PreservedHtmlWidget(
                    key: desc1Key,
                    uniqueKey: 'desc1_${product.id}',
                    data: product.description1.toString(),
                  ),
                ),
              ),
            ),
          ),
        if (product.description2 != null)
          RepaintBoundary(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.w),
              child: Card(
                elevation: 4,
                color: Colors.white,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: PreservedHtmlWidget(
                    key: desc2Key,
                    uniqueKey: 'desc2_${product.id}',
                    data: product.description2.toString(),
                  ),
                ),
              ),
            ),
          ),
      ],
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/product.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/core/providers/wish_list_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/products/product_id_p.dart';
import 'package:aadab/ui/views/checkout/cart_p.dart';
import 'package:aadab/ui/widgets/login_required_popup.dart';
import 'package:badges/badges.dart' as badges;
import 'dart:async';

class ShopsPage extends StatefulWidget {
  final String? initialText;

  const ShopsPage({Key? key, this.initialText}) : super(key: key);

  @override
  State<ShopsPage> createState() => ShopsPageState();
}

class ShopsPageState extends State<ShopsPage> {
  Map<String, dynamic> _cartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': '',
    'points': '',
    'is_add_to_cart': false
  };
  List<Product>? filteredProducts;
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  int activeIndex = -1;
  bool _isLoading = true;
  bool _isSearching = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      _controller.text = widget.initialText!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final productModel = context.read<ProductModel>();
      final wishListModel = context.read<WishListModel>();
      final addToCartModel = context.read<AddToCartModel>();
      final configModel = context.read<ConfigModel>();

      // Create list of futures based on user authentication status
      List<Future<void>> futures = [
        productModel.getAllProducts(widget.initialText ?? '') as Future<void>,
        // productModel.getCategories() as Future<void>,
      ];

      // Only fetch user-specific data if user is logged in
      if (configModel.user != null) {
        futures.addAll([
          wishListModel.getWishLists('') as Future<void>,
          addToCartModel.getAddToCart('', '', _cartData) as Future<void>,
        ]);
      }

      await Future.wait<void>(futures);

      setState(() {
        filteredProducts = productModel.allProducts?.toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load products. Please try again.';
      });
    }
  }

  Future<void> _searchProducts(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        _isSearching = true;
        _errorMessage = null;
      });

      try {
        final productModel = context.read<ProductModel>();
        await productModel.getAllProducts(query);

        setState(() {
          filteredProducts = productModel.allProducts?.toList();
          _isSearching = false;
        });
      } catch (e) {
        setState(() {
          _isSearching = false;
          _errorMessage = 'Failed to search products. Please try again.';
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configModel = locator<ConfigModel>();
    final productModel = context.watch<ProductModel>();
    final addToCartModel = context.watch<AddToCartModel>();
    final wishListModel = context.watch<WishListModel>();

    final cartCount = addToCartModel.addToCarts?.length ?? 0;

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
          child: _isLoading
              ? Center(
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
                        'Loading Products...',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff232323),
                        ),
                      ),
                    ],
                  ),
                )
              : _errorMessage != null
                  ? SizedBox(
                      height: 1.0.sh,
                      width: 1.0.sw,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_errorMessage!,
                                style: const TextStyle(color: Colors.red)),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchInitialData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFEED056),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchInitialData,
                      color: Color(0xFFEED056),
                      child: SizedBox(
                        width: 1.0.sw,
                        height: 1.0.sh,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                9.0.w, 16.0.w, 9.0.w, 22.0.w),
                            width: 1.0.sw,
                            constraints: BoxConstraints(minHeight: 1.0.sh),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTopSection(context, cartCount),
                                SizedBox(height: 2.0.w),
                                _buildCategoriesSection(context, productModel),
                                if (_isSearching)
                                  Container(
                                    height: 200,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFFEED056)),
                                      ),
                                    ),
                                  )
                                else
                                  _buildProductList(
                                      context, configModel, wishListModel),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, int cartCount) {
    return Container(
      margin: EdgeInsets.only(left: 10.0.w, bottom: 20.0.w, right: 10.0.w),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Browse Products',
              textAlign: TextAlign.center,
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 20.0.sp,
                fontWeight: FontWeight.w700,
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
                        color: Color(0xFFEED056).withOpacity(0.15),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 4.0.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0.r),
                    border: Border.all(
                      color: Color(0xFFEED056).withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFEED056).withOpacity(0.08),
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        child: Icon(
                          Icons.search,
                          color: Color(0xFFEED056),
                          size: 20.0.sp,
                        ),
                      ),
                      Center(
                        child: TextFormField(
                          controller: _controller,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            _searchProducts(value);
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
                            fontWeight: FontWeight.w500,
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
                  final configModel = locator<ConfigModel>();
                  if (configModel.user == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          LoginRequiredPopupWidget(),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CartPage(isProfile: {'isProfile': false}),
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
                        color: Color(0xFFEED056).withOpacity(0.15),
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
                      padding: EdgeInsets.all(4),
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xFFEED056),
                      size: 20.0.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(
      BuildContext context, ProductModel productModel) {
    return Container(
      height: 44,
      margin: EdgeInsets.only(bottom: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All" button
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = -1;
                filteredProducts = productModel.allProducts?.toList();
                _controller.clear();
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: activeIndex == -1
                    ? LinearGradient(
                        colors: [Color(0xFFD4C76A), Color(0xFFC7B456)],
                      )
                    : LinearGradient(
                        colors: [Colors.white, Color(0xFFFFFDF7)],
                      ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: activeIndex == -1
                      ? Colors.transparent
                      : Color(0xFFE0E0E0),
                  width: 1,
                ),
                boxShadow: activeIndex == -1
                    ? [
                        BoxShadow(
                          color: Color(0xFFC7B456).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.grid_view_rounded,
                    size: 16,
                    color: activeIndex == -1 ? Colors.white : Color(0xFF888888),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'All',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          activeIndex == -1 ? Colors.white : Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Category buttons
          ...List.generate(
            productModel.categories?.length ?? 0,
            (index) {
              final isActive = index == activeIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    activeIndex = index;
                    filteredProducts = productModel.allProducts
                        ?.where((cat) =>
                            cat.categoryId ==
                            productModel.categories![index]['id'])
                        .toList();
                    _controller.clear();
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            colors: [Color(0xFFD4C76A), Color(0xFFC7B456)],
                          )
                        : LinearGradient(
                            colors: [Colors.white, Color(0xFFFFFDF7)],
                          ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive ? Colors.transparent : Color(0xFFE0E0E0),
                      width: 1,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: Color(0xFFC7B456).withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Text(
                    productModel.categories![index]['name']?.toString() ?? '',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : Color(0xFF666666),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context, ConfigModel configModel,
      WishListModel wishListModel) {
    return Container(
      margin: EdgeInsets.fromLTRB(12.0.w, 0, 12.0.w, 0),
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: filteredProducts?.isNotEmpty ?? false
          ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 1 / 1.5,
                maxCrossAxisExtent: 200.0.w,
                mainAxisSpacing: 12.0.w,
                crossAxisSpacing: 12.0.w,
              ),
              itemCount: filteredProducts!.length,
              itemBuilder: (context, index) {
                final product = filteredProducts![index];
                double discountPrice = 0.0;

                if (product.productPrices?.isNotEmpty ?? false) {
                  final price = int.tryParse(
                          product.productPrices![0].price?.toString() ?? '0') ??
                      0;
                  final offerPrice = int.tryParse(
                          product.productPrices![0].offerPrice?.toString() ??
                              '0') ??
                      0;

                  if (price > 0 && offerPrice > 0 && offerPrice < price) {
                    discountPrice = ((price - offerPrice) / price * 100);
                  }
                }

                return _buildProductCard(context, configModel, wishListModel,
                    product, discountPrice);
              },
            )
          : SizedBox(
              height: 0.5.sh,
              child: const Center(child: Text('No products found.')),
            ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ConfigModel configModel,
    WishListModel wishListModel,
    Product product,
    double discountPrice,
  ) {
    final isInWishlist = wishListModel.wishLists!
        .where((wishList) =>
            wishList.productId == product.id &&
            wishList.userId == configModel.user?.id)
        .isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductIdPage(
              arguments: {
                'product': product.toJson(),
                'product_images': product.productImages,
              },
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFFFFDF7)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFEED056).withOpacity(0.12),
              blurRadius: 15,
              offset: Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 6,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(0xFFF8F8F8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      product.productImages?.isNotEmpty ?? false
                          ? Image.network(
                              '${configModel.apiConfig['mediaURL']}${product.productImages!.first.imagepath}',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(Icons.image_rounded,
                                    color: Colors.grey[300], size: 40),
                              ),
                            )
                          : Center(
                              child: Icon(Icons.image_rounded,
                                  color: Colors.grey[300], size: 40),
                            ),
                      // Wishlist button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () async {
                            await wishListModel.getWishLists(product.id);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isInWishlist
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color:
                                  isInWishlist ? Colors.red : Color(0xFF888888),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      // Discount badge
                      if (discountPrice > 0)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${discountPrice.round()}% OFF',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Product Details
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 4, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name ?? 'Unnamed Product',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        height: 1.3,
                      ),
                    ),
                    Spacer(),
                    // Price Row
                    if (product.productPrices?.isNotEmpty ?? false)
                      Row(
                        children: [
                          Text(
                            '₹${product.productPrices![0].offerPrice ?? product.productPrices![0].price}',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFC7B456),
                            ),
                          ),
                          if (product.productPrices![0].offerPrice != null &&
                              product.productPrices![0].offerPrice != 0 &&
                              product.productPrices![0].price !=
                                  product.productPrices![0].offerPrice) ...[
                            SizedBox(width: 6),
                            Text(
                              '₹${product.productPrices![0].price}',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                    SizedBox(height: 6),
                    // Rating Row
                    Row(
                      children: [
                        if (product.rating != null &&
                            product.rating != '0') ...[
                          Icon(Icons.star_rounded,
                              color: Colors.amber, size: 14),
                          SizedBox(width: 4),
                          Text(
                            product.rating ?? '0',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF666666),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '(${product.totalReviews ?? 0})',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 11,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ] else
                          Text(
                            'No reviews yet',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 11,
                              color: Color(0xFFAAAAAA),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

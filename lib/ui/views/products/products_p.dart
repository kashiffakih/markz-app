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

import 'package:aadab/ui/widgets/common_product_card.dart';

import 'package:badges/badges.dart' as badges;
import 'dart:async';

class ProductsPage extends StatefulWidget {
  final arguments;

  const ProductsPage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Map<String, dynamic> _cartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': '',
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
      print('Product page cart data $_cartData');
      await Future.wait<void>([
        productModel.getCategoryWiseProduct(widget.arguments['categoryId'], '')
            as Future<void>,
        productModel.getCategories() as Future<void>,
        wishListModel.getWishLists('') as Future<void>,
        addToCartModel.getAddToCart('', '', _cartData) as Future<void>,
      ]);

      setState(() {
        filteredProducts = productModel.categoryWiseproducts
            ?.where((element) =>
                element.categoryId == widget.arguments['categoryId'])
            .toList();
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
        await productModel.getCategoryWiseProduct(
            widget.arguments['categoryId'], query);

        setState(() {
          filteredProducts = productModel.categoryWiseproducts
              ?.where((element) =>
                  element.categoryId == widget.arguments['categoryId'])
              .toList();
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
                            width: 1.0.sw,
                            constraints: BoxConstraints(minHeight: 1.0.sh),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTopSection(context, cartCount),
                                SizedBox(height: 20.0.w),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Expanded(
                child: Text(
                  'Shop ${widget.arguments['category'] ?? 'Category'}',
                  textAlign: TextAlign.center,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/cartPage'),
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
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 2.0.w),
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
                SizedBox(width: 12.0.w),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    textAlign: TextAlign.start,
                    onChanged: (value) {
                      _searchProducts(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 14.0.sp,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      isDense: true,
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
                filteredProducts = productModel.categoryWiseproducts
                    ?.where((element) =>
                        element.categoryId == widget.arguments['categoryId'])
                    .toList();
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
            widget.arguments['subCategory']?.length ?? 0,
            (index) {
              final isActive = index == activeIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    activeIndex = index;
                    filteredProducts = productModel.categoryWiseproducts
                        ?.where((cat) =>
                            cat.subCategoryId ==
                            widget.arguments['subCategory'][index]['id'])
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
                    widget.arguments['subCategory'][index]['name']
                            ?.toString() ??
                        '',
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
                childAspectRatio:
                    0.52, // Matches home page card ratio (width/height ≈ 145w/0.35sh)
                maxCrossAxisExtent: 180.0.w,
                mainAxisSpacing: 12.0.w,
                crossAxisSpacing: 12.0.w,
              ),
              itemCount: filteredProducts!.length,
              itemBuilder: (context, index) {
                final product = filteredProducts![index];
                double discountPrice = 0.0;

                if (product.productPrices?.isNotEmpty ?? false) {
                  final configModel = context.watch<ConfigModel>();
                  final isDistributor = configModel.activeRole == 'Distributor';
                  final priceObj = product.productPrices![0];

                  double price =
                      double.tryParse(priceObj.price?.toString() ?? '0') ?? 0;
                  double offerPrice =
                      double.tryParse(priceObj.offerPrice?.toString() ?? '0') ??
                          0;

                  if (isDistributor) {
                    double? distPrice = double.tryParse(
                        priceObj.distributorPrice?.toString() ?? '');
                    double? distOfferPrice = double.tryParse(
                        priceObj.distributorOfferPrice?.toString() ?? '');

                    if (distPrice != null && distPrice > 0) price = distPrice;
                    if (distOfferPrice != null && distOfferPrice > 0)
                      offerPrice = distOfferPrice;
                  }

                  if (price > 0 && offerPrice > 0 && offerPrice < price) {
                    discountPrice = ((price - offerPrice) / price * 100);
                  }
                }

                return CommonProductCard(
                  product: product,
                  discountPrice: discountPrice,
                );
              },
            )
          : SizedBox(
              height: 0.5.sh,
              child: const Center(child: Text('No products found.')),
            ),
    );
  }
}

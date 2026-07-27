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

import 'package:aadab/ui/views/checkout/cart_p.dart';
import 'package:aadab/ui/widgets/login_required_popup.dart';
import 'package:aadab/ui/widgets/common_product_card.dart';
import 'package:badges/badges.dart' as badges;
import 'package:aadab/core/providers/notification_pr.dart';
import 'package:aadab/ui/views/profile/notifications_p.dart';
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
      bottomNavigationBar: _buildBottomNavigationBar(
          context, configModel, addToCartModel, cartCount),
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
                            padding: EdgeInsets.fromLTRB(0.w, 0.w, 0.w, 22.0.w),
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
                'Browse Products',
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
                    textAlign: TextAlign.start, // Left aligned
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

                  double price = 0;
                  double offerPrice = 0;

                  if (isDistributor) {
                    double? distPrice = double.tryParse(
                        priceObj.distributorPrice?.toString() ?? '');
                    double? distOfferPrice = double.tryParse(
                        priceObj.distributorOfferPrice?.toString() ?? '');

                    if (distPrice != null && distPrice > 0) {
                      price = distPrice;
                      if (distOfferPrice != null && distOfferPrice > 0) {
                        offerPrice = distOfferPrice;
                      }
                    }
                  } else {
                    price = double.tryParse(priceObj.price?.toString() ?? '0') ?? 0;
                    offerPrice = double.tryParse(priceObj.offerPrice?.toString() ?? '0') ?? 0;
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

  Widget _buildBottomNavigationBar(
    BuildContext context,
    ConfigModel configModel,
    AddToCartModel addToCartModel,
    int cartCount,
  ) {
    const double _bottomNavBarHeight = 90.0;
    const double _bottomNavIconSize = 24.0;
    return Container(
      height: _bottomNavBarHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEED056).withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 0,
            offset: Offset(0, -8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: Color(0xFFEED056).withOpacity(0.2),
            width: 1.5,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFEED056),
          unselectedItemColor: Color(0xFF909090),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          currentIndex: 1, // Set 'Category' as active (Index 1)
          selectedLabelStyle: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500,
          ),
          onTap: (value) =>
              _handleBottomNavTap(context, value, configModel, addToCartModel),
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Image.asset('assets/images/home-icon.png',
                  width: _bottomNavIconSize,
                  height: _bottomNavIconSize,
                  color: Color(0xFF909090)), // Explicitly grey
            ),
            BottomNavigationBarItem(
              label: 'Category',
              icon: Image.asset('assets/images/category-icon.png',
                  width: _bottomNavIconSize,
                  height: _bottomNavIconSize,
                  color: Color(0xFFEED056)), // Active (Yellow)
            ),
            BottomNavigationBarItem(
              label: 'Cart',
              icon: badges.Badge(
                badgeContent: Text('$cartCount',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Color(0xFFEED056),
                  padding: EdgeInsets.all(6),
                ),
                child: Image.asset('assets/images/cart-icon.png',
                    width: _bottomNavIconSize,
                    height: _bottomNavIconSize,
                    color: Color(0xFF909090)), // Explicitly grey
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Image.asset('assets/images/user-profile-icon.png',
                  width: _bottomNavIconSize,
                  height: _bottomNavIconSize,
                  color: Color(0xFF909090)), // Explicitly grey
            ),
            BottomNavigationBarItem(
              label: 'Notifs',
              icon: Consumer<NotificationModel>(
                builder: (context, notifModel, child) {
                  return badges.Badge(
                    showBadge: notifModel.systemUnreadCount > 0,
                    badgeContent: Text(
                      '${notifModel.systemUnreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: Color(0xFFEED056),
                      padding: EdgeInsets.all(6),
                    ),
                    child: Image.asset(
                      'assets/images/notification-icon.png',
                      width: _bottomNavIconSize,
                      height: _bottomNavIconSize,
                      color: Color(0xFF909090),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBottomNavTap(
    BuildContext context,
    int value,
    ConfigModel configModel,
    AddToCartModel addToCartModel,
  ) async {
    if (value == 0) {
      Navigator.pushNamed(context, '/homePage');
    } else if (value == 1) {
      // Already on Category/Shop page
    } else if (value == 2) {
      if (configModel.user == null) {
        showDialog(
            context: context, builder: (context) => LoginRequiredPopupWidget());
      } else {
        await addToCartModel.getAddToCart('', '', {});
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const CartPage(isProfile: {'isProfile': false})),
        );
      }
    } else if (value == 3 && configModel.user != null) {
      Navigator.pushNamed(context, '/profilePage');
    } else if (value == 4 && configModel.user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationsPage(sendBy: 'System'),
        ),
      );
    } else {
      showDialog(
          context: context, builder: (context) => LoginRequiredPopupWidget());
    }
  }
}

import 'package:aadab/ui/views/checkout/cart_p.dart';
import 'package:aadab/ui/views/products/products_p.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/product.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/core/providers/wish_list_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/core/services/order_s.dart';

import 'package:aadab/ui/views/products/shops_p.dart';
import 'package:badges/badges.dart' as badges;
import 'package:aadab/ui/widgets/image_zoom_w.dart';
import 'package:aadab/ui/widgets/login_required_popup.dart';
import 'package:aadab/ui/widgets/welcome_bonus_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aadab/core/providers/auth_pr.dart';
import 'package:aadab/ui/widgets/common_product_card.dart';
import 'package:aadab/core/providers/notification_pr.dart';
import 'package:aadab/ui/views/profile/notifications_p.dart';
import 'package:aadab/core/services/offline_order_s.dart';
import 'package:aadab/core/providers/order_pr.dart';
import 'package:aadab/core/models/add_to_cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // UI Constants
  static const double _bannerCarouselHeightRatio = 0.3;
  static const double _newArrivalsHeightRatio = 0.40;
  static const double _inviteBannerHeight = 180.0;
  static const double _bottomNavBarHeight = 90.0;
  static const int _bottomNavIconSize = 23;

  final TextEditingController _controller = TextEditingController();
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final ConfigModel configModel = locator<ConfigModel>();

  List<String> bannerUrls = [];
  int _current = 0;
  bool _isLoading = true;
  bool _isRetrying = false;
  String? _errorMessage;

  Map<String, dynamic> _cartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': '',
    'is_add_to_cart': false
  };

  @override
  void initState() {
    super.initState();
    _initializeData();
    _checkAndShowWelcomeBonus();
    _retryFailedOrders();
  }

  Future<void> _retryFailedOrders() async {
    if (_isRetrying) return;
    _isRetrying = true;

    try {
      final offlineService = locator<OfflineOrderService>();
      final failedOrders = await offlineService.getFailedOrders();
      if (failedOrders.isEmpty) return;

      final orderModel = Provider.of<OrderModel>(context, listen: false);
      
      // Iterate backwards so removing items doesn't mess up indices
      for (int i = failedOrders.length - 1; i >= 0; i--) {
        final orderData = failedOrders[i];
        
        List<AddToCart> cartItems = [];
        if (orderData['cartItems'] != null) {
          cartItems = (orderData['cartItems'] as List).map((e) => AddToCart.fromJson(e)).toList();
        }
        
        if (orderData['isConfirmPayment'] == true) {
          final response = await orderModel.confirmPayment(
            orderId: orderData['orderId'], 
            txnId: orderData['txnId'] ?? '', 
            paymentMode: orderData['paymentOption'] ?? 'Online Payment'
          );
          if (response) {
             await offlineService.removeFailedOrder(i);
          }
        } else {
          final response = await orderModel.placedOrder(
            cartItems,
            orderData['cartTotal'],
            orderData['addressId'],
            orderData['isGift'],
            orderData['userWalletUsed'],
            orderData['couponId'],
            orderData['paymentOption'],
            orderData['deliveryMethod'],
            orderData['couponValue'],
            orderData['gstAmount'],
            orderData['platformFee'],
            orderData['gstNumber'],
          );
          
          if (response != null && response is Map && response['success'] == true) {
            await offlineService.removeFailedOrder(i);
          } else if (response == true) { // Fallback for any old bool returns
            await offlineService.removeFailedOrder(i);
          }
        }
      }
    } catch (e) {
      debugPrint("Error retrying failed orders: $e");
    } finally {
      _isRetrying = false;
    }
  }

  Future<void> _checkAndShowWelcomeBonus() async {
    final configModel = locator<ConfigModel>();

    // Wait for user data to be available
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Check if user is logged in
    if (configModel.user != null) {
      // ONLY for newly registered users (isRegisterBonusSeen == 0)
      if ((configModel.user!.isRegisterBonusSeen ?? 0) == 0) {
        // 1. Show Reward (Welcome Bonus) Popup
        await _showWelcomeBonusDialog(configModel);

        if (!mounted) return;

        // 2. Show Referral Popup right after Reward popup is closed
        await _checkAndShowReferralPrompt(configModel);
      }
    }
  }

  Future<void> _checkAndShowReferralPrompt(ConfigModel configModel) async {
    if (configModel.user?.id == null) return;

    final prefs = await SharedPreferences.getInstance();
    final String promptKey = 'has_seen_referral_prompt_${configModel.user!.id}';
    if (prefs.getBool(promptKey) == true) {
      return;
    }
    await prefs.setBool(promptKey, true);

    // Only proceed if user hasn't been referred yet
    if (configModel.user?.referedById == null) {
      String? pendingCode = prefs.getString('pending_referral_code');

      // Remove the code so it doesn't persist forever if ignored
      if (pendingCode != null) {
        await prefs.remove('pending_referral_code');
      }

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            final TextEditingController _codeController =
                TextEditingController(text: pendingCode ?? '');
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEED056).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.card_giftcard_rounded,
                        color: const Color(0xFFEED056),
                        size: 32.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Title
                    Text(
                      'Have a Referral Code?',
                      textAlign: TextAlign.center,
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E232C),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Subtitle
                    Text(
                      'Enter it below to claim your bonus!',
                      textAlign: TextAlign.center,
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF8391A1),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Input Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEED056).withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.withOpacity(0.1)),
                      ),
                      child: TextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          hintText: 'Enter Referral Code',
                          hintStyle: TextStyle(
                            color: Color(0xFF8391A1),
                            fontFamily: 'Urbanist',
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          prefixIcon: Icon(
                            Icons.confirmation_number_outlined,
                            color: Color(0xFFEED056),
                            size: 20.sp,
                          ),
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E232C),
                        ),
                        cursorColor: const Color(0xFFEED056),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                            },
                            child: Text(
                              'Skip',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8391A1),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_codeController.text.trim().isEmpty) return;
                              Navigator.pop(context); // Close dialog first

                              // Show loading
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(
                                    child: CircularProgressIndicator(
                                        color: Color(0xFFEED056))),
                              );

                              final authModel = Provider.of<AuthModel>(context,
                                  listen: false);
                              final result =
                                  await authModel.authService.mapReferrer(
                                referralCode: _codeController.text.trim(),
                                userId: configModel.user!.id!,
                              );

                              Navigator.pop(context); // Close loading

                              if (result['success']) {
                                // Refresh valid user data to reflect changes
                                // await configModel.getUserData(); // Optional if needed immediately

                                // Show Success Popup (Hurray!)
                                if (mounted) {
                                  _showWelcomeBonusDialog(configModel);
                                }
                              } else {
                                // Show Error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      result['message'] ?? 'Invalid Code',
                                      style: TextStyle(fontFamily: 'Urbanist'),
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEED056),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Submit',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }

  Future<void> _showWelcomeBonusDialog(ConfigModel configModel) async {
    final userName = configModel.user?.firstName ?? 'User';
    final productModel = context.read<ProductModel>();
    if (productModel.banners == null) {
      await productModel.getBanners();
    }

    // Get register bonus from settings, default to 100 if not available
    int bonusPoints = 0;
    if (productModel.banners != null &&
        productModel.banners!['register_bonus'] != null) {
      bonusPoints =
          int.tryParse(productModel.banners!['register_bonus'].toString()) ?? 0;
    }

    await showWelcomeBonusPopup(
      context: context,
      userName: userName,
      bonusPoints: bonusPoints,
    );

    // Mark welcome bonus as shown in API
    if (mounted) {
      final authModel = Provider.of<AuthModel>(context, listen: false);
      authModel.authService.markRegisterBonusSeen();

      // Mark welcome bonus as shown locally (legacy or for session)
      configModel.setWelcomeBonusShown(true);
    }
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final productModel = context.read<ProductModel>();

      await Future.wait<dynamic>([
        productModel.getCategories(),
        productModel.getBanners(),
        productModel.getTags(),
        productModel.getRandomProducts(),
        if (configModel.user != null) ...[
          context.read<WishListModel>().getWishLists(''),
          context.read<AddToCartModel>().getAddToCart('', '', _cartData),
          context.read<NotificationModel>().fetchUnreadCount(),
        ],
      ]);

      final bannerList = [
        'banner_path_1',
        'banner_path_2',
        'banner_path_3',
        'banner_path_11',
        'banner_path_12',
        'banner_path_13',
      ]
          .where((path) => productModel.banners?[path] != null)
          .map((path) =>
              '${configModel.apiConfig['mediaURL']}${productModel.banners![path]}')
          .toList();

      if (mounted) {
        setState(() {
          bannerUrls = bannerList;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load data. Please try again.';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateDiscountPercentage(Product product) {
    if (product.productPrices?.isNotEmpty ?? false) {
      final priceObj = product.productPrices![0];
      final isDistributor = configModel.activeRole == 'Distributor';

      dynamic priceValue;
      dynamic offerPriceValue;

      if (isDistributor) {
        if (priceObj.distributorPrice != null &&
            priceObj.distributorPrice! > 0) {
          priceValue = priceObj.distributorPrice;
          offerPriceValue = (priceObj.distributorOfferPrice != null &&
                  priceObj.distributorOfferPrice! > 0)
              ? priceObj.distributorOfferPrice
              : 0;
        } else {
          return 0.0;
        }
      } else {
        priceValue = priceObj.price;
        offerPriceValue = priceObj.offerPrice;
      }

      if (priceValue == null || offerPriceValue == null) {
        return 0.0;
      }

      final price = int.tryParse(priceValue.toString()) ?? 0;
      final offerPrice = int.tryParse(offerPriceValue.toString()) ?? 0;

      if (price > 0 && offerPrice > 0 && price > offerPrice) {
        return ((price - offerPrice) / price * 100);
      }
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final productModel = context.watch<ProductModel>();
    final wishListModel = context.watch<WishListModel>();
    final addToCartModel = context.watch<AddToCartModel>();

    final cartCount = addToCartModel.addToCarts?.length ?? 0;

    return Scaffold(
      key: _key,
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) {
            SystemNavigator.pop();
          }
        },
        child: Container(
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFEED056)),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF232323),
                          ),
                        ),
                      ],
                    ),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_errorMessage!,
                                style: const TextStyle(color: Colors.red)),
                            ElevatedButton(
                              onPressed: _initializeData,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            _buildHeader(context),
                            const SizedBox(height: 16),
                            _buildCategories(
                                context, productModel, configModel),
                            // const SizedBox(height: 16),
                            _buildBannerCarousel(context),
                            // const SizedBox(height: 16),

                            if (productModel.tags != null)
                              ...productModel.tags!.map((tag) {
                                if (tag.products != null &&
                                    tag.products!.isNotEmpty) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 16),
                                      _buildTagSection(context, tag,
                                          wishListModel, configModel),
                                    ],
                                  );
                                }
                                return SizedBox.shrink();
                              }).toList(),
                            if (productModel.randomProducts != null &&
                                productModel.randomProducts!.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              _buildTagSection(
                                  context,
                                  Tags(
                                      name: 'Discover More',
                                      products: productModel.randomProducts),
                                  wishListModel,
                                  configModel),
                            ],
                            const SizedBox(height: 16),
                            _buildInviteBanner(context, configModel),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(
          context, configModel, addToCartModel, cartCount),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi!',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    configModel.user?.firstName ?? '', // Placeholder
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (configModel.user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NotificationsPage(sendBy: 'Admin'),
                      ),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => LoginRequiredPopupWidget());
                  }
                },
                child: Consumer<NotificationModel>(
                  builder: (context, notifModel, child) {
                    return badges.Badge(
                      showBadge: notifModel.adminUnreadCount > 0,
                      badgeContent: Text(
                        '${notifModel.adminUnreadCount}',
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
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.notifications_none,
                            color: Colors.white, size: 22.sp),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20.w),
          _buildSearchBar(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      width: double.infinity,
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
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShopsPage(initialText: value)),
                  ).then((_) => _controller.clear());
                }
              },
              decoration: InputDecoration(
                hintText: 'Search for products...',
                hintStyle: TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 14.sp,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.w),
              ),
              style: TextStyle(
                color: Color(0xff232323),
                fontSize: 14.sp,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: _bannerCarouselHeightRatio.sh,
          child: CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              onPageChanged: (index, _) => setState(() => _current = index),
            ),
            items: bannerUrls
                .map((url) => _buildBannerItem(context, url))
                .toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bannerUrls.asMap().entries.map((entry) {
            bool isActive = _current == entry.key;
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: isActive ? 28.0.w : 8.0.w,
                height: 8.0.w,
                margin:
                    EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 4.0.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0.r),
                  color: isActive
                      ? Color(0xFFEED056)
                      : Color(0xFFEED056).withOpacity(0.3),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Color(0xFFEED056).withOpacity(0.4),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBannerItem(BuildContext context, String url) {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => ImageScreen(image: url))),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.error, size: 50, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(
    BuildContext context,
    ProductModel productModel,
    ConfigModel configModel,
  ) {
    // Horizontal Categories (Stories style)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shop By Category',
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff232323),
                ),
              ),
              SizedBox(height: 6.0.w),
              Container(
                height: 4.0.w,
                width: 60.0.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFEED056),
                      Color(0xFFEED056).withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2.0.r),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.w),
        SizedBox(
          height: 115.w,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            scrollDirection: Axis.horizontal,
            itemCount: productModel.categories?.length ?? 0,
            separatorBuilder: (context, index) => SizedBox(width: 15.w),
            itemBuilder: (context, index) {
              final category = productModel.categories![index];
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductsPage(arguments: {
                      'categoryId': category['id'],
                      'subCategory': category['sub_categories'],
                      'category': category['name'].toString(),
                    }),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 150.w,
                      height: 75.w,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12.0.r),
                        border: Border.all(
                          color: Color(0xFFEED056), // Gold border
                          width: 2,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0.r),
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            image: NetworkImage(
                              '${configModel.apiConfig['mediaURL']}${category['imagepath']}',
                            ),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {},
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.w),
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        category['name'] ?? 'Category',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff1e232c),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Removed _buildCategoryItem as it's no longer used

  Widget _buildInviteBanner(BuildContext context, ConfigModel configModel) {
    return Container(
      width: double.infinity,
      height: _inviteBannerHeight.h,
      margin: EdgeInsets.only(
        top: 20.0.h,
      ),
      padding: EdgeInsets.all(10.0.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0.r),
        color: const Color(0x33eecf56),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0.r),
                color: const Color(0x33eecf56),
              ),
            ),
          ),
          Positioned(
            left: 268.130859375.w,
            top: 84.827545166.h,
            child: Image.asset(
              'assets/images/group-46.png',
              width: 81.72.w,
              height: 65.17.h,
            ),
          ),
          Positioned(
            left: 324.5180664062.w,
            top: 15.5172424316.h,
            child: Image.asset(
              'assets/images/ellipse-25.png',
              width: 5.34.w,
              height: 5.17.h,
            ),
          ),
          Positioned(
            left: 2.1362304688.w,
            top: 37.2411804199.h,
            child: Image.asset(
              'assets/images/ellipse-32.png',
              width: 8.82.w,
              height: 8.54.h,
            ),
          ),
          Positioned(
            left: 334.1323242188.w,
            top: 26.8965454102.h,
            child: Image.asset(
              'assets/images/ellipse-27.png',
              width: 11.75.w,
              height: 11.38.h,
            ),
          ),
          Positioned(
            left: 16.0239257812.w,
            top: 2.0690307617.h,
            child: Image.asset(
              'assets/images/ellipse-33.png',
              width: 16.38.w,
              height: 15.86.h,
            ),
          ),
          Positioned(
            left: 311.69921875.w,
            top: 41.3793029785.h,
            child: Image.asset(
              'assets/images/ellipse-26.png',
              width: 18.16.w,
              height: 17.59.h,
            ),
          ),
          Positioned(
            left: 329.859375.w,
            top: 66.2068786621.h,
            child: Image.asset(
              'assets/images/ellipse-34.png',
              width: 14.96.w,
              height: 14.48.h,
            ),
          ),
          Positioned(
            left: 290.333984375.w,
            top: 66.2068786621.h,
            child: Image.asset(
              'assets/images/ellipse-34.png',
              width: 11.75.w,
              height: 11.38.h,
            ),
          ),
          Positioned(
            left: 24.5698242188.w,
            top: 18.6206817627.h,
            child: SizedBox(
              width: 252.0.w,
              height: 60.0.h,
              child: Text(
                'Invite a Friend and earn Plantify rewards',
                style: MyGoogleFontStyle(
                  fontFamily: 'Philosopher',
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.2400000095,
                  color: const Color(0xff000000),
                ),
              ),
            ),
          ),
          Positioned(
            left: 28.8427734375.w,
            top: 95.1724243164.h,
            child: SizedBox(
              width: 135.0.w,
              height: 30.0.h,
              child: Text(
                'Redeem them to get instant discounts',
                style: MyGoogleFontStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.0.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.1538461538,
                  color: const Color(0xff888888),
                ),
              ),
            ),
          ),
          Positioned(
            left: 190.1484375.w,
            top: 95.1724243164.h,
            child: TextButton(
              onPressed: () async {
                final message =
                    'Hello! Use my referral code *${configModel.user?.referralCode}* to get instant discounts on the Markz App! 🎁\n\nDownload here: https://play.google.com/store/apps/details?id=com.crazzycode.aadab&hl=en_IN';
                final whatsappUrl =
                    'whatsapp://send?text=${Uri.encodeComponent(message)}';
                try {
                  await launchUrl(Uri.parse(whatsappUrl));
                } catch (e) {
                  debugPrint('Error launching WhatsApp: $e');
                }
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: const Color(0xffeecf56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0.r)),
              ),
              child: SizedBox(
                width: 64.09.w,
                height: 31.03.h,
                child: Center(
                  child: Text(
                    'Invite',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.0.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    ConfigModel configModel,
    AddToCartModel addToCartModel,
    int cartCount,
  ) {
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
                  width: _bottomNavIconSize.toDouble(),
                  height: _bottomNavIconSize.toDouble(),
                  color: Color(0xFFEED056)), // Home is yellow
            ),
            BottomNavigationBarItem(
              label: 'Category',
              icon: Image.asset('assets/images/category-icon.png',
                  width: _bottomNavIconSize.toDouble(),
                  height: _bottomNavIconSize.toDouble(),
                  color: Color(0xFF909090)), // Explicitly grey
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
                    width: _bottomNavIconSize.toDouble(),
                    height: _bottomNavIconSize.toDouble(),
                    color: Color(0xFF909090)), // Explicitly grey
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Image.asset('assets/images/user-profile-icon.png',
                  width: _bottomNavIconSize.toDouble(),
                  height: _bottomNavIconSize.toDouble(),
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
                      width: _bottomNavIconSize.toDouble(),
                      height: _bottomNavIconSize.toDouble(),
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ShopsPage(initialText: '')));
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

  Widget _buildTagSection(
    BuildContext context,
    Tags tag,
    WishListModel wishListModel,
    ConfigModel configModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.0.w, 0.w, 20.0.w, 16.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tag.name ?? '',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff232323),
                    ),
                  ),
                  SizedBox(height: 6.0.w),
                  Container(
                    height: 4.0.w,
                    width: 60.0.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFEED056),
                          Color(0xFFEED056).withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2.0.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: _newArrivalsHeightRatio.sh,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 8.0.w),
            itemCount: tag.products!.length,
            itemBuilder: (context, index) {
              final product = tag.products![index];
              // print("product: ${product.productPrices!.first.toJson()}");
              final discountPrice = _calculateDiscountPercentage(product);
              return Padding(
                padding: EdgeInsets.only(right: 12.0.w),
                child: CommonProductCard(
                  product: product,
                  discountPrice: discountPrice,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

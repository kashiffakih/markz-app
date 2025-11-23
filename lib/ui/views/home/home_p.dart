import 'package:aadab/ui/views/checkout/cart_p.dart';
import 'package:aadab/ui/views/products/products_p.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
import 'package:aadab/ui/views/products/shops_p.dart';
import 'package:aadab/ui/widgets/drawer_w.dart';
import 'package:badges/badges.dart' as badges;
import 'package:aadab/ui/widgets/image_zoom_w.dart';
import 'package:aadab/ui/widgets/login_required_popup.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // UI Constants
  static const double _productCardWidth = 145.0;
  static const double _productCardImageHeight = 184.0;
  static const double _searchBarWidthRatio = 0.75;
  static const double _searchBarHeightRatio = 0.05;
  static const double _bannerCarouselHeightRatio = 0.3;
  static const double _newArrivalsHeightRatio = 0.4;
  static const double _categoryHeightRatio = 0.15;
  static const double _inviteBannerHeight = 180.0;
  static const double _bottomNavBarHeight = 70.0;
  static const int _bottomNavIconSize = 23;
  static const double _carouselIndicatorSize = 12.0;
  static const double _ratingStarSize = 15.0;

  final TextEditingController _controller = TextEditingController();
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  List<String> bannerUrls = [];
  int _current = 0;
  bool _isLoading = true;
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
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final configModel = locator<ConfigModel>();
      final productModel = context.read<ProductModel>();

      await Future.wait<dynamic>([
        productModel.getProduct(),
        productModel.getCategories(),
        productModel.getBanners(),
        if (configModel.user != null) ...[
          context.read<WishListModel>().getWishLists(''),
          context.read<AddToCartModel>().getAddToCart('', '', _cartData),
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
      final priceValue = product.productPrices![0].price;
      final offerPriceValue = product.productPrices![0].offerPrice;

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
    final configModel = locator<ConfigModel>();
    final productModel = context.watch<ProductModel>();
    final wishListModel = context.watch<WishListModel>();
    final addToCartModel = context.watch<AddToCartModel>();

    final cartCount = addToCartModel.addToCarts?.length ?? 0;

    return Scaffold(
      key: _key,
      drawer: DrawerWidget(),
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
                            const SizedBox(height: 20),
                            _buildSearchBar(context),
                            const SizedBox(height: 16),
                            _buildBannerCarousel(context),
                            const SizedBox(height: 8),
                            _buildNewArrivals(context, productModel,
                                wishListModel, configModel),
                            const SizedBox(height: 8),
                            _buildCategories(
                                context, productModel, configModel),
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

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      width: _searchBarWidthRatio.sw,
      height: _searchBarHeightRatio.sh,
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 4.0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0.r),
        border:
            Border.all(color: Color(0xFFEED056).withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEED056).withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Color(0xFFEED056),
            size: 22.0.sp,
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
                  fontSize: 15.sp,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                color: Color(0xff232323),
                fontSize: 15.sp,
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
      child: SizedBox(
        width: 0.8.sw,
        child: Image.network(
          url,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, size: 50),
        ),
      ),
    );
  }

  Widget _buildNewArrivals(
    BuildContext context,
    ProductModel productModel,
    WishListModel wishListModel,
    ConfigModel configModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.0.w, 16.0.w, 20.0.w, 16.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Arrivals',
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
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 8.0.w),
                decoration: BoxDecoration(
                  color: Color(0xFFEED056).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20.0.r),
                  border: Border.all(
                    color: Color(0xFFEED056).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fiber_new,
                        size: 16.sp, color: Color(0xFFEED056)),
                    SizedBox(width: 4.0.w),
                    Text(
                      'Fresh',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF232323),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: _newArrivalsHeightRatio.sh,
          child: productModel.productsLoader
              ? const Center(child: CircularProgressIndicator())
              : productModel.products?.isEmpty ?? true
                  ? const Center(child: Text('No new arrivals'))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                      itemCount: productModel.products!.length,
                      itemBuilder: (context, index) {
                        final product = productModel.products![index];
                        final discountPrice =
                            _calculateDiscountPercentage(product);
                        return _buildProductCard(context, product,
                            wishListModel, configModel, discountPrice);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    WishListModel wishListModel,
    ConfigModel configModel,
    double discountPrice,
  ) {
    final isWishListed = configModel.user != null &&
        wishListModel.wishLists?.any((wishList) =>
                wishList.productId == product.id &&
                wishList.userId == configModel.user!.id) ==
            true;

    return Container(
      width: _productCardWidth.w,
      margin: EdgeInsets.only(right: 12.0.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEED056).withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: _productCardImageHeight.h,
            child: Stack(
              children: [
                InkWell(
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
                  child: Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0.r),
                        color: const Color(0x0c000000),
                        image: product.productImages?.isNotEmpty ?? false
                            ? DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  '${configModel.apiConfig['mediaURL']}${product.productImages!.first.imagepath}',
                                ),
                              )
                            : const DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage('assets/images/placeholder.png'),
                              ),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(10.0.w),
                          child: InkWell(
                            onTap: () async {
                              if (configModel.user == null) {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        LoginRequiredPopupWidget());
                              } else {
                                await wishListModel.getWishLists(product.id);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
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
                                isWishListed
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isWishListed
                                    ? Colors.red
                                    : Color(0xFF909090),
                                size: 18.0.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
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
              margin: EdgeInsets.fromLTRB(10.0.w, 4.0.h, 10.0.w, 2.0.h),
              constraints: BoxConstraints(maxWidth: 123.0.w),
              child: Text(
                product.name ?? 'Unnamed Product',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  letterSpacing: -0.3.w,
                  color: const Color(0xff000000),
                ),
              ),
            ),
          ),
          if (product.productPrices?.isNotEmpty ?? false)
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 2.0.h),
              child: product.productPrices![0].offerPrice != null &&
                      product.productPrices![0].offerPrice != 0
                  ? Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '₹${product.productPrices![0].price}',
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 13.0.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' ₹${product.productPrices![0].offerPrice}',
                            style: TextStyle(
                              color: const Color(0x99000000),
                              fontSize: 13.0.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      '₹${product.productPrices![0].price}',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.0.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        letterSpacing: -0.2190869331.w,
                        color: const Color(0x99000000),
                      ),
                    ),
            ),
          if (discountPrice != 0.0)
            Text(
              '(${discountPrice.round()}% Off)',
              style: MyGoogleFontStyle(
                fontFamily: 'Poppins',
                fontSize: 13.0.sp,
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: -0.2190869331.w,
                color: const Color(0x99000000),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: 2.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                product.rating == null || product.rating == '0'
                    ? Text(
                        "No Rating",
                        style: TextStyle(fontSize: 10.0.sp),
                      )
                    : RatingBar.builder(
                        itemSize: _ratingStarSize.sp,
                        initialRating:
                            double.tryParse(product.rating ?? '0.0') ?? 0.0,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        allowHalfRating: true,
                        ignoreGestures: true,
                        itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (double value) {},
                      ),
                if (product.rating != '0')
                  Padding(
                    padding: EdgeInsets.only(left: 4.0.w),
                    child: Text(
                      '(${product.totalReviews ?? 0} Review${(product.totalReviews ?? 0) == 1 ? '' : 's'})',
                      style: TextStyle(fontSize: 10.0.sp),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(
    BuildContext context,
    ProductModel productModel,
    ConfigModel configModel,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.0.w, 16.0.w, 20.0.w, 16.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                    width: 80.0.w,
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
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 8.0.w),
                decoration: BoxDecoration(
                  color: Color(0xFFEED056).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20.0.r),
                  border: Border.all(
                    color: Color(0xFFEED056).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.category_rounded,
                        size: 16.sp, color: Color(0xFFEED056)),
                    SizedBox(width: 4.0.w),
                    Text(
                      'Browse',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF232323),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ...?productModel.categories?.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final category = entry.value;
            return Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 5.0.h),
              child: InkWell(
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
                child:
                    _buildCategoryItem(context, category, configModel, index),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    Map<String, dynamic> category,
    ConfigModel configModel,
    int index,
  ) {
    final isEvenIndex = index % 2 == 0;
    return Container(
      height: _categoryHeightRatio.sh,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0.r),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEED056).withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0.r),
        child: Stack(
          children: [
            Image.network(
              '${configModel.apiConfig['mediaURL']}${category['imagepath']}',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 50),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(isEvenIndex ? 1 : -1, 0.138),
                  end: Alignment(isEvenIndex ? -1 : 1, 0.128),
                  colors: const [Color(0x99000000), Color(0x00d9d9d9)],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: isEvenIndex ? 230.0.w : 22.0.w,
                  top: isEvenIndex ? 33.5.h : 39.5.h),
              child: Column(
                crossAxisAlignment: isEvenIndex
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: isEvenIndex ? 100.0.w : 200.0.w,
                    child: Text(
                      category['name'] ?? 'Unnamed Category',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.31.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '${category['products'].length} Items',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Poppins',
                      fontSize: 9.16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteBanner(BuildContext context, ConfigModel configModel) {
    return Container(
      width: double.infinity,
      height: _inviteBannerHeight.h,
      margin: EdgeInsets.only(top: 20.0.h, left: 12.0.w, right: 12.0.w),
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
                    'Hello! This is my referral Code ${configModel.user?.referralCode} Redeem them to get instant discounts.';
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
                  height: _bottomNavIconSize.toDouble()),
            ),
            BottomNavigationBarItem(
              label: 'Category',
              icon: Image.asset('assets/images/category-icon.png',
                  width: _bottomNavIconSize.toDouble(),
                  height: _bottomNavIconSize.toDouble()),
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
                    height: _bottomNavIconSize.toDouble()),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Image.asset('assets/images/user-profile-icon.png',
                  width: _bottomNavIconSize.toDouble(),
                  height: _bottomNavIconSize.toDouble()),
            ),
            BottomNavigationBarItem(
              label: 'Notifs',
              icon: Image.asset('assets/images/notification-icon.png',
                  width: _bottomNavIconSize.toDouble(),
                  height: _bottomNavIconSize.toDouble()),
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
      Navigator.pushNamed(context, '/notificationPage');
    } else {
      showDialog(
          context: context, builder: (context) => LoginRequiredPopupWidget());
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseWidth = 360;
    final double fem = screenWidth / baseWidth;
    final double ffem = fem * 0.97;

    final configModel = locator<ConfigModel>();
    final productModel = context.watch<ProductModel>();
    final addToCartModel = context.watch<AddToCartModel>();
    final wishListModel = context.watch<WishListModel>();

    final cartCount = addToCartModel.addToCarts?.length ?? 0;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? SizedBox(
                height: screenHeight,
                width: screenWidth,
                child: const Center(child: CircularProgressIndicator()),
              )
            : _errorMessage != null
                ? SizedBox(
                    height: screenHeight,
                    width: screenWidth,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_errorMessage!,
                              style: const TextStyle(color: Colors.red)),
                          ElevatedButton(
                            onPressed: _fetchInitialData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchInitialData,
                    child: SizedBox(
                      width: screenWidth,
                      height: screenHeight,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              9 * fem, 16 * fem, 9 * fem, 22 * fem),
                          width: screenWidth,
                          constraints: BoxConstraints(minHeight: screenHeight),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTopSection(context, fem, ffem, cartCount),
                              SizedBox(height: 2 * fem),
                              _buildCategoriesSection(
                                  context, fem, ffem, productModel),
                              if (_isSearching)
                                SizedBox(
                                  height: screenHeight * 0.5,
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                )
                              else
                                _buildProductList(context, fem, ffem,
                                    configModel, wishListModel),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildTopSection(
      BuildContext context, double fem, double ffem, int cartCount) {
    return Container(
      margin:
          EdgeInsets.only(left: 20 * fem, bottom: 20 * fem, right: 30 * fem),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/homePage'),
            child: Center(
              child: Text(
                'Shops',
                textAlign: TextAlign.center,
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 18 * ffem,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1e232c),
                ),
              ),
            ),
          ),
          SizedBox(height: 15 * fem),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios,
                    size: 18 * ffem, color: const Color(0xffEED056)),
              ),
              SizedBox(width: 10 * fem),
              Expanded(
                child: Container(
                  height: 38 * fem,
                  padding: EdgeInsets.only(left: 21 * fem, right: 20.70 * fem),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 0.50, color: Color(0xFFC7B456)),
                      borderRadius: BorderRadius.circular(10 * fem),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controller,
                          onChanged: (value) {
                            _searchProducts(value);
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 18 * ffem,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Image.asset('assets/images/Search-1.png',
                          height: 20 * fem, fit: BoxFit.cover),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10 * fem),
              InkWell(
                onTap: () {
                  if (context.read<ConfigModel>().user == null) {
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
                child: badges.Badge(
                  badgeContent: Text(cartCount.toString(),
                      style: const TextStyle(color: Colors.white)),
                  child: Image.asset('assets/images/cart-icon.png',
                      width: 23 * fem, height: 23 * fem),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context, double fem, double ffem,
      ProductModel productModel) {
    return Container(
      height: 35 * fem,
      padding: EdgeInsets.symmetric(horizontal: 9 * fem),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                activeIndex = -1;
                filteredProducts = productModel.allProducts?.toList();
                _controller.clear();
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: activeIndex == -1 ? Colors.black : Colors.white,
            ),
            child: Container(
              width: 55 * fem,
              height: double.infinity,
              decoration: BoxDecoration(
                border: activeIndex == -1
                    ? null
                    : Border.all(color: const Color(0xffc7b456)),
                borderRadius: BorderRadius.circular(15 * fem),
              ),
              child: Center(
                child: Text(
                  'All',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 15 * ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: -0.36 * fem,
                    color: activeIndex == -1 ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 5 * fem),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productModel.categories?.length ?? 0,
              itemBuilder: (context, index) {
                final isActive = index == activeIndex;
                return Padding(
                  padding: EdgeInsets.only(right: 6 * fem),
                  child: TextButton(
                    onPressed: () {
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
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: isActive ? Colors.black : Colors.white,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10 * fem),
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffc7b456)),
                        borderRadius: BorderRadius.circular(15 * fem),
                      ),
                      child: Center(
                        child: Text(
                          productModel.categories![index]['name']?.toString() ??
                              '',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            letterSpacing: -0.36 * fem,
                            color: isActive
                                ? Colors.white
                                : const Color(0x99000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context, double fem, double ffem,
      ConfigModel configModel, WishListModel wishListModel) {
    return Container(
      margin: EdgeInsets.fromLTRB(12 * fem, 0, 12 * fem, 0),
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: filteredProducts?.isNotEmpty ?? false
          ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 1 / 2,
                maxCrossAxisExtent: 200 * fem,
                mainAxisSpacing: 12 * fem,
                crossAxisSpacing: 12 * fem,
              ),
              itemCount: filteredProducts!.length,
              itemBuilder: (context, index) {
                final product = filteredProducts![index];
                final discountPrice = product.productPrices?.isNotEmpty ?? false
                    ? ((int.parse(product.productPrices![0].price.toString()) -
                            int.parse(product.productPrices![0].offerPrice
                                .toString())) /
                        int.parse(product.productPrices![0].price.toString()) *
                        100)
                    : 0.0;

                return _buildProductCard(context, fem, ffem, configModel,
                    wishListModel, product, discountPrice);
              },
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: const Center(child: Text('No products found.')),
            ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    double fem,
    double ffem,
    ConfigModel configModel,
    WishListModel wishListModel,
    Product product,
    double discountPrice,
  ) {
    return Container(
      width: 145 * fem,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15 * fem),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 210.33 * fem,
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
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // width: 145 * fem,
                      // height: 193 * fem,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15 * fem),
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
                          padding: EdgeInsets.all(8 * fem),
                          child: InkWell(
                            onTap: () async {
                              await wishListModel.getWishLists(product.id);
                            },
                            child: wishListModel.wishLists!
                                    .where((wishList) =>
                                        wishList.productId == product.id &&
                                        wishList.userId == configModel.user?.id)
                                    .isEmpty
                                ? Icon(Icons.favorite_border_outlined,
                                    size: 20 * ffem)
                                : Icon(Icons.favorite_outlined,
                                    color: Colors.red, size: 20 * ffem),
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
              margin: EdgeInsets.fromLTRB(10 * fem, 8 * fem, 10 * fem, 4 * fem),
              constraints: BoxConstraints(maxWidth: 123 * fem),
              child: Text(
                product.name ?? 'Unnamed Product',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 15 * ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  letterSpacing: -0.3 * fem,
                  color: const Color(0xff000000),
                ),
              ),
            ),
          ),
          if (product.productPrices?.isNotEmpty ?? false)
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 4 * fem),
              child: product.productPrices![0].offerPrice != 0
                  ? Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '₹${product.productPrices![0].price}',
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 13 * ffem,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' ₹${product.productPrices![0].offerPrice}',
                            style: TextStyle(
                              color: const Color(0x99000000),
                              fontSize: 13 * ffem,
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
                        fontSize: 13 * ffem,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        letterSpacing: -0.2190869331 * fem,
                        color: const Color(0x99000000),
                      ),
                    ),
            ),
          if (discountPrice != 0.0)
            Text(
              '(${discountPrice.round()}% Off)',
              style: MyGoogleFontStyle(
                fontFamily: 'Poppins',
                fontSize: 13 * ffem,
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: -0.2190869331 * fem,
                color: const Color(0x99000000),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: 4 * fem),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                product.rating == null || product.rating == '0'
                    ? Text(
                        "No Rating",
                        style: TextStyle(fontSize: 10 * ffem),
                      )
                    : RatingBar.builder(
                        itemSize: 15 * ffem,
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
                    padding: EdgeInsets.only(left: 4 * fem),
                    child: Text(
                      '(${product.totalReviews} Review${product.totalReviews == 1 ? '' : 's'})',
                      style: TextStyle(fontSize: 10 * ffem),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:aadab/ui/views/checkout/cart_p.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/core/providers/wish_list_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/products/product_id_p.dart';
import 'package:aadab/ui/views/products/products_p.dart';
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
  TextEditingController _controller = TextEditingController();
  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': ''
  };

  // late PageController _pageController;

  List<String> bannerUrls = [];
  int _current = 0;
  final CarouselSliderController _carousalController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    final ConfigModel _configModel = locator<ConfigModel>();
    // print(_configModel.user?.referedById);
    // Fetch banners and other data after widget build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Fetch product data
      await Provider.of<ProductModel>(context, listen: false).getProduct();

      // Fetch wishlist data
      var productId = '';
      if (_configModel.user != null) {
        await Provider.of<WishListModel>(context, listen: false)
            .getWishLists(productId);
        await Provider.of<AddToCartModel>(context, listen: false)
            .getAddToCart(productId, '', _CartData);
      }

      // Fetch categories data
      await Provider.of<ProductModel>(context, listen: false).getCategories();

      // Fetch cart data

      var productModel = Provider.of<ProductModel>(context, listen: false);
      await productModel.getBanners();

      // print(productModel.banners?.length);
      // Fetch and build banners
      var bannerList = [
        productModel.banners?['banner_path_1'] != null
            ? _configModel.apiConfig['mediaURL'] +
                productModel.banners!['banner_path_1'].toString()
            : null,
        productModel.banners?['banner_path_2'] != null
            ? _configModel.apiConfig['mediaURL'] +
                productModel.banners!['banner_path_2'].toString()
            : null,
        productModel.banners?['banner_path_3'] != null
            ? _configModel.apiConfig['mediaURL'] +
                productModel.banners!['banner_path_3'].toString()
            : null,
        productModel.banners?['banner_path_11'] != null
            ? _configModel.apiConfig['mediaURL'] +
                productModel.banners!['banner_path_11'].toString()
            : null,
        productModel.banners?['banner_path_12'] != null
            ? _configModel.apiConfig['mediaURL'] +
                productModel.banners!['banner_path_12'].toString()
            : null,
        productModel.banners?['banner_path_13'] != null
            ? _configModel.apiConfig['mediaURL'] +
                productModel.banners!['banner_path_13'].toString()
            : null,
      ]
          .where((imageUrl) => imageUrl != null) // Filter out null values
          .map((imageUrl) => imageUrl as String) // Explicitly cast to String
          .toList();

      // Set banner URLs
      setState(() {
        bannerUrls = bannerList;
      });
      // print("banners : $bannerUrls");
    });
  }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ConfigModel _configModel = locator<ConfigModel>();
    final ProductModel _productModel =
        Provider.of<ProductModel>(context, listen: false);
    final WishListModel _wishListModel =
        Provider.of<WishListModel>(context, listen: false);
    final AddToCartModel _addToCartModel =
        Provider.of<AddToCartModel>(context, listen: false);

    double discountPrice = 0.0;

    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    var cartCount = 0;
    setState(() {
      cartCount = _addToCartModel.addToCarts == null
          ? 0
          : _addToCartModel.addToCarts!.length;
    });

    return Scaffold(
      key: _key,
      drawer: DrawerWidget(),
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false; // Prevent the default back button behavior
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                // Banner
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.05,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 0.50, color: Color(0xFFC7B456)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // Center vertically
                        children: [
                          Expanded(
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
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 18,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w600,
                                // letterSpacing: -0.36,
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
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: CarouselSlider(
                    carouselController: _carousalController,
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      padEnds: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                    items: bannerUrls.map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ImageScreen(image: url),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.3, // Adjust the height as needed
                              width: MediaQuery.of(context).size.width *
                                  0.8, // Adjust the height as needed
                              child: Image.network(
                                url,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bannerUrls.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _carousalController.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),

                // End Banner

                // New Arrivals
                Container(
                  child: Center(
                    child: Image.asset(
                      'assets/images/NewArrivals.png',
                      width: 500.58 * fem,
                      height: 60.58 * fem,
                    ),
                  ),
                ),
                _productModel.productsLoader
                    ? LinearProgressIndicator()
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.33,
                        child: _productModel.productsLoader
                            ? SizedBox(
                                child: Center(child: Text('No new arrivals')),
                              )
                            : ListView.builder(
                                // padding:
                                //     const EdgeInsets.only(left: 5, right: 8),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: _productModel.products!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.45,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15 * fem),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductIdPage(arguments: {
                                                    'product': _productModel
                                                        .products![index]
                                                        .toJson(),
                                                    'product_images':
                                                        _productModel
                                                            .products![index]
                                                            .productImages
                                                  }),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem,
                                                  0 * fem,
                                                  0 * fem,
                                                  5 * fem),
                                              padding: EdgeInsets.fromLTRB(
                                                  106 * fem,
                                                  13 * fem,
                                                  14 * fem,
                                                  15 * fem),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.26,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15 * fem),
                                                image: DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: NetworkImage(
                                                      _configModel.apiConfig[
                                                              'mediaURL'] +
                                                          _productModel
                                                              .products![index]
                                                              .productImages
                                                              ?.first
                                                              .imagepath
                                                              .toString()),
                                                ),
                                              ),
                                              child: InkWell(
                                                onTap: () async {
                                                  if (_configModel.user ==
                                                      null) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          LoginRequiredPopupWidget(),
                                                    );
                                                    // Show error dialog when user is null
                                                  } else {
                                                    // Fetch wishlist for a specific product
                                                    await _wishListModel
                                                        .getWishLists(
                                                            _productModel
                                                                .products![
                                                                    index]
                                                                .id);
                                                  }
                                                },
                                                child: Container(
                                                  width: 50,
                                                  child: Builder(
                                                    builder: (context) {
                                                      if (_configModel
                                                              .user?.id ==
                                                          null) {
                                                        // If user ID is null, show default icon
                                                        return const Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Icon(Icons
                                                              .favorite_border_outlined),
                                                        );
                                                      }

                                                      if (_wishListModel
                                                          .wishListLoader) {
                                                        // Show loading state
                                                        return const Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Icon(Icons
                                                              .favorite_border_outlined),
                                                        );
                                                      }

                                                      // Check if the product is in the user's wishlist
                                                      bool isWishListed = _wishListModel
                                                          .wishLists!
                                                          .any((wishList) =>
                                                              wishList.productId ==
                                                                  _productModel
                                                                      .products![
                                                                          index]
                                                                      .id &&
                                                              wishList.userId ==
                                                                  _configModel
                                                                      .user!
                                                                      .id);

                                                      // Return the appropriate icon based on wishlist status
                                                      return Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Icon(
                                                          isWishListed
                                                              ? Icons
                                                                  .favorite_outlined
                                                              : Icons
                                                                  .favorite_border_outlined,
                                                          color: isWishListed
                                                              ? Colors.red
                                                              : null,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductIdPage(
                                                              arguments: {
                                                                'product': _productModel
                                                                    .products![
                                                                        index]
                                                                    .toJson(),
                                                                'category': _productModel
                                                                    .products![
                                                                        index]
                                                                    .category!
                                                                    .name
                                                                    .toString(),
                                                              })));
                                            },
                                            child: Container(
                                              child: Text(
                                                _productModel
                                                    .products![index].name
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 15 * ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.2 * ffem / fem,
                                                  letterSpacing: -0.3 * fem,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: _productModel
                                                        .products![index]
                                                        .productPrices![0]
                                                        .offerPrice !=
                                                    0
                                                ? Text.rich(TextSpan(children: [
                                                    new TextSpan(
                                                      text:
                                                          '₹${_productModel.products![index].productPrices![0].price.toString()}',
                                                      style: new TextStyle(
                                                        color: Colors.grey,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                    new TextSpan(
                                                      text:
                                                          ' ₹${_productModel.products![index].productPrices![0].offerPrice.toString()}',
                                                    ),
                                                  ]))
                                                : Text(
                                                    _productModel
                                                            .products![index]
                                                            .productPrices![0]
                                                            .price
                                                            .toString() +
                                                        " " +
                                                        '₹',
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.5,
                                                      letterSpacing:
                                                          -0.2190869331,
                                                      color: Color(0x99000000),
                                                    ),
                                                  ),
                                          ),
                                          if (discountPrice != 0.0)
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
                      ),
                // End New Arrivals
                SizedBox(
                  height: 10,
                ),
                // Category
                Container(
                  height: 20,
                  child: Center(
                    child: Image.asset(
                      'assets/images/ShopByCategory.png',
                    ),
                  ),
                ),
                Container(
                  // width: 345 * fem,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ..._productModel.categories!
                          .map(
                            (_category) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ProductsPage(arguments: {
                                            'categoryId': _category['id'],
                                            'subCategory':
                                                _category['sub_categories'],
                                            'category':
                                                _category['name'].toString()
                                          })));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        // image24Suc (318:1963)
                                        left: 0 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 344 * fem,
                                            height: 106.69 * fem,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10 * fem),
                                              child: Image.network(
                                                _configModel
                                                        .apiConfig['mediaURL'] +
                                                    _category['imagepath']
                                                        .toString(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // rectangle2422kfQ (318:1964)
                                        left: 0 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 344 * fem,
                                            height: 107 * fem,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.1176462173 * fem),
                                                gradient: _category['id'] % 2 ==
                                                        0
                                                    ? LinearGradient(
                                                        begin:
                                                            Alignment(1, 0.138),
                                                        end: Alignment(
                                                            -1, 0.128),
                                                        colors: <Color>[
                                                          Color(0x99000000),
                                                          Color(0x00d9d9d9)
                                                        ],
                                                        stops: <double>[0, 1],
                                                      )
                                                    : LinearGradient(
                                                        begin: Alignment(
                                                            -1, 0.138),
                                                        end:
                                                            Alignment(1, 0.128),
                                                        colors: <Color>[
                                                          Color(0x99000000),
                                                          Color(0x00d9d9d9)
                                                        ],
                                                        stops: <double>[0, 1],
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (_category['id'] % 2 != 0)
                                        Positioned(
                                          left: 22 * fem,
                                          top: 39.5 * fem,
                                          child: Container(
                                            width: 200 * fem,
                                            height: 48.31 * fem,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 0 * fem,
                                                  top: 0 * fem,
                                                  child: Align(
                                                    child: SizedBox(
                                                      width: 200 * fem,
                                                      height: 30 * fem,
                                                      child: Text(
                                                        _category['name'],
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize:
                                                              18.3132514954 *
                                                                  ffem,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height:
                                                              1.5 * ffem / fem,
                                                          color:
                                                              Color(0xffffffff),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 2.7470703125 * fem,
                                                  top: 24.3071899414 * fem,
                                                  child: Align(
                                                    child: SizedBox(
                                                      width: 38 * fem,
                                                      height: 14 * fem,
                                                      child: Text(
                                                        _category['products']
                                                                .length
                                                                .toString() +
                                                            ' Items',
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize:
                                                              9.1566257477 *
                                                                  ffem,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height:
                                                              1.5 * ffem / fem,
                                                          color:
                                                              Color(0xffffffff),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      if (_category['id'] % 2 == 0)
                                        Positioned(
                                          left: 230 * fem,
                                          top: 33.5 * fem,
                                          child: Container(
                                            width: 100 * fem,
                                            height: 38.31 * fem,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 0 * fem,
                                                  top: 0 * fem,
                                                  child: Align(
                                                    child: SizedBox(
                                                      width: 250 * fem,
                                                      height: 28 * fem,
                                                      child: Text(
                                                        _category['name'],
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize:
                                                              18.3132514954 *
                                                                  ffem,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height:
                                                              1.5 * ffem / fem,
                                                          color:
                                                              Color(0xffffffff),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 2.7470703125 * fem,
                                                  top: 24.3071899414 * fem,
                                                  child: Align(
                                                    child: SizedBox(
                                                      width: 38 * fem,
                                                      height: 14 * fem,
                                                      child: Text(
                                                        _category['products']
                                                                .length
                                                                .toString() +
                                                            ' Items',
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize:
                                                              9.1566257477 *
                                                                  ffem,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height:
                                                              1.5 * ffem / fem,
                                                          color:
                                                              Color(0xffffffff),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
                // End Category

                // Last Banner
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 180 * fem,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5 * fem),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 360 * fem,
                            height: 150 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                color: Color(0x33eecf56),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // group46Ler (318:1938)
                        left: 268.130859375 * fem,
                        top: 84.827545166 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 81.72 * fem,
                            height: 65.17 * fem,
                            child: Image.asset(
                              'assets/images/group-46.png',
                              width: 81.72 * fem,
                              height: 65.17 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse25pa2 (318:1944)
                        left: 324.5180664062 * fem,
                        top: 15.5172424316 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 5.34 * fem,
                            height: 5.17 * fem,
                            child: Image.asset(
                              'assets/images/ellipse-25.png',
                              width: 5.34 * fem,
                              height: 5.17 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse32Kmg (318:1945)
                        left: 2.1362304688 * fem,
                        top: 37.2411804199 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 8.82 * fem,
                            height: 8.54 * fem,
                            child: Image.asset(
                              'assets/images/ellipse-32.png',
                              width: 8.82 * fem,
                              height: 8.54 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse27Edk (318:1946)
                        left: 334.1323242188 * fem,
                        top: 26.8965454102 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 11.75 * fem,
                            height: 11.38 * fem,
                            child: Image.asset(
                              'assets/images/ellipse-27.png',
                              width: 11.75 * fem,
                              height: 11.38 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse33MyG (318:1947)
                        left: 16.0239257812 * fem,
                        top: 2.0690307617 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 16.38 * fem,
                            height: 15.86 * fem,
                            child: Image.asset(
                              'assets/images/ellipse-33.png',
                              width: 16.38 * fem,
                              height: 15.86 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse26UY6 (318:1948)
                        left: 311.69921875 * fem,
                        top: 41.3793029785 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 18.16 * fem,
                            height: 17.59 * fem,
                            child: Image.asset(
                              'assets/images/ellipse-26.png',
                              width: 18.16 * fem,
                              height: 17.59 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse34PQA (318:1949)
                        left: 329.859375 * fem,
                        top: 66.2068786621 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 14.96 * fem,
                            height: 14.48 * fem,
                            child: Image.asset(
                              'assets/images/ellipse-34.png',
                              width: 14.96 * fem,
                              height: 14.48 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse35WUn (318:1950)
                        left: 290.333984375 * fem,
                        top: 66.2068786621 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 11.75 * fem,
                            height: 11.38 * fem,
                            child: Image.asset(
                              'assets/images/ellipse-34.png',
                              width: 11.75 * fem,
                              height: 11.38 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // inviteafriendandearnplantifyre (318:1951)
                        left: 24.5698242188 * fem,
                        top: 18.6206817627 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 252 * fem,
                            height: 60 * fem,
                            child: Text(
                              'Invite a Friend and earn Plantify rewards',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Philosopher',
                                fontSize: 24 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.2400000095 * ffem / fem,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // redeemthemtogetinstantdiscount (318:1952)
                        left: 28.8427734375 * fem,
                        top: 95.1724243164 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 135 * fem,
                            height: 30 * fem,
                            child: Text(
                              'Redeem them to get instant discounts',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.1538461538 * ffem / fem,
                                color: Color(0xff888888),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle59cAS (318:1953)
                        left: 190.1484375 * fem,
                        top: 95.1724243164 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 64.09 * fem,
                            height: 31.03 * fem,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5 * fem),
                                  color: Color(0xffeecf56),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 202.9672851562 * fem,
                        top: 99.655166626 * fem,
                        child: InkWell(
                          onTap: () {
                            final message =
                                'Hello! This is my referral Code ${_configModel.user?.referralCode.toString()} Redeem them to get instant discounts.';
                            var whatsappUrl = "whatsapp://send?" +
                                "text=${Uri.encodeComponent(message)}";
                            try {
                              launch(whatsappUrl);
                            } catch (e) {}
                          },
                          child: Align(
                            child: SizedBox(
                              width: 40 * fem,
                              height: 25 * fem,
                              child: Text(
                                'Invite',
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13 * ffem,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5 * ffem / fem,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // End Last Banner
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: 360,
        height: 70,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.50, color: Color(0xFFC7B456)),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 6,
            )
          ],
        ),
        child: BottomNavigationBar(
          elevation: 10,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(255, 249, 245, 225),
          // backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: (value) async {
            if (value == 0) {
              Navigator.pushNamed(context, '/homePage');
            }
            if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ShopsPage(initialText: ''), // Pass initialText if needed
                ),
              );
              // Navigator.pushNamed(context, '/shopsPage');
            }

            if (value == 2) {
              if (_configModel.user == null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => LoginRequiredPopupWidget(),
                );
                // Show error dialog when user is null
              } else {
                Map<String, dynamic> _CartData = {
                  'kindOfFlower': '',
                  'flavour': '',
                  'writeOnCake': '',
                  'pack': ''
                };
                await _addToCartModel.getAddToCart('', '', _CartData);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CartPage(isProfile: {'isProfile': false}),
                  ),
                );
              }
            }
            if (value == 3) {
              if (_configModel.user == null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => LoginRequiredPopupWidget(),
                );
                // Show error dialog when user is null
              } else {
                Navigator.pushNamed(context, '/profilePage');
              }
            }
            if (value == 4) {
              if (_configModel.user == null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => LoginRequiredPopupWidget(),
                );
                // Show error dialog when user is null
              } else {
                Navigator.pushNamed(context, '/notificationPage');
              }
            }
          },
          items: [
            BottomNavigationBarItem(
              label: 'HOME',
              icon: Image.asset(
                'assets/images/home-icon.png',
                width: 23,
                height: 23,
              ),
              // icon: Icon(DonIcons.wap_home, size: 23),
            ),
            BottomNavigationBarItem(
                label: 'CATEGORY',
                icon: Image.asset(
                  'assets/images/category-icon.png',
                  width: 23,
                  height: 23,
                )),
            BottomNavigationBarItem(
              label: 'CART',
              icon: badges.Badge(
                badgeContent: Text(
                  cartCount.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: Image.asset(
                  'assets/images/cart-icon.png',
                  width: 23,
                  height: 23,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: 'PROFILE',
              icon: Image.asset(
                'assets/images/user-profile-icon.png',
                width: 23,
                height: 23,
              ),
            ),
            BottomNavigationBarItem(
              label: 'NOTIFS',
              icon: Image.asset(
                'assets/images/notification-icon.png',
                width: 23,
                height: 23,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

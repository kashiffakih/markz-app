import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/core/providers/wish_list_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/products/shops_p.dart';
import 'package:aadab/ui/widgets/image_zoom_w.dart';
import 'package:aadab/ui/widgets/login_required_popup.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/models/product.dart';
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
  late ScrollController _scrollController;

  void initState() {
    super.initState();
    final ConfigModel _configModel = locator<ConfigModel>();
    print(widget.arguments);
    var productId = '';
    if (widget.arguments['product'] != null) {
      productId = widget.arguments['product']['id'].toString();
    }
    if (_configModel.user != null) {
      Provider.of<AddToCartModel>(context, listen: false)
          .getAddToCart(productId, '', _CartData);
      Provider.of<WishListModel>(context, listen: false).getWishLists('');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ProductModel>(context, listen: false)
          .getCategoryWiseProduct(widget.arguments!['product']['category_id']);
    });

    _format = DateFormat('yyyy-MM-dd');
    _scrollController = ScrollController();
    // _sizes = widget.arguments['product']['product_packs'];
  }

  int activeIndex = -1;

  bool isActive = false;
  final _formKey = GlobalKey<FormState>();
  DateFormat? _format;
  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '', // Unit Name
    'writeOnCake': '',
    'pack': ''
  };

  bool? check1 = false;

  double discountPrice = 0.0;
  String _productpoints = '';
  var unitName = '';
  var size = '';
  List<dynamic> productDisplayImages = [];
  List<dynamic> updateProductDisplayImages = [];

  var cartCount = 0;

  void scrollLeft() {
    if (_scrollController.hasClients) {
      final newOffset = (_scrollController.offset - 80)
          .clamp(0.0, _scrollController.position.maxScrollExtent);
      _scrollController.animateTo(newOffset,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void scrollRight() {
    if (_scrollController.hasClients) {
      final newOffset = (_scrollController.offset + 80)
          .clamp(0.0, _scrollController.position.maxScrollExtent);
      _scrollController.animateTo(newOffset,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel _configModel = locator<ConfigModel>();
    final ProductModel _productModel = Provider.of<ProductModel>(context);
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final WishListModel _wishListModel = Provider.of<WishListModel>(context);
    // final ReviewModel _reviewModel = Provider.of<ReviewModel>(context);

    setState(() {
      cartCount = _addToCartModel.addToCarts == null
          ? 0
          : _addToCartModel.addToCarts!.length;

      productDisplayImages = widget.arguments['product_images']
          // .where((image) => image.unit.name == unitName)
          .toList();

      _CartData['pack'] = productDisplayImages.first.id;

      if (unitName == '') {
        unitName = productDisplayImages[0].unit.name;
        _CartData['flavour'] = unitName;
      }
      if (_sizes.isEmpty) {
        _sizes = widget.arguments['product']['product_packs']
            .where((_pack) => _pack['unit']['name'] == unitName)
            .toList();
        _CartData['kind_of_flower'] = _sizes[0]['value'];
        size = _sizes[0]['value'];
      }
      print('sizeasd $size ');
      if (_prices.isEmpty) {
        _prices = widget.arguments['product']['product_prices']
            .where((_price) => _price['product_pack_id'] == _sizes[0]['id'])
            .toList();
      }
    });
    Product product = Product.fromJson(widget.arguments['product']);

    // Set<dynamic> seen = {};
    // List<Map<String, dynamic>> _s =
    //     _sizes.where((item) => seen.add(item['unit']['name'])).toList();

    // print('Sizes');
    // print('Prices: ${_sizes[0]['id']}');

    discountPrice = (int.parse(_prices[0]['price'].toString()) -
            int.parse(_prices[0]['offer_price'].toString())) /
        int.parse(_prices[0]['price'].toString()) *
        100;

    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    var disImages = updateProductDisplayImages.isNotEmpty
        ? updateProductDisplayImages
        : productDisplayImages;
    List<dynamic> imageProduct = [];
    imageProduct = [
      disImages[0].imagepath != null ? disImages[0].imagepath.toString() : '',
      disImages[0].imagepath2 != null ? disImages[0].imagepath2.toString() : '',
      disImages[0].imagepath3 != null ? disImages[0].imagepath3.toString() : '',
      disImages[0].imagepath4 != null ? disImages[0].imagepath4.toString() : '',
    ];

    final PageController _sliderController = PageController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Nav
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            'Product Details',
                            textAlign: TextAlign.center,
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e232c),
                            ),
                          ),
                        ),
                      ),
                      // End Top Nav

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Back
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 30,
                              height: 15,
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                                color: Color(0xffEED056),
                              ),
                            ),
                          ),
                          // End Back
                          const SizedBox(width: 5),

                          // Search
                          Container(
                            width: 250,
                            height: 38,
                            padding: const EdgeInsets.only(
                              left: 21,
                              right: 20.70,
                            ),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.50, color: Color(0xFFC7B456)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Center vertically
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: TextFormField(
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
                          // End Search

                          const SizedBox(width: 10),

                          // Cart
                          InkWell(
                            onTap: () {
                              if (_configModel.user == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      LoginRequiredPopupWidget(),
                                );
                                // Show error dialog when user is null
                              } else {
                                Navigator.pushNamed(context, '/cartPage');
                              }
                            },
                            child: badges.Badge(
                              badgeContent: Text(
                                cartCount.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              child: Container(
                                width: 20,
                                height: 20,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Center vertically
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/shopping_cart.png',
                                      height: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // End Cart
                        ],
                      )
                    ],
                  ),
                ),

                widget.arguments['product'] != null
                    ? SingleChildScrollView(
                        child: Container(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Stack(children: [
                                  // Images
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 350,
                                        child: PageView.builder(
                                            itemCount: imageProduct.length,
                                            controller: _sliderController,
                                            pageSnapping: true,
                                            itemBuilder:
                                                (context, pagePosition) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => ImageScreen(
                                                          image: _configModel
                                                                      .apiConfig[
                                                                  'mediaURL'] +
                                                              imageProduct[
                                                                  pagePosition]),
                                                    ),
                                                  );
                                                },
                                                child: Image.network(
                                                  _configModel.apiConfig[
                                                          'mediaURL'] +
                                                      imageProduct[
                                                          pagePosition],
                                                  fit: BoxFit.contain,
                                                  // fit: BoxFit.cover,
                                                ),
                                              );
                                            }),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 10,
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (_configModel.user == null) {
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
                                                          widget.arguments[
                                                              'product']['id']);
                                                }
                                              },
                                              child: Builder(
                                                builder: (context) {
                                                  if (_configModel.user?.id ==
                                                      null) {
                                                    // If user ID is null, show default icon
                                                    return const Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Icon(Icons
                                                          .favorite_border_outlined),
                                                    );
                                                  }

                                                  if (_wishListModel
                                                      .wishListLoader) {
                                                    // Show loading state
                                                    return const Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Icon(Icons
                                                          .favorite_border_outlined),
                                                    );
                                                  }

                                                  // Check if the product is in the user's wishlist
                                                  bool isWishListed = _wishListModel
                                                      .wishLists!
                                                      .any((wishList) =>
                                                          wishList.productId ==
                                                              widget.arguments[
                                                                      'product']
                                                                  ['id'] &&
                                                          wishList.userId ==
                                                              _configModel
                                                                  .user!.id);
                                                  print(
                                                      "wishlist $isWishListed");

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
                                            SizedBox(width: 5),
                                            IconButton(
                                              onPressed: () {
                                                Share.share(
                                                  'Check out this product:`${widget.arguments['product']['name']}`\n\nDescription: `${widget.arguments['product']['description']}`\n\nLink: `${_configModel.apiConfig['mediaURL'] + widget.arguments['product']['imagepath1'].toString()}`',
                                                );
                                              },
                                              icon: Icon(Icons.share),
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  // End Images

                                  Positioned(
                                    top: 325,
                                    child: Align(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 41,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xffffffff),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                SmoothPageIndicator(
                                  controller: _sliderController,
                                  count: imageProduct.length,
                                  effect: ExpandingDotsEffect(
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    activeDotColor: Colors.blue,
                                    dotColor: Colors.grey,
                                  ),
                                ),

                                SizedBox(
                                  height: 15,
                                ),

                                // Display Images

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_left,
                                          ),
                                          onPressed: () {
                                            if (_scrollController.hasClients) {
                                              final currentIndex =
                                                  productDisplayImages
                                                      .indexWhere((image) =>
                                                          image.unit.name ==
                                                          unitName);
                                              final newIndex =
                                                  (currentIndex - 1).clamp(
                                                      0,
                                                      productDisplayImages
                                                              .length -
                                                          1);

                                              setState(() {
                                                unitName = productDisplayImages[
                                                        newIndex]
                                                    .unit
                                                    .name
                                                    .toString();
                                                _CartData['flavour'] = unitName;

                                                updateProductDisplayImages =
                                                    widget.arguments[
                                                            'product_images']
                                                        .where((image) =>
                                                            image.unit.name ==
                                                            unitName)
                                                        .toList();

                                                _sizes = widget
                                                    .arguments['product']
                                                        ['product_packs']
                                                    .where((_pack) =>
                                                        _pack['unit']['name'] ==
                                                        productDisplayImages[
                                                                newIndex]
                                                            .unit
                                                            .name)
                                                    .toList();

                                                activeIndex = -1;
                                                _CartData['kindOfFlower'] = '';
                                              });

                                              final double offset = (newIndex *
                                                      80.0) -
                                                  (MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 -
                                                      40.0); // Center the item
                                              _scrollController.animateTo(
                                                offset.clamp(
                                                  0.0,
                                                  _scrollController
                                                      .position.maxScrollExtent,
                                                ),
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.easeInOut,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Container(
                                          height: 100,
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 8),
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount:
                                                productDisplayImages.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    unitName =
                                                        productDisplayImages[
                                                                index]
                                                            .unit
                                                            .name
                                                            .toString();
                                                    _CartData['flavour'] =
                                                        unitName;
                                                    _CartData['pack'] =
                                                        productDisplayImages[
                                                                index]
                                                            .id;

                                                    updateProductDisplayImages =
                                                        widget.arguments[
                                                                'product_images']
                                                            .where((image) =>
                                                                image.unit
                                                                    .name ==
                                                                unitName)
                                                            .toList();

                                                    _sizes = widget
                                                        .arguments['product']
                                                            ['product_packs']
                                                        .where((_pack) =>
                                                            _pack['unit']
                                                                ['name'] ==
                                                            productDisplayImages[
                                                                    index]
                                                                .unit
                                                                .name)
                                                        .toList();

                                                    activeIndex = -1;
                                                    _CartData['kindOfFlower'] =
                                                        '';
                                                  });

                                                  final double offset = (index *
                                                          80.0) -
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2 -
                                                          40.0); // Center the item
                                                  _scrollController.animateTo(
                                                    offset.clamp(
                                                      0.0,
                                                      _scrollController.position
                                                          .maxScrollExtent,
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeInOut,
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: unitName ==
                                                            productDisplayImages[
                                                                    index]
                                                                .unit
                                                                .name
                                                        ? Border.all(
                                                            color: Colors.black,
                                                            width: 2)
                                                        : Border.all(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                  margin:
                                                      EdgeInsets.only(right: 8),
                                                  width: 60,
                                                  height: 80,
                                                  child: productDisplayImages[
                                                                  index]
                                                              .imagepath !=
                                                          ''
                                                      ? Image.network(
                                                          _configModel.apiConfig[
                                                                  'mediaURL'] +
                                                              productDisplayImages[
                                                                      index]
                                                                  .imagepath
                                                                  .toString(),
                                                          fit: BoxFit.fill,
                                                        )
                                                      : Text(''),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_right),
                                          onPressed: () {
                                            if (_scrollController.hasClients) {
                                              final currentIndex =
                                                  productDisplayImages
                                                      .indexWhere((image) =>
                                                          image.unit.name ==
                                                          unitName);
                                              final newIndex =
                                                  (currentIndex + 1).clamp(
                                                      0,
                                                      productDisplayImages
                                                              .length -
                                                          1);

                                              setState(() {
                                                unitName = productDisplayImages[
                                                        newIndex]
                                                    .unit
                                                    .name
                                                    .toString();
                                                _CartData['flavour'] = unitName;

                                                updateProductDisplayImages =
                                                    widget.arguments[
                                                            'product_images']
                                                        .where((image) =>
                                                            image.unit.name ==
                                                            unitName)
                                                        .toList();

                                                _sizes = widget
                                                    .arguments['product']
                                                        ['product_packs']
                                                    .where((_pack) =>
                                                        _pack['unit']['name'] ==
                                                        productDisplayImages[
                                                                newIndex]
                                                            .unit
                                                            .name)
                                                    .toList();

                                                activeIndex = -1;
                                                _CartData['kindOfFlower'] = '';
                                              });

                                              final double offset = (newIndex *
                                                      80.0) -
                                                  (MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 -
                                                      40.0); // Center the item
                                              _scrollController.animateTo(
                                                offset.clamp(
                                                  0.0,
                                                  _scrollController
                                                      .position.maxScrollExtent,
                                                ),
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.easeInOut,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Display Images
                                Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Column(
                                    children: [
                                      // Product Name to Available in Stock
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xffffffff),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            // Name
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        widget.arguments![
                                                                'product']
                                                                ['name']
                                                            .toString(),
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontSize: 19,
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    // Reviews
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          if (product.rating !=
                                                              '0')
                                                            RatingBar.builder(
                                                              itemSize: 15,
                                                              initialRating: product
                                                                          .reviews ==
                                                                      null
                                                                  ? 0.0
                                                                  // product
                                                                  //             .rating ==
                                                                  //         null
                                                                  //     ? 0
                                                                  : double.parse(
                                                                      product
                                                                          .rating
                                                                          .toString()),
                                                              direction: Axis
                                                                  .horizontal,
                                                              itemCount: 5,
                                                              allowHalfRating:
                                                                  true,
                                                              ignoreGestures:
                                                                  true,
                                                              itemBuilder:
                                                                  (context,
                                                                          _) =>
                                                                      const Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              onRatingUpdate:
                                                                  (double
                                                                      value) {},
                                                            ),

                                                          // Row(
                                                          //   children:

                                                          //   List.generate(
                                                          //       int.parse(product
                                                          //           .rating
                                                          //           .toString()),
                                                          //       (index) {
                                                          //     return Icon(
                                                          //       index < 5
                                                          //           ? Icons.star
                                                          //           : Icons
                                                          //               .star_border,
                                                          //       color: Colors
                                                          //           .amber,
                                                          //       size: 16,
                                                          //     );
                                                          //   }),
                                                          // ),
                                                          Text(
                                                            '( ' +
                                                                (product.reviews ==
                                                                            null
                                                                        ? 'No'
                                                                        : product
                                                                            .reviews
                                                                            ?.length)
                                                                    .toString() +
                                                                ' Review)',
                                                            style:
                                                                MyGoogleFontStyle(
                                                              fontFamily:
                                                                  'Urbanist',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  10,
                                            ),
                                            // Qty
                                            Column(
                                              children: [
                                                if (_addToCartModel.addToCarts
                                                        ?.where((cart) =>
                                                            cart.productId ==
                                                                widget.arguments[
                                                                        'product']
                                                                    ['id'] &&
                                                            cart.flavour ==
                                                                unitName &&
                                                            cart.kindOfFlower ==
                                                                size)
                                                        .toList()
                                                        .isEmpty ??
                                                    true)
                                                  TextButton(
                                                    onPressed: () async {
                                                      // if (_formKey.currentState!
                                                      //     .validate()) {
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
                                                        _formKey.currentState!
                                                            .save();
                                                        bool type = true;

                                                        if (_CartData[
                                                                    'kindOfFlower'] ==
                                                                '' ||
                                                            _CartData[
                                                                    'flavour'] ==
                                                                '') {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              title: _CartData[
                                                                              'kindOfFlower'] ==
                                                                          '' &&
                                                                      _CartData[
                                                                              'flavour'] !=
                                                                          ''
                                                                  ? Text(
                                                                      "kindly choose size.")
                                                                  : _CartData['flavour'] ==
                                                                              '' &&
                                                                          _CartData['kindOfFlower'] !=
                                                                              ''
                                                                      ? Text(
                                                                          "kindly choose colour.")
                                                                      : Text(
                                                                          "kindly choose colour and size."),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'Ok',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        } else {
                                                          _CartData['points'] =
                                                              _productpoints;
                                                          _CartData[
                                                              'product_price'] = _prices[0]
                                                                      [
                                                                      'offer_price'] !=
                                                                  0
                                                              ? _prices[0][
                                                                  'offer_price']
                                                              : _prices[0]
                                                                      ['price']
                                                                  .toString();
                                                          // print(
                                                          //     "Product Details: $_CartData");
                                                          await _addToCartModel
                                                              .getAddToCart(
                                                                  widget.arguments![
                                                                          'product']
                                                                      ['id'],
                                                                  type,
                                                                  _CartData);
                                                        }
                                                      }
                                                    },
                                                    style: TextButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    child: Container(
                                                      width: 82,
                                                      height: 27.33,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffeaeaea)),
                                                        color:
                                                            Color(0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x3f000000),
                                                            offset: Offset(0,
                                                                2.1298701763),
                                                            blurRadius:
                                                                2.1298701763,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'ADD',
                                                          style:
                                                              MyGoogleFontStyle(
                                                            fontFamily:
                                                                'DM Sans',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            height: 1,
                                                            color: Color(
                                                                0xffc7b456),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if (_addToCartModel.addToCarts
                                                        ?.where((cart) =>
                                                            cart.productId ==
                                                                widget.arguments[
                                                                        'product']
                                                                    ['id'] &&
                                                            cart.flavour ==
                                                                unitName &&
                                                            cart.kindOfFlower ==
                                                                size)
                                                        .toList()
                                                        .isNotEmpty ==
                                                    true)
                                                  Center(
                                                    child: Row(
                                                      children: [
                                                        TextButton(
                                                          onPressed: () async {
                                                            bool minus = false;
                                                            await _addToCartModel
                                                                .getAddToCart(
                                                                    widget.arguments[
                                                                            'product']
                                                                        ['id'],
                                                                    minus,
                                                                    _CartData);
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            padding:
                                                                EdgeInsets.zero,
                                                          ),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    5),
                                                              ),
                                                            ),
                                                            child: Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Text(
                                                          // '1',
                                                          _addToCartModel
                                                                  .addToCarts!
                                                                  .where((_aTC) =>
                                                                      _aTC.productId ==
                                                                      widget.arguments[
                                                                              'product']
                                                                          [
                                                                          'id'])
                                                                  .toList()
                                                                  .isNotEmpty
                                                              ? _addToCartModel
                                                                  .addToCarts!
                                                                  .where((_aTC) =>
                                                                      _aTC.productId ==
                                                                      widget.arguments[
                                                                              'product']
                                                                          [
                                                                          'id'])
                                                                  .toList()[0]
                                                                  .qty
                                                                  .toString()
                                                              : '0',
                                                          style:
                                                              MyGoogleFontStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff1e1e1e),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            bool type = true;

                                                            await _addToCartModel
                                                                .getAddToCart(
                                                                    widget.arguments[
                                                                            'product']
                                                                        ['id'],
                                                                    type,
                                                                    _CartData);
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            padding:
                                                                EdgeInsets.zero,
                                                          ),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    5),
                                                              ),
                                                            ),
                                                            child: Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                Text(
                                                  'Avaliable in stock',
                                                  style: MyGoogleFontStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      // End Product Name to Available in Stock
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      // Price
                                      _prices[0]['offer_price'] != 0
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                    text: 'Total Price',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[500]),
                                                    children: [
                                                      WidgetSpan(
                                                        child: SizedBox(
                                                            width:
                                                                20), // Adjust the width as needed
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '₹${_prices[0]['price'].toString()} ',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFC7B456),
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      WidgetSpan(
                                                        child: SizedBox(
                                                            width:
                                                                20), // Adjust the width as needed
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              '₹${_prices[0]['offer_price'].toString()}',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      if (discountPrice != 0.0)
                                                        WidgetSpan(
                                                          child: SizedBox(
                                                              width:
                                                                  10), // Adjust the width as needed
                                                        ),
                                                      if (discountPrice != 0.0)
                                                        TextSpan(
                                                            text:
                                                                '( ${discountPrice.round()}% Off)',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Text(
                                              '₹ ${_prices[0]['price'].toString()}',
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                height: 1.5,
                                                letterSpacing: -0.2190869331,
                                                color: Color(0x99000000),
                                              ),
                                            ),
                                      // Size
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 15, bottom: 5),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Size',
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 8,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 10, 8),
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.7,
                                                      height: 60,
                                                      child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            _sizes.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                index) {
                                                          isActive = index ==
                                                              activeIndex;
                                                          // print(
                                                          //     'isActive $isActive');

                                                          return Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                                child: SizedBox(
                                                                  width: 50,
                                                                  height: 52,
                                                                  child:
                                                                      TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        activeIndex =
                                                                            index;
                                                                        print(
                                                                            'tab');

                                                                        _CartData[
                                                                            'kindOfFlower'] = _sizes[index]
                                                                                ['value']
                                                                            .toString();

                                                                        _prices = widget
                                                                            .arguments['product'][
                                                                                'product_prices']
                                                                            .where((_price) =>
                                                                                _price['product_pack_id'] ==
                                                                                _sizes[index]['id'])
                                                                            .toList();
                                                                        _productpoints = widget
                                                                            .arguments['product'][
                                                                                'product_packs']
                                                                            .where((_pack) =>
                                                                                _pack['id'] ==
                                                                                _prices[0]['product_pack_id'])
                                                                            .toList()[0]['points']
                                                                            .toString();
                                                                        size = _sizes[index]['value']
                                                                            .toString();
                                                                        // print('points: $_productpoints');
                                                                        // print(_prices[index]);
                                                                      });
                                                                    },
                                                                    style: TextButton
                                                                        .styleFrom(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      backgroundColor: isActive
                                                                          ? Colors.black // Set the active color here
                                                                          : null,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(30.0), // Adjust the border radius
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                      decoration:
                                                                          ShapeDecoration(
                                                                        shape:
                                                                            OvalBorder(
                                                                          side: BorderSide(
                                                                              width: 0.95,
                                                                              color: Color(0xFFDDDDDD)),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          _sizes[index]['value']
                                                                              .toString(),
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Urbanist',
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            height:
                                                                                1.2,
                                                                            letterSpacing:
                                                                                -0.36,
                                                                            color: isActive
                                                                                ? Colors.white
                                                                                : Color(0x99000000),
                                                                            // Set the text color based on active state
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: InkWell(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                                width: double
                                                                    .infinity,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            30),
                                                                height: 200,
                                                                child: Image
                                                                    .network(
                                                                  _configModel.apiConfig[
                                                                          'mediaURL'] +
                                                                      product
                                                                          .sizeChartPath
                                                                          .toString(),
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ));
                                                          },
                                                        );
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            child: Image.asset(
                                                              'assets/images/size-chart-icon.png',
                                                              width: 40,
                                                              height: 40,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Size Chart',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Container(
                                            //   margin: EdgeInsets.only(top: 10),
                                            //   width: 318.36,
                                            //   height: 70,
                                            //   decoration: ShapeDecoration(
                                            //     color: Colors.white,
                                            //     shape: RoundedRectangleBorder(
                                            //       side: BorderSide(
                                            //           width: 0.95,
                                            //           color: Color(0xFFDADADA)),
                                            //       borderRadius:
                                            //           BorderRadius.circular(
                                            //               19.01),
                                            //     ),
                                            //   ),
                                            //   child: DropdownButtonFormField(
                                            //       decoration: InputDecoration(
                                            //           border: InputBorder.none,
                                            //           focusedBorder:
                                            //               InputBorder.none,
                                            //           enabledBorder:
                                            //               InputBorder.none,
                                            //           errorBorder:
                                            //               InputBorder.none,
                                            //           disabledBorder:
                                            //               InputBorder.none,
                                            //           labelText: 'Select Color',
                                            //           contentPadding:
                                            //               EdgeInsets.all(10)),
                                            //       items: _s
                                            //           .map(
                                            //             (_color) =>
                                            //                 DropdownMenuItem(
                                            //               child: Text(
                                            //                 _color['unit']
                                            //                     ['name'],
                                            //               ),
                                            //               value: _color['unit']
                                            //                   ['name'],
                                            //             ),
                                            //           )
                                            //           .toList(),
                                            //       onChanged: (value) {
                                            //         _CartData['flavour'] =
                                            //             value.toString();

                                            //         unitName = value
                                            //             .toString()
                                            //             .toString();
                                            //         print(unitName);
                                            //         setState(() {
                                            //           updateProductDisplayImages =
                                            //               widget
                                            //                   .arguments[
                                            //                       'product_images']
                                            //                   .where((image) =>
                                            //                       image.unit
                                            //                           .name ==
                                            //                       unitName)
                                            //                   .toList();
                                            //         });
                                            //       }),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, top: 10),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Customer Ratings',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              // height: 1.5 * ffem / fem,
                                              // letterSpacing:
                                              //     -0.2190869331 * fem,
                                              color: Color(0x99000000),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (product.rating.toString() != '0')
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0, top: 10),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  product.rating.toString(),
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    // height: 1.5 * ffem / fem,
                                                    // letterSpacing:
                                                    //     -0.2190869331 * fem,
                                                    color: Color(0x99000000),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0, left: 3),
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0, top: 10),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  ' ( ${(product.reviews == null ? 0 : product.reviews?.length)} ratings )',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    '/reviewsPage', arguments: {
                                                  'productId': widget
                                                          .arguments['product']
                                                      ['id']
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20.0, top: 10),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'View Reviews & Ratings',
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      // height: 1.5 * ffem / fem,
                                                      // letterSpacing:
                                                      //     -0.2190869331 * fem,
                                                      color: Color(0x99000000),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Description
                                if (product.description != null)
                                  Container(
                                    width: double.infinity,
                                    child: Card(
                                      elevation: 4,
                                      color: Colors.white,
                                      child: Padding(
                                          padding: const EdgeInsets.all(
                                              16.0), // Optional padding
                                          child:
                                              // Text(product.description.toString()),
                                              Html(
                                            data:
                                                """${product.description.toString()}""",
                                          )),
                                    ),
                                  ),
                                if (product.description1 != null)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (product.description1 != null)
                                  Container(
                                    width: double.infinity,
                                    child: Card(
                                      elevation: 4,
                                      color: Colors.white,
                                      child: Padding(
                                          padding: const EdgeInsets.all(
                                              16.0), // Optional padding
                                          child:
                                              // Text(product.description.toString()),
                                              Html(
                                            data:
                                                """${product.description1.toString()}""",
                                          )),
                                    ),
                                  ),
                                if (product.description2 != null)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (product.description2 != null)
                                  Container(
                                    width: double.infinity,
                                    child: Card(
                                      elevation: 4,
                                      color: Colors.white,
                                      child: Padding(
                                          padding: const EdgeInsets.all(
                                              16.0), // Optional padding
                                          child:
                                              // Text(product.description.toString()),
                                              Html(
                                            data:
                                                """${product.description2.toString()}""",
                                          )),
                                    ),
                                  ),
                                // Container(
                                //   margin: EdgeInsets.only(top: 10),
                                //   height: 380,
                                //   child: DefaultTabController(
                                //     length: 2,
                                //     child: Column(
                                //       children: [
                                //         Container(
                                //           width: MediaQuery.of(context)
                                //                   .size
                                //                   .width -
                                //               50,
                                //           child: TabBar(
                                //             indicatorColor: Colors.black,
                                //             tabs: [
                                //               Text(
                                //                 'Description',
                                //                 style: TextStyle(
                                //                     color: Colors.black,
                                //                     fontSize: 13),
                                //               ),
                                //               Text(
                                //                 'Reviews',
                                //                 style: TextStyle(
                                //                     color: Colors.black,
                                //                     fontSize: 13),
                                //               ),
                                //               // Text(
                                //               //   'Write a review',
                                //               //   style: TextStyle(
                                //               //       color: Colors.black,
                                //               //       fontSize: 13),
                                //               // ),
                                //             ],
                                //           ),
                                //         ),
                                //         Container(
                                //           width: MediaQuery.of(context)
                                //                   .size
                                //                   .width -
                                //               50,
                                //           height: 350,
                                //           child: TabBarView(
                                //             children: [
                                //               Padding(
                                //                 padding:
                                //                     const EdgeInsets.all(8.0),
                                //                 child: Text(widget.arguments![
                                //                                 'product']![
                                //                             'description'] !=
                                //                         null
                                //                     ? widget
                                //                         .arguments!['product']![
                                //                             'description']
                                //                         .toString()
                                //                     : ''),
                                //               ),
                                //               Container(
                                //                 child: Column(
                                //                   crossAxisAlignment:
                                //                       CrossAxisAlignment.start,
                                //                   children: [
                                //                     Container(
                                //                       // height:
                                //                       // MediaQuery.of(context)
                                //                       //         .size
                                //                       //         .height -
                                //                       //     50,
                                //                       child: product.reviews ==
                                //                               null
                                //                           ? Center(
                                //                               child: Text(
                                //                                   'No reviews'))
                                //                           : SingleChildScrollView(
                                //                               child: Padding(
                                //                                 padding:
                                //                                     const EdgeInsets
                                //                                         .only(
                                //                                         top:
                                //                                             8.0),
                                //                                 child: SizedBox(
                                //                                   height: MediaQuery.of(
                                //                                               context)
                                //                                           .size
                                //                                           .height *
                                //                                       0.45,
                                //                                   child: ListView
                                //                                       .builder(
                                //                                     scrollDirection:
                                //                                         Axis.vertical,
                                //                                     itemCount: widget
                                //                                         .arguments![
                                //                                             'product']
                                //                                             [
                                //                                             'reviews']!
                                //                                         .length,
                                //                                     itemBuilder:
                                //                                         (BuildContext context,
                                //                                                 index) =>
                                //                                             Container(
                                //                                       margin: EdgeInsets.only(
                                //                                           bottom:
                                //                                               10),
                                //                                       padding:
                                //                                           EdgeInsets.all(
                                //                                               10),
                                //                                       decoration:
                                //                                           BoxDecoration(
                                //                                         border: Border.all(
                                //                                             color:
                                //                                                 Color(0xffc7b456)),
                                //                                         color: Color(
                                //                                             0xffffffff),
                                //                                         borderRadius:
                                //                                             BorderRadius.all(Radius.circular(5)),
                                //                                         boxShadow: [
                                //                                           BoxShadow(
                                //                                             color:
                                //                                                 Color(0x338a959e),
                                //                                             offset:
                                //                                                 Offset(0, 7.6690645218),
                                //                                             blurRadius:
                                //                                                 19.1726608276,
                                //                                           ),
                                //                                         ],
                                //                                       ),
                                //                                       child:
                                //                                           Column(
                                //                                         crossAxisAlignment:
                                //                                             CrossAxisAlignment.start,
                                //                                         children: [
                                //                                           Row(
                                //                                             children: [
                                //                                               Expanded(
                                //                                                 child: Text(_configModel.user!.firstName.toString()),
                                //                                               ),
                                //                                               Expanded(
                                //                                                 child: Text(
                                //                                                   _format!.format(DateTime.parse(widget.arguments!['product']['reviews']![index]['created_at'].toString())),
                                //                                                   textAlign: TextAlign.right,
                                //                                                   style: MyGoogleFontStyle(
                                //                                                     fontFamily: 'Poppins',
                                //                                                     fontSize: 12,
                                //                                                     fontWeight: FontWeight.w400,
                                //                                                     color: Color(0xff909090),
                                //                                                   ),
                                //                                                 ),
                                //                                               ),
                                //                                             ],
                                //                                           ),
                                //                                           SizedBox(
                                //                                               height: 10),
                                //                                           Text(
                                //                                             widget.arguments!['product']['reviews']![index]['description'] ??
                                //                                                 '',
                                //                                             style:
                                //                                                 MyGoogleFontStyle(
                                //                                               fontFamily: 'Poppins',
                                //                                               fontSize: 12,
                                //                                               fontWeight: FontWeight.w400,
                                //                                               color: Color(0xff909090),
                                //                                             ),
                                //                                           ),

                                //                                           SizedBox(
                                //                                             height:
                                //                                                 100,
                                //                                             child:
                                //                                                 ListView.builder(
                                //                                               scrollDirection: Axis.horizontal,
                                //                                               itemCount: widget.arguments!['product']['reviews']![index]['review_images'].length,
                                //                                               itemBuilder: (context, index) {
                                //                                                 final image = widget.arguments!['product']['reviews']![index]['review_images'][index];

                                //                                                 return InkWell(
                                //                                                   onTap: () {
                                //                                                     Navigator.of(context).push(
                                //                                                       MaterialPageRoute(
                                //                                                         builder: (context) => ImageScreen(image: _configModel.apiConfig['mediaURL'] + image['image_path']),
                                //                                                       ),
                                //                                                     );
                                //                                                   },
                                //                                                   child: Container(
                                //                                                     margin: const EdgeInsets.only(right: 10),
                                //                                                     width: 60,
                                //                                                     height: 50,
                                //                                                     child: Image.network(
                                //                                                       _configModel.apiConfig['mediaURL'] + image['image_path'],
                                //                                                       fit: BoxFit.contain,
                                //                                                       errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                //                                                     ),
                                //                                                   ),
                                //                                                 );
                                //                                               },
                                //                                             ),
                                //                                           ),
                                //                                           // Text(
                                //                                           //   widget.arguments!['product']['reviews']![index]['review_images'].toString(),
                                //                                           //   style:
                                //                                           //       MyGoogleFontStyle(
                                //                                           //     fontFamily: 'Poppins',
                                //                                           //     fontSize: 12,
                                //                                           //     fontWeight: FontWeight.w400,
                                //                                           //     color: Color(0xff909090),
                                //                                           //   ),
                                //                                           // ),
                                //                                           // Image.network(_configModel.apiConfig['mediaUrl'] +
                                //                                           //     widget.arguments!['product']['reviews']![index]['review_images'][0]['image_path'].toString())
                                //                                         ],
                                //                                       ),
                                //                                     ),
                                //                                   ),
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                     ),
                                //                   ],
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),

                                // Add More Items
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 20),
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 220,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: _productModel
                                                        .categoryWiseproductsLoader
                                                    ? Center(
                                                        child:
                                                            LinearProgressIndicator())
                                                    : ListView.builder(
                                                        itemCount: _productModel
                                                            .categoryWiseproducts!
                                                            .length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (BuildContext
                                                                        context,
                                                                    index) =>
                                                                InkWell(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ProductIdPage(
                                                                        arguments: {
                                                                      'product': _productModel
                                                                          .categoryWiseproducts![
                                                                              index]
                                                                          .toJson(),
                                                                      'product_images': _productModel
                                                                          .categoryWiseproducts![
                                                                              index]
                                                                          .productImages
                                                                    }),
                                                              ),
                                                            );
                                                          },
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                // margin: EdgeInsets.fromLTRB(
                                                                //     0, 0, 0, 0),
                                                                width: 170,
                                                                height: 320,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          140,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Positioned(
                                                                              // frame9SvA (318:2815)
                                                                              left: 0,
                                                                              top: 0,
                                                                              child: Container(
                                                                                padding: EdgeInsets.fromLTRB(106, 13, 14, 13),
                                                                                width: 145,
                                                                                height: 133,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(15),
                                                                                  color: Color(0x0c000000),
                                                                                  image: DecorationImage(
                                                                                    fit: BoxFit.cover,
                                                                                    image: NetworkImage(_configModel.apiConfig['mediaURL'] + _productModel.categoryWiseproducts![index].productImages!.first.imagepath.toString()
                                                                                        // 'assets/images/shades-chocolate-cake-3-1-2-1-bg.png',

                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                child: InkWell(
                                                                                  onTap: () async {
                                                                                    await _wishListModel.getWishLists(_productModel.categoryWiseproducts![index].id);
                                                                                  },
                                                                                  child: _wishListModel.wishLists!.where((wishList) => wishList.productId == _productModel.categoryWiseproducts![index].id && wishList.userId == _configModel.user!.id).toList().length == 0
                                                                                      ? Align(alignment: Alignment.topRight, child: Icon(Icons.favorite_border_outlined))
                                                                                      : Align(
                                                                                          alignment: Alignment.topRight,
                                                                                          child: Icon(
                                                                                            Icons.favorite_outlined,
                                                                                            color: Colors.red,
                                                                                          )),
                                                                                ),
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        _productModel
                                                                            .categoryWiseproducts![index]
                                                                            .name
                                                                            .toString(),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            MyGoogleFontStyle(
                                                                          fontFamily:
                                                                              'Urbanist',
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          height:
                                                                              1.2,
                                                                          letterSpacing:
                                                                              -0.3,
                                                                          color:
                                                                              Color(0xff000000),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context).push(MaterialPageRoute(
                                                                            builder: (context) => ProductIdPage(arguments: {
                                                                                  'product': _productModel.categoryWiseproducts![index].toJson(),
                                                                                  'product_images': _productModel.categoryWiseproducts![index].productImages
                                                                                })));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        child: _productModel.categoryWiseproducts![index].productPrices![0].offerPrice !=
                                                                                0
                                                                            ? Text.rich(TextSpan(children: [
                                                                                new TextSpan(
                                                                                  text: '₹${_productModel.categoryWiseproducts![index].productPrices![0].price.toString()}',
                                                                                  style: new TextStyle(
                                                                                    color: Colors.grey,
                                                                                    decoration: TextDecoration.lineThrough,
                                                                                  ),
                                                                                ),
                                                                                new TextSpan(
                                                                                  text: ' ₹${_productModel.categoryWiseproducts![index].productPrices![0].offerPrice.toString()}',
                                                                                ),
                                                                              ]))
                                                                            : Text(
                                                                                _productModel.categoryWiseproducts![index].productPrices![0].price.toString() + " " + '₹',
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
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Earn Points Text
                                if (_productpoints != '0')
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Earn ${_productpoints} points for this product',
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                          color: Colors.black,
                                        ),
                                        // SizedBox(
                                        //   height: 20,
                                        // ),

                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 650,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                // End Images
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _configModel.user == null
          ? SizedBox.shrink()
          : Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          height: 41,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                bool type = true;

                                // await _addToCartModel
                                //     .getAddToCart(
                                //         widget.arguments![
                                //             'product']['id'],
                                //         type,
                                //         _CartData);
                                Navigator.pushNamed(context, '/cartPage');
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
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          height: 41,
                          child: TextButton(
                            onPressed: () async {
                              _formKey.currentState!.save();
                              bool type = true;
                              Navigator.pushNamed(context, '/cartPage');

                              // if (_CartData['kindOfFlower'] == '' ||
                              //     _CartData['flavour'] == '') {
                              //   showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) => AlertDialog(
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(20)),
                              //       title: _CartData['kindOfFlower'] == '' &&
                              //               _CartData['flavour'] != ''
                              //           ? Text("kindly choose size.")
                              //           : _CartData['flavour'] == '' &&
                              //                   _CartData['kindOfFlower'] != ''
                              //               ? Text("kindly choose colour.")
                              //               : Text("kindly choose colour and size."),
                              //       actions: <Widget>[
                              //         TextButton(
                              //           onPressed: () {
                              //             Navigator.pop(context);
                              //           },
                              //           child: Text(
                              //             'Ok',
                              //             style: TextStyle(
                              //                 color: Colors.black, fontSize: 16),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   );
                              // } else {
                              //   await _addToCartModel.getAddToCart(
                              //       widget.arguments!['product']['id'],
                              //       type,
                              //       _CartData);
                              //   Navigator.pushNamed(context, '/cartPage');
                              // }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
                              decoration: BoxDecoration(
                                color: Color(0xFFC7B456),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
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
                                    'Buy Now',
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
                  ],
                ),
              ),
            ),
    );
  }
}

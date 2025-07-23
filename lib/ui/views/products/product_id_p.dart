// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:provider/provider.dart';
// import 'package:aadab/core/models/product.dart';
// import 'package:aadab/core/providers/add_to_cart_pr.dart';
// import 'package:aadab/core/providers/config_pr.dart';
// import 'package:aadab/core/providers/product_pr.dart';
// import 'package:aadab/core/providers/wish_list_pr.dart';
// import 'package:aadab/locator.dart';
// import 'package:aadab/ui/shared/font_sh.dart';
// import 'package:aadab/ui/views/checkout/cart_p.dart';
// import 'package:aadab/ui/views/products/shops_p.dart';
// import 'package:aadab/ui/widgets/image_zoom_w.dart';
// import 'package:aadab/ui/widgets/login_required_popup.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'dart:async';
// import 'package:badges/badges.dart' as badges;

// class ProductIdPage extends StatefulWidget {
//   final arguments;

//   const ProductIdPage({Key? key, this.arguments}) : super(key: key);

//   @override
//   State<ProductIdPage> createState() => _ProductIdPageState();
// }

// class _ProductIdPageState extends State<ProductIdPage> {
//   List<Map<String, dynamic>> _sizes = [];
//   List<Map<String, dynamic>> _prices = [];
//   List<dynamic> productDisplayImages = [];
//   List<dynamic> updateProductDisplayImages = [];
//   String unitName = '';
//   String size = '';
//   String _productPoints = '';
//   int activeIndex = -1;
//   int cartCount = 0;
//   double discountPrice = 0.0;
//   bool _isLoading = true;
//   String? _errorMessage;
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _searchController = TextEditingController();
//   Timer? _debounce;
//   Map<String, dynamic> _cartData = {
//     'kindOfFlower': '',
//     'flavour': '',
//     'writeOnCake': '',
//     'pack': '',
//     'is_add_to_cart': false
//   };

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchInitialData();
//     });
//   }

//   Future<void> _fetchInitialData() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     final configModel = locator<ConfigModel>();
//     final productId = widget.arguments!['product']['id'];
//     final addToCartModel = context.read<AddToCartModel>();
//     final wishListModel = context.read<WishListModel>();
//     final productModel = context.read<ProductModel>();
//     await Future.wait<void>([
//       if (configModel.user != null)
//         addToCartModel.getAddToCart(productId, '', _cartData),
//       if (configModel.user != null) wishListModel.getWishLists(''),
//       productModel.getCategoryWiseProduct(
//           widget.arguments!['product']['category_id'] ?? '', ''),
//     ]);

//     setState(() {
//       _initializeProductData();
//       _isLoading = false;
//     });
//   }

//   void _initializeProductData() {
//     productDisplayImages = widget.arguments?['product_images']?.toList() ?? [];
//     if (productDisplayImages.isNotEmpty) {
//       unitName = productDisplayImages[0].unit?.name ?? '';
//       _cartData['flavour'] = unitName;
//       _cartData['pack'] = productDisplayImages[0].id?.toString() ?? '';
//     }
//     _sizes = widget.arguments?['product']?['product_packs']
//             ?.where((pack) => pack['unit']?['name'] == unitName)
//             ?.toList() ??
//         [];
//     if (_sizes.isNotEmpty) {
//       _cartData['kindOfFlower'] = _sizes[0]['value']?.toString() ?? '';
//       size = _sizes[0]['value']?.toString() ?? '';
//       _productPoints = _sizes[0]['points'];
//       activeIndex = 0; // Pre-select the first size
//     }
//     _prices = widget.arguments?['product']?['product_prices']
//             ?.where((price) => price['product_pack_id'] == _sizes[0]?['id'])
//             ?.toList() ??
//         [];
//     if (_prices.isNotEmpty) {
//       discountPrice = _prices[0]['offer_price'] != 0
//           ? ((int.parse(_prices[0]['price'].toString()) -
//                   int.parse(_prices[0]['offer_price'].toString())) /
//               int.parse(_prices[0]['price'].toString()) *
//               100)
//           : 0.0;
//     }
//     cartCount = context.read<AddToCartModel>().addToCarts?.length ?? 0;
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final double baseWidth = 360;
//     final double fem = screenWidth / baseWidth;
//     final double ffem = fem * 0.97;

//     final configModel = locator<ConfigModel>();
//     final productModel = context.watch<ProductModel>();
//     final addToCartModel = context.watch<AddToCartModel>();
//     final wishListModel = context.watch<WishListModel>();

//     final product = widget.arguments?['product'] != null
//         ? Product.fromJson(widget.arguments!['product'])
//         : null;

//     if (_isLoading) {
//       return Scaffold(
//         body: SafeArea(
//           child: SizedBox(
//             width: screenWidth,
//             height: screenHeight,
//             child: const Center(child: CircularProgressIndicator()),
//           ),
//         ),
//       );
//     }

//     if (_errorMessage != null || product == null) {
//       return Scaffold(
//         body: SafeArea(
//           child: SizedBox(
//             width: screenWidth,
//             height: screenHeight,
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _errorMessage ?? 'Product data not available.',
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                   SizedBox(height: 16 * fem),
//                   ElevatedButton(
//                     onPressed: _fetchInitialData,
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     final disImages = updateProductDisplayImages.isNotEmpty
//         ? updateProductDisplayImages
//         : productDisplayImages;
//     final imageProduct = [
//       if (disImages.isNotEmpty) ...[
//         disImages[0].imagepath?.toString() ?? '',
//         disImages[0].imagepath2?.toString() ?? '',
//         disImages[0].imagepath3?.toString() ?? '',
//         disImages[0].imagepath4?.toString() ?? '',
//       ]
//     ].where((img) => img.isNotEmpty).toList();

//     final PageController sliderController = PageController();

//     return Scaffold(
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: _fetchInitialData,
//           child: SingleChildScrollView(
//             child: Container(
//               width: screenWidth,
//               constraints: BoxConstraints(minHeight: screenHeight),
//               decoration: const BoxDecoration(color: Colors.white),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 20 * fem, vertical: 16 * fem),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Center(
//                             child: Text(
//                               'Product Details',
//                               style: MyGoogleFontStyle(
//                                 fontFamily: 'Urbanist',
//                                 fontSize: 18 * ffem,
//                                 fontWeight: FontWeight.bold,
//                                 color: const Color(0xff1e232c),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 15 * fem),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               InkWell(
//                                 onTap: () => Navigator.pop(context),
//                                 child: Icon(
//                                   Icons.arrow_back_ios,
//                                   size: 18 * ffem,
//                                   color: const Color(0xffEED056),
//                                 ),
//                               ),
//                               SizedBox(width: 10 * fem),
//                               Expanded(
//                                 child: Container(
//                                   height: 38 * fem,
//                                   padding: EdgeInsets.only(
//                                       left: 21 * fem, right: 20.70 * fem),
//                                   decoration: ShapeDecoration(
//                                     shape: RoundedRectangleBorder(
//                                       side: const BorderSide(
//                                           width: 0.50,
//                                           color: Color(0xFFC7B456)),
//                                       borderRadius:
//                                           BorderRadius.circular(10 * fem),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextFormField(
//                                           controller: _searchController,
//                                           onChanged: (value) {
//                                             if (_debounce?.isActive ?? false)
//                                               _debounce!.cancel();
//                                             _debounce = Timer(
//                                                 const Duration(
//                                                     milliseconds: 500), () {
//                                               if (value.length % 3 == 0 &&
//                                                   value.isNotEmpty) {
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         ShopsPage(
//                                                             initialText: value),
//                                                   ),
//                                                 );
//                                               }
//                                             });
//                                           },
//                                           decoration: const InputDecoration(
//                                             hintText: 'Search',
//                                             border: InputBorder.none,
//                                           ),
//                                           style: TextStyle(
//                                             color:
//                                                 Colors.black.withOpacity(0.6),
//                                             fontSize: 18 * ffem,
//                                             fontFamily: 'Urbanist',
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                       Image.asset(
//                                         'assets/images/Search-1.png',
//                                         height: 20 * fem,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 10 * fem),
//                               InkWell(
//                                 onTap: () {
//                                   if (configModel.user == null) {
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) =>
//                                           LoginRequiredPopupWidget(),
//                                     );
//                                   } else {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => CartPage(
//                                             isProfile: {'isProfile': false}),
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 child: badges.Badge(
//                                   badgeContent: Text(
//                                     cartCount.toString(),
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                   child: Image.asset(
//                                     'assets/images/shopping_cart.png',
//                                     height: 20 * fem,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Product Content
//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Image Slider
//                           Stack(
//                             children: [
//                               SizedBox(
//                                 width: screenWidth,
//                                 height: 350 * fem,
//                                 child: imageProduct.isEmpty
//                                     ? const Center(
//                                         child: Text('No images available'))
//                                     : PageView.builder(
//                                         itemCount: imageProduct.length,
//                                         controller: sliderController,
//                                         pageSnapping: true,
//                                         itemBuilder: (context, pagePosition) {
//                                           return InkWell(
//                                             onTap: () {
//                                               Navigator.of(context).push(
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       ImageScreen(
//                                                     image:
//                                                         '${configModel.apiConfig['mediaURL']}${imageProduct[pagePosition]}',
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             child: Image.network(
//                                               '${configModel.apiConfig['mediaURL']}${imageProduct[pagePosition]}',
//                                               fit: BoxFit.contain,
//                                               errorBuilder: (context, error,
//                                                       stackTrace) =>
//                                                   const Icon(Icons.error),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                               ),
//                               Positioned(
//                                 top: 10 * fem,
//                                 right: 10 * fem,
//                                 child: Row(
//                                   children: [
//                                     InkWell(
//                                       onTap: () async {
//                                         if (configModel.user == null) {
//                                           showDialog(
//                                             context: context,
//                                             builder: (context) =>
//                                                 LoginRequiredPopupWidget(),
//                                           );
//                                         } else {
//                                           await wishListModel.getWishLists(
//                                               widget.arguments!['product']
//                                                   ['id']);
//                                           setState(() {});
//                                         }
//                                       },
//                                       child: wishListModel.wishListLoader
//                                           ? SizedBox(
//                                               width: 20 * ffem,
//                                               height: 20 * ffem,
//                                               child:
//                                                   const CircularProgressIndicator(
//                                                       strokeWidth: 2),
//                                             )
//                                           : Icon(
//                                               wishListModel.wishLists?.any((wishList) =>
//                                                           wishList.productId ==
//                                                               widget.arguments![
//                                                                       'product']
//                                                                   ['id'] &&
//                                                           wishList.userId ==
//                                                               configModel
//                                                                   .user?.id) ??
//                                                       false
//                                                   ? Icons.favorite_outlined
//                                                   : Icons
//                                                       .favorite_border_outlined,
//                                               color: wishListModel.wishLists
//                                                           ?.any((wishList) =>
//                                                               wishList.productId ==
//                                                                   widget.arguments![
//                                                                           'product']
//                                                                       ['id'] &&
//                                                               wishList.userId ==
//                                                                   configModel
//                                                                       .user
//                                                                       ?.id) ??
//                                                       false
//                                                   ? Colors.red
//                                                   : null,
//                                               size: 20 * ffem,
//                                             ),
//                                     ),
//                                     SizedBox(width: 10 * fem),
//                                     IconButton(
//                                       onPressed: () {
//                                         Share.share(
//                                           'Check out this product: ${product.name ?? ''}\n\nDescription: ${product.description ?? ''}\n\nLink: ${configModel.apiConfig['mediaURL']}${product.imagepath1 ?? ''}',
//                                         );
//                                       },
//                                       icon: const Icon(Icons.share),
//                                       color: Colors.black,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 325 * fem,
//                                 child: Container(
//                                   width: screenWidth,
//                                   height: 41 * fem,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(30 * fem),
//                                       topRight: Radius.circular(30 * fem),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Center(
//                             child: SmoothPageIndicator(
//                               controller: sliderController,
//                               count: imageProduct.length,
//                               effect: ExpandingDotsEffect(
//                                 dotHeight: 8 * fem,
//                                 dotWidth: 8 * fem,
//                                 activeDotColor: Colors.blue,
//                                 dotColor: Colors.grey,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 15 * fem),
//                           // Thumbnail Images
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8 * fem),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   flex: 1,
//                                   child: IconButton(
//                                     icon:
//                                         Icon(Icons.arrow_left, size: 24 * ffem),
//                                     onPressed: () {
//                                       if (productDisplayImages.isNotEmpty) {
//                                         final currentIndex =
//                                             productDisplayImages.indexWhere(
//                                                 (image) =>
//                                                     image.unit?.name ==
//                                                     unitName);
//                                         final newIndex = (currentIndex - 1)
//                                             .clamp(
//                                                 0,
//                                                 productDisplayImages.length -
//                                                     1);
//                                         setState(() {
//                                           unitName =
//                                               productDisplayImages[newIndex]
//                                                       .unit
//                                                       ?.name
//                                                       ?.toString() ??
//                                                   '';
//                                           _cartData['flavour'] = unitName;
//                                           _cartData['pack'] =
//                                               productDisplayImages[newIndex]
//                                                       .id
//                                                       ?.toString() ??
//                                                   '';
//                                           updateProductDisplayImages = widget
//                                                   .arguments?['product_images']
//                                                   ?.where((image) =>
//                                                       image.unit?.name ==
//                                                       unitName)
//                                                   ?.toList() ??
//                                               [];
//                                           _sizes = widget.arguments?['product']
//                                                       ?['product_packs']
//                                                   ?.where((pack) =>
//                                                       pack['unit']?['name'] ==
//                                                       unitName)
//                                                   ?.toList() ??
//                                               [];
//                                           activeIndex =
//                                               0; // Pre-select first size
//                                           _cartData['kindOfFlower'] =
//                                               _sizes.isNotEmpty
//                                                   ? _sizes[0]['value']
//                                                           ?.toString() ??
//                                                       ''
//                                                   : '';
//                                           _prices = widget.arguments?['product']
//                                                       ?['product_prices']
//                                                   ?.where((price) =>
//                                                       price[
//                                                           'product_pack_id'] ==
//                                                       _sizes[0]?['id'])
//                                                   ?.toList() ??
//                                               [];
//                                           _productPoints = _sizes.isNotEmpty
//                                               ? _sizes[0]['points']
//                                                       ?.toString() ??
//                                                   ''
//                                               : '';
//                                           discountPrice = _prices.isNotEmpty &&
//                                                   _prices[0]['offer_price'] != 0
//                                               ? ((int.parse(_prices[0]['price']
//                                                           .toString()) -
//                                                       int.parse(_prices[0]
//                                                               ['offer_price']
//                                                           .toString())) /
//                                                   int.parse(_prices[0]['price']
//                                                       .toString()) *
//                                                   100)
//                                               : 0.0;
//                                         });
//                                       }
//                                     },
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 10,
//                                   child: SizedBox(
//                                     height: 100 * fem,
//                                     child: ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 5 * fem),
//                                       itemCount: productDisplayImages.length,
//                                       itemBuilder: (context, index) {
//                                         final isSelected = unitName ==
//                                             productDisplayImages[index]
//                                                 .unit
//                                                 ?.name;
//                                         return InkWell(
//                                           onTap: () {
//                                             setState(() {
//                                               unitName =
//                                                   productDisplayImages[index]
//                                                           .unit
//                                                           ?.name
//                                                           ?.toString() ??
//                                                       '';
//                                               _cartData['flavour'] = unitName;
//                                               _cartData['pack'] =
//                                                   productDisplayImages[index]
//                                                           .id
//                                                           ?.toString() ??
//                                                       '';
//                                               updateProductDisplayImages =
//                                                   widget.arguments?[
//                                                               'product_images']
//                                                           ?.where((image) =>
//                                                               image
//                                                                   .unit?.name ==
//                                                               unitName)
//                                                           ?.toList() ??
//                                                       [];
//                                               _sizes = widget
//                                                       .arguments?['product']
//                                                           ?['product_packs']
//                                                       ?.where((pack) =>
//                                                           pack['unit']
//                                                               ?['name'] ==
//                                                           unitName)
//                                                       ?.toList() ??
//                                                   [];
//                                               activeIndex =
//                                                   0; // Pre-select first size
//                                               _cartData['kindOfFlower'] =
//                                                   _sizes.isNotEmpty
//                                                       ? _sizes[0]['value']
//                                                               ?.toString() ??
//                                                           ''
//                                                       : '';
//                                               _prices = widget
//                                                       .arguments?['product']
//                                                           ?['product_prices']
//                                                       ?.where((price) =>
//                                                           price[
//                                                               'product_pack_id'] ==
//                                                           _sizes[0]?['id'])
//                                                       ?.toList() ??
//                                                   [];
//                                               _productPoints = _sizes.isNotEmpty
//                                                   ? _sizes[0]['points']
//                                                           ?.toString() ??
//                                                       ''
//                                                   : '';
//                                               discountPrice = _prices
//                                                           .isNotEmpty &&
//                                                       _prices[0]['offer_price'] !=
//                                                           0
//                                                   ? ((int.parse(_prices[0]
//                                                                   ['price']
//                                                               .toString()) -
//                                                           int.parse(_prices[0][
//                                                                   'offer_price']
//                                                               .toString())) /
//                                                       int.parse(_prices[0]
//                                                               ['price']
//                                                           .toString()) *
//                                                       100)
//                                                   : 0.0;
//                                             });
//                                           },
//                                           child: Container(
//                                             margin:
//                                                 EdgeInsets.only(right: 8 * fem),
//                                             width: 60 * fem,
//                                             height: 80 * fem,
//                                             decoration: BoxDecoration(
//                                               border: isSelected
//                                                   ? Border.all(
//                                                       color: Colors.black,
//                                                       width: 2 * fem)
//                                                   : Border.all(
//                                                       color: Colors.grey[300]!),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       8 * fem),
//                                             ),
//                                             child: productDisplayImages[index]
//                                                         .imagepath !=
//                                                     null
//                                                 ? Image.network(
//                                                     '${configModel.apiConfig['mediaURL']}${productDisplayImages[index].imagepath}',
//                                                     fit: BoxFit.cover,
//                                                     errorBuilder: (context,
//                                                             error,
//                                                             stackTrace) =>
//                                                         const Icon(Icons.error),
//                                                   )
//                                                 : const Center(
//                                                     child: Text('No Image')),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 1,
//                                   child: IconButton(
//                                     icon: Icon(Icons.arrow_right,
//                                         size: 24 * ffem),
//                                     onPressed: () {
//                                       if (productDisplayImages.isNotEmpty) {
//                                         final currentIndex =
//                                             productDisplayImages.indexWhere(
//                                                 (image) =>
//                                                     image.unit?.name ==
//                                                     unitName);
//                                         final newIndex = (currentIndex + 1)
//                                             .clamp(
//                                                 0,
//                                                 productDisplayImages.length -
//                                                     1);
//                                         setState(() {
//                                           unitName =
//                                               productDisplayImages[newIndex]
//                                                       .unit
//                                                       ?.name
//                                                       ?.toString() ??
//                                                   '';
//                                           _cartData['flavour'] = unitName;
//                                           _cartData['pack'] =
//                                               productDisplayImages[newIndex]
//                                                       .id
//                                                       ?.toString() ??
//                                                   '';
//                                           updateProductDisplayImages = widget
//                                                   .arguments?['product_images']
//                                                   ?.where((image) =>
//                                                       image.unit?.name ==
//                                                       unitName)
//                                                   ?.toList() ??
//                                               [];
//                                           _sizes = widget.arguments?['product']
//                                                       ?['product_packs']
//                                                   ?.where((pack) =>
//                                                       pack['unit']?['name'] ==
//                                                       unitName)
//                                                   ?.toList() ??
//                                               [];
//                                           activeIndex =
//                                               0; // Pre-select first size
//                                           _cartData['kindOfFlower'] =
//                                               _sizes.isNotEmpty
//                                                   ? _sizes[0]['value']
//                                                           ?.toString() ??
//                                                       ''
//                                                   : '';
//                                           _prices = widget.arguments?['product']
//                                                       ?['product_prices']
//                                                   ?.where((price) =>
//                                                       price[
//                                                           'product_pack_id'] ==
//                                                       _sizes[0]?['id'])
//                                                   ?.toList() ??
//                                               [];
//                                           _productPoints = _sizes.isNotEmpty
//                                               ? _sizes[0]['points']
//                                                       ?.toString() ??
//                                                   ''
//                                               : '';
//                                           discountPrice = _prices.isNotEmpty &&
//                                                   _prices[0]['offer_price'] != 0
//                                               ? ((int.parse(_prices[0]['price']
//                                                           .toString()) -
//                                                       int.parse(_prices[0]
//                                                               ['offer_price']
//                                                           .toString())) /
//                                                   int.parse(_prices[0]['price']
//                                                       .toString()) *
//                                                   100)
//                                               : 0.0;
//                                         });
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // Product Details
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 25 * fem),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             product.name ?? 'Unnamed Product',
//                                             style: MyGoogleFontStyle(
//                                               fontFamily: 'Urbanist',
//                                               fontSize: 19 * ffem,
//                                               fontWeight: FontWeight.w700,
//                                               color: const Color(0xff000000),
//                                             ),
//                                           ),
//                                           SizedBox(height: 8 * fem),
//                                           Row(
//                                             children: [
//                                               if (product.rating != null &&
//                                                   product.rating != '0')
//                                                 RatingBar.builder(
//                                                   itemSize: 15 * ffem,
//                                                   initialRating:
//                                                       double.tryParse(
//                                                               product.rating ??
//                                                                   '0.0') ??
//                                                           0.0,
//                                                   direction: Axis.horizontal,
//                                                   itemCount: 5,
//                                                   allowHalfRating: true,
//                                                   ignoreGestures: true,
//                                                   itemBuilder: (context, _) =>
//                                                       const Icon(Icons.star,
//                                                           color: Colors.amber),
//                                                   onRatingUpdate:
//                                                       (double value) {},
//                                                 ),
//                                               Text(
//                                                 '(${product.reviews?.length ?? 0} Review${(product.reviews?.length ?? 0) == 1 ? '' : 's'})',
//                                                 style: MyGoogleFontStyle(
//                                                   fontFamily: 'Urbanist',
//                                                   fontSize: 10 * ffem,
//                                                   fontWeight: FontWeight.w400,
//                                                   color:
//                                                       const Color(0xff000000),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(width: 20 * fem),
//                                     Column(
//                                       children: [
//                                         if (addToCartModel.addToCarts
//                                                 ?.where((cart) =>
//                                                     cart.productId ==
//                                                         widget.arguments![
//                                                             'product']['id'] &&
//                                                     cart.flavour == unitName &&
//                                                     cart.kindOfFlower == size)
//                                                 .isEmpty ??
//                                             true)
//                                           TextButton(
//                                             onPressed: () async {
//                                               if (configModel.user == null) {
//                                                 showDialog(
//                                                   context: context,
//                                                   builder: (context) =>
//                                                       LoginRequiredPopupWidget(),
//                                                 );
//                                               } else if (_cartData[
//                                                       'kindOfFlower'] ==
//                                                   '') {
//                                                 showDialog(
//                                                   context: context,
//                                                   builder: (context) =>
//                                                       AlertDialog(
//                                                     shape: RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                     20 * fem)),
//                                                     title: const Text(
//                                                         'Kindly choose a size.'),
//                                                     actions: [
//                                                       TextButton(
//                                                         onPressed: () =>
//                                                             Navigator.pop(
//                                                                 context),
//                                                         child: Text(
//                                                           'Ok',
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize:
//                                                                   16 * ffem),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 );
//                                               } else if (_cartData['flavour'] ==
//                                                   '') {
//                                                 showDialog(
//                                                   context: context,
//                                                   builder: (context) =>
//                                                       AlertDialog(
//                                                     shape: RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                     20 * fem)),
//                                                     title: const Text(
//                                                         'Kindly choose a colour.'),
//                                                     actions: [
//                                                       TextButton(
//                                                         onPressed: () =>
//                                                             Navigator.pop(
//                                                                 context),
//                                                         child: Text(
//                                                           'Ok',
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize:
//                                                                   16 * ffem),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 );
//                                               } else {
//                                                 _cartData['points'] =
//                                                     _productPoints;
//                                                 _cartData[
//                                                     'product_price'] = _prices
//                                                             .isNotEmpty &&
//                                                         _prices[0][
//                                                                 'offer_price'] !=
//                                                             0
//                                                     ? _prices[0]['offer_price']
//                                                         .toString()
//                                                     : _prices[0]['price']
//                                                         .toString();
//                                                 _cartData['is_add_to_cart'] =
//                                                     true;
//                                                 await addToCartModel
//                                                     .getAddToCart(
//                                                         widget.arguments![
//                                                             'product']['id'],
//                                                         true,
//                                                         _cartData);
//                                                 setState(() {
//                                                   cartCount = addToCartModel
//                                                           .addToCarts?.length ??
//                                                       0;
//                                                 });
//                                               }
//                                             },
//                                             style: TextButton.styleFrom(
//                                                 padding: EdgeInsets.zero),
//                                             child: Container(
//                                               width: 82 * fem,
//                                               height: 27.33 * fem,
//                                               decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                     color: const Color(
//                                                         0xffeaeaea)),
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         15 * fem),
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     color: Colors.black
//                                                         .withOpacity(0.1),
//                                                     offset: const Offset(0, 2),
//                                                     blurRadius: 5,
//                                                   ),
//                                                 ],
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   'ADD',
//                                                   style: MyGoogleFontStyle(
//                                                     fontFamily: 'DM Sans',
//                                                     fontSize: 12 * ffem,
//                                                     fontWeight: FontWeight.w700,
//                                                     color:
//                                                         const Color(0xffc7b456),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         if (addToCartModel.addToCarts
//                                                 ?.where((cart) =>
//                                                     cart.productId ==
//                                                         widget.arguments![
//                                                             'product']['id'] &&
//                                                     cart.flavour == unitName &&
//                                                     cart.kindOfFlower == size)
//                                                 .isNotEmpty ??
//                                             false)
//                                           Row(
//                                             children: [
//                                               TextButton(
//                                                 onPressed: () async {
//                                                   if (_cartData[
//                                                               'kindOfFlower'] ==
//                                                           '' ||
//                                                       _cartData['flavour'] ==
//                                                           '') {
//                                                     showDialog(
//                                                       context: context,
//                                                       builder: (context) =>
//                                                           AlertDialog(
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(20 *
//                                                                         fem)),
//                                                         title: Text(
//                                                           _cartData['kindOfFlower'] ==
//                                                                       '' &&
//                                                                   _cartData[
//                                                                           'flavour'] !=
//                                                                       ''
//                                                               ? 'Kindly choose size.'
//                                                               : _cartData['flavour'] ==
//                                                                           '' &&
//                                                                       _cartData[
//                                                                               'kindOfFlower'] !=
//                                                                           ''
//                                                                   ? 'Kindly choose colour.'
//                                                                   : 'Kindly choose colour and size.',
//                                                         ),
//                                                         actions: [
//                                                           TextButton(
//                                                             onPressed: () =>
//                                                                 Navigator.pop(
//                                                                     context),
//                                                             child: Text(
//                                                               'Ok',
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .black,
//                                                                   fontSize: 16 *
//                                                                       ffem),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     );
//                                                   } else {
//                                                     _cartData[
//                                                             'is_add_to_cart'] =
//                                                         true;
//                                                     await addToCartModel
//                                                         .getAddToCart(
//                                                             widget.arguments![
//                                                                     'product']
//                                                                 ['id'],
//                                                             false,
//                                                             _cartData);
//                                                     setState(() {
//                                                       cartCount = addToCartModel
//                                                               .addToCarts
//                                                               ?.length ??
//                                                           0;
//                                                     });
//                                                   }
//                                                 },
//                                                 style: TextButton.styleFrom(
//                                                     padding: EdgeInsets.zero),
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     border: Border.all(),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             5 * fem),
//                                                   ),
//                                                   child: Icon(Icons.remove,
//                                                       color: Colors.black,
//                                                       size: 20 * ffem),
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal: 8 * fem),
//                                                 child: Text(
//                                                   addToCartModel.addToCarts
//                                                           ?.firstWhere(
//                                                             (cart) =>
//                                                                 cart.productId ==
//                                                                     widget.arguments![
//                                                                             'product']
//                                                                         [
//                                                                         'id'] &&
//                                                                 cart.flavour ==
//                                                                     unitName &&
//                                                                 cart.kindOfFlower ==
//                                                                     size,
//                                                             orElse: () =>
//                                                                 AddToCartModel()
//                                                                     .addToCarts!
//                                                                     .first,
//                                                           )
//                                                           ?.qty
//                                                           ?.toString() ??
//                                                       '0',
//                                                   style: MyGoogleFontStyle(
//                                                     fontFamily: 'Poppins',
//                                                     fontSize: 14 * ffem,
//                                                     fontWeight: FontWeight.w500,
//                                                     color:
//                                                         const Color(0xff1e1e1e),
//                                                   ),
//                                                 ),
//                                               ),
//                                               TextButton(
//                                                 onPressed: () async {
//                                                   if (_cartData[
//                                                               'kindOfFlower'] ==
//                                                           '' ||
//                                                       _cartData['flavour'] ==
//                                                           '') {
//                                                     showDialog(
//                                                       context: context,
//                                                       builder: (context) =>
//                                                           AlertDialog(
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(20 *
//                                                                         fem)),
//                                                         title: Text(
//                                                           _cartData['kindOfFlower'] ==
//                                                                       '' &&
//                                                                   _cartData[
//                                                                           'flavour'] !=
//                                                                       ''
//                                                               ? 'Kindly choose size.'
//                                                               : _cartData['flavour'] ==
//                                                                           '' &&
//                                                                       _cartData[
//                                                                               'kindOfFlower'] !=
//                                                                           ''
//                                                                   ? 'Kindly choose colour.'
//                                                                   : 'Kindly choose colour and size.',
//                                                         ),
//                                                         actions: [
//                                                           TextButton(
//                                                             onPressed: () =>
//                                                                 Navigator.pop(
//                                                                     context),
//                                                             child: Text(
//                                                               'Ok',
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .black,
//                                                                   fontSize: 16 *
//                                                                       ffem),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     );
//                                                   } else {
//                                                     _cartData[
//                                                             'is_add_to_cart'] =
//                                                         true;
//                                                     await addToCartModel
//                                                         .getAddToCart(
//                                                             widget.arguments![
//                                                                     'product']
//                                                                 ['id'],
//                                                             true,
//                                                             _cartData);
//                                                     setState(() {
//                                                       cartCount = addToCartModel
//                                                               .addToCarts
//                                                               ?.length ??
//                                                           0;
//                                                     });
//                                                   }
//                                                 },
//                                                 style: TextButton.styleFrom(
//                                                     padding: EdgeInsets.zero),
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     border: Border.all(),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             5 * fem),
//                                                   ),
//                                                   child: Icon(Icons.add,
//                                                       color: Colors.black,
//                                                       size: 20 * ffem),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         Text(
//                                           'Available in stock',
//                                           style: MyGoogleFontStyle(
//                                             fontFamily: 'Urbanist',
//                                             fontSize: 12 * ffem,
//                                             fontWeight: FontWeight.w600,
//                                             color: const Color(0xff000000),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 // Price
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                       left: 25 * fem, top: 10 * fem),
//                                   child: _prices.isNotEmpty &&
//                                           _prices[0]['offer_price'] != 0
//                                       ? Text.rich(
//                                           TextSpan(
//                                             children: [
//                                               TextSpan(
//                                                 text: 'Total Price',
//                                                 style: TextStyle(
//                                                     color: Colors.grey[500],
//                                                     fontSize: 14 * ffem),
//                                               ),
//                                               WidgetSpan(
//                                                   child: SizedBox(
//                                                       width: 20 * fem)),
//                                               TextSpan(
//                                                 text: '₹${_prices[0]['price']}',
//                                                 style: TextStyle(
//                                                   color:
//                                                       const Color(0xFFC7B456),
//                                                   decoration: TextDecoration
//                                                       .lineThrough,
//                                                   fontSize: 18 * ffem,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                               WidgetSpan(
//                                                   child: SizedBox(
//                                                       width: 20 * fem)),
//                                               TextSpan(
//                                                 text:
//                                                     '₹${_prices[0]['offer_price']}',
//                                                 style: TextStyle(
//                                                   fontSize: 18 * ffem,
//                                                   fontWeight: FontWeight.bold,
//                                                   color:
//                                                       const Color(0xff000000),
//                                                 ),
//                                               ),
//                                               if (discountPrice != 0.0) ...[
//                                                 WidgetSpan(
//                                                     child: SizedBox(
//                                                         width: 10 * fem)),
//                                                 TextSpan(
//                                                   text:
//                                                       '(${discountPrice.round()}% Off)',
//                                                   style: TextStyle(
//                                                     fontSize: 16 * ffem,
//                                                     fontWeight: FontWeight.bold,
//                                                     color:
//                                                         const Color(0xff000000),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ],
//                                           ),
//                                         )
//                                       : Text(
//                                           _prices.isNotEmpty
//                                               ? '₹${_prices[0]['price']}'
//                                               : 'Price not available',
//                                           style: MyGoogleFontStyle(
//                                             fontFamily: 'Poppins',
//                                             fontSize: 18 * ffem,
//                                             fontWeight: FontWeight.w500,
//                                             color: const Color(0x99000000),
//                                           ),
//                                         ),
//                                 ),
//                                 // Size Selection
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                       left: 25 * fem,
//                                       top: 15 * fem,
//                                       bottom: 5 * fem),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Size',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontSize: 16 * ffem,
//                                           fontWeight: FontWeight.w700,
//                                           color: const Color(0xff000000),
//                                         ),
//                                       ),
//                                       SizedBox(height: 10 * fem),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             flex: 8,
//                                             child: SizedBox(
//                                               height: 60 * fem,
//                                               child: ListView.builder(
//                                                 scrollDirection:
//                                                     Axis.horizontal,
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal: 10 * fem),
//                                                 itemCount: _sizes.length,
//                                                 itemBuilder: (context, index) {
//                                                   final isActive =
//                                                       index == activeIndex;
//                                                   return Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal:
//                                                                 8 * fem),
//                                                     child: TextButton(
//                                                       onPressed: () {
//                                                         setState(() {
//                                                           activeIndex = index;
//                                                           _cartData[
//                                                               'kindOfFlower'] = _sizes[
//                                                                           index]
//                                                                       ['value']
//                                                                   ?.toString() ??
//                                                               '';
//                                                           size = _sizes[index]
//                                                                       ['value']
//                                                                   ?.toString() ??
//                                                               '';
//                                                           _prices = widget
//                                                                   .arguments?[
//                                                                       'product']
//                                                                       ?[
//                                                                       'product_prices']
//                                                                   ?.where((price) =>
//                                                                       price[
//                                                                           'product_pack_id'] ==
//                                                                       _sizes[index]
//                                                                           [
//                                                                           'id'])
//                                                                   ?.toList() ??
//                                                               [];
//                                                           _productPoints = widget
//                                                                   .arguments?[
//                                                                       'product']
//                                                                       ?[
//                                                                       'product_packs']
//                                                                   ?.where((pack) =>
//                                                                       pack[
//                                                                           'id'] ==
//                                                                       _sizes[index]
//                                                                           [
//                                                                           'id'])
//                                                                   ?.toList()[0]
//                                                                       ['points']
//                                                                   ?.toString() ??
//                                                               '';
//                                                           discountPrice = _prices
//                                                                       .isNotEmpty &&
//                                                                   _prices[0][
//                                                                           'offer_price'] !=
//                                                                       0
//                                                               ? ((int.parse(_prices[0]['price']
//                                                                           .toString()) -
//                                                                       int.parse(
//                                                                           _prices[0]['offer_price']
//                                                                               .toString())) /
//                                                                   int.parse(_prices[0]
//                                                                           ['price']
//                                                                       .toString()) *
//                                                                   100)
//                                                               : 0.0;
//                                                         });
//                                                       },
//                                                       style:
//                                                           TextButton.styleFrom(
//                                                         padding:
//                                                             EdgeInsets.zero,
//                                                         backgroundColor:
//                                                             isActive
//                                                                 ? Colors.black
//                                                                 : Colors.white,
//                                                         shape:
//                                                             RoundedRectangleBorder(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       30 * fem),
//                                                         ),
//                                                       ),
//                                                       child: Container(
//                                                         width: 50 * fem,
//                                                         height: 50 * fem,
//                                                         decoration:
//                                                             ShapeDecoration(
//                                                           shape: OvalBorder(
//                                                             side: BorderSide(
//                                                                 width:
//                                                                     0.95 * fem,
//                                                                 color: const Color(
//                                                                     0xFFDDDDDD)),
//                                                           ),
//                                                         ),
//                                                         child: Center(
//                                                           child: Text(
//                                                             _sizes[index][
//                                                                         'value']
//                                                                     ?.toString() ??
//                                                                 '',
//                                                             style:
//                                                                 MyGoogleFontStyle(
//                                                               fontFamily:
//                                                                   'Urbanist',
//                                                               fontSize:
//                                                                   15 * ffem,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                               color: isActive
//                                                                   ? Colors.white
//                                                                   : const Color(
//                                                                       0x99000000),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(width: 15 * fem),
//                                           Expanded(
//                                             flex: 2,
//                                             child: InkWell(
//                                               onTap: () {
//                                                 if (product.sizeChartPath !=
//                                                     null) {
//                                                   showModalBottomSheet(
//                                                     context: context,
//                                                     builder: (context) =>
//                                                         Container(
//                                                       width: double.infinity,
//                                                       padding: EdgeInsets.all(
//                                                           20 * fem),
//                                                       height: 200 * fem,
//                                                       child: Image.network(
//                                                         '${configModel.apiConfig['mediaURL']}${product.sizeChartPath}',
//                                                         fit: BoxFit.contain,
//                                                         errorBuilder: (context,
//                                                                 error,
//                                                                 stackTrace) =>
//                                                             const Icon(
//                                                                 Icons.error),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 }
//                                               },
//                                               child: Column(
//                                                 children: [
//                                                   Image.asset(
//                                                     'assets/images/size-chart-icon.png',
//                                                     width: 40 * fem,
//                                                     height: 40 * fem,
//                                                   ),
//                                                   Text(
//                                                     'Size Chart',
//                                                     style: TextStyle(
//                                                       fontSize: 11 * ffem,
//                                                       color: Colors.black,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 // Points
//                                 if (_productPoints.isNotEmpty)
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                         left: 25 * fem, top: 10 * fem),
//                                     child: Text(
//                                       'Earn $_productPoints points for this product',
//                                       style: MyGoogleFontStyle(
//                                         fontFamily: 'Urbanist',
//                                         fontSize: 14 * ffem,
//                                         fontWeight: FontWeight.w700,
//                                         color: const Color(0xFFC7B456),
//                                       ),
//                                     ),
//                                   ),
//                                 // Customer Ratings
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                       left: 25 * fem, top: 10 * fem),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Customer Ratings',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Poppins',
//                                           fontSize: 14 * ffem,
//                                           fontWeight: FontWeight.bold,
//                                           color: const Color(0x99000000),
//                                         ),
//                                       ),
//                                       if (product.rating != null &&
//                                           product.rating != '0')
//                                         Row(
//                                           children: [
//                                             Text(
//                                               product.rating.toString(),
//                                               style: MyGoogleFontStyle(
//                                                 fontFamily: 'Poppins',
//                                                 fontSize: 14 * ffem,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: const Color(0x99000000),
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding: EdgeInsets.only(
//                                                   left: 3 * fem),
//                                               child: const Icon(Icons.star,
//                                                   color: Colors.amber,
//                                                   size: 16),
//                                             ),
//                                             Text(
//                                               '(${product.reviews?.length ?? 0} ratings)',
//                                               style: TextStyle(
//                                                   fontSize: 12 * ffem),
//                                             ),
//                                             const Spacer(),
//                                             InkWell(
//                                               onTap: () {
//                                                 Navigator.pushNamed(
//                                                   context,
//                                                   '/reviewsPage',
//                                                   arguments: {
//                                                     'productId':
//                                                         widget.arguments![
//                                                             'product']['id']
//                                                   },
//                                                 );
//                                               },
//                                               child: Text(
//                                                 'View Reviews & Ratings',
//                                                 style: MyGoogleFontStyle(
//                                                   fontFamily: 'Poppins',
//                                                   fontSize: 12 * ffem,
//                                                   fontWeight: FontWeight.bold,
//                                                   color:
//                                                       const Color(0x99000000),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                                 // Descriptions
//                                 if (product.smallDescription != null)
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 25 * fem,
//                                         vertical: 10 * fem),
//                                     child: Card(
//                                       elevation: 4,
//                                       color: Colors.white,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(12 * fem)),
//                                       child: Padding(
//                                         padding: EdgeInsets.all(16 * fem),
//                                         child: Html(
//                                             data: product.smallDescription
//                                                 .toString()),
//                                       ),
//                                     ),
//                                   ),
//                                 if (product.description != null)
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 25 * fem,
//                                         vertical: 10 * fem),
//                                     child: Card(
//                                       elevation: 4,
//                                       color: Colors.white,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(12 * fem)),
//                                       child: Padding(
//                                         padding: EdgeInsets.all(16 * fem),
//                                         child: Html(
//                                             data:
//                                                 product.description.toString()),
//                                       ),
//                                     ),
//                                   ),
//                                 if (product.description1 != null)
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 25 * fem,
//                                         vertical: 10 * fem),
//                                     child: Card(
//                                       elevation: 4,
//                                       color: Colors.white,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(12 * fem)),
//                                       child: Padding(
//                                         padding: EdgeInsets.all(16 * fem),
//                                         child: Html(
//                                             data: product.description1
//                                                 .toString()),
//                                       ),
//                                     ),
//                                   ),
//                                 if (product.description2 != null)
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 25 * fem,
//                                         vertical: 10 * fem),
//                                     child: Card(
//                                       elevation: 4,
//                                       color: Colors.white,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(12 * fem)),
//                                       child: Padding(
//                                         padding: EdgeInsets.all(16 * fem),
//                                         child: Html(
//                                             data: product.description2
//                                                 .toString()),
//                                       ),
//                                     ),
//                                   ),
//                                 // Add More Items
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                       left: 25 * fem, top: 20 * fem),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Add More Items',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontSize: 16 * ffem,
//                                           fontWeight: FontWeight.w700,
//                                           color: const Color(0xff000000),
//                                         ),
//                                       ),
//                                       SizedBox(height: 10 * fem),
//                                       SizedBox(
//                                         height: 260 * fem,
//                                         child: productModel
//                                                 .categoryWiseproductsLoader
//                                             ? const Center(
//                                                 child:
//                                                     CircularProgressIndicator())
//                                             : productModel.categoryWiseproducts
//                                                         ?.isEmpty ??
//                                                     true
//                                                 ? const Center(
//                                                     child: Text(
//                                                         'No related products available'))
//                                                 : ListView.builder(
//                                                     scrollDirection:
//                                                         Axis.horizontal,
//                                                     itemCount: productModel
//                                                         .categoryWiseproducts!
//                                                         .length,
//                                                     itemBuilder:
//                                                         (context, index) {
//                                                       final relatedProduct =
//                                                           productModel
//                                                                   .categoryWiseproducts![
//                                                               index];
//                                                       final relatedDiscount = relatedProduct
//                                                                   .productPrices
//                                                                   ?.isNotEmpty ??
//                                                               false
//                                                           ? ((int.parse(relatedProduct
//                                                                       .productPrices![
//                                                                           0]
//                                                                       .price
//                                                                       .toString()) -
//                                                                   int.parse(relatedProduct
//                                                                       .productPrices![
//                                                                           0]
//                                                                       .offerPrice
//                                                                       .toString())) /
//                                                               int.parse(relatedProduct
//                                                                   .productPrices![0]
//                                                                   .price
//                                                                   .toString()) *
//                                                               100)
//                                                           : 0.0;
//                                                       return InkWell(
//                                                         onTap: () {
//                                                           Navigator.of(context)
//                                                               .push(
//                                                             MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   ProductIdPage(
//                                                                 arguments: {
//                                                                   'product':
//                                                                       relatedProduct
//                                                                           .toJson(),
//                                                                   'product_images':
//                                                                       relatedProduct
//                                                                           .productImages,
//                                                                 },
//                                                               ),
//                                                             ),
//                                                           );
//                                                         },
//                                                         child: Container(
//                                                           width: 145 * fem,
//                                                           margin:
//                                                               EdgeInsets.only(
//                                                                   right:
//                                                                       12 * fem),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         15 *
//                                                                             fem),
//                                                             color: Colors.white,
//                                                             boxShadow: [
//                                                               BoxShadow(
//                                                                 color: Colors
//                                                                     .black
//                                                                     .withOpacity(
//                                                                         0.1),
//                                                                 blurRadius: 5,
//                                                                 offset:
//                                                                     const Offset(
//                                                                         0, 2),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           child: Column(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .center,
//                                                             children: [
//                                                               Stack(
//                                                                 children: [
//                                                                   Container(
//                                                                     width: 145 *
//                                                                         fem,
//                                                                     height:
//                                                                         140 *
//                                                                             fem,
//                                                                     decoration:
//                                                                         BoxDecoration(
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(15 *
//                                                                               fem),
//                                                                       image:
//                                                                           DecorationImage(
//                                                                         fit: BoxFit
//                                                                             .cover,
//                                                                         image: relatedProduct.productImages?.isNotEmpty ??
//                                                                                 false
//                                                                             ? NetworkImage(
//                                                                                 '${configModel.apiConfig['mediaURL']}${relatedProduct.productImages!.first.imagepath}')
//                                                                             : const AssetImage('assets/images/placeholder.png')
//                                                                                 as ImageProvider,
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                   Positioned(
//                                                                     top:
//                                                                         8 * fem,
//                                                                     right:
//                                                                         8 * fem,
//                                                                     child:
//                                                                         InkWell(
//                                                                       onTap:
//                                                                           () async {
//                                                                         if (configModel.user ==
//                                                                             null) {
//                                                                           showDialog(
//                                                                             context:
//                                                                                 context,
//                                                                             builder: (context) =>
//                                                                                 LoginRequiredPopupWidget(),
//                                                                           );
//                                                                         } else {
//                                                                           await wishListModel
//                                                                               .getWishLists(relatedProduct.id);
//                                                                           setState(
//                                                                               () {});
//                                                                         }
//                                                                       },
//                                                                       child: wishListModel
//                                                                               .wishListLoader
//                                                                           ? SizedBox(
//                                                                               width: 20 * ffem,
//                                                                               height: 20 * ffem,
//                                                                               child: const CircularProgressIndicator(strokeWidth: 2),
//                                                                             )
//                                                                           : Icon(
//                                                                               wishListModel.wishLists?.any((wishList) => wishList.productId == relatedProduct.id && wishList.userId == configModel.user?.id) ?? false ? Icons.favorite_outlined : Icons.favorite_border_outlined,
//                                                                               color: wishListModel.wishLists?.any((wishList) => wishList.productId == relatedProduct.id && wishList.userId == configModel.user?.id) ?? false ? Colors.red : null,
//                                                                               size: 20 * ffem,
//                                                                             ),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                               Padding(
//                                                                 padding: EdgeInsets.symmetric(
//                                                                     horizontal:
//                                                                         10 *
//                                                                             fem,
//                                                                     vertical:
//                                                                         8 * fem),
//                                                                 child: Text(
//                                                                   relatedProduct
//                                                                           .name ??
//                                                                       'Unnamed Product',
//                                                                   textAlign:
//                                                                       TextAlign
//                                                                           .center,
//                                                                   maxLines: 2,
//                                                                   overflow:
//                                                                       TextOverflow
//                                                                           .ellipsis,
//                                                                   style:
//                                                                       MyGoogleFontStyle(
//                                                                     fontFamily:
//                                                                         'Urbanist',
//                                                                     fontSize:
//                                                                         15 *
//                                                                             ffem,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w700,
//                                                                     color: const Color(
//                                                                         0xff000000),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               if (relatedProduct
//                                                                       .productPrices
//                                                                       ?.isNotEmpty ??
//                                                                   false)
//                                                                 Padding(
//                                                                   padding: EdgeInsets.only(
//                                                                       bottom: 4 *
//                                                                           fem),
//                                                                   child: relatedProduct
//                                                                               .productPrices![0]
//                                                                               .offerPrice !=
//                                                                           0
//                                                                       ? Text.rich(
//                                                                           TextSpan(
//                                                                             children: [
//                                                                               TextSpan(
//                                                                                 text: '₹${relatedProduct.productPrices![0].price}',
//                                                                                 style: TextStyle(
//                                                                                   color: Colors.grey,
//                                                                                   decoration: TextDecoration.lineThrough,
//                                                                                   fontSize: 13 * ffem,
//                                                                                   fontFamily: 'Poppins',
//                                                                                   fontWeight: FontWeight.w500,
//                                                                                 ),
//                                                                               ),
//                                                                               TextSpan(
//                                                                                 text: ' ₹${relatedProduct.productPrices![0].offerPrice}',
//                                                                                 style: TextStyle(
//                                                                                   fontSize: 13 * ffem,
//                                                                                   fontFamily: 'Poppins',
//                                                                                   fontWeight: FontWeight.w500,
//                                                                                   color: const Color(0x99000000),
//                                                                                 ),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                         )
//                                                                       : Text(
//                                                                           '₹${relatedProduct.productPrices![0].price}',
//                                                                           style:
//                                                                               MyGoogleFontStyle(
//                                                                             fontFamily:
//                                                                                 'Poppins',
//                                                                             fontSize:
//                                                                                 13 * ffem,
//                                                                             fontWeight:
//                                                                                 FontWeight.w500,
//                                                                             color:
//                                                                                 const Color(0x99000000),
//                                                                           ),
//                                                                         ),
//                                                                 ),
//                                                               if (relatedDiscount !=
//                                                                   0.0)
//                                                                 Text(
//                                                                   '(${relatedDiscount.round()}% Off)',
//                                                                   style:
//                                                                       MyGoogleFontStyle(
//                                                                     fontFamily:
//                                                                         'Poppins',
//                                                                     fontSize:
//                                                                         13 *
//                                                                             ffem,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w500,
//                                                                     color: const Color(
//                                                                         0x99000000),
//                                                                   ),
//                                                                 ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       );
//                                                     },
//                                                   ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ]),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: configModel.user == null
//           ? const SizedBox.shrink()
//           : Container(
//               padding: EdgeInsets.all(8 * fem),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () async {
//                         if (_cartData['kindOfFlower'] == '' ||
//                             _cartData['flavour'] == '') {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(20 * fem)),
//                               title: Text(
//                                 _cartData['kindOfFlower'] == '' &&
//                                         _cartData['flavour'] != ''
//                                     ? 'Kindly choose size.'
//                                     : _cartData['flavour'] == '' &&
//                                             _cartData['kindOfFlower'] != ''
//                                         ? 'Kindly choose colour.'
//                                         : 'Kindly choose colour and size.',
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: Text(
//                                     'Ok',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 16 * ffem),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         } else {
//                           _cartData['points'] = _productPoints;
//                           _cartData['product_price'] = _prices.isNotEmpty &&
//                                   _prices[0]['offer_price'] != 0
//                               ? _prices[0]['offer_price'].toString()
//                               : _prices[0]['price'].toString();
//                           await addToCartModel.getAddToCart(
//                               widget.arguments!['product']['id'],
//                               true,
//                               _cartData);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   CartPage(isProfile: {'isProfile': false}),
//                             ),
//                           );
//                         }
//                       },
//                       style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 20 * fem, vertical: 10 * fem),
//                         decoration: BoxDecoration(
//                           color: const Color(0xff1e1e1e),
//                           borderRadius: BorderRadius.circular(10 * fem),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               'assets/images/shopping-bag-03.png',
//                               width: 18 * fem,
//                               height: 17 * fem,
//                             ),
//                             SizedBox(width: 10 * fem),
//                             Text(
//                               'Go To Cart',
//                               style: MyGoogleFontStyle(
//                                 fontFamily: 'Urbanist',
//                                 fontSize: 14 * ffem,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 8 * fem),
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () async {
//                         if (_cartData['kindOfFlower'] == '' ||
//                             _cartData['flavour'] == '') {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(20 * fem)),
//                               title: Text(
//                                 _cartData['kindOfFlower'] == '' &&
//                                         _cartData['flavour'] != ''
//                                     ? 'Kindly choose size.'
//                                     : _cartData['flavour'] == '' &&
//                                             _cartData['kindOfFlower'] != ''
//                                         ? 'Kindly choose colour.'
//                                         : 'Kindly choose colour and size.',
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: Text(
//                                     'Ok',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 16 * ffem),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         } else {
//                           _cartData['points'] = _productPoints;
//                           _cartData['product_price'] = _prices.isNotEmpty &&
//                                   _prices[0]['offer_price'] != 0
//                               ? _prices[0]['offer_price'].toString()
//                               : _prices[0]['price'].toString();
//                           await addToCartModel.getAddToCart(
//                               widget.arguments!['product']['id'],
//                               true,
//                               _cartData);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   CartPage(isProfile: {'isProfile': false}),
//                             ),
//                           );
//                         }
//                       },
//                       style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 20 * fem, vertical: 10 * fem),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFC7B456),
//                           borderRadius: BorderRadius.circular(10 * fem),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               'assets/images/shopping-bag-03.png',
//                               width: 18 * fem,
//                               height: 17 * fem,
//                             ),
//                             SizedBox(width: 10 * fem),
//                             Text(
//                               'Buy Now',
//                               style: MyGoogleFontStyle(
//                                 fontFamily: 'Urbanist',
//                                 fontSize: 14 * ffem,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/product.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/core/providers/wish_list_pr.dart';
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

    final configModel = locator<ConfigModel>();
    final productId = widget.arguments!['product']['id'];
    final addToCartModel = context.read<AddToCartModel>();
    final wishListModel = context.read<WishListModel>();
    final productModel = context.read<ProductModel>();
    await Future.wait<void>([
      if (configModel.user != null)
        addToCartModel.getAddToCart(productId, '', _cartData),
      if (configModel.user != null) wishListModel.getWishLists(''),
      productModel.getCategoryWiseProduct(
          widget.arguments!['product']['category_id'] ?? '', ''),
    ]);

    setState(() {
      _initializeProductData();
      _isLoading = false;
    });
  }

  void _initializeProductData() {
    productDisplayImages = widget.arguments?['product_images']?.toList() ?? [];
    if (productDisplayImages.isNotEmpty) {
      unitName = productDisplayImages[0].unit?.name ?? '';
      _cartData['flavour'] = unitName;
      _cartData['pack'] = productDisplayImages[0].id?.toString() ?? '';
    }
    _sizes = widget.arguments?['product']?['product_packs']
            ?.where((pack) => pack['unit']?['name'] == unitName)
            ?.toList() ??
        [];
    if (_sizes.isNotEmpty) {
      _cartData['kindOfFlower'] = _sizes[0]['value']?.toString() ?? '';
      size = _sizes[0]['value']?.toString() ?? '';
      _productPoints = _sizes[0]['points'];
      activeIndex = 0; // Pre-select the first size
    }
    _prices = widget.arguments?['product']?['product_prices']
            ?.where((price) => price['product_pack_id'] == _sizes[0]?['id'])
            ?.toList() ??
        [];
    if (_prices.isNotEmpty) {
      discountPrice = _prices[0]['offer_price'] != 0
          ? ((int.parse(_prices[0]['price'].toString()) -
                  int.parse(_prices[0]['offer_price'].toString())) /
              int.parse(_prices[0]['price'].toString()) *
              100)
          : 0.0;
    }
    cartCount = context.read<AddToCartModel>().addToCarts?.length ?? 0;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double baseWidth = 360;
    final double fem = screenWidth / baseWidth;
    final double ffem = fem * 0.97;

    final configModel = locator<ConfigModel>();
    final productModel = context.watch<ProductModel>();
    final addToCartModel = context.watch<AddToCartModel>();
    final wishListModel = context.watch<WishListModel>();

    final product = widget.arguments?['product'] != null
        ? Product.fromJson(widget.arguments!['product'])
        : null;

    if (_isLoading) {
      return Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    if (_errorMessage != null || product == null) {
      return Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage ?? 'Product data not available.',
                    style: const TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 16 * fem),
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchInitialData,
          child: SingleChildScrollView(
            child: Container(
              width: screenWidth,
              constraints: BoxConstraints(minHeight: screenHeight),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20 * fem, vertical: 16 * fem),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Product Details',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 18 * ffem,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff1e232c),
                              ),
                            ),
                          ),
                          SizedBox(height: 15 * fem),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 18 * ffem,
                                  color: const Color(0xffEED056),
                                ),
                              ),
                              SizedBox(width: 10 * fem),
                              Expanded(
                                child: Container(
                                  height: 38 * fem,
                                  padding: EdgeInsets.only(
                                      left: 21 * fem, right: 20.70 * fem),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 0.50,
                                          color: Color(0xFFC7B456)),
                                      borderRadius:
                                          BorderRadius.circular(10 * fem),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
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
                                                            initialText: value),
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Search',
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 18 * ffem,
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/images/Search-1.png',
                                        height: 20 * fem,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10 * fem),
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
                                child: badges.Badge(
                                  badgeContent: Text(
                                    cartCount.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  child: Image.asset(
                                    'assets/images/shopping_cart.png',
                                    height: 20 * fem,
                                    fit: BoxFit.cover,
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
                                width: screenWidth,
                                height: 350 * fem,
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
                                top: 10 * fem,
                                right: 10 * fem,
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
                                      child: wishListModel.wishListLoader
                                          ? SizedBox(
                                              width: 20 * ffem,
                                              height: 20 * ffem,
                                              child:
                                                  const CircularProgressIndicator(
                                                      strokeWidth: 2),
                                            )
                                          : Icon(
                                              wishListModel.wishLists?.any((wishList) =>
                                                          wishList.productId ==
                                                              widget.arguments![
                                                                      'product']
                                                                  ['id'] &&
                                                          wishList.userId ==
                                                              configModel
                                                                  .user?.id) ??
                                                      false
                                                  ? Icons.favorite_outlined
                                                  : Icons
                                                      .favorite_border_outlined,
                                              color: wishListModel.wishLists
                                                          ?.any((wishList) =>
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
                                                  : null,
                                              size: 20 * ffem,
                                            ),
                                    ),
                                    SizedBox(width: 10 * fem),
                                    IconButton(
                                      onPressed: () {
                                        Share.share(
                                          'Check out this product: ${product.name ?? ''}\n\nDescription: ${product.description ?? ''}\n\nLink: ${configModel.apiConfig['mediaURL']}${product.imagepath1 ?? ''}',
                                        );
                                      },
                                      icon: const Icon(Icons.share),
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 325 * fem,
                                child: Container(
                                  width: screenWidth,
                                  height: 41 * fem,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30 * fem),
                                      topRight: Radius.circular(30 * fem),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: SmoothPageIndicator(
                              controller: sliderController,
                              count: imageProduct.length,
                              effect: ExpandingDotsEffect(
                                dotHeight: 8 * fem,
                                dotWidth: 8 * fem,
                                activeDotColor: Colors.blue,
                                dotColor: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 15 * fem),
                          // Thumbnail Images
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8 * fem),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon:
                                        Icon(Icons.arrow_left, size: 24 * ffem),
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
                                          _cartData['pack'] =
                                              productDisplayImages[newIndex]
                                                      .id
                                                      ?.toString() ??
                                                  '';
                                          updateProductDisplayImages = widget
                                                  .arguments?['product_images']
                                                  ?.where((image) =>
                                                      image.unit?.name ==
                                                      unitName)
                                                  ?.toList() ??
                                              [];
                                          _sizes = widget.arguments?['product']
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
                                          _prices = widget.arguments?['product']
                                                      ?['product_prices']
                                                  ?.where((price) =>
                                                      price[
                                                          'product_pack_id'] ==
                                                      _sizes[0]?['id'])
                                                  ?.toList() ??
                                              [];
                                          _productPoints = _sizes.isNotEmpty
                                              ? _sizes[0]['points']
                                                      ?.toString() ??
                                                  ''
                                              : '';
                                          discountPrice = _prices.isNotEmpty &&
                                                  _prices[0]['offer_price'] != 0
                                              ? ((int.parse(_prices[0]['price']
                                                          .toString()) -
                                                      int.parse(_prices[0]
                                                              ['offer_price']
                                                          .toString())) /
                                                  int.parse(_prices[0]['price']
                                                      .toString()) *
                                                  100)
                                              : 0.0;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: SizedBox(
                                    height: 100 * fem,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5 * fem),
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
                                              _cartData['pack'] =
                                                  productDisplayImages[index]
                                                          .id
                                                          ?.toString() ??
                                                      '';
                                              updateProductDisplayImages =
                                                  widget.arguments?[
                                                              'product_images']
                                                          ?.where((image) =>
                                                              image
                                                                  .unit?.name ==
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
                                              _prices = widget
                                                      .arguments?['product']
                                                          ?['product_prices']
                                                      ?.where((price) =>
                                                          price[
                                                              'product_pack_id'] ==
                                                          _sizes[0]?['id'])
                                                      ?.toList() ??
                                                  [];
                                              _productPoints = _sizes.isNotEmpty
                                                  ? _sizes[0]['points']
                                                          ?.toString() ??
                                                      ''
                                                  : '';
                                              discountPrice = _prices
                                                          .isNotEmpty &&
                                                      _prices[0]['offer_price'] !=
                                                          0
                                                  ? ((int.parse(_prices[0]
                                                                  ['price']
                                                              .toString()) -
                                                          int.parse(_prices[0][
                                                                  'offer_price']
                                                              .toString())) /
                                                      int.parse(_prices[0]
                                                              ['price']
                                                          .toString()) *
                                                      100)
                                                  : 0.0;
                                            });
                                          },
                                          child: Container(
                                            margin:
                                                EdgeInsets.only(right: 8 * fem),
                                            width: 60 * fem,
                                            height: 80 * fem,
                                            decoration: BoxDecoration(
                                              border: isSelected
                                                  ? Border.all(
                                                      color: Colors.black,
                                                      width: 2 * fem)
                                                  : Border.all(
                                                      color: Colors.grey[300]!),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8 * fem),
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
                                                        const Icon(Icons.error),
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
                                        size: 24 * ffem),
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
                                          _cartData['pack'] =
                                              productDisplayImages[newIndex]
                                                      .id
                                                      ?.toString() ??
                                                  '';
                                          updateProductDisplayImages = widget
                                                  .arguments?['product_images']
                                                  ?.where((image) =>
                                                      image.unit?.name ==
                                                      unitName)
                                                  ?.toList() ??
                                              [];
                                          _sizes = widget.arguments?['product']
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
                                          _prices = widget.arguments?['product']
                                                      ?['product_prices']
                                                  ?.where((price) =>
                                                      price[
                                                          'product_pack_id'] ==
                                                      _sizes[0]?['id'])
                                                  ?.toList() ??
                                              [];
                                          _productPoints = _sizes.isNotEmpty
                                              ? _sizes[0]['points']
                                                      ?.toString() ??
                                                  ''
                                              : '';
                                          discountPrice = _prices.isNotEmpty &&
                                                  _prices[0]['offer_price'] != 0
                                              ? ((int.parse(_prices[0]['price']
                                                          .toString()) -
                                                      int.parse(_prices[0]
                                                              ['offer_price']
                                                          .toString())) /
                                                  int.parse(_prices[0]['price']
                                                      .toString()) *
                                                  100)
                                              : 0.0;
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
                            padding: EdgeInsets.symmetric(horizontal: 25 * fem),
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
                                              fontSize: 19 * ffem,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xff000000),
                                            ),
                                          ),
                                          SizedBox(height: 8 * fem),
                                          Row(
                                            children: [
                                              if (product.rating != null &&
                                                  product.rating != '0')
                                                RatingBar.builder(
                                                  itemSize: 15 * ffem,
                                                  initialRating:
                                                      double.tryParse(
                                                              product.rating ??
                                                                  '0.0') ??
                                                          0.0,
                                                  direction: Axis.horizontal,
                                                  itemCount: 5,
                                                  allowHalfRating: true,
                                                  ignoreGestures: true,
                                                  itemBuilder: (context, _) =>
                                                      const Icon(Icons.star,
                                                          color: Colors.amber),
                                                  onRatingUpdate:
                                                      (double value) {},
                                                ),
                                              Text(
                                                '(${product.reviews?.length ?? 0} Review${(product.reviews?.length ?? 0) == 1 ? '' : 's'})',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 10 * ffem,
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
                                    SizedBox(width: 20 * fem),
                                    Column(
                                      children: [
                                        if (addToCartModel.addToCarts
                                                ?.where((cart) =>
                                                    cart.productId ==
                                                        widget.arguments![
                                                            'product']['id'] &&
                                                    cart.flavour == unitName &&
                                                    cart.kindOfFlower == size)
                                                .isEmpty ??
                                            true)
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
                                                                    20 * fem)),
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
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  16 * ffem),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else if (_cartData['flavour'] ==
                                                  '') {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20 * fem)),
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
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  16 * ffem),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                _cartData['points'] =
                                                    _productPoints;
                                                _cartData[
                                                    'product_price'] = _prices
                                                            .isNotEmpty &&
                                                        _prices[0][
                                                                'offer_price'] !=
                                                            0
                                                    ? _prices[0]['offer_price']
                                                        .toString()
                                                    : _prices[0]['price']
                                                        .toString();
                                                _cartData['is_add_to_cart'] =
                                                    true;
                                                await addToCartModel
                                                    .getAddToCart(
                                                        widget.arguments![
                                                            'product']['id'],
                                                        true,
                                                        _cartData);
                                                setState(() {
                                                  cartCount = addToCartModel
                                                          .addToCarts?.length ??
                                                      0;
                                                });
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero),
                                            child: Container(
                                              width: 82 * fem,
                                              height: 27.33 * fem,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: const Color(
                                                        0xffeaeaea)),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15 * fem),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    offset: const Offset(0, 2),
                                                    blurRadius: 5,
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'ADD',
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'DM Sans',
                                                    fontSize: 12 * ffem,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        const Color(0xffc7b456),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (addToCartModel.addToCarts
                                                ?.where((cart) =>
                                                    cart.productId ==
                                                        widget.arguments![
                                                            'product']['id'] &&
                                                    cart.flavour == unitName &&
                                                    cart.kindOfFlower == size)
                                                .isNotEmpty ??
                                            false)
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
                                                                    .circular(20 *
                                                                        fem)),
                                                        title: Text(
                                                          _cartData['kindOfFlower'] ==
                                                                      '' &&
                                                                  _cartData[
                                                                          'flavour'] !=
                                                                      ''
                                                              ? 'Kindly choose size.'
                                                              : _cartData['flavour'] ==
                                                                          '' &&
                                                                      _cartData[
                                                                              'kindOfFlower'] !=
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
                                                                  fontSize: 16 *
                                                                      ffem),
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
                                                  decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5 * fem),
                                                  ),
                                                  child: Icon(Icons.remove,
                                                      color: Colors.black,
                                                      size: 20 * ffem),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8 * fem),
                                                child: Text(
                                                  addToCartModel.addToCarts
                                                          ?.firstWhere(
                                                            (cart) =>
                                                                cart.productId ==
                                                                    widget.arguments![
                                                                            'product']
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
                                                          ?.qty
                                                          ?.toString() ??
                                                      '0',
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14 * ffem,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xff1e1e1e),
                                                  ),
                                                ),
                                              ),
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
                                                                    .circular(20 *
                                                                        fem)),
                                                        title: Text(
                                                          _cartData['kindOfFlower'] ==
                                                                      '' &&
                                                                  _cartData[
                                                                          'flavour'] !=
                                                                      ''
                                                              ? 'Kindly choose size.'
                                                              : _cartData['flavour'] ==
                                                                          '' &&
                                                                      _cartData[
                                                                              'kindOfFlower'] !=
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
                                                                  fontSize: 16 *
                                                                      ffem),
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
                                                style: TextButton.styleFrom(
                                                    padding: EdgeInsets.zero),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5 * fem),
                                                  ),
                                                  child: Icon(Icons.add,
                                                      color: Colors.black,
                                                      size: 20 * ffem),
                                                ),
                                              ),
                                            ],
                                          ),
                                        Text(
                                          'Available in stock',
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 12 * ffem,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff000000),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Price
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25 * fem, top: 10 * fem),
                                  child: _prices.isNotEmpty &&
                                          _prices[0]['offer_price'] != 0
                                      ? Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Total Price',
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 14 * ffem),
                                              ),
                                              WidgetSpan(
                                                  child: SizedBox(
                                                      width: 20 * fem)),
                                              TextSpan(
                                                text: '₹${_prices[0]['price']}',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFFC7B456),
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: 18 * ffem,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              WidgetSpan(
                                                  child: SizedBox(
                                                      width: 20 * fem)),
                                              TextSpan(
                                                text:
                                                    '₹${_prices[0]['offer_price']}',
                                                style: TextStyle(
                                                  fontSize: 18 * ffem,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      const Color(0xff000000),
                                                ),
                                              ),
                                              if (discountPrice != 0.0) ...[
                                                WidgetSpan(
                                                    child: SizedBox(
                                                        width: 10 * fem)),
                                                TextSpan(
                                                  text:
                                                      '(${discountPrice.round()}% Off)',
                                                  style: TextStyle(
                                                    fontSize: 16 * ffem,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff000000),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        )
                                      : Text(
                                          _prices.isNotEmpty
                                              ? '₹${_prices[0]['price']}'
                                              : 'Price not available',
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 18 * ffem,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0x99000000),
                                          ),
                                        ),
                                ),
                                // Size Selection
                                Padding(
                                  padding: EdgeInsets.only(
                                      // left: 25 * fem,
                                      top: 15 * fem,
                                      bottom: 5 * fem),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Size',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff000000),
                                        ),
                                      ),
                                      SizedBox(height: 10 * fem),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: SizedBox(
                                              height: 60 * fem,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10 * fem),
                                                itemCount: _sizes.length,
                                                itemBuilder: (context, index) {
                                                  final isActive =
                                                      index == activeIndex;
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                8 * fem),
                                                    child: TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          activeIndex = index;
                                                          _cartData[
                                                              'kindOfFlower'] = _sizes[
                                                                          index]
                                                                      ['value']
                                                                  ?.toString() ??
                                                              '';
                                                          size = _sizes[index]
                                                                      ['value']
                                                                  ?.toString() ??
                                                              '';
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
                                                                  ?.toList()[0]
                                                                      ['points']
                                                                  ?.toString() ??
                                                              '';
                                                          discountPrice = _prices
                                                                      .isNotEmpty &&
                                                                  _prices[0][
                                                                          'offer_price'] !=
                                                                      0
                                                              ? ((int.parse(_prices[0]['price']
                                                                          .toString()) -
                                                                      int.parse(
                                                                          _prices[0]['offer_price']
                                                                              .toString())) /
                                                                  int.parse(_prices[0]
                                                                          ['price']
                                                                      .toString()) *
                                                                  100)
                                                              : 0.0;
                                                        });
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        backgroundColor:
                                                            isActive
                                                                ? Colors.black
                                                                : Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30 * fem),
                                                        ),
                                                      ),
                                                      child: Container(
                                                        width: 50 * fem,
                                                        height: 50 * fem,
                                                        decoration:
                                                            ShapeDecoration(
                                                          shape: OvalBorder(
                                                            side: BorderSide(
                                                                width:
                                                                    0.95 * fem,
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
                                                                  15 * ffem,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: isActive
                                                                  ? Colors.white
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
                                          SizedBox(width: 15 * fem),
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
                                                        width: double.infinity,
                                                        padding: EdgeInsets.all(
                                                            20 * fem),
                                                        height: 200 * fem,
                                                        child: Image.network(
                                                          '${configModel.apiConfig['mediaURL']}${product.sizeChartPath}',
                                                          fit: BoxFit.contain,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              const Icon(
                                                                  Icons.error),
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
                                                    width: 40 * fem,
                                                    height: 40 * fem,
                                                  ),
                                                  Text(
                                                    'Size Chart',
                                                    style: TextStyle(
                                                      fontSize: 11 * ffem,
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
                                        left: 25 * fem, top: 10 * fem),
                                    child: Text(
                                      'Earn $_productPoints points for this product',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFC7B456),
                                      ),
                                    ),
                                  ),
                                // Customer Ratings
                                Padding(
                                  padding: EdgeInsets.only(top: 10 * fem),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Customer Ratings',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14 * ffem,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0x99000000),
                                        ),
                                      ),
                                      if (product.rating != null &&
                                          product.rating != '0')
                                        Row(
                                          children: [
                                            Text(
                                              product.rating.toString(),
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14 * ffem,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0x99000000),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 3 * fem),
                                              child: const Icon(Icons.star,
                                                  color: Colors.amber,
                                                  size: 16),
                                            ),
                                            Text(
                                              '(${product.reviews?.length ?? 0} ratings)',
                                              style: TextStyle(
                                                  fontSize: 12 * ffem),
                                            ),
                                            const Spacer(),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/reviewsPage',
                                                  arguments: {
                                                    'productId':
                                                        widget.arguments![
                                                            'product']['id']
                                                  },
                                                );
                                              },
                                              child: Text(
                                                'View Reviews & Ratings',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      const Color(0x99000000),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                // Descriptions
                                if (product.smallDescription != null)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10 * fem),
                                    child: Card(
                                      elevation: 4,
                                      color: Colors.white,
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12 * fem)),
                                      child: Padding(
                                        padding: EdgeInsets.all(16 * fem),
                                        child: Html(
                                            data: product.smallDescription
                                                .toString()),
                                      ),
                                    ),
                                  ),
                                if (product.description != null)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10 * fem),
                                    child: Card(
                                      elevation: 4,
                                      color: Colors.white,
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12 * fem)),
                                      child: Padding(
                                        padding: EdgeInsets.all(16 * fem),
                                        child: Html(
                                            data:
                                                product.description.toString()),
                                      ),
                                    ),
                                  ),
                                if (product.description1 != null)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10 * fem),
                                    child: Card(
                                      elevation: 4,
                                      color: Colors.white,
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12 * fem)),
                                      child: Padding(
                                        padding: EdgeInsets.all(16 * fem),
                                        child: Html(
                                            data: product.description1
                                                .toString()),
                                      ),
                                    ),
                                  ),
                                if (product.description2 != null)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10 * fem),
                                    child: Card(
                                      elevation: 4,
                                      color: Colors.white,
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12 * fem)),
                                      child: Padding(
                                        padding: EdgeInsets.all(16 * fem),
                                        child: Html(
                                            data: product.description2
                                                .toString()),
                                      ),
                                    ),
                                  ),
                                // Add More Items
                                Padding(
                                  padding: EdgeInsets.only(top: 20 * fem),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Add More Items',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff000000),
                                        ),
                                      ),
                                      SizedBox(height: 10 * fem),
                                      SizedBox(
                                        height: 240 * fem,
                                        child: productModel
                                                .categoryWiseproductsLoader
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : productModel.categoryWiseproducts
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
                                                      final relatedDiscount = relatedProduct
                                                                  .productPrices
                                                                  ?.isNotEmpty ??
                                                              false
                                                          ? ((int.parse(relatedProduct
                                                                      .productPrices![
                                                                          0]
                                                                      .price
                                                                      .toString()) -
                                                                  int.parse(relatedProduct
                                                                      .productPrices![
                                                                          0]
                                                                      .offerPrice
                                                                      .toString())) /
                                                              int.parse(relatedProduct
                                                                  .productPrices![0]
                                                                  .price
                                                                  .toString()) *
                                                              100)
                                                          : 0.0;
                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
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
                                                          width: 145 * fem,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right:
                                                                      12 * fem),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15 *
                                                                            fem),
                                                            color: Colors.white,
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
                                                                    width: 145 *
                                                                        fem,
                                                                    height:
                                                                        140 *
                                                                            fem,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(15 *
                                                                              fem),
                                                                      image:
                                                                          DecorationImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: relatedProduct.productImages?.isNotEmpty ??
                                                                                false
                                                                            ? NetworkImage(
                                                                                '${configModel.apiConfig['mediaURL']}${relatedProduct.productImages!.first.imagepath}')
                                                                            : const AssetImage('assets/images/placeholder.png')
                                                                                as ImageProvider,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top:
                                                                        8 * fem,
                                                                    right:
                                                                        8 * fem,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        if (configModel.user ==
                                                                            null) {
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                LoginRequiredPopupWidget(),
                                                                          );
                                                                        } else {
                                                                          await wishListModel
                                                                              .getWishLists(relatedProduct.id);
                                                                          setState(
                                                                              () {});
                                                                        }
                                                                      },
                                                                      child: wishListModel
                                                                              .wishListLoader
                                                                          ? SizedBox(
                                                                              width: 20 * ffem,
                                                                              height: 20 * ffem,
                                                                              child: const CircularProgressIndicator(strokeWidth: 2),
                                                                            )
                                                                          : Icon(
                                                                              wishListModel.wishLists?.any((wishList) => wishList.productId == relatedProduct.id && wishList.userId == configModel.user?.id) ?? false ? Icons.favorite_outlined : Icons.favorite_border_outlined,
                                                                              color: wishListModel.wishLists?.any((wishList) => wishList.productId == relatedProduct.id && wishList.userId == configModel.user?.id) ?? false ? Colors.red : null,
                                                                              size: 20 * ffem,
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        10 *
                                                                            fem,
                                                                    vertical:
                                                                        8 * fem),
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
                                                                        15 *
                                                                            ffem,
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
                                                                      bottom: 4 *
                                                                          fem),
                                                                  child: relatedProduct
                                                                              .productPrices![0]
                                                                              .offerPrice !=
                                                                          0
                                                                      ? Text.rich(
                                                                          TextSpan(
                                                                            children: [
                                                                              TextSpan(
                                                                                text: '₹${relatedProduct.productPrices![0].price}',
                                                                                style: TextStyle(
                                                                                  color: Colors.grey,
                                                                                  decoration: TextDecoration.lineThrough,
                                                                                  fontSize: 13 * ffem,
                                                                                  fontFamily: 'Poppins',
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                              TextSpan(
                                                                                text: ' ₹${relatedProduct.productPrices![0].offerPrice}',
                                                                                style: TextStyle(
                                                                                  fontSize: 13 * ffem,
                                                                                  fontFamily: 'Poppins',
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: const Color(0x99000000),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : Text(
                                                                          '₹${relatedProduct.productPrices![0].price}',
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                13 * ffem,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                const Color(0x99000000),
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
                                                                        13 *
                                                                            ffem,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: const Color(
                                                                        0x99000000),
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
      bottomNavigationBar: configModel.user == null
          ? const SizedBox.shrink()
          : Container(
              padding: EdgeInsets.all(8 * fem),
              child: Row(
                children: [
                  // Expanded(
                  //   child: TextButton(
                  //     onPressed: () async {
                  //       if (_cartData['kindOfFlower'] == '' ||
                  //           _cartData['flavour'] == '') {
                  //         showDialog(
                  //           context: context,
                  //           builder: (context) => AlertDialog(
                  //             shape: RoundedRectangleBorder(
                  //                 borderRadius:
                  //                     BorderRadius.circular(20 * fem)),
                  //             title: Text(
                  //               _cartData['kindOfFlower'] == '' &&
                  //                       _cartData['flavour'] != ''
                  //                   ? 'Kindly choose size.'
                  //                   : _cartData['flavour'] == '' &&
                  //                           _cartData['kindOfFlower'] != ''
                  //                       ? 'Kindly choose colour.'
                  //                       : 'Kindly choose colour and size.',
                  //             ),
                  //             actions: [
                  //               TextButton(
                  //                 onPressed: () => Navigator.pop(context),
                  //                 child: Text(
                  //                   'Ok',
                  //                   style: TextStyle(
                  //                       color: Colors.black,
                  //                       fontSize: 16 * ffem),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         );
                  //       } else {
                  //         _cartData['points'] = _productPoints;
                  //         _cartData['product_price'] = _prices.isNotEmpty &&
                  //                 _prices[0]['offer_price'] != 0
                  //             ? _prices[0]['offer_price'].toString()
                  //             : _prices[0]['price'].toString();
                  //         await addToCartModel.getAddToCart(
                  //             widget.arguments!['product']['id'],
                  //             true,
                  //             _cartData);
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) =>
                  //                 CartPage(isProfile: {'isProfile': false}),
                  //           ),
                  //         );
                  //       }
                  //     },
                  //     style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  //     child: Container(
                  //       padding: EdgeInsets.symmetric(
                  //           horizontal: 20 * fem, vertical: 10 * fem),
                  //       decoration: BoxDecoration(
                  //         color: const Color(0xff1e1e1e),
                  //         borderRadius: BorderRadius.circular(10 * fem),
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Image.asset(
                  //             'assets/images/shopping-bag-03.png',
                  //             width: 18 * fem,
                  //             height: 17 * fem,
                  //           ),
                  //           SizedBox(width: 10 * fem),
                  //           Text(
                  //             'Go To Cart',
                  //             style: MyGoogleFontStyle(
                  //               fontFamily: 'Urbanist',
                  //               fontSize: 14 * ffem,
                  //               fontWeight: FontWeight.w700,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                  SizedBox(width: 8 * fem),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        if (_cartData['kindOfFlower'] == '' ||
                            _cartData['flavour'] == '') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20 * fem)),
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
                                        color: Colors.black,
                                        fontSize: 16 * ffem),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          _cartData['points'] = _productPoints;
                          _cartData['product_price'] = _prices.isNotEmpty &&
                                  _prices[0]['offer_price'] != 0
                              ? _prices[0]['offer_price'].toString()
                              : _prices[0]['price'].toString();
                          await addToCartModel.getAddToCart(
                              widget.arguments!['product']['id'],
                              true,
                              _cartData);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CartPage(isProfile: {'isProfile': false}),
                            ),
                          );
                        }
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20 * fem, vertical: 10 * fem),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7B456),
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/shopping-bag-03.png',
                              width: 18 * fem,
                              height: 17 * fem,
                            ),
                            SizedBox(width: 10 * fem),
                            Text(
                              'Buy Now',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14 * ffem,
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

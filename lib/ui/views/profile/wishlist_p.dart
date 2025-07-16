// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:aadab/core/models/product.dart';
// import 'package:aadab/core/providers/add_to_cart_pr.dart';
// import 'package:aadab/core/providers/config_pr.dart';
// import 'package:aadab/core/providers/product_pr.dart';
// import 'package:aadab/core/providers/wish_list_pr.dart';
// import 'package:aadab/locator.dart';
// import 'package:aadab/ui/shared/font_sh.dart';

// import 'package:badges/badges.dart' as badges;

// class WishlistPage extends StatefulWidget {
//   const WishlistPage({Key? key}) : super(key: key);

//   @override
//   State<WishlistPage> createState() => _WishlistPageState();
// }

// class _WishlistPageState extends State<WishlistPage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       var productId = '';
//       await Provider.of<WishListModel>(context, listen: false)
//           .getWishLists(productId);
//       await Provider.of<ProductModel>(context, listen: false)
//           .getAllProducts(productId);
//     });
//   }

//   int activeIndex = -1;
//   int sizeActiveIndex = -1;

//   bool isActive = false;
//   bool isSizeActive = false;
//   bool isPageLoading = false;
//   double discountPrice = 0.0;
//   Map<String, dynamic> _CartData = {
//     'kindOfFlower': '',
//     'flavour': '',
//     'writeOnCake': '',
//   };
//   @override
//   Widget build(BuildContext context) {
//     final WishListModel _wishListModel =
//         Provider.of<WishListModel>(context, listen: false);
//     final AddToCartModel _addToCartModel =
//         Provider.of<AddToCartModel>(context, listen: false);
//     final ConfigModel _configModel = locator<ConfigModel>();
//     double baseWidth = 360;
//     double fem = MediaQuery.of(context).size.width / baseWidth;
//     double ffem = fem * 0.97;
//     var cartCount = 0;
//     setState(() {
//       cartCount = _addToCartModel.addToCarts == null
//           ? 0
//           : _addToCartModel.addToCarts!.length;
//     });
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 margin:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       icon: const Icon(
//                         Icons.arrow_back_ios,
//                         size: 18,
//                         color: Color(0xffEED056),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     Expanded(
//                       child: Text(
//                         'Wishlist',
//                         textAlign: TextAlign.center,
//                         style: MyGoogleFontStyle(
//                           fontFamily: 'Urbanist',
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: const Color(0xff1e232c),
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.pushNamed(context, '/cartPage');
//                       },
//                       child: badges.Badge(
//                         badgeContent: Text(
//                           cartCount.toString(),
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                         child: Image.asset(
//                           'assets/images/shopping_cart.png',
//                           height: 20,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Body
//               Container(
//                 width: MediaQuery.of(context).size.width - 50,
//                 // height: MediaQuery.of(context).size.height - 90,
//                 child: _wishListModel.wishLists!.length == 0
//                     ? SizedBox(
//                         height: 60,
//                         child: Center(child: Text('Wishlist is empty')),
//                       )
//                     : SizedBox(
//                         height: MediaQuery.of(context).size.height - 240,
//                         child: ListView.builder(
//                           itemCount: _wishListModel.wishLists!.length,
//                           itemBuilder: (BuildContext context, index) {
//                             discountPrice = (int.parse(_wishListModel
//                                         .wishLists![index]
//                                         .product!
//                                         .productPrices![0]
//                                         .price
//                                         .toString()) -
//                                     int.parse(_wishListModel.wishLists![index]
//                                         .product!.productPrices![0].offerPrice
//                                         .toString())) /
//                                 int.parse(_wishListModel.wishLists![index]
//                                     .product!.productPrices![0].price
//                                     .toString()) *
//                                 100;
//                             return Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       height: 90,
//                                       width: 80,
//                                       child: Image.network(
//                                         _configModel.apiConfig['mediaURL'] +
//                                             _wishListModel
//                                                 .wishLists![index]
//                                                 .product!
//                                                 .productImages!
//                                                 .first
//                                                 .imagepath
//                                                 .toString(),
//                                         // 'assets/images/mask-group-HvE.png',
//                                         width: 80,
//                                         height: 100,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 12,
//                                     ),
//                                     Container(
//                                       child: Expanded(
//                                         flex: 5,
//                                         child: Column(
//                                           children: [
//                                             Align(
//                                               alignment: Alignment.centerLeft,
//                                               child: Text(
//                                                 _wishListModel.wishLists![index]
//                                                     .product!.name
//                                                     .toString(),
//                                                 style: MyGoogleFontStyle(
//                                                   fontFamily: 'Urbanist',
//                                                   fontWeight: FontWeight.w500,
//                                                   color: Color(0xff909090),
//                                                 ),
//                                               ),
//                                             ),
//                                             Align(
//                                                 alignment: Alignment.centerLeft,
//                                                 child: Text.rich(
//                                                   TextSpan(
//                                                     text: 'Total Price',
//                                                     style: TextStyle(
//                                                         color:
//                                                             Colors.grey[500]),
//                                                     children: [
//                                                       WidgetSpan(
//                                                         child: SizedBox(
//                                                             width:
//                                                                 10), // Adjust the width as needed
//                                                       ),
//                                                       TextSpan(
//                                                         text:
//                                                             'RS. ${_wishListModel.wishLists![index].product!.productPrices![0].price.toString()}',
//                                                         style: TextStyle(
//                                                             color: Color(
//                                                                 0xFFC7B456),
//                                                             decoration:
//                                                                 TextDecoration
//                                                                     .lineThrough,
//                                                             fontSize: 12,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .bold),
//                                                       ),
//                                                       WidgetSpan(
//                                                         child: SizedBox(
//                                                             width:
//                                                                 10), // Adjust the width as needed
//                                                       ),
//                                                       TextSpan(
//                                                           text:
//                                                               'RS.${_wishListModel.wishLists![index].product!.productPrices![0].offerPrice.toString()}',
//                                                           style: TextStyle(
//                                                               fontSize: 12,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold)),
//                                                       if (discountPrice != 0.0)
//                                                         WidgetSpan(
//                                                           child: SizedBox(
//                                                               width:
//                                                                   10), // Adjust the width as needed
//                                                         ),
//                                                       if (discountPrice != 0.0)
//                                                         TextSpan(
//                                                             text:
//                                                                 '( ${discountPrice.round()}% Off)',
//                                                             style: TextStyle(
//                                                                 fontSize: 12,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold))
//                                                     ],
//                                                   ),
//                                                 )),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Align(
//                                               alignment: Alignment.centerLeft,
//                                               child: InkWell(
//                                                 onTap: () async {
//                                                   List<ProductImages>
//                                                       productImages = [];
//                                                   List<ProductPack>
//                                                       productPacks = [];
//                                                   List<ProductPrices>
//                                                       productPrices = [];

//                                                   productImages = _wishListModel
//                                                       .wishLists![index]
//                                                       .product!
//                                                       .productImages!;
//                                                   productPacks = _wishListModel
//                                                       .wishLists![index]
//                                                       .product!
//                                                       .productPacks!;
//                                                   productPrices = _wishListModel
//                                                       .wishLists![index]
//                                                       .product!
//                                                       .productPrices!;
//                                                   showModalBottomSheet(
//                                                     context: context,
//                                                     builder:
//                                                         (BuildContext context) {
//                                                       return SizedBox(
//                                                         height: MediaQuery.of(
//                                                                     context)
//                                                                 .size
//                                                                 .height *
//                                                             0.4,
//                                                         child: StatefulBuilder(
//                                                           builder: (BuildContext
//                                                                   context,
//                                                               StateSetter
//                                                                   modalSetState) {
//                                                             // Re-filter productPacks based on activeIndex
//                                                             List<
//                                                                 ProductPack> filteredProductPacks = (activeIndex !=
//                                                                     -1)
//                                                                 ? productPacks
//                                                                     .where((element) =>
//                                                                         element
//                                                                             .unitId ==
//                                                                         productImages[activeIndex]
//                                                                             .unit!
//                                                                             .id)
//                                                                     .toList()
//                                                                 : productPacks; // If no product image selected, show all packs

//                                                             return Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .symmetric(
//                                                                       horizontal:
//                                                                           8.0),
//                                                               child: Column(
//                                                                 children: [
//                                                                   // Select Variant Section
//                                                                   SizedBox(
//                                                                     height: MediaQuery.of(context)
//                                                                             .size
//                                                                             .height *
//                                                                         0.4,
//                                                                     width: double
//                                                                         .infinity,
//                                                                     child:
//                                                                         Column(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .start,
//                                                                       crossAxisAlignment:
//                                                                           CrossAxisAlignment
//                                                                               .start,
//                                                                       children: [
//                                                                         SizedBox(
//                                                                             height:
//                                                                                 20),
//                                                                         Text(
//                                                                           'Select Variant:',
//                                                                           textAlign:
//                                                                               TextAlign.left,
//                                                                           style:
//                                                                               MyGoogleFontStyle(
//                                                                             fontFamily:
//                                                                                 'Urbanist',
//                                                                             fontSize:
//                                                                                 15,
//                                                                             fontWeight:
//                                                                                 FontWeight.w600,
//                                                                             height:
//                                                                                 1.2,
//                                                                             letterSpacing:
//                                                                                 -0.36,
//                                                                           ),
//                                                                         ),
//                                                                         SizedBox(
//                                                                             height:
//                                                                                 20),
//                                                                         SizedBox(
//                                                                           width:
//                                                                               double.infinity,
//                                                                           height:
//                                                                               50,
//                                                                           child:
//                                                                               ListView.builder(
//                                                                             scrollDirection:
//                                                                                 Axis.horizontal,
//                                                                             itemCount:
//                                                                                 productImages.length,
//                                                                             itemBuilder:
//                                                                                 (BuildContext context, int index) {
//                                                                               bool isActive = index == activeIndex;

//                                                                               return Row(
//                                                                                 children: [
//                                                                                   SizedBox(
//                                                                                     child: TextButton(
//                                                                                       onPressed: () {
//                                                                                         modalSetState(() {
//                                                                                           activeIndex = index; // Update the selected product image
//                                                                                           sizeActiveIndex = -1;
//                                                                                           _CartData['flavour'] = productImages[index].unit!.name.toString();
//                                                                                           _CartData['pack'] = productImages[index].id;
//                                                                                         });
//                                                                                       },
//                                                                                       style: TextButton.styleFrom(
//                                                                                         padding: EdgeInsets.zero,
//                                                                                         backgroundColor: isActive ? Colors.black : null,
//                                                                                         shape: RoundedRectangleBorder(
//                                                                                           borderRadius: BorderRadius.circular(30.0),
//                                                                                         ),
//                                                                                       ),
//                                                                                       child: Container(
//                                                                                         width: MediaQuery.of(context).size.width * 0.3,
//                                                                                         padding: EdgeInsets.symmetric(horizontal: 10),
//                                                                                         decoration: ShapeDecoration(
//                                                                                           shape: RoundedRectangleBorder(
//                                                                                             borderRadius: BorderRadius.circular(30.0),
//                                                                                             side: BorderSide(
//                                                                                               color: Colors.black,
//                                                                                               width: 1.0,
//                                                                                             ),
//                                                                                           ),
//                                                                                         ),
//                                                                                         child: Center(
//                                                                                           child: Text(
//                                                                                             productImages[index].unit!.name.toString(),
//                                                                                             style: MyGoogleFontStyle(
//                                                                                               fontFamily: 'Urbanist',
//                                                                                               fontSize: 12,
//                                                                                               fontWeight: FontWeight.w600,
//                                                                                               height: 1.2,
//                                                                                               letterSpacing: -0.36,
//                                                                                               color: isActive ? Colors.white : Colors.black,
//                                                                                             ),
//                                                                                           ),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                   SizedBox(width: 15),
//                                                                                 ],
//                                                                               );
//                                                                             },
//                                                                           ),
//                                                                         ),
//                                                                         SizedBox(
//                                                                             height:
//                                                                                 20),
//                                                                         // Select Size Section
//                                                                         Text(
//                                                                           'Select Size:',
//                                                                           textAlign:
//                                                                               TextAlign.left,
//                                                                           style:
//                                                                               MyGoogleFontStyle(
//                                                                             fontFamily:
//                                                                                 'Urbanist',
//                                                                             fontSize:
//                                                                                 15,
//                                                                             fontWeight:
//                                                                                 FontWeight.w600,
//                                                                             height:
//                                                                                 1.2,
//                                                                             letterSpacing:
//                                                                                 -0.36,
//                                                                           ),
//                                                                         ),
//                                                                         SizedBox(
//                                                                             height:
//                                                                                 20),
//                                                                         SizedBox(
//                                                                           width:
//                                                                               double.infinity,
//                                                                           height:
//                                                                               50,
//                                                                           child:
//                                                                               ListView.builder(
//                                                                             scrollDirection:
//                                                                                 Axis.horizontal,
//                                                                             itemCount:
//                                                                                 filteredProductPacks.length, // Use filtered product packs
//                                                                             itemBuilder:
//                                                                                 (BuildContext context, int index) {
//                                                                               bool isSizeActive = index == sizeActiveIndex;

//                                                                               return Row(
//                                                                                 children: [
//                                                                                   SizedBox(
//                                                                                     child: TextButton(
//                                                                                       onPressed: () {
//                                                                                         modalSetState(() {
//                                                                                           sizeActiveIndex = index; // Update the selected size
//                                                                                           _CartData['pack'] = filteredProductPacks[index].id;
//                                                                                           _CartData['kindOfFlower'] = filteredProductPacks[index].value.toString();
//                                                                                         });
//                                                                                       },
//                                                                                       style: TextButton.styleFrom(
//                                                                                         padding: EdgeInsets.zero,
//                                                                                         backgroundColor: isSizeActive ? Colors.black : null,
//                                                                                         shape: RoundedRectangleBorder(
//                                                                                           borderRadius: BorderRadius.circular(30.0),
//                                                                                         ),
//                                                                                       ),
//                                                                                       child: Container(
//                                                                                         width: MediaQuery.of(context).size.width * 0.3,
//                                                                                         padding: EdgeInsets.symmetric(horizontal: 10),
//                                                                                         decoration: ShapeDecoration(
//                                                                                           shape: RoundedRectangleBorder(
//                                                                                             borderRadius: BorderRadius.circular(30.0),
//                                                                                             side: BorderSide(
//                                                                                               color: Colors.black,
//                                                                                               width: 1.0,
//                                                                                             ),
//                                                                                           ),
//                                                                                         ),
//                                                                                         child: Center(
//                                                                                           child: Text(
//                                                                                             "${filteredProductPacks[index].value}",
//                                                                                             style: MyGoogleFontStyle(
//                                                                                               fontFamily: 'Urbanist',
//                                                                                               fontSize: 12,
//                                                                                               fontWeight: FontWeight.w600,
//                                                                                               height: 1.2,
//                                                                                               letterSpacing: -0.36,
//                                                                                               color: isSizeActive ? Colors.white : Colors.black,
//                                                                                             ),
//                                                                                           ),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                   SizedBox(width: 15),
//                                                                                 ],
//                                                                               );
//                                                                             },
//                                                                           ),
//                                                                         ),
//                                                                         SizedBox(
//                                                                           height:
//                                                                               20,
//                                                                         ),

//                                                                         InkWell(
//                                                                           onTap:
//                                                                               () async {
//                                                                             if (activeIndex ==
//                                                                                 -1) {
//                                                                               showDialog(
//                                                                                 context: context,
//                                                                                 builder: (BuildContext context) {
//                                                                                   return AlertDialog(
//                                                                                     title: Text(
//                                                                                       'Oops...!',
//                                                                                       style: TextStyle(
//                                                                                         fontWeight: FontWeight.bold,
//                                                                                         color: Colors.red,
//                                                                                       ),
//                                                                                     ),
//                                                                                     content: Text('Please select a variant before adding to cart.'),
//                                                                                     actions: [
//                                                                                       TextButton(
//                                                                                         onPressed: () {
//                                                                                           Navigator.of(context).pop(); // Close the dialog
//                                                                                         },
//                                                                                         child: Text(
//                                                                                           'OK',
//                                                                                           style: TextStyle(color: Colors.black),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ],
//                                                                                   );
//                                                                                 },
//                                                                               );
//                                                                               return; // Stop execution if variant is not selected
//                                                                             }
//                                                                             if (sizeActiveIndex ==
//                                                                                 -1) {
//                                                                               showDialog(
//                                                                                 context: context,
//                                                                                 builder: (BuildContext context) {
//                                                                                   return AlertDialog(
//                                                                                     title: Text(
//                                                                                       'Oops...!',
//                                                                                       style: TextStyle(
//                                                                                         fontWeight: FontWeight.bold,
//                                                                                         color: Colors.red,
//                                                                                       ),
//                                                                                     ),
//                                                                                     content: Text('Please select a size before adding to cart.'),
//                                                                                     actions: [
//                                                                                       TextButton(
//                                                                                         onPressed: () {
//                                                                                           Navigator.of(context).pop(); // Close the dialog
//                                                                                         },
//                                                                                         child: Text(
//                                                                                           'OK',
//                                                                                           style: TextStyle(color: Colors.black),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ],
//                                                                                   );
//                                                                                 },
//                                                                               );
//                                                                               return; // Stop execution if size is not selected
//                                                                             }

//                                                                             print(_CartData);
//                                                                             setState(() {
//                                                                               isPageLoading = true;
//                                                                             });

//                                                                             String
//                                                                                 _prices =
//                                                                                 productPrices.where((_price) => _price.productPackId == _CartData['pack']).toList()[0].offerPrice.toString();
//                                                                             bool
//                                                                                 type =
//                                                                                 true;

//                                                                             String
//                                                                                 _productpoints =
//                                                                                 productPacks.where((_pack) => _pack.id == _CartData['pack']).toList()[0].points.toString();
//                                                                             // print(_productpoints);
//                                                                             _CartData['points'] =
//                                                                                 _productpoints;
//                                                                             _CartData['product_price'] =
//                                                                                 _prices;

//                                                                             _CartData['is_add_to_cart'] =
//                                                                                 true;
//                                                                             // print(_CartData);
//                                                                             await _addToCartModel.getAddToCart(
//                                                                               _wishListModel.wishLists![index].product!.id,
//                                                                               type,
//                                                                               _CartData,
//                                                                             );

//                                                                             setState(() {
//                                                                               isPageLoading = false;
//                                                                               _wishListModel.getWishLists('');
//                                                                               Navigator.pop(context);
//                                                                             });
//                                                                           },
//                                                                           child:
//                                                                               Center(
//                                                                             child:
//                                                                                 Container(
//                                                                               padding: EdgeInsets.fromLTRB(13, 4, 14, 6),
//                                                                               width: 160,
//                                                                               height: 50,
//                                                                               decoration: BoxDecoration(
//                                                                                 color: Color(0xff000000),
//                                                                                 borderRadius: BorderRadius.circular(5),
//                                                                               ),
//                                                                               child: Row(
//                                                                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                                                                 children: [
//                                                                                   Container(
//                                                                                     padding: EdgeInsets.symmetric(horizontal: 5),
//                                                                                     child: isPageLoading == false
//                                                                                         ? Text(
//                                                                                             'Add to Cart',
//                                                                                             style: MyGoogleFontStyle(
//                                                                                               fontFamily: 'Poppins',
//                                                                                               fontSize: 15,
//                                                                                               fontWeight: FontWeight.w600,
//                                                                                               color: Color(0xffffffff),
//                                                                                             ),
//                                                                                           )
//                                                                                         : CircularProgressIndicator(
//                                                                                             color: Colors.white,
//                                                                                           ),
//                                                                                   ),
//                                                                                   Image.asset(
//                                                                                     'assets/images/shopping-bag-03-YoY.png',
//                                                                                     width: 18,
//                                                                                     height: 15,
//                                                                                   ),
//                                                                                 ],
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             );
//                                                           },
//                                                         ),
//                                                       );
//                                                     },
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   padding: EdgeInsets.fromLTRB(
//                                                       13, 4, 14, 6),
//                                                   width: 100,
//                                                   height: 30,
//                                                   decoration: BoxDecoration(
//                                                     color: Color(0xff000000),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             5),
//                                                   ),
//                                                   child: Row(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Container(
//                                                         margin:
//                                                             EdgeInsets.fromLTRB(
//                                                                 0, 0, 5, 0),
//                                                         child: Text(
//                                                           'Add to Cart',
//                                                           style:
//                                                               MyGoogleFontStyle(
//                                                             fontFamily:
//                                                                 'Poppins',
//                                                             fontSize: 9,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                             color: Color(
//                                                                 0xffffffff),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Image.asset(
//                                                         'assets/images/shopping-bag-03-YoY.png',
//                                                         width: 9.5,
//                                                         height: 9.2,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     IconButton(
//                                       onPressed: () async {
//                                         await _wishListModel.getWishLists(
//                                             _wishListModel
//                                                 .wishLists![index].product!.id);
//                                         setState(() {});
//                                       },
//                                       icon: Icon(Icons.close_rounded),
//                                     )
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   width: MediaQuery.of(context).size.width - 50,
//                                   child: Divider(
//                                     thickness: 2,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/product.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/core/providers/wish_list_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:badges/badges.dart' as badges;

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  bool _isPageLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isPageLoading = true);
    try {
      await Future.wait<void>([
        Provider.of<WishListModel>(context, listen: false).getWishLists(''),
        Provider.of<ProductModel>(context, listen: false).getAllProducts(''),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading wishlist: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPageLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WishListModel, AddToCartModel>(
      builder: (context, wishListModel, addToCartModel, _) {
        final configModel = locator<ConfigModel>();
        final double fem = MediaQuery.sizeOf(context).width / 360;
        final double ffem = fem * 0.97;
        final cartCount = addToCartModel.addToCarts?.length ?? 0;

        return Scaffold(
          body: SafeArea(
            child: _isPageLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildHeader(context, cartCount, fem, ffem),
                        _buildWishlistContent(context, wishListModel,
                            addToCartModel, configModel, fem),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
      BuildContext context, int cartCount, double fem, double ffem) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                size: 18, color: Color(0xffEED056)),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Wishlist',
              textAlign: TextAlign.center,
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 18 * ffem,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/cartPage'),
            child: badges.Badge(
              badgeContent: Text(
                cartCount.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: Image.asset(
                'assets/images/shopping_cart.png',
                height: 20 * ffem,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistContent(
    BuildContext context,
    WishListModel wishListModel,
    AddToCartModel addToCartModel,
    ConfigModel configModel,
    double fem,
  ) {
    if (wishListModel.wishLists?.isEmpty ?? true) {
      return const SizedBox(
        height: 60,
        child: Center(child: Text('Wishlist is empty')),
      );
    }

    return SizedBox(
      height: MediaQuery.sizeOf(context).height - 240,
      width: MediaQuery.sizeOf(context).width - 50,
      child: ListView.separated(
        itemCount: wishListModel.wishLists!.length,
        separatorBuilder: (_, __) =>
            const Divider(thickness: 2, color: Colors.black),
        itemBuilder: (context, index) => _buildWishlistItem(
          context,
          wishListModel,
          addToCartModel,
          configModel,
          index,
          fem,
        ),
      ),
    );
  }

  Widget _buildWishlistItem(
    BuildContext context,
    WishListModel wishListModel,
    AddToCartModel addToCartModel,
    ConfigModel configModel,
    int index,
    double fem,
  ) {
    final product = wishListModel.wishLists![index].product!;
    final price = int.parse(product.productPrices![0].price.toString());
    final offerPrice =
        int.parse(product.productPrices![0].offerPrice.toString());
    final discountPrice = ((price - offerPrice) / price * 100).round();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(configModel, product, fem),
            const SizedBox(width: 12),
            Expanded(
              child: _buildProductDetails(context, wishListModel,
                  addToCartModel, product, discountPrice, index, fem),
            ),
            IconButton(
              onPressed: () async {
                await wishListModel.getWishLists(product.id);
              },
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildProductImage(
      ConfigModel configModel, Product product, double fem) {
    return SizedBox(
      height: 90 * fem,
      width: 80 * fem,
      child: Image.network(
        '${configModel.apiConfig['mediaURL']}${product.productImages!.first.imagepath}',
        width: 80 * fem,
        height: 100 * fem,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildProductDetails(
    BuildContext context,
    WishListModel wishListModel,
    AddToCartModel addToCartModel,
    Product product,
    int discountPrice,
    int index,
    double fem,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name.toString(),
          style: MyGoogleFontStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500,
            color: const Color(0xff909090),
          ),
        ),
        Text.rich(
          TextSpan(
            text: 'Total Price',
            style: TextStyle(color: Colors.grey[500]),
            children: [
              const WidgetSpan(child: SizedBox(width: 10)),
              TextSpan(
                text: 'RS. ${product.productPrices![0].price}',
                style: const TextStyle(
                  color: Color(0xFFC7B456),
                  decoration: TextDecoration.lineThrough,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 10)),
              TextSpan(
                text: 'RS.${product.productPrices![0].offerPrice}',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              if (discountPrice != 0)
                const WidgetSpan(child: SizedBox(width: 10)),
              if (discountPrice != 0)
                TextSpan(
                  text: '($discountPrice% Off)',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _buildAddToCartButton(
            context, wishListModel, addToCartModel, index, fem),
      ],
    );
  }

  Widget _buildAddToCartButton(
    BuildContext context,
    WishListModel wishListModel,
    AddToCartModel addToCartModel,
    int index,
    double fem,
  ) {
    return InkWell(
      onTap: () => _showAddToCartBottomSheet(
          context, wishListModel, addToCartModel, index, fem),
      child: Container(
        padding: EdgeInsets.fromLTRB(13 * fem, 4 * fem, 14 * fem, 6 * fem),
        width: 100 * fem,
        height: 30 * fem,
        decoration: BoxDecoration(
          color: const Color(0xff000000),
          borderRadius: BorderRadius.circular(5 * fem),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Add to Cart',
              style: MyGoogleFontStyle(
                fontFamily: 'Poppins',
                fontSize: 9 * fem,
                fontWeight: FontWeight.w600,
                color: const Color(0xffffffff),
              ),
            ),
            const SizedBox(width: 5),
            Image.asset(
              'assets/images/shopping-bag-03-YoY.png',
              width: 9.5 * fem,
              height: 9.2 * fem,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddToCartBottomSheet(
    BuildContext context,
    WishListModel wishListModel,
    AddToCartModel addToCartModel,
    int index,
    double fem,
  ) {
    int activeIndex = -1;
    int sizeActiveIndex = -1;
    final product = wishListModel.wishLists![index].product!;
    final Map<String, dynamic> cartData = {
      'kindOfFlower': '',
      'flavour': '',
      'writeOnCake': '',
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            final filteredProductPacks = activeIndex != -1
                ? product.productPacks!
                    .where((element) =>
                        element.unitId ==
                        product.productImages![activeIndex].unit!.id)
                    .toList()
                : product.productPacks!;

            return Container(
              height: MediaQuery.sizeOf(context).height * 0.4,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Select Variant:',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15 * fem,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      letterSpacing: -0.36,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildVariantSelector(product, activeIndex, fem, (index) {
                    modalSetState(() {
                      activeIndex = index;
                      sizeActiveIndex = -1;
                      cartData['flavour'] =
                          product.productImages![index].unit!.name.toString();
                      cartData['pack'] = product.productImages![index].id;
                    });
                  }),
                  const SizedBox(height: 20),
                  Text(
                    'Select Size:',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15 * fem,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      letterSpacing: -0.36,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSizeSelector(filteredProductPacks, sizeActiveIndex, fem,
                      (index) {
                    modalSetState(() {
                      sizeActiveIndex = index;
                      cartData['pack'] = filteredProductPacks[index].id;
                      cartData['kindOfFlower'] =
                          filteredProductPacks[index].value.toString();
                    });
                  }),
                  const SizedBox(height: 20),
                  _buildBottomSheetAddToCartButton(
                    context,
                    addToCartModel,
                    wishListModel,
                    product,
                    cartData,
                    activeIndex,
                    sizeActiveIndex,
                    fem,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVariantSelector(
    Product product,
    int activeIndex,
    double fem,
    Function(int) onSelect,
  ) {
    return SizedBox(
      height: 50 * fem,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: product.productImages!.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final isActive = index == activeIndex;
          return TextButton(
            onPressed: () => onSelect(index),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: isActive ? Colors.black : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0 * fem),
              ),
            ),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.3,
              padding: EdgeInsets.symmetric(horizontal: 10 * fem),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0 * fem),
                  side: const BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              child: Center(
                child: Text(
                  product.productImages![index].unit!.name.toString(),
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12 * fem,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: -0.36,
                    color: isActive ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSizeSelector(
    List<ProductPack> filteredProductPacks,
    int sizeActiveIndex,
    double fem,
    Function(int) onSelect,
  ) {
    return SizedBox(
      height: 50 * fem,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filteredProductPacks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final isSizeActive = index == sizeActiveIndex;
          return TextButton(
            onPressed: () => onSelect(index),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: isSizeActive ? Colors.black : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0 * fem),
              ),
            ),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.3,
              padding: EdgeInsets.symmetric(horizontal: 10 * fem),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0 * fem),
                  side: const BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              child: Center(
                child: Text(
                  filteredProductPacks[index].value.toString(),
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12 * fem,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: -0.36,
                    color: isSizeActive ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomSheetAddToCartButton(
    BuildContext context,
    AddToCartModel addToCartModel,
    WishListModel wishListModel,
    Product product,
    Map<String, dynamic> cartData,
    int activeIndex,
    int sizeActiveIndex,
    double fem,
  ) {
    bool isLoading = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return InkWell(
          onTap: () async {
            if (activeIndex == -1) {
              _showErrorDialog(
                  context, 'Please select a variant before adding to cart.');
              return;
            }
            if (sizeActiveIndex == -1) {
              _showErrorDialog(
                  context, 'Please select a size before adding to cart.');
              return;
            }

            setState(() => isLoading = true);
            try {
              final price = product.productPrices!
                  .firstWhere((p) => p.productPackId == cartData['pack'])
                  .offerPrice
                  .toString();
              final points = product.productPacks!
                  .firstWhere((p) => p.id == cartData['pack'])
                  .points
                  .toString();

              cartData
                ..['points'] = points
                ..['product_price'] = price
                ..['is_add_to_cart'] = true;

              await addToCartModel.getAddToCart(product.id, true, cartData);
              await wishListModel.getWishLists('');
              if (mounted) {
                Navigator.pop(context);
              }
            } catch (e) {
              if (mounted) {
                _showErrorDialog(context, 'Error adding to cart: $e');
              }
            } finally {
              if (mounted) {
                setState(() => isLoading = false);
              }
            }
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(13 * fem, 4 * fem, 14 * fem, 6 * fem),
            width: 160 * fem,
            height: 50 * fem,
            decoration: BoxDecoration(
              color: const Color(0xff000000),
              borderRadius: BorderRadius.circular(5 * fem),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Add to Cart',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15 * fem,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xffffffff),
                        ),
                      ),
                const SizedBox(width: 5),
                Image.asset(
                  'assets/images/shopping-bag-03-YoY.png',
                  width: 18 * fem,
                  height: 15 * fem,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Oops...!',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

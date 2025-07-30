// import 'package:aadab/ui/root_p.dart';
// import 'package:aadab/ui/views/checkout/cart_p.dart';
// import 'package:aadab/ui/views/profile/orders_p.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'package:aadab/core/providers/add_to_cart_pr.dart';
// import 'package:aadab/core/providers/config_pr.dart';
// import 'package:aadab/core/providers/order_pr.dart';
// import 'package:aadab/core/providers/review_pr.dart';
// import 'package:aadab/core/providers/user_address_pr.dart';
// import 'package:aadab/core/providers/user_wallet_pr.dart';
// import 'package:aadab/core/providers/wish_list_pr.dart';
// import 'package:aadab/locator.dart';
// import 'package:aadab/ui/shared/font_sh.dart';
// // import 'package:aadab/ui/views/auth/login_p.dart';
// import 'package:aadab/ui/views/profile/address_p.dart';
// import 'package:aadab/ui/views/profile/widgets/photo_picker_w.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   void initState() {
//     super.initState();
//     var productId = '';
//     Map<String, dynamic> _CartData = {
//       'kindOfFlower': '',
//       'flavour': '',
//       'writeOnCake': '',
//       'pack': ''
//     };
//     Provider.of<ReviewModel>(context, listen: false)
//         .getMyReviews(productId, '', '');
//     Provider.of<WishListModel>(context, listen: false).getWishLists(productId);
//     Provider.of<OrderModel>(context, listen: false).getOrder();
//     Provider.of<AddToCartModel>(context, listen: false)
//         .getAddToCart(productId, '', _CartData);
//     Provider.of<UserAddressModel>(context, listen: false).getUserAddresses();
//     Provider.of<UserWalletModel>(context, listen: false).getMyUserWallets();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ConfigModel _configModel = locator<ConfigModel>();
//     final AddToCartModel _addToCartModel =
//         Provider.of<AddToCartModel>(context, listen: false);
//     final OrderModel _orderModel =
//         Provider.of<OrderModel>(context, listen: false);
//     final WishListModel _wishListModel =
//         Provider.of<WishListModel>(context, listen: false);
//     final ReviewModel _reviewModel =
//         Provider.of<ReviewModel>(context, listen: false);
//     final UserAddressModel _userAddressModel =
//         Provider.of<UserAddressModel>(context, listen: false);
//     final UserWalletModel _userWalletModel =
//         Provider.of<UserWalletModel>(context, listen: false);
//     String initials = getInitials(_configModel.user!.firstName.toString());
//     return Scaffold(
//       body: WillPopScope(
//         onWillPop: () async {
//           Navigator.pushReplacementNamed(context, '/homePage');
//           return false;
//         },
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Container(
//               child: Column(
//                 children: [
//                   // Title
//                   Container(
//                     margin: const EdgeInsets.symmetric(
//                         horizontal: 30, vertical: 10),
//                     width: double.infinity,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           icon: const Icon(
//                             Icons.arrow_back_ios,
//                             size: 18,
//                             color: Color(0xffEED056),
//                           ),
//                           onPressed: () {
//                             Navigator.pushReplacementNamed(
//                                 context, '/homePage');
//                           },
//                         ),
//                         Expanded(
//                           child: Text(
//                             'Profile',
//                             textAlign: TextAlign.center,
//                             style: MyGoogleFontStyle(
//                               fontFamily: 'Urbanist',
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: const Color(0xff1e232c),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 48),
//                       ],
//                     ),
//                   ),
//                   // Body
//                   Container(
//                     margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
//                     child: Column(
//                       children: [
//                         // Photo and Name
//                         Row(
//                           children: [
//                             PhotoPickerWidget(),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     _configModel.user!.firstName.toString(),
//                                     style: MyGoogleFontStyle(
//                                       fontFamily: 'Urbanist',
//                                       fontWeight: FontWeight.w700,
//                                       color: Color(0xff303030),
//                                     ),
//                                   ),
//                                   Text(
//                                     _configModel.user!.email.toString(),
//                                     style: MyGoogleFontStyle(
//                                       fontFamily: 'Urbanist',
//                                       fontWeight: FontWeight.w400,
//                                       color: Color(0xff808080),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Container(
//                                     child: TextButton(
//                                       onPressed: () async {
//                                         showDialog(
//                                           context: context,
//                                           builder: (BuildContext context) =>
//                                               AlertDialog(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(20),
//                                             ),
//                                             title: const Text(
//                                                 'Are you sure you want to logout?'),
//                                             actions: <Widget>[
//                                               TextButton(
//                                                 onPressed: () {
//                                                   Navigator.of(context).pop();
//                                                 },
//                                                 child: const Text('NO'),
//                                               ),
//                                               TextButton(
//                                                 onPressed: () async {
//                                                   try {
//                                                     // Initialize services if needed
//                                                     final GoogleSignIn
//                                                         googleSignIn =
//                                                         GoogleSignIn();
//                                                     final FacebookAuth
//                                                         facebookAuth =
//                                                         FacebookAuth.instance;

//                                                     // Sign out from Firebase
//                                                     await FirebaseAuth.instance
//                                                         .signOut();
//                                                     print(
//                                                         'Firebase sign-out successful');

//                                                     // Sign out from Google (if signed in)
//                                                     if (await googleSignIn
//                                                         .isSignedIn()) {
//                                                       await googleSignIn
//                                                           .signOut();
//                                                       print(
//                                                           'Google sign-out successful');
//                                                     }

//                                                     // Sign out from Facebook
//                                                     await facebookAuth.logOut();
//                                                     print(
//                                                         'Facebook sign-out successful');

//                                                     // Clear local login data (once)
//                                                     if (_configModel != null) {
//                                                       await _configModel
//                                                           .removeLoginData();
//                                                       print(
//                                                           'Local login data cleared');
//                                                     } else {
//                                                       print(
//                                                           'Warning: _configModel is null');
//                                                     }

//                                                     // Close dialog before navigation
//                                                     Navigator.of(context).pop();

//                                                     // Navigate to RootPage
//                                                     Navigator.of(context)
//                                                         .pushAndRemoveUntil(
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               RootPage()),
//                                                       (Route<dynamic> route) =>
//                                                           false,
//                                                     );
//                                                   } catch (e, stackTrace) {
//                                                     print(
//                                                         'Logout Error: $e\nStackTrace: $stackTrace');
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(
//                                                       SnackBar(
//                                                           content: Text(
//                                                               'Failed to logout: $e')),
//                                                     );
//                                                     Navigator.of(context)
//                                                         .pop(); // Close dialog
//                                                   }
//                                                 },
//                                                 child: const Text('YES'),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                       style: TextButton.styleFrom(
//                                         padding: EdgeInsets.zero,
//                                       ),
//                                       child: Container(
//                                         width: 80,
//                                         height: 35,
//                                         decoration: BoxDecoration(
//                                           color: const Color(0xFF1E1e1e),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         child: Center(
//                                           child: Text(
//                                             'Logout',
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               fontFamily: 'Roboto',
//                                               fontSize: 15.267,
//                                               fontWeight: FontWeight.w700,
//                                               color: const Color(0xffffffff),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         //wholesale login
//                         // Container(
//                         //   // margin: EdgeInsets.fromLTRB(5, 0, 6.34, 0),
//                         //   child: TextButton(
//                         //     onPressed: () async {
//                         //       showDialog(
//                         //         context: context,
//                         //         builder: (BuildContext context) => AlertDialog(
//                         //           shape: RoundedRectangleBorder(
//                         //               borderRadius: BorderRadius.circular(20)),
//                         //           title:
//                         //               Text('Are you sure you want to logout?'),
//                         //           actions: <Widget>[
//                         //             TextButton(
//                         //               onPressed: () {
//                         //                 Navigator.of(context).pop();
//                         //               },
//                         //               child: Text('NO'),
//                         //             ),
//                         //             TextButton(
//                         //               onPressed: () async {
//                         //                 Navigator.of(context).pop();
//                         //                 await GoogleSignIn().signOut();
//                         //                 await FacebookAuth.instance.logOut();
//                         //                 await _configModel.removeLoginData();
//                         //                 Navigator.pushAndRemoveUntil(
//                         //                   context,
//                         //                   MaterialPageRoute(
//                         //                     builder: (context) =>
//                         //                         const LoginPage(
//                         //                       argument: {'role': 'User'},
//                         //                     ),
//                         //                   ),
//                         //                   (Route<dynamic> route) => false,
//                         //                 );
//                         //               },
//                         //               child: Text('YES'),
//                         //             ),
//                         //           ],
//                         //         ),
//                         //       );
//                         //     },
//                         //     style: TextButton.styleFrom(
//                         //       padding: EdgeInsets.zero,
//                         //     ),
//                         //     child: Container(
//                         //       width: 200,
//                         //       height: 35,
//                         //       decoration: BoxDecoration(
//                         //         color: Color(0xff1e1e1e),
//                         //         borderRadius: BorderRadius.circular(10),
//                         //       ),
//                         //       child: Center(
//                         //         child: Text(
//                         //           'Login As Wholesaler',
//                         //           textAlign: TextAlign.center,
//                         //           style: MyGoogleFontStyle(
//                         //             fontFamily: 'Urbanist',
//                         //             fontSize: 15.1428556442,
//                         //             fontWeight: FontWeight.w700,
//                         //             height: 1.4999999685,
//                         //             color: Color(0xffffffff),
//                         //           ),
//                         //         ),
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),
//                         // My Orders
//                         InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     OrdersPage(isProfile: {'isProfile': true}),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(top: 10, bottom: 10),
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Color(0xffc7b456)),
//                               color: Color(0xffffffff),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(5),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0x338a959e),
//                                   offset: Offset(0, 7.6690645218),
//                                   blurRadius: 19.1726608276,
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'My Orders',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontWeight: FontWeight.w700,
//                                           color: Color(0xff232323),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         _orderModel.orders.length == 0
//                                             ? 'My Order is empty'
//                                             : 'Already have ' +
//                                                 _orderModel.orders.length
//                                                     .toString() +
//                                                 ' orders',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w400,
//                                           color: Color(0xff909090),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Image.asset(
//                                   'assets/images/frame-15-6zi.png',
//                                   width: 7.18,
//                                   height: 12.92,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         // Rewards
//                         InkWell(
//                           onTap: () {
//                             Navigator.pushNamed(context, '/rewardsPage');
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 10),
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Color(0xffc7b456)),
//                               color: Color(0xffffffff),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(5),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0x338a959e),
//                                   offset: Offset(0, 7.6690645218),
//                                   blurRadius: 19.1726608276,
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Rewards',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontWeight: FontWeight.w700,
//                                           color: Color(0xff232323),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         // alreadyhave10orders9Ca (I318:2511;0:1158)
//                                         'Total earn ${_userWalletModel.totalEarnPoint.toString()} points',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w400,
//                                           color: Color(0xff909090),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Image.asset(
//                                   'assets/images/frame-15-6zi.png',
//                                   width: 7.18,
//                                   height: 12.92,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         // Wishlist
//                         InkWell(
//                           onTap: () {
//                             Navigator.pushNamed(context, '/wishlistPage');
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 10),
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Color(0xffc7b456)),
//                               color: Color(0xffffffff),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(5),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0x338a959e),
//                                   offset: Offset(0, 7.6690645218),
//                                   blurRadius: 19.1726608276,
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Wishlist',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontWeight: FontWeight.w700,
//                                           color: Color(0xff232323),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         _wishListModel.wishLists!.length == 0
//                                             ? 'Wishlist is empty'
//                                             : 'Already have ' +
//                                                 _wishListModel.wishLists!.length
//                                                     .toString() +
//                                                 ' orders',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w400,
//                                           color: Color(0xff909090),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Image.asset(
//                                   'assets/images/frame-15-6zi.png',
//                                   width: 7.18,
//                                   height: 12.92,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         // Cart List
//                         InkWell(
//                           onTap: () async {
//                             Map<String, dynamic> _CartData = {
//                               'kindOfFlower': '',
//                               'flavour': '',
//                               'writeOnCake': '',
//                               'pack': ''
//                             };
//                             await _addToCartModel.getAddToCart(
//                                 '', '', _CartData);
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     CartPage(isProfile: {'isProfile': true}),
//                               ),
//                             );
//                             // Navigator.pushNamed(context, '/cartPage',
//                             //     arguments: {'isProfile': true});
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 10),
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Color(0xffc7b456)),
//                               color: Color(0xffffffff),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(5),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0x338a959e),
//                                   offset: Offset(0, 7.6690645218),
//                                   blurRadius: 19.1726608276,
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'My Cart',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontWeight: FontWeight.w700,
//                                           color: Color(0xff232323),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         _addToCartModel.addToCartLoader
//                                             ? 'My Cart is empty'
//                                             : _addToCartModel
//                                                         .addToCarts!.length ==
//                                                     0
//                                                 ? 'My Cart is empty'
//                                                 : 'Already have ' +
//                                                     _addToCartModel
//                                                         .addToCarts!.length
//                                                         .toString() +
//                                                     ' products',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w400,
//                                           color: Color(0xff909090),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Image.asset(
//                                   'assets/images/frame-15-6zi.png',
//                                   width: 7.18,
//                                   height: 12.92,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         // My Reviews
//                         InkWell(
//                           onTap: () {
//                             Navigator.pushNamed(context, '/reviewsPage');
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 10),
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Color(0xffc7b456)),
//                               color: Color(0xffffffff),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(5),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0x338a959e),
//                                   offset: Offset(0, 7.6690645218),
//                                   blurRadius: 19.1726608276,
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'My Reviews',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontWeight: FontWeight.w700,
//                                           color: Color(0xff232323),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         _reviewModel.reviewLoader
//                                             ? 'My review is empty.'
//                                             : _reviewModel.reviews!.length == 0
//                                                 ? 'My review is empty.'
//                                                 : 'Already have ' +
//                                                     _reviewModel.reviews!.length
//                                                         .toString() +
//                                                     ' reviews',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w400,
//                                           color: Color(0xff909090),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Image.asset(
//                                   'assets/images/frame-15-6zi.png',
//                                   width: 7.18,
//                                   height: 12.92,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         // Shipping Addresses
//                         InkWell(
//                           onTap: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => AddressPage(arguments: {
//                                       'cartItems': [],
//                                       'cartTotal': '',
//                                       'couponValue': 0,
//                                       'isAddress': false
//                                     })));
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 10),
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Color(0xffc7b456)),
//                               color: Color(0xffffffff),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(5),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0x338a959e),
//                                   offset: Offset(0, 7.6690645218),
//                                   blurRadius: 19.1726608276,
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Shipping Addresses',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontWeight: FontWeight.w700,
//                                           color: Color(0xff232323),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         _userAddressModel.userAddressesLoader
//                                             ? 'Shipping address is empty.'
//                                             : _userAddressModel.userAddresses!
//                                                         .length ==
//                                                     0
//                                                 ? 'Shipping address is empty.'
//                                                 : 'Already have ' +
//                                                     _userAddressModel
//                                                         .userAddresses!.length
//                                                         .toString() +
//                                                     ' address',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w400,
//                                           color: Color(0xff909090),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Image.asset(
//                                   'assets/images/frame-15-6zi.png',
//                                   width: 7.18,
//                                   height: 12.92,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),

//                         // Contact Us
//                         InkWell(
//                           onTap: () {
//                             Navigator.pushNamed(context, '/contactPage');
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 10),
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Color(0xffc7b456)),
//                               color: Color(0xffffffff),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(5),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0x338a959e),
//                                   offset: Offset(0, 7.6690645218),
//                                   blurRadius: 19.1726608276,
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Contact Us',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontWeight: FontWeight.w700,
//                                           color: Color(0xff232323),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         // alreadyhave10orders9Ca (I318:2511;0:1158)
//                                         'Email & Whatsapp',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w400,
//                                           color: Color(0xff909090),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Image.asset(
//                                   'assets/images/frame-15-6zi.png',
//                                   width: 7.18,
//                                   height: 12.92,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         // Setting
//                         InkWell(
//                           onTap: () {
//                             Navigator.pushNamed(context, '/settingsPage');
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 10),
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Color(0xffc7b456)),
//                               color: Color(0xffffffff),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(5),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0x338a959e),
//                                   offset: Offset(0, 7.6690645218),
//                                   blurRadius: 19.1726608276,
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Setting',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontWeight: FontWeight.w700,
//                                           color: Color(0xff232323),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         // alreadyhave10orders9Ca (I318:2511;0:1158)
//                                         'Update your profile',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w400,
//                                           color: Color(0xff909090),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Image.asset(
//                                   'assets/images/frame-15-6zi.png',
//                                   width: 7.18,
//                                   height: 12.92,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// String getInitials(String name) {
//   List<String> nameParts = name.split(' ');
//   String initials = '';

//   for (String part in nameParts) {
//     if (part.isNotEmpty) {
//       initials += part[0];
//     }
//   }

//   return initials;
// }

import 'package:aadab/ui/root_p.dart';
import 'package:aadab/ui/views/checkout/cart_p.dart';
import 'package:aadab/ui/views/profile/address_p.dart';
import 'package:aadab/ui/views/profile/orders_p.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/order_pr.dart';
import 'package:aadab/core/providers/review_pr.dart';
import 'package:aadab/core/providers/user_address_pr.dart';
import 'package:aadab/core/providers/user_wallet_pr.dart';
import 'package:aadab/core/providers/wish_list_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/profile/widgets/photo_picker_w.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final productId = '';
      final cartData = {
        'kindOfFlower': '',
        'flavour': '',
        'writeOnCake': '',
        'pack': '',
      };
      await Future.wait<void>([
        Provider.of<ReviewModel>(context, listen: false)
            .getMyReviews(productId, '', 0),
        Provider.of<WishListModel>(context, listen: false)
            .getWishLists(productId),
        Provider.of<OrderModel>(context, listen: false).getOrder(),
        Provider.of<AddToCartModel>(context, listen: false)
            .getAddToCart(productId, '', cartData),
        Provider.of<UserAddressModel>(context, listen: false)
            .getUserAddresses(),
        Provider.of<UserWalletModel>(context, listen: false).getMyUserWallets(),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final configModel = locator<ConfigModel>();
    final double fem = MediaQuery.of(context).size.width / 360;
    final double ffem = fem * 0.97;

    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) {
            Navigator.pushReplacementNamed(context, '/homePage');
          }
        },
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        _buildHeader(context, configModel, fem, ffem),
                        _buildBody(context, fem, ffem),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, ConfigModel configModel, double fem, double ffem) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30 * fem, vertical: 10 * fem),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 18 * fem,
                  color: const Color(0xffEED056),
                ),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/homePage'),
              ),
              Expanded(
                child: Text(
                  'Profile',
                  textAlign: TextAlign.center,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 18 * ffem,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1e232c),
                  ),
                ),
              ),
              SizedBox(width: 48 * fem),
            ],
          ),
          Row(
            children: [
              PhotoPickerWidget(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      configModel.user?.firstName?.toString() ?? 'Anonymous',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16 * ffem,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff303030),
                      ),
                    ),
                    Text(
                      configModel.user?.email?.toString() ?? 'No email',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff808080),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () =>
                    _showLogoutDialog(context, configModel, fem, ffem),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Container(
                  width: 80 * fem,
                  height: 35 * fem,
                  decoration: BoxDecoration(
                    color: const Color(0xff1e1e1e),
                    borderRadius: BorderRadius.circular(10 * fem),
                  ),
                  child: Center(
                    child: Text(
                      'Logout',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 15 * ffem,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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

  Widget _buildBody(BuildContext context, double fem, double ffem) {
    final orderModel = Provider.of<OrderModel>(context, listen: false);
    final userWalletModel =
        Provider.of<UserWalletModel>(context, listen: false);
    final wishListModel = Provider.of<WishListModel>(context, listen: false);
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);
    final reviewModel = Provider.of<ReviewModel>(context, listen: false);
    final userAddressModel =
        Provider.of<UserAddressModel>(context, listen: false);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20 * fem, vertical: 20 * fem),
      child: Column(
        children: [
          _buildProfileItem(
            context: context,
            title: 'My Orders',
            subtitle: orderModel.orders.isEmpty
                ? 'My Order is empty'
                : 'Already have ${orderModel.orders.length} orders',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OrdersPage(isProfile: {'isProfile': true}),
              ),
            ),
            fem: fem,
            ffem: ffem,
          ),
          _buildProfileItem(
            context: context,
            title: 'Rewards',
            subtitle:
                'Total earn ${userWalletModel.totalEarnPoint.toString()} points',
            onTap: () => Navigator.pushNamed(context, '/rewardsPage'),
            fem: fem,
            ffem: ffem,
          ),
          _buildProfileItem(
            context: context,
            title: 'Wishlist',
            subtitle: wishListModel.wishLists?.isEmpty ?? true
                ? 'Wishlist is empty'
                : 'Already have ${wishListModel.wishLists!.length} items',
            onTap: () => Navigator.pushNamed(context, '/wishlistPage'),
            fem: fem,
            ffem: ffem,
          ),
          _buildProfileItem(
            context: context,
            title: 'My Cart',
            subtitle: addToCartModel.addToCartLoader ||
                    (addToCartModel.addToCarts?.isEmpty ?? true)
                ? 'My Cart is empty'
                : 'Already have ${addToCartModel.addToCarts!.length} products',
            onTap: () async {
              final cartData = {
                'kindOfFlower': '',
                'flavour': '',
                'writeOnCake': '',
                'pack': '',
              };
              await addToCartModel.getAddToCart('', '', cartData);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CartPage(isProfile: {'isProfile': true}),
                ),
              );
            },
            fem: fem,
            ffem: ffem,
          ),
          _buildProfileItem(
            context: context,
            title: 'My Reviews',
            subtitle: reviewModel.reviewLoader ||
                    (reviewModel.reviews?.isEmpty ?? true)
                ? 'My review is empty'
                : 'Already have ${reviewModel.reviews!.length} reviews',
            onTap: () => Navigator.pushNamed(context, '/reviewsPage'),
            fem: fem,
            ffem: ffem,
          ),
          _buildProfileItem(
            context: context,
            title: 'Shipping Addresses',
            subtitle: userAddressModel.userAddressesLoader ||
                    (userAddressModel.userAddresses?.isEmpty ?? true)
                ? 'Shipping address is empty'
                : 'Already have ${userAddressModel.userAddresses!.length} addresses',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddressPage(arguments: {
                  'cartItems': [],
                  'cartTotal': '',
                  'couponValue': 0,
                  'isAddress': false,
                }),
              ),
            ),
            fem: fem,
            ffem: ffem,
          ),
          _buildProfileItem(
            context: context,
            title: 'Contact Us',
            subtitle: 'Email & Whatsapp',
            onTap: () => Navigator.pushNamed(context, '/contactPage'),
            fem: fem,
            ffem: ffem,
          ),
          _buildProfileItem(
            context: context,
            title: 'Settings',
            subtitle: 'Update your profile',
            onTap: () => Navigator.pushNamed(context, '/settingsPage'),
            fem: fem,
            ffem: ffem,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required double fem,
    required double ffem,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10 * fem),
        padding: EdgeInsets.all(10 * fem),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffc7b456)),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5 * fem)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x338a959e),
              offset: Offset(0, 7.6690645218 * fem),
              blurRadius: 19.1726608276 * fem,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16 * ffem,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff232323),
                    ),
                  ),
                  SizedBox(height: 5 * fem),
                  Text(
                    subtitle,
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 11 * ffem,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff909090),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12 * fem,
              color: const Color(0xff232323),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(
      BuildContext context, ConfigModel configModel, double fem, double ffem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20 * fem)),
        title: Text(
          'Confirm Logout',
          style: MyGoogleFontStyle(
            fontFamily: 'Urbanist',
            fontSize: 16 * ffem,
            fontWeight: FontWeight.w600,
            color: const Color(0xff1e232c),
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: MyGoogleFontStyle(
            fontFamily: 'Poppins',
            fontSize: 14 * ffem,
            fontWeight: FontWeight.w400,
            color: const Color(0xff909090),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: MyGoogleFontStyle(
                fontFamily: 'Poppins',
                fontSize: 14 * ffem,
                fontWeight: FontWeight.w500,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Future.wait([
                  FirebaseAuth.instance.signOut(),
                  GoogleSignIn().signOut(),
                  FacebookAuth.instance.logOut(),
                  configModel.removeLoginData(),
                ]);
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => RootPage()),
                    (Route<dynamic> route) => false,
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to logout: $e')),
                  );
                  Navigator.pop(context);
                }
              }
            },
            child: Text(
              'Yes',
              style: MyGoogleFontStyle(
                fontFamily: 'Poppins',
                fontSize: 14 * ffem,
                fontWeight: FontWeight.w500,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String getInitials(String name) {
  if (name.isEmpty) return '';
  final nameParts = name.trim().split(' ').where((part) => part.isNotEmpty);
  return nameParts.map((part) => part[0]).join();
}

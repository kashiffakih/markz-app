import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/core/providers/review_pr.dart';
import 'package:sales_app/core/providers/user_address_pr.dart';
import 'package:sales_app/core/providers/user_wallet_pr.dart';
import 'package:sales_app/core/providers/wish_list_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/auth/login_p.dart';
import 'package:sales_app/ui/views/profile/address_p.dart';
import 'package:sales_app/ui/views/profile/widgets/photo_picker_w.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    var productId = '';
    var reviewDescription = '';
    Map<String, dynamic> _CartData = {
      'kindOfFlower': '',
      'flavour': '',
      'writeOnCake': '',
      'pack': ''
    };
    Provider.of<ReviewModel>(context, listen: false)
        .getMyReviews(productId, reviewDescription, '');
    Provider.of<WishListModel>(context, listen: false).getWishLists(productId);
    Provider.of<OrderModel>(context, listen: false).getOrder();
    Provider.of<AddToCartModel>(context, listen: false)
        .getAddToCart(productId, '', _CartData);
    Provider.of<UserAddressModel>(context, listen: false).getUserAddresses();
    Provider.of<UserWalletModel>(context, listen: false).getMyUserWallets();
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel _configModel = locator<ConfigModel>();
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final OrderModel _orderModel = Provider.of<OrderModel>(context);
    final WishListModel _wishListModel = Provider.of<WishListModel>(context);
    final ReviewModel _reviewModel = Provider.of<ReviewModel>(context);
    final UserAddressModel _userAddressModel =
        Provider.of<UserAddressModel>(context);
    final UserWalletModel _userWalletModel =
        Provider.of<UserWalletModel>(context);
    String initials = getInitials(_configModel.user!.firstName.toString());
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                // Title
                Container(
                  margin:
                      EdgeInsets.only(top: 10, left: 30, bottom: 20, right: 30),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Image.asset(
                                'assets/images/vector-GJ4.png',
                                height: 15,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Profile',
                                textAlign: TextAlign.center,
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1e232c),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Column(
                    children: [
                      // Photo and Name
                      Row(
                        children: [
                          // _configModel.user!.imagepath != null
                          //     ? Container(
                          //         margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          //         width: 65,
                          //         height: 65,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(40),
                          //           image: DecorationImage(
                          //             fit: BoxFit.cover,
                          //             image: NetworkImage(
                          //                 _configModel.apiConfig['mediaURL'] + _configModel.user!.imagepath
                          //                         .toString()),
                          //           ),
                          //         ),
                          //       )
                              // : Container(
                              //     margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              //     width: 65,
                              //     height: 65,
                              //     child: CircleAvatar(
                              //       radius: 50,
                              //       backgroundColor: Colors.black,
                              //       child: Text(
                              //         initials,
                              //         style: TextStyle(
                              //           fontSize: 24,
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                          // :
                          PhotoPickerWidget(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _configModel.user!.firstName.toString(),
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff303030),
                                  ),
                                ),
                                Text(
                                  _configModel.user!.email.toString(),
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff808080),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  // margin: EdgeInsets.fromLTRB(5, 0, 6.34, 0),
                                  child: TextButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          title: Text(
                                              'Are you sure you want to logout?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('NO'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                await GoogleSignIn().signOut();
                                                await FacebookAuth.instance.logOut();
                                                await _configModel
                                                    .removeLoginData();
                                                Navigator.pushReplacementNamed(
                                                    context, '/login');
                                              },
                                              child: Text('YES'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Container(
                                      width: 80,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Color(0xff1e1e1e),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Logout',
                                          textAlign: TextAlign.center,
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 15.1428556442,
                                            fontWeight: FontWeight.w700,
                                            height: 1.4999999685,
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
                        ],
                      ),
                      //wholesale login
                      Container(
                        // margin: EdgeInsets.fromLTRB(5, 0, 6.34, 0),
                        child: TextButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20)),
                                    title: Text(
                                        'Are you sure you want to logout?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('NO'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await GoogleSignIn().signOut();
                                          await FacebookAuth.instance.logOut();
                                          await _configModel.removeLoginData();
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const LoginPage(argument: {'role': 'Distributor'},),
                                            ),
                                                (Route<dynamic> route) => false,
                                          );
                                        },
                                        child: Text('YES'),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            width: 200,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Color(0xff1e1e1e),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Login As Wholesaler',
                                textAlign: TextAlign.center,
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 15.1428556442,
                                  fontWeight: FontWeight.w700,
                                  height: 1.4999999685,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // My Orders
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/ordersPage');
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffc7b456)),
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x338a959e),
                                offset: Offset(0, 7.6690645218),
                                blurRadius: 19.1726608276,
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
                                      'My Orders',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _orderModel.orders.length == 0
                                          ? 'My Order is empty'
                                          : 'Already have ' +
                                              _orderModel.orders.length
                                                  .toString() +
                                              ' orders',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/frame-15-6zi.png',
                                width: 7.18,
                                height: 12.92,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Rewards
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/rewardsPage');
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffc7b456)),
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x338a959e),
                                offset: Offset(0, 7.6690645218),
                                blurRadius: 19.1726608276,
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
                                      'Rewards',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      // alreadyhave10orders9Ca (I318:2511;0:1158)
                                      'Total earn ${_userWalletModel.totalEarnPoint.toString()} points',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/frame-15-6zi.png',
                                width: 7.18,
                                height: 12.92,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Wishlist
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/wishlistPage');
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffc7b456)),
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x338a959e),
                                offset: Offset(0, 7.6690645218),
                                blurRadius: 19.1726608276,
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
                                      'Wishlist',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _wishListModel.wishLists!.length == 0
                                          ? 'Wishlist is empty'
                                          : 'Already have ' +
                                              _wishListModel.wishLists!.length
                                                  .toString() +
                                              ' orders',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/frame-15-6zi.png',
                                width: 7.18,
                                height: 12.92,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Cart List
                      InkWell(
                        onTap: () async {
                          Map<String, dynamic> _CartData = {
                            'kindOfFlower': '',
                            'flavour': '',
                            'writeOnCake': '',
                            'pack': ''
                          };
                          await _addToCartModel.getAddToCart('', '', _CartData);
                          Navigator.pushNamed(context, '/cartPage');
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffc7b456)),
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x338a959e),
                                offset: Offset(0, 7.6690645218),
                                blurRadius: 19.1726608276,
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
                                      'My Cart',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _addToCartModel.addToCartLoader
                                          ? 'My Cart is empty'
                                          : _addToCartModel
                                                      .addToCarts!.length ==
                                                  0
                                              ? 'My Cart is empty'
                                              : 'Already have ' +
                                                  _addToCartModel
                                                      .addToCarts!.length
                                                      .toString() +
                                                  ' orders',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/frame-15-6zi.png',
                                width: 7.18,
                                height: 12.92,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // My Reviews
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/reviewsPage');
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffc7b456)),
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x338a959e),
                                offset: Offset(0, 7.6690645218),
                                blurRadius: 19.1726608276,
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
                                      'My Reviews',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _reviewModel.reviewLoader
                                          ? 'My review is empty.'
                                          : _reviewModel.reviews!.length == 0
                                              ? 'My review is empty.'
                                              : 'Already have ' +
                                                  _reviewModel.reviews!.length
                                                      .toString() +
                                                  ' reviews',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/frame-15-6zi.png',
                                width: 7.18,
                                height: 12.92,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Shipping Addresses
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddressPage(arguments: {
                                    'cartItems': [],
                                    'cartTotal': '',
                                    'couponValue': 0,
                                    'isAddress': false
                                  })));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffc7b456)),
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x338a959e),
                                offset: Offset(0, 7.6690645218),
                                blurRadius: 19.1726608276,
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
                                      'Shipping Addresses',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _userAddressModel.userAddressesLoader
                                          ? 'Shipping address is empty.'
                                          : _userAddressModel
                                                      .userAddresses!.length ==
                                                  0
                                              ? 'Shipping address is empty.'
                                              : 'Already have ' +
                                                  _userAddressModel
                                                      .userAddresses!.length
                                                      .toString() +
                                                  ' address',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/frame-15-6zi.png',
                                width: 7.18,
                                height: 12.92,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Contact Us
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/contactPage');
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffc7b456)),
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x338a959e),
                                offset: Offset(0, 7.6690645218),
                                blurRadius: 19.1726608276,
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
                                      'Contact Us',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      // alreadyhave10orders9Ca (I318:2511;0:1158)
                                      'Email & Whatsapp',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/frame-15-6zi.png',
                                width: 7.18,
                                height: 12.92,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Setting
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/settingsPage');
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffc7b456)),
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x338a959e),
                                offset: Offset(0, 7.6690645218),
                                blurRadius: 19.1726608276,
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
                                      'Setting',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      // alreadyhave10orders9Ca (I318:2511;0:1158)
                                      'Already have 10 orders',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/frame-15-6zi.png',
                                width: 7.18,
                                height: 12.92,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   elevation: 10,
      //   iconSize: 30,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.black,
      //   selectedFontSize: 14,
      //   unselectedFontSize: 14,
      //   onTap: (value) async {
      //     if (value == 0) {
      //       Navigator.pushNamed(context, '/homePage');
      //     }
      //     if (value == 1) {
      //       Navigator.pushNamed(context, '/wishlistPage');
      //     }

      //     if (value == 2) {
      //       Map<String, dynamic> _CartData = {
      //         'kindOfFlower': '',
      //         'flavour': '',
      //         'writeOnCake': '',
      //         'pack': ''
      //       };
      //       await _addToCartModel.getAddToCart('', '', _CartData);
      //       Navigator.pushNamed(context, '/cartPage');
      //     }
      //     if (value == 3) {
      //       Navigator.pushNamed(context, '/profilePage');
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: Iconoir(Iconoir.home_simple),
      //       // icon: Icon(DonIcons.wap_home, size: 23),
      //     ),
      //     BottomNavigationBarItem(label: 'Saved', icon: Iconoir(Iconoir.heart)),
      //     BottomNavigationBarItem(
      //       label: 'Cart',
      //       icon: Iconoir(Iconoir.shopping_bag),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Profile',
      //       icon: Icon(
      //         DonIcons.user_o,
      //         size: 23,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

String getInitials(String name) {
  List<String> nameParts = name.split(' ');
  String initials = '';

  for (String part in nameParts) {
    if (part.isNotEmpty) {
      initials += part[0];
    }
  }

  return initials;
}

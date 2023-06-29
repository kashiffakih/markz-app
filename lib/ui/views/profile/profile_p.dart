import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/core/providers/wish_list_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final ConfigModel _configModel = locator<ConfigModel>();
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final OrderModel _orderModel = Provider.of<OrderModel>(context);
    final WishListModel _wishListModel = Provider.of<WishListModel>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                // Title
                Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
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
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Photo and Name
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/avatar-bg.png',
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _configModel.user.firstName.toString(),
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff303030),
                                ),
                              ),
                              Text(
                                // bruno203gmailcom6y4 (318:2508)
                                _configModel.user.email.toString(),
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff808080),
                                ),
                              ),
                            ],
                          )
                        ],
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
                                      _addToCartModel.addToCarts!.length == 0
                                          ? 'My Cart is empty'
                                          : 'Already have ' +
                                              _addToCartModel.addToCarts!.length
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
                      // Shipping Addresses
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/addressPage');
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
                      // Payment Method
                      Container(
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
                                    'Payment Method',
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
    );
  }
}

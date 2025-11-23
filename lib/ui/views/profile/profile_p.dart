import 'package:aadab/ui/root_p.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            .getMyReviews('', productId, '', '', []),
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
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to load data: $e')),
        // );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final configModel = locator<ConfigModel>();
    return Scaffold(
      body: Container(
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
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (!didPop) {
              Navigator.pushReplacementNamed(context, '/homePage');
            }
          },
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
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEED056)),
                            strokeWidth: 3,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Loading Profile...',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff232323),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          _buildHeader(context, configModel),
                          _buildBody(context),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ConfigModel configModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.0.w),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/homePage'),
                child: Container(
                  padding: EdgeInsets.all(8.0.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFEED056).withOpacity(0.15),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 16.0.sp,
                    color: const Color(0xffEED056),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'My Profile',
                  textAlign: TextAlign.center,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e232c),
                  ),
                ),
              ),
              SizedBox(width: 48.0.w),
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
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff303030),
                      ),
                    ),
                    Text(
                      configModel.user?.email?.toString() ?? 'No email',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff808080),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _showLogoutDialog(context, configModel),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Container(
                  width: 80.0.w,
                  height: 35.0.w,
                  decoration: BoxDecoration(
                    color: const Color(0xff1e1e1e),
                    borderRadius: BorderRadius.circular(10.0.r),
                  ),
                  child: Center(
                    child: Text(
                      'Logout',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 15.0.sp,
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

  Widget _buildBody(BuildContext context) {
    final orderModel = Provider.of<OrderModel>(context, listen: false);
    final userWalletModel =
        Provider.of<UserWalletModel>(context, listen: false);
    final wishListModel = Provider.of<WishListModel>(context, listen: false);
    final addToCartModel = Provider.of<AddToCartModel>(context, listen: false);
    final reviewModel = Provider.of<ReviewModel>(context, listen: false);
    final userAddressModel =
        Provider.of<UserAddressModel>(context, listen: false);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.0.w),
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
          ),
          _buildProfileItem(
            context: context,
            title: 'Rewards',
            subtitle:
                'Total earn ${userWalletModel.totalEarnPoint.toString()} points',
            onTap: () => Navigator.pushNamed(context, '/rewardsPage'),
          ),
          _buildProfileItem(
            context: context,
            title: 'Wishlist',
            subtitle: wishListModel.wishLists?.isEmpty ?? true
                ? 'Wishlist is empty'
                : 'Already have ${wishListModel.wishLists!.length} items',
            onTap: () => Navigator.pushNamed(context, '/wishlistPage'),
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
          ),
          _buildProfileItem(
            context: context,
            title: 'My Reviews',
            subtitle: reviewModel.reviewLoader ||
                    (reviewModel.reviews?.isEmpty ?? true)
                ? 'My review is empty'
                : 'Already have ${reviewModel.reviews!.length} reviews',
            onTap: () =>
                Navigator.pushNamed(context, '/reviewsPage', arguments: {
              'is_edit': true,
              'is_popup': true,
            }),
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
          ),
          _buildProfileItem(
            context: context,
            title: 'Contact Us',
            subtitle: 'Email & Whatsapp',
            onTap: () => Navigator.pushNamed(context, '/contactPage'),
          ),
          _buildProfileItem(
            context: context,
            title: 'Settings',
            subtitle: 'Update your profile',
            onTap: () => Navigator.pushNamed(context, '/settingsPage'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(
      {required BuildContext context,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
      required}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0.w),
        padding: EdgeInsets.all(10.0.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffc7b456)),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0.w)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x338a959e),
              offset: Offset(0, 7.6690645218.w),
              blurRadius: 19.1726608276.w,
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
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff232323),
                    ),
                  ),
                  SizedBox(height: 5.0.w),
                  Text(
                    subtitle,
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 11.0.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff909090),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12.0.w,
              color: const Color(0xff232323),
            ),
          ],
        ),
      ),
    );
  }

  void _clearAllProviderStates() {
    // Clear all provider states to ensure no data persists after logout
    try {
      // Clear cart data
      Provider.of<AddToCartModel>(context, listen: false).addToCarts = [];

      // Clear wishlist data
      Provider.of<WishListModel>(context, listen: false).wishLists = [];

      // Clear order data
      Provider.of<OrderModel>(context, listen: false).orders = [];

      // Clear review data
      Provider.of<ReviewModel>(context, listen: false).reviews = [];

      // Clear user address data
      Provider.of<UserAddressModel>(context, listen: false).userAddresses = [];

      // Clear wallet data
      Provider.of<UserWalletModel>(context, listen: false).userWallets = [];
    } catch (e) {
      print('Error clearing provider states: $e');
    }
  }

  void _showLogoutDialog(BuildContext context, ConfigModel configModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0.r)),
        title: Text(
          'Confirm Logout',
          style: MyGoogleFontStyle(
            fontFamily: 'Urbanist',
            fontSize: 16.0.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff1e232c),
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: MyGoogleFontStyle(
            fontFamily: 'Poppins',
            fontSize: 14.0.sp,
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
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Clear all provider states
                _clearAllProviderStates();

                // Sign out from all auth services and clear login data
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
                fontSize: 14.0.sp,
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

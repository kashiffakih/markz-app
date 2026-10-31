import 'package:aadab/ui/root_p.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/core/services/auth_s.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aadab/ui/views/checkout/cart_p.dart';
import 'package:aadab/ui/views/profile/address_p.dart';
import 'package:aadab/ui/views/profile/orders_p.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
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

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:aadab/core/providers/auth_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/profile/widgets/photo_picker_w.dart';
import 'package:aadab/ui/views/products/shops_p.dart';
import 'package:aadab/ui/widgets/login_required_popup.dart';
import 'package:badges/badges.dart' as badges;
import 'package:aadab/core/models/user.dart';
import 'package:aadab/core/providers/notification_pr.dart';
import 'package:aadab/ui/views/profile/notifications_p.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const double _bottomNavBarHeight = 90.0;
  static const int _bottomNavIconSize = 23;

  final ImagePicker _bsPicker = ImagePicker();
  bool _bsHasGst = false;
  File? _bsVisitingCardImage;
  File? _bsShopImage;
  final Map<String, dynamic> _bsWholesalerData = {
    'first_name': '',
    'email': '',
    'password': '',
    'confirm_password': '',
    'phone': '',
    'gst_number': '',
    'business_name': '',
    'trade_name': '',
    'address': '',
    'pincode_business': '',
    'state_business': '',
    'registration_date': '',
    'role': 'Distributor',
  };

  @override
  Widget build(BuildContext context) {
    final configModel = context.watch<ConfigModel>();
    final addToCartModel = Provider.of<AddToCartModel>(context);
    final cartCount = addToCartModel.addToCarts?.length ?? 0;

    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(
          context, configModel, addToCartModel, cartCount),
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
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    _buildHeader(context, configModel),
                    _buildRoleSwitcher(context, configModel),
                    _buildQuickLinks(context, configModel),
                    _buildBody(context, configModel),
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
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEED056),
            Color(0xFFF6E27F),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 30.w),
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/homePage'),
                  child: Container(
                    padding: EdgeInsets.all(8.0.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      size: 20.0.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Hello,',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        _getDisplayName(configModel.user),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 22.0.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Placeholder for balance spacing or slight offset
                SizedBox(width: 40.w),
              ],
            ),
          ),
          SizedBox(height: 20.w),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: PhotoPickerWidget(),
              ),
            ],
          ),
          SizedBox(height: 10.w),
          Text(
            configModel.user?.email?.toString() ?? '',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinks(BuildContext context, ConfigModel configModel) {
    // Flipkart/Amazon style grid row
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 10.w),
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickLinkItem(
            context,
            'Orders',
            Icons.move_to_inbox_rounded,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OrdersPage(isProfile: {'isProfile': true}),
              ),
            ),
          ),
          _buildQuickLinkItem(
            context,
            'Wishlist',
            Icons.favorite_rounded,
            Colors.pink,
            () => Navigator.pushNamed(context, '/wishlistPage'),
          ),
          if (configModel.activeRole != 'Distributor')
            _buildQuickLinkItem(
              context,
              'Wallet',
              Icons.account_balance_wallet_rounded,
              Colors.orange,
              () => Navigator.pushNamed(context, '/rewardsPage'),
            ),
          _buildQuickLinkItem(
            context,
            'Help',
            Icons.headset_mic_rounded,
            Colors.teal,
            () => Navigator.pushNamed(context, '/contactPage'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinkItem(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(height: 8.w),
          Text(
            title,
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xff232323),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ConfigModel configModel) {
    // Grouped List for "Amazon/Flipkart" feel
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Account Settings'),
          Container(
            decoration: _boxDecoration(),
            child: Column(
              children: [
                _buildProfileItem(
                  context: context,
                  title: 'Edit Profile',
                  icon: Icons.person_outline_rounded,
                  onTap: () => Navigator.pushNamed(context, '/settingsPage'),
                ),
                _buildDivider(),
                _buildProfileItem(
                  context: context,
                  title: 'Saved Addresses',
                  icon: Icons.location_on_outlined,
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
              ],
            ),
          ),
          SizedBox(height: 20.w),
          _buildSectionTitle('My Activity'),
          Container(
            decoration: _boxDecoration(),
            child: Column(
              children: [
                _buildProfileItem(
                  context: context,
                  title: 'My Reviews',
                  icon: Icons.rate_review_outlined,
                  onTap: () =>
                      Navigator.pushNamed(context, '/reviewsPage', arguments: {
                    'is_edit': true,
                    'is_popup': true,
                  }),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.w),
          _buildSectionTitle('Marketplace'),
          Container(
            decoration: _boxDecoration(),
            child: Column(
              children: [
                _buildProfileItem(
                  context: context,
                  title: 'Markz Marketplace',
                  icon: Icons.storefront_outlined,
                  onTap: () => Navigator.pushNamed(context, '/marketplacePage'),
                ),
                _buildDivider(),
                _buildProfileItem(
                  context: context,
                  title: 'My Chats',
                  icon: Icons.chat_bubble_outline,
                  onTap: () => Navigator.pushNamed(context, '/chatListPage'),
                ),
                _buildDivider(),
                _buildProfileItem(
                  context: context,
                  title: 'My Returns',
                  icon: Icons.assignment_return_outlined,
                  onTap: () => Navigator.pushNamed(context, '/myReturnsPage'),
                ),
                _buildDivider(),
                _buildProfileItem(
                  context: context,
                  title: 'Reseller Program',
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: () => Navigator.pushNamed(context, '/resellerPage'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.w),
          _buildSectionTitle('Feedback & Information'),
          Container(
            decoration: _boxDecoration(),
            child: Column(
              children: [
                _buildProfileItem(
                  context: context,
                  title: 'Contact Us',
                  icon: Icons.support_agent_outlined,
                  onTap: () => Navigator.pushNamed(context, '/contactPage'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.w),
          InkWell(
            onTap: () => _showLogoutDialog(context, configModel),
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: Center(
                child: Text(
                  'Log Out',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.w),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.w, left: 5.w),
      child: Text(
        title,
        style: MyGoogleFontStyle(
          fontFamily: 'Urbanist',
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xff1e232c),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withOpacity(0.1),
      indent: 50.w,
      endIndent: 20.w,
    );
  }

  Widget _buildProfileItem(
      {required BuildContext context,
      required String title,
      required IconData icon,
      required VoidCallback onTap,
      bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: isDestructive ? Colors.red : Color(0xff909090),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(
                title,
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.w600,
                  color: isDestructive ? Colors.red : const Color(0xff1e232c),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12.0.sp,
              color: const Color(0xff909090),
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayName(User? user) {
    if (user == null) return 'Guest';

    // For Distributors, prioritize Business/Trade Name
    if (user.roles?.any((r) => r.name == 'Distributor') ?? false) {
      if (user.businessName != null && user.businessName!.isNotEmpty) {
        // Capitalize Business Name
        return user.businessName![0].toUpperCase() +
            user.businessName!.substring(1);
      }
      if (user.tradeName != null && user.tradeName!.isNotEmpty) {
        return user.tradeName!;
      }
    }

    // Fallback to First Name + Last Name
    String name = user.firstName ?? '';
    if (user.lastName != null && user.lastName!.isNotEmpty) {
      name += ' ${user.lastName}';
    }
    // Capitalize User Name
    if (name.isNotEmpty) {
      return name[0].toUpperCase() + name.substring(1);
    }

    return name.isNotEmpty ? name : 'Guest';
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
                  auth.FirebaseAuth.instance.signOut(),
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
          currentIndex: 3, // Set to Profile tab
          onTap: (value) =>
              _handleBottomNavTap(context, value, configModel, addToCartModel),
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Image.asset('assets/images/home-icon.png',
                  width: _bottomNavIconSize.toDouble(),
                  height: _bottomNavIconSize.toDouble(),
                  color: Color(0xFF909090)),
            ),
            BottomNavigationBarItem(
              label: 'Category',
              icon: Image.asset('assets/images/category-icon.png',
                  width: _bottomNavIconSize.toDouble(),
                  height: _bottomNavIconSize.toDouble(),
                  color: Color(0xFF909090)),
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
                    height: _bottomNavIconSize.toDouble(),
                    color: Color(0xFF909090)),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Image.asset('assets/images/user-profile-icon.png',
                  width: _bottomNavIconSize.toDouble(),
                  height: _bottomNavIconSize.toDouble(),
                  color: Color(0xFFEED056)), // Highlight the profile icon
            ),
            BottomNavigationBarItem(
              label: 'Notifs',
              icon: Consumer<NotificationModel>(
                builder: (context, notifModel, child) {
                  return badges.Badge(
                    showBadge: notifModel.systemUnreadCount > 0,
                    badgeContent: Text(
                      '${notifModel.systemUnreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: Color(0xFFEED056),
                      padding: EdgeInsets.all(6),
                    ),
                    child: Image.asset(
                      'assets/images/notification-icon.png',
                      width: _bottomNavIconSize.toDouble(),
                      height: _bottomNavIconSize.toDouble(),
                      color: Color(0xFF909090),
                    ),
                  );
                },
              ),
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
      // Already on profile page
    } else if (value == 4 && configModel.user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationsPage(sendBy: 'System'),
        ),
      );
    } else {
      showDialog(
          context: context, builder: (context) => LoginRequiredPopupWidget());
    }
  }

  Widget _buildRoleSwitcher(BuildContext context, ConfigModel configModel) {
    bool isDistributorActive = configModel.activeRole == 'Distributor';
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDistributorActive ? Colors.blueGrey : Color(0xFFEED056),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        onPressed: () => _handleRoleSwitch(context, configModel),
        child: Text(
          isDistributorActive
              ? 'Switch to User View'
              : 'Switch to Distributor View',
          style: MyGoogleFontStyle(
            fontFamily: 'Urbanist',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDistributorActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  void _handleRoleSwitch(BuildContext context, ConfigModel configModel) async {
    // Show loading spinner while fetching fresh user status from server
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffc9b758)),
        ),
      ),
    );

    // Fetch fresh user data from API
    final authService = locator<AuthService>();
    final freshUser = await authService.fetchFreshUserData();

    // Close loading spinner
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    final user = freshUser ?? configModel.user;

    if (configModel.activeRole == 'Distributor') {
      // Switch directly to Customer (User) mode
      configModel.switchRole('User');
    } else {
      // Trying to switch to Wholesaler (Distributor)

      // 1. Check if user account is blocked
      if (user?.isBlocked == 1) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Account Blocked'),
            content: Text(
              'Your account has been blocked/blacklisted by admin.\n\n${user?.blockedReason != null && user!.blockedReason!.trim().isNotEmpty ? "Reason: ${user.blockedReason}\n\n" : ""}Please contact support for assistance.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      final isDistributorRole =
          user?.roles?.any((r) => r.name == 'Distributor') ?? false;

      // 2. If approved wholesaler, switch role immediately
      if (user?.isApproved == 1) {
        configModel.switchRole('Distributor');
        return;
      }

      // 3. Check if wholesaler request is rejected (only when not approved)
      if (user?.isRejected == 1 || user?.isApproved == 2) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Wholesaler Request Rejected'),
            content: Text(
              'Your wholesaler account request has been rejected by admin.\n\n${user?.rejectionReason != null && user!.rejectionReason!.trim().isNotEmpty ? "Reason: ${user.rejectionReason}\n\n" : ""}Please contact support for assistance.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // 4. If pending approval with submitted business details
      bool hasSubmittedBusinessDetails = (user?.businessName != null &&
              user!.businessName!.trim().isNotEmpty) ||
          (user?.address != null && user!.address!.trim().isNotEmpty);

      if ((isDistributorRole || hasSubmittedBusinessDetails) &&
          (user?.isApproved == 0 || user?.isApproved == null) &&
          hasSubmittedBusinessDetails) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Approval Pending'),
            content: const Text(
                'Your wholesaler request has been submitted and is pending admin approval. Please wait for approval.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // 5. Not registered as Wholesaler or incomplete details -> Navigate to Register Page to fill business/document details
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Register as Wholesaler'),
          content: const Text(
              'To switch to Wholesaler view, please complete your business details and upload required documents.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffc9b758),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _showWholesalerRequestBottomSheet(
                  userId: configModel.user?.id?.toString() ?? '',
                );
              },
              child: const Text('Fill Details',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _bsPickImage(
      {required bool isVisitingCard,
      required StateSetter setModalState}) async {
    final XFile? pickedFile = await _bsPicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setModalState(() {
        if (isVisitingCard) {
          _bsVisitingCardImage = File(pickedFile.path);
        } else {
          _bsShopImage = File(pickedFile.path);
        }
      });
    }
  }

  bool _isValidEmail(String input) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(emailPattern).hasMatch(input);
  }

  void _showWholesalerPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Wholesaler Request Submitted'),
        content: const Text(
            'Your wholesaler account request has been submitted successfully and is pending admin approval.'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffc9b758),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showWholesalerRequestBottomSheet({required String userId}) {
    final bsFormKey = GlobalKey<FormState>();
    bool bsLoading = false;
    bool bsObscurePassword = true;
    bool bsObscureConfirmPassword = true;
    String? bsErrorMessage;
    TextEditingController regDateController = TextEditingController(
      text: _bsWholesalerData['registration_date'] ?? '',
    );

    final configModel = Provider.of<ConfigModel>(context, listen: false);
    final user = configModel.user;

    String initialFullName = user != null
        ? '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim()
        : '';
    String initialEmail = user?.email ?? '';

    TextEditingController fullNameController =
        TextEditingController(text: initialFullName);
    TextEditingController emailController =
        TextEditingController(text: initialEmail);

    _bsWholesalerData['first_name'] = initialFullName;
    _bsWholesalerData['email'] = initialEmail;
    _bsWholesalerData['role'] = 'Distributor';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bsContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xffDDDDDD),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9A825).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.store,
                              color: Color(0xFFF9A825), size: 22),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wholesaler Request',
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff1e232c),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Fill in your business details to complete registration',
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff8390a1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 24, color: Color(0xffF0F0F0)),
                  // Scrollable form
                  // Inline error message banner
                  if (bsErrorMessage != null)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red.shade700, size: 20),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              bsErrorMessage!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setModalState(() => bsErrorMessage = null);
                            },
                            child: Icon(Icons.close,
                                color: Colors.red.shade700, size: 18),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
                      child: Form(
                        key: bsFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Full Name (Required, ReadOnly)
                            _buildBsTextField(
                              hintText: 'Full Name',
                              controller: fullNameController,
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Full name cannot be empty';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['first_name'] =
                                      value?.trim() ?? fullNameController.text,
                            ),
                            SizedBox(height: 10.h),
                            // Email (Required, ReadOnly)
                            _buildBsTextField(
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email cannot be empty';
                                }
                                if (!_isValidEmail(value.trim())) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (value) => _bsWholesalerData['email'] =
                                  value?.trim() ?? emailController.text,
                            ),
                            SizedBox(height: 10.h),
                            // Phone Number (Required)
                            _buildBsTextField(
                              hintText: 'Phone Number',
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (value.trim().length < 10) {
                                  return 'Please enter a valid 10-digit phone number';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['phone'] = value?.trim(),
                            ),
                            SizedBox(height: 10.h),
                            // Password (Required)
                            _buildBsTextField(
                              hintText: 'Password',
                              obscureText: bsObscurePassword,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    bsObscurePassword = !bsObscurePassword;
                                  });
                                },
                                child: Icon(
                                  bsObscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xff8390a1),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password cannot be empty';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                _bsWholesalerData['password'] = value;
                                return null;
                              },
                              onChanged: (value) {
                                _bsWholesalerData['password'] = value;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['password'] = value,
                            ),
                            SizedBox(height: 10.h),
                            // Confirm Password (Required)
                            _buildBsTextField(
                              hintText: 'Confirm Password',
                              obscureText: bsObscureConfirmPassword,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    bsObscureConfirmPassword =
                                        !bsObscureConfirmPassword;
                                  });
                                },
                                child: Icon(
                                  bsObscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xff8390a1),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm password cannot be empty';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                if (value != _bsWholesalerData['password']) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['confirm_password'] = value,
                            ),
                            SizedBox(height: 10.h),
                            // Business Name (Required)
                            _buildBsTextField(
                              hintText: 'Business Name',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Business Name is required';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['business_name'] = value,
                            ),
                            SizedBox(height: 10.h),
                            // Trade Name (Optional)
                            _buildBsTextField(
                              hintText: 'Trade Name',
                              onSaved: (value) =>
                                  _bsWholesalerData['trade_name'] = value,
                            ),
                            SizedBox(height: 10.h),
                            // Registration Date (Optional)
                            TextFormField(
                              readOnly: true,
                              controller: regDateController,
                              decoration: _bsInputDecoration(
                                hintText: 'Registration Date',
                                suffixIcon: const Icon(Icons.calendar_today,
                                    color: Color(0xff8390a1)),
                              ),
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                                color: const Color(0xff000000),
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  setModalState(() {
                                    _bsWholesalerData['registration_date'] =
                                        '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                                    regDateController.text =
                                        _bsWholesalerData['registration_date'];
                                  });
                                }
                              },
                            ),
                            SizedBox(height: 10.h),
                            // GST Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: _bsHasGst,
                                  onChanged: (value) {
                                    setModalState(() {
                                      _bsHasGst = value!;
                                      if (!_bsHasGst) {
                                        _bsWholesalerData['gst_number'] = '';
                                      }
                                    });
                                  },
                                  activeColor: const Color(0xff1A1A1A),
                                ),
                                Text(
                                  'I have GST Number',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff1A1A1A),
                                  ),
                                ),
                              ],
                            ),
                            if (_bsHasGst) ...[
                              _buildBsTextField(
                                hintText: 'GST Number',
                                textCapitalization:
                                    TextCapitalization.characters,
                                validator: (value) {
                                  if (_bsHasGst &&
                                      (value == null || value.trim().isEmpty)) {
                                    return 'GST Number is required';
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    _bsWholesalerData['gst_number'] = value,
                              ),
                              SizedBox(height: 10.h),
                            ],
                            // Address
                            _buildBsTextField(
                              hintText: 'Business Address',
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Address is required';
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['address'] = value,
                            ),
                            SizedBox(height: 10.h),
                            // Pincode
                            _buildBsTextField(
                              hintText: 'Pincode',
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Pincode required';
                                if (value.length != 6) return 'Invalid pincode';
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['pincode_business'] = value,
                            ),
                            SizedBox(height: 10.h),
                            // State & City picker
                            CSCPickerPlus(
                              layout: Layout.vertical,
                              showStates: true,
                              showCities: true,
                              flagState: CountryFlag.DISABLE,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.66),
                                color: const Color(0xfff7f8f9),
                                border:
                                    Border.all(color: const Color(0xffe8ecf4)),
                              ),
                              disabledDropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.66),
                                color: const Color(0xfff7f8f9),
                                border:
                                    Border.all(color: const Color(0xffe8ecf4)),
                              ),
                              countrySearchPlaceholder: "Search Country",
                              stateSearchPlaceholder: "Search State",
                              citySearchPlaceholder: "Search City",
                              countryDropdownLabel: "Select Country",
                              stateDropdownLabel: "Select State",
                              cityDropdownLabel: "Select City",
                              defaultCountry: CscCountry.India,
                              disableCountry: false,
                              selectedItemStyle: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              dropdownHeadingStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              dropdownItemStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              dropdownDialogRadius: 10.0,
                              searchBarRadius: 10.0,
                              onCountryChanged: (value) {
                                // Country value tracked by picker
                              },
                              onStateChanged: (value) {
                                setModalState(() {
                                  _bsWholesalerData['state_business'] =
                                      value?.toString() ?? "";
                                });
                              },
                              onCityChanged: (value) {
                                // City value tracked by picker
                              },
                            ),
                            SizedBox(height: 16.h),
                            // Upload Documents header
                            Text(
                              'Upload Documents',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff1e232c),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            // Visiting Card
                            Text(
                              'Visiting Card',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13.0.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff8390a1),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            InkWell(
                              onTap: () => _bsPickImage(
                                  isVisitingCard: true,
                                  setModalState: setModalState),
                              child: Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffe8ecf4), width: 2),
                                  color: const Color(0xfff7f8f9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _bsVisitingCardImage != null
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              _bsVisitingCardImage!,
                                              height: 120.h,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setModalState(() {
                                                  _bsVisitingCardImage = null;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                              Icons.cloud_upload_outlined,
                                              color: Color(0xff8390a1),
                                              size: 28),
                                          SizedBox(width: 10.w),
                                          Text(
                                            'Tap to upload visiting card',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 14.0.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff8390a1),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            // Shop Image
                            Text(
                              'Shop Image',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13.0.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff8390a1),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            InkWell(
                              onTap: () => _bsPickImage(
                                  isVisitingCard: false,
                                  setModalState: setModalState),
                              child: Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffe8ecf4), width: 2),
                                  color: const Color(0xfff7f8f9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _bsShopImage != null
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              _bsShopImage!,
                                              height: 120.h,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setModalState(() {
                                                  _bsShopImage = null;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                              Icons.cloud_upload_outlined,
                                              color: Color(0xff8390a1),
                                              size: 28),
                                          SizedBox(width: 10.w),
                                          Text(
                                            'Tap to upload shop image',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 14.0.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff8390a1),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Submit button
                  Container(
                    padding: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: bsLoading
                              ? null
                              : () async {
                                  if (bsFormKey.currentState!.validate()) {
                                    bsFormKey.currentState!.save();
                                    setModalState(() => bsLoading = true);

                                    try {
                                      var authModel = Provider.of<AuthModel>(
                                          context,
                                          listen: false);

                                      // Upload documents
                                      if (userId.isNotEmpty &&
                                          (_bsVisitingCardImage != null ||
                                              _bsShopImage != null)) {
                                        await authModel
                                            .uploadWholesalerDocuments(
                                          userId: userId,
                                          visitingCardImage:
                                              _bsVisitingCardImage,
                                          shopImage: _bsShopImage,
                                        );
                                      }

                                      // Update user with business details
                                      if (userId.isNotEmpty) {
                                        final updateRes =
                                            await authModel.updateUser(
                                          updateUserData: _bsWholesalerData,
                                        );

                                        if (updateRes['success'] != true) {
                                          setModalState(() {
                                            bsLoading = false;
                                            bsErrorMessage = updateRes[
                                                    'message'] ??
                                                'Failed to submit details. Please try again.';
                                          });
                                          return;
                                        }
                                      }

                                      // Close bottom sheet
                                      Navigator.of(bsContext).pop();

                                      // Show pending approval dialog
                                      _showWholesalerPendingDialog();
                                    } catch (e) {
                                      print('Wholesaler request error: $e');
                                      setModalState(() {
                                        bsLoading = false;
                                        bsErrorMessage =
                                            'Failed to submit. Please try again.';
                                      });
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffc9b758),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: bsLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Submit Wholesaler Request',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w600,
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
          },
        );
      },
    );
  }

  Widget _buildBsTextField({
    required String hintText,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    bool obscureText = false,
    bool readOnly = false,
    Widget? suffixIcon,
    TextEditingController? controller,
    String? initialValue,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      readOnly: readOnly,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: _bsInputDecoration(
          hintText: hintText, suffixIcon: suffixIcon, readOnly: readOnly),
      style: MyGoogleFontStyle(
        fontFamily: 'Urbanist',
        fontSize: 14.0.sp,
        fontWeight: FontWeight.w500,
        height: 1.25,
        color: readOnly ? const Color(0xff8390a1) : const Color(0xff000000),
      ),
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }

  InputDecoration _bsInputDecoration(
      {required String hintText, Widget? suffixIcon, bool readOnly = false}) {
    return InputDecoration(
      filled: true,
      fillColor: readOnly ? const Color(0xffeef0f2) : const Color(0xfff7f8f9),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xffe8ecf4)),
        borderRadius: BorderRadius.circular(7.66),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xffe8ecf4)),
        borderRadius: BorderRadius.circular(7.66),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(7.66),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(7.66),
      ),
      contentPadding: EdgeInsets.fromLTRB(17.94.w, 16.34.w, 17.94.w, 17.66.w),
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xff8390a1)),
      counterText: '',
      suffixIcon: suffixIcon,
    );
  }
}

String getInitials(String name) {
  if (name.isEmpty) return '';
  final nameParts = name.trim().split(' ').where((part) => part.isNotEmpty);
  return nameParts.map((part) => part[0]).join();
}

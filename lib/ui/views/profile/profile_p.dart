import 'package:aadab/ui/root_p.dart';

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

import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/profile/widgets/photo_picker_w.dart';
import 'package:aadab/ui/views/products/shops_p.dart';
import 'package:aadab/ui/widgets/login_required_popup.dart';
import 'package:badges/badges.dart' as badges;
import 'package:aadab/core/models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const double _bottomNavBarHeight = 90.0;
  static const int _bottomNavIconSize = 23;

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
              icon: Image.asset('assets/images/notification-icon.png',
                  width: _bottomNavIconSize.toDouble(),
                  height: _bottomNavIconSize.toDouble(),
                  color: Color(0xFF909090)),
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
      Navigator.pushNamed(context, '/notificationPage');
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
    final user = configModel.user;

    if (configModel.activeRole == 'Distributor') {
      // Trying to switch to User
      final hasUserRole = user?.roles?.any((r) => r.name == 'User') ?? false;

      if (!hasUserRole) {
        print('Check yes');

        // User doesn't have User role - add it automatically
        // final authService = locator<AuthService>();

        // Show loading
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Become a Customer'),
            content:
                Text('You need to register as a customer to access this mode.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(context, '/registerPage',
                      arguments: {'role': 'User'});
                },
                child: Text('Register'),
              ),
            ],
          ),
        );

        // final result = await authService.addRole(role: 'User');

        // Close loading dialog
        // if (context.mounted) Navigator.pop(context);

        // if (result['success'] == true) {
        //   configModel.switchRole('User');
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Switched to User mode')),
        //   );
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //         content: Text(result['message'] ?? 'Failed to add User role')),
        //   );
        // }
      } else {
        // Has User role, switch
        configModel.switchRole('User');
      }
    } else {
      // Trying to switch to Distributor
      final isDistributorRole =
          user?.roles?.any((r) => r.name == 'Distributor') ?? false;

      if (!isDistributorRole) {
        // Not registered as Distributor - Go to Register
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Become a Distributor'),
            content: Text(
                'You need to register as a distributor to access this mode.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(context, '/registerPage',
                      arguments: {'role': 'Distributor'});
                },
                child: Text('Register'),
              ),
            ],
          ),
        );
      } else {
        // Has role, check approval
        if (user?.isApproved == 1) {
          configModel.switchRole('Distributor');
        } else if (user?.isApproved == 0 || user?.isApproved == null) {
          // Pending
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Approval Pending'),
                    content: Text(
                        'Your distributor account is pending approval from admin.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('OK'),
                      )
                    ],
                  ));
        } else {
          // Rejected or others (2 usually means rejected/blocked)
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Account Blocked/Rejected'),
                    content: Text(
                        'Your distributor account has been rejected or blocked. Please contact admin.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('OK'),
                      )
                    ],
                  ));
        }
      }
    }
  }
}

String getInitials(String name) {
  if (name.isEmpty) return '';
  final nameParts = name.trim().split(' ').where((part) => part.isNotEmpty);
  return nameParts.map((part) => part[0]).join();
}

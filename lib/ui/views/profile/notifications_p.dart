import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/notification_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/profile/orders_p.dart';
import 'package:badges/badges.dart' as badges;
import 'package:aadab/ui/widgets/login_required_popup.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/views/products/shops_p.dart';
import 'package:aadab/ui/views/checkout/cart_p.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotifications();
    });
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Provider.of<NotificationModel>(context, listen: false)
          .getMyNotifications();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load notifications. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel _configModel = locator<ConfigModel>();
    final AddToCartModel _addToCartModel =
        Provider.of<AddToCartModel>(context, listen: false);

    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(context, _configModel,
          _addToCartModel, _addToCartModel.addToCarts?.length ?? 0),
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFEED056)),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Loading Notifications...',
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
              : _errorMessage != null
                  ? SizedBox(
                      height: 1.0.sh,
                      width: 1.0.sw,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchNotifications,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFEED056),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchNotifications,
                      color: Color(0xFFEED056),
                      child: SizedBox(
                        width: 1.0.sw,
                        height: 1.0.sh,
                        child: Column(
                          children: [
                            // Header
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0.w, vertical: 16.0.w),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      padding: EdgeInsets.all(8.0.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFFEED056)
                                                .withOpacity(0.15),
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
                                    child: Center(
                                      child: Text(
                                        'Notifications',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 20.0.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff1e232c),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: 48.0.w), // Balance for back button
                                ],
                              ),
                            ),
                            // Notification List
                            Expanded(
                              child: Consumer<NotificationModel>(
                                builder: (context, notificationModel, child) {
                                  final notifications =
                                      notificationModel.notifications;
                                  if (notifications == null ||
                                      notifications.isEmpty) {
                                    return SizedBox(
                                      height: 1.0.sh * 0.5,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.notifications_off,
                                              size: 48.0.w,
                                              color: const Color(0xff909090),
                                            ),
                                            SizedBox(height: 16.0.w),
                                            Text(
                                              'No notifications found',
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Urbanist',
                                                fontSize: 16.0.sp,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff909090),
                                              ),
                                            ),
                                            SizedBox(height: 8.0.w),
                                            Text(
                                              'You\'ll see notifications here when there\'s an update',
                                              textAlign: TextAlign.center,
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Urbanist',
                                                fontSize: 12.0.sp,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xffB0B0B0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return ListView.separated(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25.0.w, vertical: 8.0.w),
                                    itemCount: notifications.length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 12.0.w),
                                    itemBuilder: (context, index) {
                                      final notification = notifications[index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => OrdersPage(
                                                isProfile: {'isProfile': false},
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(12.0.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12.0.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                notification.title ??
                                                    'Notification',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14.0.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      const Color(0xff232323),
                                                ),
                                              ),
                                              SizedBox(height: 4.0.w),
                                              Text(
                                                notification.details ??
                                                    'No details available',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12.0.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      const Color(0xff909090),
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    ConfigModel configModel,
    AddToCartModel addToCartModel,
    int cartCount,
  ) {
    const double _bottomNavBarHeight = 90.0;
    const double _bottomNavIconSize = 24.0;
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
          currentIndex: 4, // Set 'Notifs' as active (Index 4)
          selectedLabelStyle: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500,
          ),
          onTap: (value) =>
              _handleBottomNavTap(context, value, configModel, addToCartModel),
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Image.asset('assets/images/home-icon.png',
                  width: _bottomNavIconSize,
                  height: _bottomNavIconSize,
                  color: Color(0xFF909090)), // Explicitly grey
            ),
            BottomNavigationBarItem(
              label: 'Category',
              icon: Image.asset('assets/images/category-icon.png',
                  width: _bottomNavIconSize,
                  height: _bottomNavIconSize,
                  color: Color(0xFF909090)), // Explicitly grey
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
                    width: _bottomNavIconSize,
                    height: _bottomNavIconSize,
                    color: Color(0xFF909090)), // Explicitly grey
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Image.asset('assets/images/user-profile-icon.png',
                  width: _bottomNavIconSize,
                  height: _bottomNavIconSize,
                  color: Color(0xFF909090)), // Explicitly grey
            ),
            BottomNavigationBarItem(
              label: 'Notifs',
              icon: Image.asset('assets/images/notification-icon.png',
                  width: _bottomNavIconSize,
                  height: _bottomNavIconSize,
                  color: Color(0xFFEED056)), // Explicitly active (Yellow)
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
      Navigator.pushNamed(context, '/profilePage');
    } else if (value == 4) {
      // Already on Notification Page
    } else {
      showDialog(
          context: context, builder: (context) => LoginRequiredPopupWidget());
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/notification_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/profile/orders_p.dart';

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
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? SizedBox(
                height: 1.0.sh,
                width: 1.0.sw,
                child: const Center(child: CircularProgressIndicator()),
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
                          SizedBox(height: 16.0.w),
                          ElevatedButton(
                            onPressed: _fetchNotifications,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchNotifications,
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
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    size: 18.0.sp,
                                    color: const Color(0xffEED056),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'Notifications',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 18.0.sp,
                                        fontWeight: FontWeight.bold,
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
                                              color:
                                                  Colors.black.withOpacity(0.1),
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
                                                color: const Color(0xff232323),
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
                                                color: const Color(0xff909090),
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
    );
  }
}

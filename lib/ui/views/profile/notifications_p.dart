import 'package:flutter/material.dart';
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
      await context.read<NotificationModel>().getMyNotifications();
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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseWidth = 360;
    final double fem = screenWidth / baseWidth;
    final double ffem = fem * 0.97;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? SizedBox(
                height: screenHeight,
                width: screenWidth,
                child: const Center(child: CircularProgressIndicator()),
              )
            : _errorMessage != null
                ? SizedBox(
                    height: screenHeight,
                    width: screenWidth,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 16 * fem),
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
                      width: screenWidth,
                      height: screenHeight,
                      child: Column(
                        children: [
                          // Header
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20 * fem, vertical: 16 * fem),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    size: 18 * ffem,
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
                                        fontSize: 18 * ffem,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff1e232c),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: 48 * fem), // Balance for back button
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
                                    height: screenHeight * 0.5,
                                    child: const Center(
                                        child:
                                            Text('No notifications available')),
                                  );
                                }
                                return ListView.separated(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25 * fem, vertical: 8 * fem),
                                  itemCount: notifications.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 12 * fem),
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
                                        padding: EdgeInsets.all(12 * fem),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12 * fem),
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
                                                fontSize: 14 * ffem,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff232323),
                                              ),
                                            ),
                                            SizedBox(height: 4 * fem),
                                            Text(
                                              notification.details ??
                                                  'No details available',
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12 * ffem,
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

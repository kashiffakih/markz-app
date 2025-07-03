// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:aadab/core/providers/notification_pr.dart';
// import 'package:aadab/ui/shared/font_sh.dart';
// import 'package:aadab/ui/views/auth/splash_p.dart';
// import 'package:aadab/ui/views/profile/orders_p.dart';

// class NotificationsPage extends StatefulWidget {
//   const NotificationsPage({Key? key}) : super(key: key);

//   @override
//   State<NotificationsPage> createState() => _NotificationsPageState();
// }

// class _NotificationsPageState extends State<NotificationsPage> {
//   void initState() {
//     super.initState();
//     Provider.of<NotificationModel>(context, listen: false).getMyNotifications();
//   }

//   TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final _notificationModel =
//         Provider.of<NotificationModel>(context, listen: false);
//     // print(_notificationModel.notifications![0].id);
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             child: Column(
//               children: [
//                 // Title
//                 Container(
//                   margin: EdgeInsets.all(20),
//                   width: double.infinity,
//                   child: Column(
//                     // crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         // mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: Container(
//                                 width: 15,
//                                 height: 15,
//                                 child: Icon(
//                                   Icons.arrow_back_ios,
//                                   size: 18,
//                                   color: Color(0xffEED056),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 100),
//                           InkWell(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Center(
//                               child: Text(
//                                 'Notifications',
//                                 style: MyGoogleFontStyle(
//                                   fontFamily: 'Urbanist',
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xff1e232c),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Body
//                 Container(
//                   height: MediaQuery.of(context).size.height,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         left: 25,
//                         top: 0,
//                         child: SingleChildScrollView(
//                           child: Container(
//                             width: MediaQuery.of(context).size.width - 50,
//                             height: MediaQuery.of(context).size.height - 100,
//                             child: _notificationModel.notificationLoader !=
//                                     false
//                                 ? SplashPage()
//                                 : ListView.builder(
//                                     itemCount: _notificationModel
//                                         .notifications!.length,
//                                     itemBuilder:
//                                         (BuildContext context, index) =>
//                                             InkWell(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => OrdersPage(),
//                                           ),
//                                         );
//                                       },
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 margin: EdgeInsets.fromLTRB(
//                                                     0, 0, 18, 0),
//                                                 child: Image.asset(
//                                                   'assets/images/mask-group-HvE.png',
//                                                   width: 100,
//                                                   height: 100,
//                                                 ),
//                                               ),
//                                               Container(
//                                                 width: MediaQuery.of(context)
//                                                         .size
//                                                         .width -
//                                                     180,
//                                                 child: Column(
//                                                   children: [
//                                                     Align(
//                                                       alignment:
//                                                           Alignment.centerLeft,
//                                                       child: Text(
//                                                         _notificationModel
//                                                             .notifications![
//                                                                 index]
//                                                             .title
//                                                             .toString(),
//                                                         style:
//                                                             MyGoogleFontStyle(
//                                                           fontFamily: 'Poppins',
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           color:
//                                                               Color(0xff232323),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         Expanded(
//                                                           child: Text(
//                                                             _notificationModel
//                                                                 .notifications![
//                                                                     index]
//                                                                 .details
//                                                                 .toString(),
//                                                             style:
//                                                                 MyGoogleFontStyle(
//                                                               fontFamily:
//                                                                   'Poppins',
//                                                               fontSize: 12,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w400,
//                                                               color: Color(
//                                                                   0xff909090),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width -
//                                                 50,
//                                             child: Divider(
//                                               thickness: 2,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/notification_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/auth/splash_p.dart';
import 'package:aadab/ui/views/profile/orders_p.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    // Schedule notification fetching after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationModel>(context, listen: false)
          .getMyNotifications();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                      color: Color(0xffEED056),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Notifications',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff1e232c),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance for back button
                ],
              ),
            ),
            // Notification List
            Expanded(
              child: Consumer<NotificationModel>(
                builder: (context, notificationModel, child) {
                  if (notificationModel.notificationLoader) {
                    return SplashPage();
                  }
                  if (notificationModel.notifications?.isEmpty ?? true) {
                    return const Center(
                      child: Text('No notifications available'),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    itemCount: notificationModel.notifications!.length,
                    separatorBuilder: (context, index) => const Divider(
                      thickness: 1,
                      color: Colors.black12,
                      height: 20,
                    ),
                    itemBuilder: (context, index) {
                      final notification =
                          notificationModel.notifications![index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrdersPage(isProfile: {'isProfile': false}),
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image.asset(
                            //   'assets/images/mask-group-HvE.png',
                            //   width: 100,
                            //   height: 100,
                            //   fit: BoxFit.cover,
                            // ),
                            // const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.title ?? '',
                                    style: MyGoogleFontStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff232323),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification.details ?? '',
                                    style: MyGoogleFontStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff909090),
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    );
  }
}

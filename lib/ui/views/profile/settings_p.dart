import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/user_wallet_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/profile/setting_id.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ConfigModel _configModel = locator<ConfigModel>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/profilePage');

        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  // Title
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                            color: Color(0xffEED056),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/profilePage');
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Settings',
                            textAlign: TextAlign.center,
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff1e232c),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  // Body
                  Container(
                    height: 600,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 25,
                          top: 0,
                          child: Container(
                            width: 1.0.sw - 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Personal information
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Personal information',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff909090),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SettingUpdatePage(
                                                        arguments: {
                                                          'user':
                                                              _configModel.user!
                                                        })));
                                      },
                                      child: Image.asset(
                                        'assets/images/edit-2-mP4.png',
                                        width: 15.34,
                                        height: 19.15,
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  width: 1.0.sw - 50,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffc7b456)),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff232323),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        _configModel.user!.firstName.toString(),
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff909090),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1.0.sw - 50,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffc7b456)),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Email',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff232323),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        _configModel.user!.email.toString(),
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff909090),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1.0.sw - 50,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffc7b456)),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Phone',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff232323),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        _configModel.user!.phone.toString(),
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff909090),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1.0.sw - 50,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffc7b456)),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Referral Code',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff232323),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        _configModel.user!.referralCode != null
                                            ? _configModel.user!.referralCode
                                                .toString()
                                            : '',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff909090),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_configModel.user?.referedById == null ||
                                    _configModel.user?.referedById! == '' ||
                                    _configModel.user?.referedById == 'null')
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .stretch, // Ensures full width
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            'Redeem Referral Code',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all<
                                                          Color>(
                                                      Color.fromARGB(
                                                          255, 67, 67, 243))),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                TextEditingController
                                                    referralCodeController =
                                                    TextEditingController();

                                                return AlertDialog(
                                                  title: const Text(
                                                    'Redeem Referral Code',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            referralCodeController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Enter Referral Code',
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context); // Close the dialog
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        String referralCode =
                                                            referralCodeController
                                                                .text;
                                                        if (referralCode
                                                            .isNotEmpty) {
                                                          // Show loading indicator
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              );
                                                            },
                                                          );

                                                          try {
                                                            Map<String, dynamic>
                                                                response =
                                                                await Provider.of<
                                                                            UserWalletModel>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .mapRedeemReferralCode(
                                                                        referralCode);

                                                            // Close loading indicator
                                                            Navigator.pop(
                                                                context);
                                                            // Close the referral dialog
                                                            Navigator.pop(
                                                                context);

                                                            // Show appropriate message based on response
                                                            _showReferralResponseDialog(
                                                                context,
                                                                response);
                                                          } catch (e) {
                                                            // Close loading indicator
                                                            Navigator.pop(
                                                                context);
                                                            // Show error message
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    'An error occurred. Please try again.'),
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                            );
                                                          }
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Please enter a valid referral code')),
                                                          );
                                                        }
                                                      },
                                                      child:
                                                          const Text('Redeem'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: const Text(
                                            'Redeem',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Notifications
                                // Row(
                                //   children: [
                                //     Expanded(
                                //       child: Text(
                                //         'Notifications',
                                //         style: MyGoogleFontStyle(
                                //           fontFamily: 'Urbanist',
                                //           fontWeight: FontWeight.w700,
                                //           color: Color(0xff909090),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Container(
                                //   width: 1.0.sw - 50,
                                //   margin: EdgeInsets.only(top: 10, bottom: 10),
                                //   padding: EdgeInsets.all(10),
                                //   decoration: BoxDecoration(
                                //     border: Border.all(color: Color(0xffc7b456)),
                                //     color: Color(0xffffffff),
                                //     borderRadius: BorderRadius.all(
                                //       Radius.circular(5),
                                //     ),
                                //     boxShadow: [
                                //       BoxShadow(
                                //         color: Color(0x338a959e),
                                //         offset: Offset(0, 7.6690645218),
                                //         blurRadius: 19.1726608276,
                                //       ),
                                //     ],
                                //   ),
                                //   child: Row(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Text(
                                //         'New arrivals',
                                //         style: MyGoogleFontStyle(
                                //           fontFamily: 'Urbanist',
                                //           fontWeight: FontWeight.w700,
                                //           color: Color(0xff232323),
                                //         ),
                                //       ),
                                //       Expanded(
                                //         child: Container(
                                //           child: Text(
                                //             'Icon',
                                //             textAlign: TextAlign.end,
                                //             style: MyGoogleFontStyle(
                                //               fontFamily: 'Urbanist',
                                //               fontWeight: FontWeight.w700,
                                //               color: Color(0xff232323),
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        )
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
      ),
    );
  }

  // Show referral response dialog with appropriate styling
  void _showReferralResponseDialog(
      BuildContext context, Map<String, dynamic> response) {
    bool isSuccess = response['success'] == true;
    String errorType = response['error'] ?? '';

    Color backgroundColor;
    IconData iconData;
    String title;
    String message = response['message'] ?? 'Unknown error occurred';

    // Determine dialog style based on response type
    if (isSuccess) {
      backgroundColor = const Color(0xFF4CAF50);
      iconData = Icons.check_circle;
      title = 'Success!';
    } else if (errorType == 'SELF_REFERRAL_NOT_ALLOWED') {
      backgroundColor = const Color(0xFFFF9800);
      iconData = Icons.warning;
      title = 'Cannot Use Own Code';
    } else if (errorType == 'REFERRAL_ALREADY_USED') {
      backgroundColor = const Color(0xFFFF9800);
      iconData = Icons.info;
      title = 'Already Used';
    } else if (errorType == 'INVALID_REFERRAL_CODE') {
      backgroundColor = const Color(0xFFFF5252);
      iconData = Icons.error;
      title = 'Invalid Code';
    } else {
      backgroundColor = const Color(0xFFFF5252);
      iconData = Icons.error;
      title = 'Error';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    iconData,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Message
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Action Button
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // If successful, refresh the wallet data
                      if (isSuccess) {
                        Provider.of<UserWalletModel>(context, listen: false)
                            .getMyUserWallets();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isSuccess ? 'Great!' : 'OK',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

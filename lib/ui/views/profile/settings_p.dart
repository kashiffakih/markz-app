import 'package:flutter/material.dart';
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                // Title
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 15,
                              height: 15,
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                                color: Color(0xffEED056),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Center(
                                child: Text(
                                  'Settings',
                                  textAlign: TextAlign.center,
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff1e232c),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
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
                          width: MediaQuery.of(context).size.width - 50,
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
                                                  SettingUpdatePage(arguments: {
                                                    'user': _configModel.user!
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
                                width: MediaQuery.of(context).size.width - 50,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                width: MediaQuery.of(context).size.width - 50,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                width: MediaQuery.of(context).size.width - 50,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                width: MediaQuery.of(context).size.width - 50,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                WidgetStateProperty.all<Color>(
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
                                                    child: const Text('Cancel'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      String referralCode =
                                                          referralCodeController
                                                              .text;
                                                      if (referralCode
                                                          .isNotEmpty) {
                                                        Provider.of<UserWalletModel>(
                                                                context,
                                                                listen: false)
                                                            .mapRedeemReferralCode(
                                                                referralCode);

                                                        Navigator.pop(
                                                            context); // Close the dialog
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  'Referral Code Redeemed: $referralCode')),
                                                        );
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
                                                    child: const Text('Redeem'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text(
                                          'Redeem',
                                          style: TextStyle(color: Colors.white),
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
                              //   width: MediaQuery.of(context).size.width - 50,
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/profile/setting_id.dart';

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
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/profilePage');
                        },
                        child: Center(
                          child: Text(
                            'Setting',
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
                      const SizedBox(height: 15),
                      // Row(
                      //   children: [
                      //     Container(
                      //       width: 15,
                      //       height: 15,
                      //       child: Icon(
                      //         Icons.arrow_back_ios,
                      //         size: 18,
                      //         color: Color(0xffEED056),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 15),
                      //     Container(
                      //       width: 258,
                      //       height: 38,
                      //       padding: const EdgeInsets.only(
                      //         top: 8,
                      //         left: 21,
                      //         right: 20.70,
                      //         bottom: 7.70,
                      //       ),
                      //       clipBehavior: Clip.antiAlias,
                      //       decoration: ShapeDecoration(
                      //         shape: RoundedRectangleBorder(
                      //           side: BorderSide(
                      //               width: 0.50, color: Color(0xFFC7B456)),
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //       ),
                      //       child: Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             'Search',
                      //             style: TextStyle(
                      //               color: Colors.black
                      //                   .withOpacity(0.6000000238418579),
                      //               fontSize: 18,
                      //               fontFamily: 'Urbanist',
                      //               fontWeight: FontWeight.w600,
                      //               height: 0,
                      //               letterSpacing: -0.36,
                      //             ),
                      //           ),
                      //           const SizedBox(width: 139),
                      //           Container(
                      //             width: 10.30,
                      //             // height: 20.30,
                      //             child: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 Icon(
                      //                   Icons.search_rounded,
                      //                   size: 20,
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     )
                      //   ],
                      // )
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
                          const SizedBox(width: 15),
                          Container(
                            width: 258,
                            height: 38,
                            padding: const EdgeInsets.only(
                              left: 21,
                              right: 20.70,
                            ),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.50, color: Color(0xFFC7B456)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Center vertically
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Search',
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 18,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w600,
                                        // letterSpacing: -0.36,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    'assets/images/Search-1.png',
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 20,
                            height: 20,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // Center vertically
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/filter.png',
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                              ],
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
                              // Notifications
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Notifications',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                  ),
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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'New arrivals',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          'Icon',
                                          textAlign: TextAlign.end,
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff232323),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:aadab/core/providers/config_pr.dart';
// import 'package:aadab/core/providers/product_pr.dart';
// import 'package:aadab/locator.dart';
// import 'package:aadab/ui/shared/font_sh.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ContactPage extends StatefulWidget {
//   const ContactPage({Key? key}) : super(key: key);

//   @override
//   State<ContactPage> createState() => _ContactPageState();
// }

// class _ContactPageState extends State<ContactPage> {
//   @override
//   void initState() {
//     Provider.of<ProductModel>(context, listen: false).getBanners();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ConfigModel _configModel = locator<ConfigModel>();
//     // final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
//     final ProductModel _productModel =
//         Provider.of<ProductModel>(context, listen: false);
//     print(_productModel.banners!['email']);
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             child: Column(
//               children: [
//                 // Title
//                 Container(
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                   width: double.infinity,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         icon: const Icon(
//                           Icons.arrow_back_ios,
//                           size: 18,
//                           color: Color(0xffEED056),
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                       Expanded(
//                         child: Text(
//                           'Contact Us',
//                           textAlign: TextAlign.center,
//                           style: MyGoogleFontStyle(
//                             fontFamily: 'Urbanist',
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: const Color(0xff1e232c),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 48),
//                     ],
//                   ),
//                 ),
//                 // Body
//                 Container(
//                   margin: EdgeInsets.all(10),
//                   child: Column(
//                     children: [
//                       // Email
//                       InkWell(
//                         onTap: () async {
//                           String email = Uri.encodeComponent(
//                               _productModel.banners!['email'].toString());
//                           String subject = Uri.encodeComponent("Hello Aadab");
//                           String body = Uri.encodeComponent(
//                               "Hello! I would like to order a delicious cake.");
//                           print(subject); //output: Hello%20Flutter
//                           Uri mail =
//                               Uri.parse("mailto:$email?subject=$subject");
//                           if (await launchUrl(mail)) {
//                             //email app opened
//                           } else {
//                             //email app is not opened
//                           }
//                         },
//                         child: Container(
//                           margin: EdgeInsets.only(top: 10, bottom: 10),
//                           padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Color(0xffc7b456)),
//                             color: Color(0xffffffff),
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(5),
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Color(0x338a959e),
//                                 offset: Offset(0, 7.6690645218),
//                                 blurRadius: 19.1726608276,
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.fromLTRB(0, 0, 18, 0),
//                                 padding: EdgeInsets.fromLTRB(4, 5, 4, 5),
//                                 decoration: BoxDecoration(
//                                   color: Color(0xfffbfbfb),
//                                   borderRadius: BorderRadius.circular(10),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(0x3f000000),
//                                       offset: Offset(0, 4),
//                                       blurRadius: 2,
//                                     ),
//                                   ],
//                                 ),
//                                 child: Center(
//                                   child: SizedBox(
//                                     width: 32,
//                                     height: 30,
//                                     child: Image.asset(
//                                       'assets/images/image-25.png',
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Email',
//                                       style: MyGoogleFontStyle(
//                                         fontFamily: 'Urbanist',
//                                         fontWeight: FontWeight.w700,
//                                         color: Color(0xff232323),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       _productModel.banners!['email'] ?? '',
//                                       style: MyGoogleFontStyle(
//                                         fontFamily: 'Urbanist',
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w400,
//                                         color: Color(0xff232323),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // Whatsapp
//                       InkWell(
//                         onTap: () async {
//                           // final message =
//                           //     'Hello! I would like to order a delicious cake.';
//                           final phone =
//                               _productModel.banners!['phone'].toString();
//                           var whatsappUrl = "whatsapp://send?phone=${phone}";
//                           try {
//                             launch(whatsappUrl);
//                           } catch (e) {
//                             //To handle error and display error message
//                             // Helper.errorSnackBar(
//                             //     context: context,
//                             //     message: "Unable to open whatsapp");
//                           }
//                         },
//                         child: Container(
//                           margin: EdgeInsets.only(top: 10, bottom: 10),
//                           padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Color(0xffc7b456)),
//                             color: Color(0xffffffff),
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(5),
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Color(0x338a959e),
//                                 offset: Offset(0, 7.6690645218),
//                                 blurRadius: 19.1726608276,
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.fromLTRB(0, 0, 18, 0),
//                                 padding: EdgeInsets.fromLTRB(4, 5, 4, 5),
//                                 decoration: BoxDecoration(
//                                   color: Color(0xfffbfbfb),
//                                   borderRadius: BorderRadius.circular(10),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(0x3f000000),
//                                       offset: Offset(0, 4),
//                                       blurRadius: 2,
//                                     ),
//                                   ],
//                                 ),
//                                 child: Center(
//                                   child: SizedBox(
//                                     width: 32,
//                                     height: 30,
//                                     child: Image.asset(
//                                       'assets/images/image-26.png',
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Whatsapp',
//                                       style: MyGoogleFontStyle(
//                                         fontFamily: 'Urbanist',
//                                         fontWeight: FontWeight.w700,
//                                         color: Color(0xff232323),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       _productModel.banners!['phone'] ?? '',
//                                       style: MyGoogleFontStyle(
//                                         fontFamily: 'Urbanist',
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w400,
//                                         color: Color(0xff232323),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () async {
//                           String number =
//                               _productModel.banners!['phone'].toString();
//                           final Uri phoneUri = Uri(scheme: 'tel', path: number);
//                           if (await canLaunch(phoneUri.toString())) {
//                             await launch(phoneUri.toString());
//                           } else {
//                             throw 'Could not launch $number';
//                           }
//                         },
//                         child: Container(
//                           margin: EdgeInsets.only(top: 10, bottom: 10),
//                           padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Color(0xffc7b456)),
//                             color: Color(0xffffffff),
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(5),
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Color(0x338a959e),
//                                 offset: Offset(0, 7.6690645218),
//                                 blurRadius: 19.1726608276,
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.fromLTRB(0, 0, 18, 0),
//                                 padding: EdgeInsets.fromLTRB(4, 5, 4, 5),
//                                 decoration: BoxDecoration(
//                                   color: Color(0xfffbfbfb),
//                                   borderRadius: BorderRadius.circular(10),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(0x3f000000),
//                                       offset: Offset(0, 4),
//                                       blurRadius: 2,
//                                     ),
//                                   ],
//                                 ),
//                                 child: Center(
//                                   child: SizedBox(
//                                     width: 32,
//                                     height: 30,
//                                     child: Icon(
//                                       Icons.phone,
//                                       size: 25,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Call Us',
//                                       style: MyGoogleFontStyle(
//                                         fontFamily: 'Urbanist',
//                                         fontWeight: FontWeight.w700,
//                                         color: Color(0xff232323),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       _productModel.banners!['phone'] ?? '',
//                                       style: MyGoogleFontStyle(
//                                         fontFamily: 'Urbanist',
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w400,
//                                         color: Color(0xff232323),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//       // bottomNavigationBar: BottomNavigationBar(
//       //   elevation: 10,
//       //   iconSize: 30,
//       //   type: BottomNavigationBarType.fixed,
//       //   backgroundColor: Colors.white,
//       //   selectedItemColor: Colors.black,
//       //   unselectedItemColor: Colors.black,
//       //   selectedFontSize: 14,
//       //   unselectedFontSize: 14,
//       //   onTap: (value) async {
//       //     if (value == 0) {
//       //       Navigator.pushNamed(context, '/homePage');
//       //     }
//       //     if (value == 1) {
//       //       Navigator.pushNamed(context, '/wishlistPage');
//       //     }

//       //     if (value == 2) {
//       //       Map<String, dynamic> _CartData = {
//       //         'kindOfFlower': '',
//       //         'flavour': '',
//       //         'writeOnCake': '',
//       //         'pack': ''
//       //       };
//       //       await _addToCartModel.getAddToCart('', '', _CartData);
//       //       Navigator.pushNamed(context, '/cartPage');
//       //     }
//       //     if (value == 3) {
//       //       Navigator.pushNamed(context, '/profilePage');
//       //     }
//       //   },
//       //   items: const [
//       //     BottomNavigationBarItem(
//       //       label: 'Home',
//       //       icon: Iconoir(Iconoir.home_simple),
//       //       // icon: Icon(DonIcons.wap_home, size: 23),
//       //     ),
//       //     BottomNavigationBarItem(label: 'Saved', icon: Iconoir(Iconoir.heart)),
//       //     BottomNavigationBarItem(
//       //       label: 'Cart',
//       //       icon: Iconoir(Iconoir.shopping_bag),
//       //     ),
//       //     BottomNavigationBarItem(
//       //       label: 'Profile',
//       //       icon: Icon(
//       //         DonIcons.user_o,
//       //         size: 23,
//       //       ),
//       //     ),
//       //   ],
//       // ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<ProductModel>(context, listen: false).getBanners();
    } catch (e) {
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to load contact information: $e')),
        // );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context, listen: false);
    final double fem = MediaQuery.of(context).size.width / 360;
    final double ffem = fem * 0.97;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      _buildHeader(context, fem, ffem),
                      _buildBody(context, productModel, fem, ffem),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double fem, double ffem) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30 * fem, vertical: 10 * fem),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18 * fem,
              color: const Color(0xffEED056),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Contact Us',
              textAlign: TextAlign.center,
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 18 * ffem,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
          SizedBox(width: 48 * fem),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductModel productModel, double fem,
      double ffem) {
    return Container(
      margin: EdgeInsets.all(10 * fem),
      child: Column(
        children: [
          _buildContactItem(
            context: context,
            title: 'Email',
            subtitle: productModel.banners?['email']?.toString() ??
                'No email available',
            icon: Icons.email,
            onTap: () async {
              final email = productModel.banners?['email']?.toString() ?? '';
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email address not available')),
                );
                return;
              }
              final emailUri = Uri(
                scheme: 'mailto',
                path: email,
                query: 'subject=${Uri.encodeComponent("Hello Aadab")}',
              );
              try {
                if (!await launchUrl(emailUri)) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open email app')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to open email: $e')),
                  );
                }
              }
            },
            fem: fem,
            ffem: ffem,
          ),
          _buildContactItem(
            context: context,
            title: 'WhatsApp',
            subtitle: productModel.banners?['phone']?.toString() ??
                'No phone number available',
            icon: Icons.message,
            onTap: () async {
              final phone = productModel.banners?['phone']?.toString() ?? '';
              if (phone.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Phone number not available')),
                );
                return;
              }
              final whatsappUri = Uri.parse('whatsapp://send?phone=$phone');
              try {
                if (!await launchUrl(whatsappUri)) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open WhatsApp')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to open WhatsApp: $e')),
                  );
                }
              }
            },
            fem: fem,
            ffem: ffem,
          ),
          _buildContactItem(
            context: context,
            title: 'Call Us',
            subtitle: productModel.banners?['phone']?.toString() ??
                'No phone number available',
            icon: Icons.phone,
            onTap: () async {
              final phone = productModel.banners?['phone']?.toString() ?? '';
              if (phone.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Phone number not available')),
                );
                return;
              }
              final phoneUri = Uri(scheme: 'tel', path: phone);
              try {
                if (!await launchUrl(phoneUri)) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open phone app')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to call: $e')),
                  );
                }
              }
            },
            fem: fem,
            ffem: ffem,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required double fem,
    required double ffem,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10 * fem),
        padding: EdgeInsets.all(10 * fem),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffc7b456)),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5 * fem)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x338a959e),
              offset: Offset(0, 7.6690645218 * fem),
              blurRadius: 19.1726608276 * fem,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 18 * fem),
              padding: EdgeInsets.all(5 * fem),
              decoration: BoxDecoration(
                color: const Color(0xfffbfbfb),
                borderRadius: BorderRadius.circular(10 * fem),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x3f000000),
                    offset: Offset(0, 4 * fem),
                    blurRadius: 2 * fem,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 25 * fem,
                color: const Color(0xff232323),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16 * ffem,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff232323),
                    ),
                  ),
                  SizedBox(height: 5 * fem),
                  Text(
                    subtitle,
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15 * ffem,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff232323),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

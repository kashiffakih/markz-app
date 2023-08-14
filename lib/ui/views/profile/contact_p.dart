import 'package:flutter/material.dart';
import 'package:icon_forest/don_icons.dart';
import 'package:icon_forest/iconoir.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    final ConfigModel _configModel = locator<ConfigModel>();
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20),
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
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                'assets/images/vector-GJ4.png',
                                height: 15,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Contact Us',
                                textAlign: TextAlign.center,
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1e232c),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Email
                      InkWell(
                        onTap: () async {
                          String email = Uri.encodeComponent(
                              _configModel.user.companies![0].email.toString());
                          String subject = Uri.encodeComponent("Hello Flutter");
                          String body =
                              Uri.encodeComponent("Hi! I'm Flutter Developer");
                          print(subject); //output: Hello%20Flutter
                          Uri mail = Uri.parse(
                              "mailto:$email?subject=$subject&body=$body");
                          if (await launchUrl(mail)) {
                            //email app opened
                          } else {
                            //email app is not opened
                          }
                        },
                        child: Container(
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
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 18, 0),
                                padding: EdgeInsets.fromLTRB(4, 5, 4, 5),
                                decoration: BoxDecoration(
                                  color: Color(0xfffbfbfb),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3f000000),
                                      offset: Offset(0, 4),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 32,
                                    height: 30,
                                    child: Image.asset(
                                      'assets/images/image-25.png',
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
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
                                      height: 5,
                                    ),
                                    Text(
                                      _configModel.user.companies![0].email
                                          .toString(),
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Whatsapp
                      InkWell(
                        onTap: () async {
                          final message = 'Hello';
                          final phone =
                              _configModel.user.companies![0].phone.toString();
                          var whatsappUrl =
                              "whatsapp://send?phone=${'+91 ' + phone}" +
                                  "&text=${Uri.encodeComponent(message)}";
                          try {
                            launch(whatsappUrl);
                          } catch (e) {
                            //To handle error and display error message
                            // Helper.errorSnackBar(
                            //     context: context,
                            //     message: "Unable to open whatsapp");
                          }
                        },
                        child: Container(
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
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 18, 0),
                                padding: EdgeInsets.fromLTRB(4, 5, 4, 5),
                                decoration: BoxDecoration(
                                  color: Color(0xfffbfbfb),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3f000000),
                                      offset: Offset(0, 4),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 32,
                                    height: 30,
                                    child: Image.asset(
                                      'assets/images/image-26.png',
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Whatsapp',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _configModel.user.companies![0].phone
                                          .toString(),
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) async {
          if (value == 0) {
            Navigator.pushNamed(context, '/homePage');
          }
          if (value == 1) {
            Navigator.pushNamed(context, '/wishlistPage');
          }

          if (value == 2) {
            Map<String, dynamic> _CartData = {
              'kindOfFlower': '',
              'flavour': '',
              'writeOnCake': '',
              'pack': ''
            };
            await _addToCartModel.getAddToCart('', '', _CartData);
            Navigator.pushNamed(context, '/cartPage');
          }
          if (value == 3) {
            Navigator.pushNamed(context, '/profilePage');
          }
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Iconoir(Iconoir.home_simple),
            // icon: Icon(DonIcons.wap_home, size: 23),
          ),
          BottomNavigationBarItem(label: 'Saved', icon: Iconoir(Iconoir.heart)),
          BottomNavigationBarItem(
            label: 'Cart',
            icon: Iconoir(Iconoir.shopping_bag),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              DonIcons.user_o,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }
}

void launchWhatsApp(String message, phone) async {
  String url = "https://wa.me/${phone}?text=${Uri.parse(message)}";
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

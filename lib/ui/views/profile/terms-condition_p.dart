import 'package:flutter/material.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 1.0,
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
                          Navigator.pushReplacementNamed(context, '/homePage');
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
                                'Terms & Conditions',
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
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('1. '),
                                Text(
                                    'AADAB maintains the \nhttps://aadab.com/ Website (“Site”).'),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('2. '),
                                Text(
                                    '““United Arab of Emirates is our country \nof domicile” and stipulate that the governing \nlaw is the local law. All disputes arising in \nconnection therewith shall be heard \nonly by a court of competent jurisdiction in U.A.E.'),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('3. '),
                                Text(
                                    'Visa or MasterCard debit and credit cards in \nAED will be accepted for payment'),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('4. '),
                                Text(
                                    'We will not trade with or provide any services \nto OFAC and sanctioned countries'),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('5. '),
                                Text(
                                    'Customer using the website who are Minor /\nunder the age of 18 shall not register as a \nUser of the website and shall not transact on \nor use the website'),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('6. '),
                                Text(
                                    'Cardholder must retain a copy of \ntransaction records and Merchant policies \nand rules'),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('7. '),
                                Text(
                                    'User is responsible for maintaining the \nconfidentiality of his account'),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Delivery Policy',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'We use bike / car delivery any place in UAE, we accept same day delivery only in Dubai, Sharjah, Ajman, other UAE city not accept same day order (need order at least one day advance)'),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Delivery Locations',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'We do delivery all over UAE | Dubai, Abu Dhabi, Sharjah, Ajman, Al Ain, Ras Al Khaimah, Fujairah, Umm al Quwain.'),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Delivery Fees',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Delivery to Dubai 30DHSDelivery outside of Dubai 50DHSDelivery for Far areas as Dibba 70DHSFree delivery on 1,000+ orders.'),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Delivery Time Duration',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Free delivery in time period (only for Dubai) from Sunday to Saturday10:00AM-2:00pm2:00pm-5:00pm5:00pm-7:00pm7:00pm-11:00pm'),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Delivery to Sharjah, Ajman',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Free delivery in time period (only for Dubai) from Sunday to Saturday10:00AM-2:00pm2:00pm-5:00pm5:00pm-7:00pm7:00pm-11:00pm'),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Delivery to Abu Dhabi, Al Ain, Ras Al Khaimah, Fujairah, Umm al Quwain',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Delivery time period: 11:00AM-8:00PM (Sunday to Saturday)'),
                            SizedBox(
                              height: 25,
                            ),
                            Center(
                              child: Text('PRIVACY POLICY',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                'This privacy policy sets out how https://aadab.com/ uses and protects any information that you give https://aadab.com/ when you use this website. By using the site, you are accepting the practices described in this privacy policy. These executions may be reshaped, but any alter will be posted and changes will only apply to activities and information on advancement, not retroactive basis. We aggregate the personal information that you provide us, such as when you: Sign up for or register on https://aadab.com/, Register to use https://aadab.com/ or sign up for newsletter of specials or other promotions on https://aadab.com/; Place an order or purchase products or services at our online store or over the phone, Contact us for any reason, such as by replying to inquiries by mail, or through our website’s live chat, by telephone through customer service, or We may automatically collect some information when you visit our website, such as your internet protocol address and operating system, your site browsing and the time and date of your visit and purchases. This information may be collected through the use of “cookies”. Aadab takes appropriate steps to ensure data privacy and security including through various hardware and software methodologies. However, (https://aadab.com/) cannot guarantee the security of any information that is disclosed online. The Website Policies and Terms &amp; Conditions may be changed or updated occasionally to meet the requirements and standards. Therefore, the Customers’ are encouraged to frequently visit these sections to be updated about the changes on the website. Modifications will be effective on the day they are posted.'),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'How we use Cookies',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'We use ‘traffic log’ cookies to identify which pages are being used. Cookies collect information about how you use our website e.g. which pages you visit, and if you experience any errors. These cookies do not collect any information that could identify you all the information collected is anonymous and is only used to help us improve how our website works, understand what interests our users and improve our website in order to tailor it to customer needs. You can choose to accept or decline cookies. Most web browsers automatically accept cookies, but you can usually modify your browser setting to decline cookies if you prefer. This may prevent you from taking full advantage of the website.'),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Data Security',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Your personal data will be retain secure. Only authorized employees, and contractors (who have agreed to keep information safe and confidential) have access to this data. All of credit/debit cards details and personally identifiable Data Won’t Be Saved, sold, shared, Leased or Rented to any third parties. https://aadab.com/ can also disclose personally identifiable information so as to answer a subpoena, court order or other similar request. https://aadab.com/ may also give such personally identifiable information in response to some law enforcement agencies ask or as otherwise required by law. Your personally identifiable information may be offered to a party when https://aadab.com/ files for bankruptcy, or there’s a transfer of their possession or assets of https://aadab.com/ in connection with proposed or consummated corporate reorganizations, like mergers or acquisitions. https://aadab.com/ does not allow to share minor information. https://aadab.com/ does not knowingly distribute personal information regarding minors.'),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Variant Network',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'https://aadab.com/ isn’t liable for the privacy policies of sites to which it connects. If you supply any information to these third parties’ different rules concerning the collection and use of your personal information could employ. We strongly advise you to review these third party’s privacy policies before providing any information to them.'),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Improvement',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'If you would like to alter or improvement any information https://aadab.com/ has obtained, please contact info@ aadab.com'),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Advertisements',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'We use third-party advertising organizations to promote ads when you visit our Website. These companies may use data (not contain your name, address, or contact number) about your visits to this and other websites in order to provide advertisements about goods and services of interest to you.'),
                          ],
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

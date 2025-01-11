import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class RefundPolicyPage extends StatefulWidget {
  const RefundPolicyPage({Key? key}) : super(key: key);

  @override
  State<RefundPolicyPage> createState() => _RefundPolicyPageState();
}

class _RefundPolicyPageState extends State<RefundPolicyPage> {
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
                                'Refund Policy',
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
                  child: Text(
                      'The companies refund policies are applied to only those orders for which a payment has been made to the https://aadab.com/. In order to ensure provision of in-time delivery and quality of bakery items or flowers or any other products listed on our website, we accept only those orders that are possible to process according to the requirements of the customers and in the time allowed. In this regard, we may decline certain orders. Moreover, we also spend lots of time in understanding customers’ orders. This involves working with customers on tasting, designing, researching, matching cake design with venue and ordering materials for the cake or flowers. For these reasons, it is not possible for us to refund any money that customers have deposited at any time. We thank you for your understanding. \n\nIn many instances, for customize orders, we have to make decorative elements beforehand. Generally, these decorative items are made at least 3 to 5 days before the order so that these items can have proper drying and setting time. In this regard, we follow the following cancellation and refund policy.  \n\nIf a customer cancels an order, at least 2 days before the actual delivery of the order, 100 % of the deposited money is returned to the customers; refunds will be made back to the payment solution used initially by the customer. Please allow for up to 45 days for the refund transfer to be completed. \n\nRefunds will be made onto the original mode of payment and will be processed within 10 to 45 days depends on the issuing bank of the credit card. If a customer cancels an order, within 6 hours of the actual delivery of the order, no part of the deposited money is returned to the customers as store credit. There is no exception to this policy and we sincerely apologize you for this. You can still collect your processed order on the promised time and date of delivery and are obliged to pay the balance due to you. \n\nIf because of any reason, customer requests a reschedule of an order, then we will handle this on case-to-case basis. However, such requests are required to be given at least 24 hours before actual delivery. We try our best to accommodate such request, yet it is always depending on the availability of resources and our schedule so there is no guarantee that we will be able to meet the deadline that you award us. A reschedule may require customer to help us in accommodating the customers’ requests.'),
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

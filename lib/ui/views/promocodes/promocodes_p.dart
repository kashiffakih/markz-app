// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:aadab/core/providers/config_pr.dart';
// import 'package:aadab/core/providers/coupon_pr.dart';
// import 'package:aadab/locator.dart';
// import 'package:aadab/ui/shared/font_sh.dart';

// class PromocodesPage extends StatefulWidget {
//   const PromocodesPage({Key? key}) : super(key: key);

//   @override
//   State<PromocodesPage> createState() => _PromocodesPageState();
// }

// class _PromocodesPageState extends State<PromocodesPage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       // Call the verifyCoupon method after the widget is built
//       await Provider.of<CouponModel>(context, listen: false)
//           .verifyCoupon('All');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ConfigModel _configModel = locator<ConfigModel>();
//     final CouponModel _couponModel =
//         Provider.of<CouponModel>(context, listen: false);
//     // print(_couponModel.coupons);
//     DateTime currentDate = DateTime.now();
//     String formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             child: Column(
//               children: [
//                 Container(
//                   margin: EdgeInsets.all(20),
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Row(
//                           children: [
//                             Container(
//                               child: Image.asset(
//                                 'assets/images/vector-GJ4.png',
//                                 height: 15,
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 'Promocodes',
//                                 textAlign: TextAlign.center,
//                                 style: MyGoogleFontStyle(
//                                   fontFamily: 'Urbanist',
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xff1e232c),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Body
//                 _couponModel.coupons == null
//                     ? CircularProgressIndicator()
//                     : Container(
//                         margin: EdgeInsets.all(10),
//                         child: Column(
//                           children: [
//                             ..._couponModel.coupons!.map((coupon) {
//                               // Convert end date string to DateTime object
//                               DateTime endDate = DateFormat('dd-MM-yyyy')
//                                   .parse(coupon.endDate.toString());

//                               // Get current date
//                               DateTime currentDate = DateTime.now();

//                               // Check if coupon is expired
//                               bool isExpired = endDate.isBefore(currentDate);

//                               // Render InkWell if not expired, otherwise render Text widget
//                               return isExpired
//                                   ? Text(
//                                       'Expired',
//                                       style: MyGoogleFontStyle(
//                                         fontFamily: 'Urbanist',
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w400,
//                                         color: Color(0xff232323),
//                                       ),
//                                     )
//                                   : InkWell(
//                                       onTap: () async {
//                                         Navigator.pop(context, coupon.name);
//                                       },
//                                       child: Container(
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         margin: EdgeInsets.only(
//                                             top: 10, bottom: 10),
//                                         padding: EdgeInsets.all(10),
//                                         decoration: BoxDecoration(
//                                           border: Border.all(
//                                               color: Color(0xffc7b456)),
//                                           color: Color(0xffffffff),
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(5),
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Color(0x338a959e),
//                                               offset: Offset(0, 7.6690645218),
//                                               blurRadius: 19.1726608276,
//                                             ),
//                                           ],
//                                         ),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Coupon code: ' +
//                                                   coupon.name.toString(),
//                                               style: MyGoogleFontStyle(
//                                                 fontFamily: 'Urbanist',
//                                                 fontWeight: FontWeight.w700,
//                                                 color: Color(0xff232323),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Text(
//                                               'Minimum order value: Rs ' +
//                                                   coupon.minOrderValue
//                                                       .toString(),
//                                               style: MyGoogleFontStyle(
//                                                 fontFamily: 'Urbanist',
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.w400,
//                                                 color: Color(0xff232323),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Text(
//                                               'Expire on: ' +
//                                                   coupon.endDate.toString(),
//                                               style: MyGoogleFontStyle(
//                                                 fontFamily: 'Urbanist',
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.w400,
//                                                 color: Color(0xff232323),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                             }).toList(),
//                           ],
//                         ),
//                       )
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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/coupon_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class PromocodesPage extends StatefulWidget {
  const PromocodesPage({Key? key}) : super(key: key);

  @override
  State<PromocodesPage> createState() => _PromocodesPageState();
}

class _PromocodesPageState extends State<PromocodesPage> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCoupons();
  }

  Future<void> _fetchCoupons() async {
    try {
      await Provider.of<CouponModel>(context, listen: false)
          .verifyCoupon('All');
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load coupons: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final configModel = locator<ConfigModel>();
    final couponModel = Provider.of<CouponModel>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildBody(context, couponModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/images/vector-GJ4.png',
              height: 15,
            ),
          ),
          Expanded(
            child: Text(
              'Promocodes',
              textAlign: TextAlign.center,
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
          const SizedBox(width: 15), // Balance the layout
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, CouponModel couponModel) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            _errorMessage!,
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (couponModel.coupons == null || couponModel.coupons!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'No coupons available',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xff232323),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: couponModel.coupons!.map((coupon) {
          final endDate = DateFormat('dd-MM-yyyy').parse(coupon.endDate ?? '');
          final isExpired = endDate.isBefore(DateTime.now());

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: isExpired
                ? _buildExpiredCoupon()
                : _buildActiveCoupon(context, coupon),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpiredCoupon() {
    return Text(
      'Expired',
      style: MyGoogleFontStyle(
        fontFamily: 'Urbanist',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: const Color(0xff232323),
      ),
    );
  }

  Widget _buildActiveCoupon(BuildContext context, dynamic coupon) {
    return InkWell(
      onTap: () async {
        bool isProfile = true;
        Navigator.pop(context, {'name': coupon.name, 'isProfile': isProfile});
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffc7b456)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
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
              'Coupon code: ${coupon.name ?? 'N/A'}',
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w700,
                color: const Color(0xff232323),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Minimum order value: Rs ${coupon.minOrderValue?.toString() ?? '0'}',
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color(0xff232323),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Expires on: ${coupon.endDate ?? 'N/A'}',
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color(0xff232323),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

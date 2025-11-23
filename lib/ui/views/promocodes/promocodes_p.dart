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
//                                             1.0.sw,
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/coupon_pr.dart';
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
      margin: EdgeInsets.all(20.0.w),
      width: double.infinity,
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/images/vector-GJ4.png',
              height: 15.0.h,
            ),
          ),
          Expanded(
            child: Text(
              'Promocodes',
              textAlign: TextAlign.center,
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 18.0.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
          SizedBox(width: 15.0.w), // Balance the layout
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
          padding: EdgeInsets.all(20.0.w),
          child: Text(
            _errorMessage!,
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 16.0.sp,
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

    // Filter active coupons
    final activeCoupons = <Widget>[];
    final currentDate = DateTime.now();

    for (var coupon in couponModel.coupons!) {
      try {
        // Parse dates safely
        DateTime? startDate;
        DateTime? endDate;

        if (coupon.startDate != null && coupon.startDate!.isNotEmpty) {
          startDate = DateFormat('dd-MM-yyyy').parse(coupon.startDate!);
        }

        if (coupon.endDate != null && coupon.endDate!.isNotEmpty) {
          endDate = DateFormat('dd-MM-yyyy').parse(coupon.endDate!);
        }

        // Check if coupon is active (current date is between start and end dates)
        bool isActive = true;

        if (startDate != null && currentDate.isBefore(startDate)) {
          isActive = false;
          print(
              'Coupon ${coupon.name} not yet active. Starts on ${coupon.startDate}');
        }

        if (endDate != null && currentDate.isAfter(endDate)) {
          isActive = false;
          print('Coupon ${coupon.name} expired on ${coupon.endDate}');
        }

        // Only add active coupons
        if (isActive) {
          activeCoupons.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _buildActiveCoupon(context, coupon),
            ),
          );
        }
      } catch (e) {
        print('Error parsing coupon dates for ${coupon.name}: $e');
      }
    }

    // Show message if no active coupons
    if (activeCoupons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.local_offer_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No active coupons available',
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff232323),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Check back later for new offers!',
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: activeCoupons,
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
        width: 1.0.sw,
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
            Row(
              children: [
                if (coupon.startDate != null)
                  Text(
                    'Valid from: ${coupon.startDate} | ',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff666666),
                    ),
                  ),
                Text(
                  'Expires on: ${coupon.endDate ?? 'N/A'}',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

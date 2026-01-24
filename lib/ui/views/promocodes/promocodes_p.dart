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
      body: Container(
        width: 1.0.sw,
        height: 1.0.sh,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFEF9), Color(0xFFFFFDF7), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                _buildBody(context, couponModel),
              ],
            ),
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
        height: 120.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: Stack(
          children: [
            Row(
              children: [
                // Left Side (Main Content)
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFEED056).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.local_offer,
                                color: const Color(0xFFC7B456),
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  coupon.type?.toString() == 'Flat'
                                      ? '₹${coupon.value?.toString() ?? '0'} OFF'
                                      : '${coupon.value?.toString() ?? '0'}% OFF',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xff1d1617),
                                  ),
                                ),
                                Text(
                                  'Min Order: ₹${coupon.minOrderValue?.toString() ?? '0'}',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14.sp,
                              color: Colors.grey[400],
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Expires: ${coupon.endDate ?? 'N/A'}',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Divider (Dashed Line)
                Container(
                  width: 1,
                  color: Colors.white,
                  child: Column(
                    children: List.generate(
                      15,
                      (index) => Expanded(
                        child: Container(
                          color: index % 2 == 0
                              ? Colors.grey[300]
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                // Right Side (Action)
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEED056).withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.r),
                        bottomRight: Radius.circular(16.r),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          coupon.name ?? 'CODE',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff1d1617),
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEED056), Color(0xFFC7B456)],
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEED056).withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            'APPLY',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Cutouts
            Positioned(
              top: -10,
              right: 1.0.sw / 3 - 10,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFDF7), // Match background gradient
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              right: 1.0.sw / 3 - 10,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFDF7), // Match background gradient
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

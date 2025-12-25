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
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff1d1617).withOpacity(0.07),
              offset: const Offset(0, 5),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEED056).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    // Icon Container
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEED056), Color(0xFFC7B456)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.percent_rounded,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                coupon.name ?? 'N/A',
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff1d1617),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFEED056).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Apply',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFC4A64C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Coupon Value:${coupon.type?.toString() == 'Flat' ? ' ₹${coupon.value?.toString() ?? '0'}' : ' %${coupon.value?.toString() ?? '0'}'}',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Min Order: ₹${coupon.minOrderValue?.toString() ?? '0'}',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            height: 1,
                            color: Colors.grey[200],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14.sp,
                                color: Colors.grey[500],
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  'Expires: ${coupon.endDate ?? 'N/A'}',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

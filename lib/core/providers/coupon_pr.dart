import 'package:flutter/material.dart';
import 'package:aadab/core/models/coupon.dart';
import 'package:aadab/core/services/coupon_s.dart';
import 'package:aadab/locator.dart';

class CouponModel with ChangeNotifier {
  final CouponService _couponService = locator<CouponService>();

  bool couponLoader = true;

  List<Coupon>? _coupons;

  set coupons(List<Coupon>? newCoupon) {
    _coupons = newCoupon;
    couponLoader = false;
    notifyListeners();
  }

  List<Coupon>? get coupons => _coupons;
  verifyCoupon(coupon) async {
    coupons = await _couponService.verifyCoupon(coupon);
  }
}

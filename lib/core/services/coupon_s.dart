import 'dart:convert';

import 'package:sales_app/core/models/coupon.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;

class CouponService {
  final ConfigModel _configModel = locator<ConfigModel>();
  List<Coupon> _coupons = [];

  Future<List<Coupon>> verifyCoupon(coupon) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var userId = _configModel.user.id;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/company_coupons?search=$coupon'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _coupons = [];
      _responseData['data'].forEach((data) {
        _coupons.add(Coupon.fromJson(data));
      });
    }
    return _coupons;
  }
}

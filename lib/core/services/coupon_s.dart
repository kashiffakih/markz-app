import 'dart:convert';

import 'package:aadab/core/models/coupon.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;

class CouponService {
  final ConfigModel _configModel = locator<ConfigModel>();
  List<Coupon> _coupons = [];

  Future<List<Coupon>> verifyCoupon(coupon) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    print(coupon);
    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/company_coupons'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    // print(_responseData);
    if (_responseData['success']) {
      _coupons = [];
      _responseData['data'].forEach((data) {
        _coupons.add(Coupon.fromJson(data));
      });
    }
    // print('coupon: $_coupons');
    return _coupons;
  }
}

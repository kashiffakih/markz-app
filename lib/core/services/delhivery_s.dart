import 'dart:convert';

import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;

class DelhiveryService {
  final ConfigModel _configModel = locator<ConfigModel>();

  Future<dynamic> checkServiceability(String pincode) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/delhivery/serviceability?pincode=$pincode'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    return _responseData;
  }

  Future<dynamic> calculateShippingCost(
      String pincode, int weight, String paymentMode) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/delhivery/shipping_cost?pincode=$pincode&weight=$weight&payment_mode=$paymentMode'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    print("Delhivery shipping response: $_responseData");
    return _responseData;
  }

  Future<dynamic> trackOrder(int orderId) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/delhivery/track?order_id=$orderId'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    return _responseData;
  }
}

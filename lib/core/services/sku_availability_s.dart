import 'dart:convert';

import 'package:sales_app/core/models/sku_availability.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SkuAvailabilityService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Update SKU Availablity
  updateSkuAvailability(
      {@required Map<String, dynamic>? skuAvailability}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    print(skuAvailability);

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/sku_availabilities'),
      body: json.encode(skuAvailability),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);

    print(_responseData);
  }

  // List of SKU Availabilities
  late List<SkuAvailability> _skuAvailabilities;

  getSkuAvailabilities({@required retailerId}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/sku_availabilities?retailerId=$retailerId'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _skuAvailabilities = [];
      _responseData['data'].forEach((_skuAvailability) {
        _skuAvailabilities.add(SkuAvailability.fromJson(_skuAvailability));
      });
    }

    return _skuAvailabilities;
  }
}

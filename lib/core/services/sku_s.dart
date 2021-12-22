import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sales_app/core/models/sku.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;

class SkuService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Get reference plans
  late List<Sku> _skus;

  Future<List<Sku>> getSkus() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/products/1/skus?userId=${_configModel.user.id}'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);

    if (_responseData['success']) {
      _skus = [];
      _responseData['data'].forEach((_referencePlan) {
        _skus.add(Sku.fromJson(_referencePlan));
      });
    }

    return _skus;
  }
}

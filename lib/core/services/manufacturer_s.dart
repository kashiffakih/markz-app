import 'dart:convert';

import 'package:sales_app/core/models/asset.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;

class ManufacturerService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Manufacturers
  late List<Manufacturer> _manufacturers;

  getManufacturers() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/manufacturers'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _manufacturers = [];
      _responseData['data'].forEach((_manufacturer) {
        _manufacturers.add(Manufacturer.fromJson(_manufacturer));
      });
    }

    return _manufacturers;
  }
}

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sales_app/core/models/asset.dart';
import 'package:sales_app/core/models/asset_status.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/ui/routing/routes.dart';

class AssetService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Get Assets
  late List<Asset> _assets;

  getAssets() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/assets'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _assets = [];
      _responseData['data'].forEach((_notice) {
        _assets.add(Asset.fromJson(_notice));
      });
    }

    return _assets;
  }

  // Create Asset
  assetCreate({@required Asset? asset}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/assets'),
      body: json.encode(asset!.toJson()),
      headers: _apiConfig['headers'],
    );

    // Map<String, dynamic> _responseData = json.decode(_response.body);
  }

  // Update Asset
  assetUpdate({@required Asset? asset}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.patch(
      Uri.parse('${_apiConfig['baseURL']}/assets/${asset!.id}'),
      body: json.encode(asset.toJson()),
      headers: _apiConfig['headers'],
    );

    // Map<String, dynamic> _responseData = json.decode(_response.body);
  }

  // Create Asset Sattus
  assetStatusCreate(
      {@required Asset? asset, @required AssetStatus? assetStatus}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    DateFormat _format = DateFormat('dd-MM-yyyy');
    String _todayDate = _format.format(DateTime.now());

    User _user = _configModel.user;
    assetStatus!.userId = _user.id;
    assetStatus.date = _todayDate;

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/asset_statuses'),
      body: json.encode(assetStatus.toJson()),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
  }
}

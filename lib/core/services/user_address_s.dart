import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aadab/core/models/user_address.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;

class UserAddressService {
  final ConfigModel _configModel = locator<ConfigModel>();

  List<UserAddress> _userAddresses = [];

  getUserAddresses() async {
    Map<String, dynamic> apiConfig = _configModel.apiConfig;
    var userId = _configModel.user!.id;
    http.Response _response = await http.get(
      Uri.parse(apiConfig['baseURL'] + '/user_addresses?userId=$userId'),
      headers: apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _userAddresses = [];
      _responseData['data'].forEach((data) {
        _userAddresses.add(UserAddress.fromJson(data));
      });
    }

    return _userAddresses;
  }

  Future<bool> saveUserAddress({@required UserAddress? userAddress}) async {
    Map<String, dynamic> apiConfig = _configModel.apiConfig;
    userAddress!.userId = _configModel.user!.id;
    userAddress.isDeleted = 0;
    http.Response _response = await http.post(
        Uri.parse(apiConfig['baseURL'] + '/user_addresses'),
        body: json.encode(userAddress.toJson()),
        headers: apiConfig['headers']);

    Map<String, dynamic> _responseData = json.decode(_response.body);
    return _responseData['success'];
  }

  Future<bool> updateUserAddress({@required UserAddress? userAddress}) async {
    Map<String, dynamic> apiConfig = _configModel.apiConfig;
    http.Response _response = await http.patch(
        Uri.parse(apiConfig['baseURL'] + '/user_addresses/${userAddress!.id}'),
        body: json.encode(userAddress.toJson()),
        headers: apiConfig['headers']);

    Map<String, dynamic> _responseData = json.decode(_response.body);
    return _responseData['success'];
  }
}

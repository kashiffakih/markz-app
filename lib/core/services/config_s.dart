import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  String? url;

  Map<String, dynamic> getApiConfig(
      {String domain = '', String? token = '', int? companyId}) {
    url = (domain == '' ? url : domain);

    return {
      'headers': {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'company-id': '$companyId',
      },
      'responseType': 'json',
      'baseURL': url! + '/api',
      'mediaURL': url! + '/storage/',
    };
  }

  Future<void> saveLoginData(
      {@required Map<String, dynamic>? newLoginData}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('loginData', json.encode(newLoginData));
  }

  Future<Map<String, dynamic>> fetchLoginData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? _loginData = _prefs.get('loginData').toString();
    if (_loginData != 'null') {
      return json.decode(_prefs.get('loginData').toString());
    }
    return {};
  }

  removeLoginData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _loginData = _prefs.get('loginData').toString();
    Map<String, dynamic> _loginMap = json.decode(_loginData);
    _loginMap['password'] = '';
    _prefs.setString('loginData', json.encode(_loginMap));
  }
}

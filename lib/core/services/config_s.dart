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
        'company-id': '${companyId}',
      },
      'responseType': 'json',
      'baseURL': url! + '/api',
      'mediaURL': url! + '/storage/',
      // 'mediaURL': 'https://api.staging.aadab.online/storage/Aadab/',
    };
  }

  Future<void> saveLoginData(
      {@required Map<String, dynamic>? newLoginData}) async {
    if (newLoginData == null) {
      return null;
    } else {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      await _prefs.setString('loginData', json.encode(newLoginData));
    }
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
    // Completely remove the loginData key from SharedPreferences
    await _prefs.remove('loginData');

    // Optional: Clear all SharedPreferences data if needed
    // await _prefs.clear();

    print('Login data completely removed from device storage');
  }

  // Method to clear all SharedPreferences data
  clearAllStoredData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.clear();
    print('All stored data cleared from device');
  }
}

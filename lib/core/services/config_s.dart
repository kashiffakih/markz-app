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
      // 'mediaURL': url! + '/storage/',
      'mediaURL': 'https://api.staging.aadab.online/storage/Aadab/',
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
    String? _loginDataStr = _prefs.getString('loginData');
    if (_loginDataStr != null && _loginDataStr.isNotEmpty && _loginDataStr != 'null') {
      try {
        return Map<String, dynamic>.from(json.decode(_loginDataStr));
      } catch (e) {
        print('Error decoding loginData: $e');
      }
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

  // New user welcome bonus tracking
  Future<void> setNewUserFlag(bool isNewUser) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool('is_new_user', isNewUser);
  }

  Future<bool> getNewUserFlag() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool('is_new_user') ?? false;
  }

  Future<void> setWelcomeBonusShown(bool shown) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool('welcome_bonus_shown', shown);
  }

  Future<bool> getWelcomeBonusShown() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool('welcome_bonus_shown') ?? false;
  }

  // Store the user ID to track if it's the same user
  Future<void> setLastUserId(int userId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('last_user_id', userId);
  }

  Future<int?> getLastUserId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('last_user_id');
  }
}

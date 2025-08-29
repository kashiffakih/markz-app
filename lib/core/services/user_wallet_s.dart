import 'dart:convert';

import 'package:aadab/core/models/user_wallet.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;

class UserWalletService {
  final ConfigModel _configModel = locator<ConfigModel>();
  List<UserWallet> _userWallets = [];

  getMyUserWallets() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    
    if (_configModel.user == null) {
      return null;
    }
    
    var userId = _configModel.user!.id;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/user_wallets?userId=$userId'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _userWallets = [];
      _responseData['data'].forEach((data) {
        _userWallets.add(UserWallet.fromJson(data));
      });
      _responseData['data'] = _userWallets;
      // print(_responseData);
      return _responseData;
    }
    return null;
  }

  Future<Map<String, dynamic>> mapRedeemReferralCode(String referralCode) async {
    try {
      Map<String, dynamic> _apiConfig = _configModel.apiConfig;
      
      if (_configModel.user == null) {
        return {
          'success': false,
          'message': 'User not logged in',
          'error': 'USER_NOT_LOGGED_IN'
        };
      }
      
      var userId = _configModel.user!.id;

      http.Response _response = await http.get(
        Uri.parse(
            '${_apiConfig['baseURL']}/map_referrer?referral_code=$referralCode&user_id=$userId'),
        headers: _apiConfig['headers'],
      );
      
      Map<String, dynamic> _responseData = json.decode(_response.body);
      print('Referral response: ${_response.body}');
      print('Status code: ${_response.statusCode}');

      // Return the complete response for proper error handling
      return {
        'success': _responseData['success'] ?? false,
        'message': _responseData['message'] ?? 'Unknown error occurred',
        'error': _responseData['error'],
        'data': _responseData['data'],
        'statusCode': _response.statusCode
      };
      
    } catch (e) {
      print('Error in mapRedeemReferralCode: $e');
      return {
        'success': false,
        'message': 'Network error. Please check your connection and try again.',
        'error': 'NETWORK_ERROR'
      };
    }
  }
}

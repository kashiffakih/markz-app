import 'dart:convert';

import 'package:sales_app/core/models/user_wallet.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;

class UserWalletService {
  final ConfigModel _configModel = locator<ConfigModel>();
  List<UserWallet> _userWallets = [];

  getMyUserWallets() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var userId = _configModel.user.id;

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
}

import 'package:flutter/material.dart';
import 'package:sales_app/core/models/file.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/services/config_s.dart';
import 'package:sales_app/locator.dart';

class ConfigModel with ChangeNotifier {
  final ConfigService _configService = locator<ConfigService>();

  // File
  File _file;
  set file(File newFile) {
    _file = newFile;
    notifyListeners();
  }

  File get file => _file;

  updateFile({@required File newFile}) {
    file = newFile;
  }

  // Api Config
  Map<String, dynamic> _apiConfig;

  set apiConfig(Map<String, dynamic> newApiConfig) {
    _apiConfig = newApiConfig;
    notifyListeners();
  }

  Map<String, dynamic> get apiConfig => _apiConfig;

  void getApiConfig({@required String domain}) {
    apiConfig = _configService.getApiConfig(domain: domain);
  }

  // Login Data
  Map<String, dynamic> _loginData = {};

  set loginData(Map<String, dynamic> newLoginData) {
    _loginData = newLoginData;
    notifyListeners();
  }

  Map<String, dynamic> get loginData => _loginData;

  Future<void> saveLoginData(
      {@required Map<String, dynamic> newLoginData}) async {
    await _configService.saveLoginData(newLoginData: newLoginData);
  }

  Future<void> fetchLoginData() async {
    loginData = await _configService.fetchLoginData();
  }

  Future<void> removeLoginData() async {
    await _configService.removeLoginData();
  }

  // Logged in user
  User _user;
  bool _isLoggedIn;
  String _loginFailedMessage;

  set user(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  User get user => _user;

  set isLoggedIn(bool newIsLoggedIn) {
    _isLoggedIn = newIsLoggedIn;
    notifyListeners();
  }

  bool get isLoggedIn => _isLoggedIn;

  set loginFailedMessage(String newLoginFailedMessage) {
    _loginFailedMessage = newLoginFailedMessage;
    notifyListeners();
  }

  String get loginFailedMessage => _loginFailedMessage;

  saveUserData({@required Map<String, dynamic> responseData}) {
    if (responseData['success'] == null) {
      isLoggedIn = false;
      loginFailedMessage = responseData['message'];
    } else if (responseData['success']) {
      isLoggedIn = true;
      user = User.fromJson(responseData['data']);
      apiConfig = _configService.getApiConfig(
        token: user.apiToken,
        companyId: user.companies.length > 0 ? user.companies[0].id : null,
      );
    }
    notifyListeners();
  }
}

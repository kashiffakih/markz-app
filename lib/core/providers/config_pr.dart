// import 'package:flutter/material.dart';
// import 'package:aadab/core/models/user.dart';
// import 'package:aadab/core/services/config_s.dart';
// import 'package:aadab/locator.dart';
// import 'package:aadab/core/models/file.dart';

// class ConfigModel with ChangeNotifier {
//   final ConfigService _configService = locator<ConfigService>();
// // File
//   late List<File> _files = [];

//   set files(List<File> newFiles) {
//     _files = newFiles;
//     notifyListeners();
//   }

//   List<File> get files => _files;

//   updateFiles({required List<File> newFiles}) {
//     files = newFiles;
//     notifyListeners();
//   }

//   // Api Config
//   late Map<String, dynamic> _apiConfig;

//   set apiConfig(Map<String, dynamic> newApiConfig) {
//     _apiConfig = newApiConfig;
//     notifyListeners();
//   }

//   Map<String, dynamic> get apiConfig => _apiConfig;

//   void getApiConfig({required String domain}) {
//     apiConfig = _configService.getApiConfig(domain: domain);
//   }

//   // Login Data
//   Map<String, dynamic> _loginData = {};

//   set loginData(Map<String, dynamic> newLoginData) {
//     _loginData = newLoginData;
//     notifyListeners();
//   }

//   Map<String, dynamic> get loginData => _loginData;

//   Future<void> saveLoginData(
//       {required Map<String, dynamic>? newLoginData}) async {
//     await _configService.saveLoginData(newLoginData: newLoginData);
//   }

//   Future<void> fetchLoginData() async {
//     loginData = await _configService.fetchLoginData();
//   }

//   Future<void> removeLoginData() async {
//     await _configService.removeLoginData();
//   }

//   // Logged in user
//   late User _user;

//   late bool _isLoggedIn;
//   late String _loginFailedMessage;

//   set user(User newUser) {
//     _user = newUser;
//     notifyListeners();
//   }

//   User get user => _user;

//   set isLoggedIn(bool newIsLoggedIn) {
//     _isLoggedIn = newIsLoggedIn;
//     notifyListeners();
//   }

//   bool get isLoggedIn => _isLoggedIn;

//   set loginFailedMessage(String newLoginFailedMessage) {
//     _loginFailedMessage = newLoginFailedMessage;
//     notifyListeners();
//   }

//   String get loginFailedMessage => _loginFailedMessage;

//   String _currentAndroidVersionFromApi = '';

//   String get currentAndroidVersionFromApi => _currentAndroidVersionFromApi;

//   set currentAndroidVersionFromApi(String newCurrentAndroidVersionFromApi) {
//     _currentAndroidVersionFromApi = newCurrentAndroidVersionFromApi;
//     notifyListeners();
//   }

//   saveUserData({required Map<String, dynamic> responseData}) {
//     if (responseData['success'] == null) {
//       isLoggedIn = false;
//       loginFailedMessage = responseData['message'];
//     } else if (responseData['success']) {
//       isLoggedIn = true;
//       user = User.fromJson(responseData['data']);
//       apiConfig = _configService.getApiConfig(
//         token: user.apiToken,
//         companyId: user.companies!.length > 0 ? user.companies![0].id : null,
//       );
//       currentAndroidVersionFromApi =
//           responseData['currentAndroidVersionFromApi'];
//     }
//     notifyListeners();
//   }
// }
// Test V2

import 'package:flutter/material.dart';
import 'package:aadab/core/models/user.dart';
import 'package:aadab/core/services/config_s.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/core/models/file.dart';

class ConfigModel with ChangeNotifier {
  final ConfigService _configService = locator<ConfigService>();

  // File Management
  List<File> _files = [];

  set files(List<File> newFiles) {
    _files = newFiles;
    notifyListeners();
  }

  List<File> get files => _files;

  void updateFiles({required List<File> newFiles}) {
    files = newFiles;
    notifyListeners();
  }

  // API Configuration
  Map<String, dynamic> _apiConfig = {};

  set apiConfig(Map<String, dynamic> newApiConfig) {
    _apiConfig = newApiConfig;
    notifyListeners();
  }

  Map<String, dynamic> get apiConfig => _apiConfig;

  void getApiConfig({required String domain}) {
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
      {required Map<String, dynamic>? newLoginData}) async {
    await _configService.saveLoginData(newLoginData: newLoginData);
  }

  Future<void> fetchLoginData() async {
    loginData = await _configService.fetchLoginData();
  }

  Future<void> removeLoginData() async {
    await _configService.removeLoginData();
  }

  // User Management
  User? _user;

  User? get user => _user;

  set user(User? newUser) {
    _user = newUser;
    notifyListeners();
  }

  // Logged-In Status
  bool _isLoggedIn = false;
  String _loginFailedMessage = "";

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

  // Android Version
  String _currentAndroidVersionFromApi = "";

  String get currentAndroidVersionFromApi => _currentAndroidVersionFromApi;

  set currentAndroidVersionFromApi(String newCurrentAndroidVersionFromApi) {
    _currentAndroidVersionFromApi = newCurrentAndroidVersionFromApi;
    notifyListeners();
  }

  void saveUserData({required Map<String, dynamic> responseData}) {
    if (responseData['success'] == null) {
      isLoggedIn = false;
      loginFailedMessage = responseData['message'];
    } else if (responseData['success'] == true) {
      isLoggedIn = true;
      user = User.fromJson(responseData['data']);
      final currentUser = user;
      apiConfig = _configService.getApiConfig(
        token: currentUser?.apiToken,
        companyId: (currentUser != null && currentUser.companies != null && currentUser.companies!.isNotEmpty)
            ? currentUser.companies![0].id
            : 1,
      );
      currentAndroidVersionFromApi =
          responseData['currentAndroidVersionFromApi'];
    }
    notifyListeners();
  }

  String _selectedImage = '';

  String get selectedImage => _selectedImage;

  set selectedImage(String value) {
    _selectedImage = value;
    notifyListeners();
  }

  // updateProfileImage(String newPath) {
  //   user?.imagepath = newPath; // Update the user's imagePath
  //   selectedImage = newPath; // Store the selected image path
  //   notifyListeners();
  // }
}

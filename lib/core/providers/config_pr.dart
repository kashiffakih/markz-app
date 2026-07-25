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
import 'package:aadab/core/services/auth_s.dart';
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
    // Clear user data from memory
    clearUserData();
  }

  void clearUserData() {
    // Clear all user-related data from memory
    _user = null;
    _isLoggedIn = false;
    _loginFailedMessage = "";
    _loginData = {};
    _selectedImage = '';
    // Reset API config to default (without token)
    _apiConfig = _configService.getApiConfig(domain: '');
    _activeRole = 'User';
    notifyListeners();
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
        companyId: (currentUser != null &&
                currentUser.companies != null &&
                currentUser.companies!.isNotEmpty)
            ? currentUser.companies![0].id
            : 1,
      );
      currentAndroidVersionFromApi =
          responseData['currentAndroidVersionFromApi'];

      // Initialize Active Role
      if (user?.isApproved == 1) {
        if (user?.activeRole != null && user!.activeRole!.isNotEmpty) {
          _activeRole = user!.activeRole!;
        } else {
          _activeRole = _loginData['role'] ?? 'User';
        }
      } else {
        // Unapproved or rejected wholesalers cannot be active Distributors; default to User mode
        _activeRole = 'User';
        user?.activeRole = 'User';
      }
      if (_loginData.isNotEmpty) {
        _loginData['role'] = _activeRole;
        saveLoginData(newLoginData: _loginData);
      }
    }
    notifyListeners();
  }

  // Active Role Management
  String _activeRole = 'User';

  String get activeRole {
    // Always use user's activeRole from their data when logged in
    if (user?.activeRole != null && user!.activeRole!.isNotEmpty) {
      return user!.activeRole!;
    }
    return _activeRole;
  }

  set activeRole(String role) {
    _activeRole = role;
    if (user != null) {
      user!.activeRole = role;
    }
    if (_loginData.isNotEmpty) {
      _loginData['role'] = role;
      saveLoginData(newLoginData: _loginData);
    }
    notifyListeners();
  }

  void switchRole(String role) {
    _activeRole = role;
    // Also update user's activeRole so getter returns correct value
    if (user != null) {
      user!.activeRole = role;
    }
    if (_loginData.isNotEmpty) {
      _loginData['role'] = role;
      saveLoginData(newLoginData: _loginData);
    }
    notifyListeners();

    // Persist to API in background
    _persistActiveRoleToApi(role);
  }

  /// Persist active role to API (fire and forget)
  Future<void> _persistActiveRoleToApi(String role) async {
    try {
      final authService = locator<AuthService>();
      await authService.updateActiveRole(role: role);
    } catch (e) {
      debugPrint('Failed to persist active role to API: $e');
    }
  }

  String _selectedImage = '';

  String get selectedImage => _selectedImage;

  set selectedImage(String value) {
    _selectedImage = value;
    notifyListeners();
  }

  // New user welcome bonus tracking
  bool _isNewUser = false;
  bool _showWelcomeBonus = false;

  bool get isNewUser => _isNewUser;
  bool get showWelcomeBonus => _showWelcomeBonus;

  set isNewUser(bool value) {
    _isNewUser = value;
    notifyListeners();
  }

  set showWelcomeBonus(bool value) {
    _showWelcomeBonus = value;
    notifyListeners();
  }

  Future<void> setNewUserFlag(bool isNewUser) async {
    _isNewUser = isNewUser;
    await _configService.setNewUserFlag(isNewUser);
    notifyListeners();
  }

  Future<bool> getNewUserFlag() async {
    _isNewUser = await _configService.getNewUserFlag();
    return _isNewUser;
  }

  Future<void> setWelcomeBonusShown(bool shown) async {
    _showWelcomeBonus = !shown;
    await _configService.setWelcomeBonusShown(shown);
    notifyListeners();
  }

  Future<bool> getWelcomeBonusShown() async {
    return await _configService.getWelcomeBonusShown();
  }

  Future<void> checkAndSetNewUserStatus() async {
    if (_user != null && _user!.id != null) {
      final lastUserId = await _configService.getLastUserId();
      final welcomeBonusShown = await _configService.getWelcomeBonusShown();

      // If this is a different user or first time user, mark as new user
      if (lastUserId == null || lastUserId != _user!.id) {
        _isNewUser = true;
        _showWelcomeBonus = true;
        await _configService.setLastUserId(_user!.id!);
        await _configService.setWelcomeBonusShown(false);
      } else {
        // Same user - check if welcome bonus was already shown
        _isNewUser = await _configService.getNewUserFlag();
        _showWelcomeBonus = !welcomeBonusShown && _isNewUser;
      }
      notifyListeners();
    }
  }

  // updateProfileImage(String newPath) {
  //   user?.imagepath = newPath; // Update the user's imagePath
  //   selectedImage = newPath; // Store the selected image path
  //   notifyListeners();
  // }

  void updateRegisterBonusSeen(bool seen) {
    if (_user != null) {
      _user!.isRegisterBonusSeen = seen ? 1 : 0;
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:sales_app/core/models/file.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/services/profile_s.dart';
import 'package:sales_app/locator.dart';

class ProfileModel with ChangeNotifier {
  final ConfigModel _configModel = locator<ConfigModel>();
  final ProfileService _profileService = ProfileService();

  // Add profile image
  addProfileImage() async {
    final _responseData = await _profileService.addProfileImage();
    if (_responseData['success']) {
      _configModel.saveUserData(responseData: _responseData);
    }
    _configModel.file = File();
    // _configModel.file = null;
    notifyListeners();
  }
}

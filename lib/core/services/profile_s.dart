import 'dart:convert';

import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ProfileService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Send OTP
  sendOTP({@required otp}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/send_otp?phone=${_configModel.user.phone}&otp=$otp'),
      headers: _apiConfig['headers'],
    );
  }

  // Update Profile
  updateProfile({@required User? userData}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.patch(
      Uri.parse('${_apiConfig['baseURL']}/users/${_configModel.user.id}'),
      body: json.encode(userData!.toJson()),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _configModel.saveUserData(responseData: _responseData);
    }
  }

  // Upload profile image
  addProfileImage() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${_apiConfig['baseURL']}/upload_user_image'),
    )
      ..fields['userid'] = _configModel.user.id.toString()
      ..fields['filename'] = _configModel.file.fileName.toString()
      ..files.add(
        await http.MultipartFile.fromPath(
          'imagepath',
          _configModel.file.file.toString(),
        ),
      )
      ..headers.addAll(_apiConfig['headers']);
    http.StreamedResponse _response = await request.send();
    http.Response response = await http.Response.fromStream(_response);

    Map<String, dynamic> _responseData = json.decode(response.body);
    return _responseData;
  }
}

import 'package:flutter/material.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final ConfigModel _configModel = locator<ConfigModel>();

  Future<void> getLoggedInUser(
      {@required Map<String, dynamic>? loginData}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/login'),
      body: json.encode(loginData),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success'] == null) {
    } else if (_responseData['success']) {
      await _configModel.saveLoginData(newLoginData: loginData);
    }
    _configModel.saveUserData(responseData: _responseData);
  }

  Future<bool> registerUser(
      {@required Map<String, dynamic>? registerData}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/register-user'),
      body: json.encode(registerData),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      var userRole = {
        'role_id': 6,
        'user_id': _responseData['data']['id'],
      };
      http.Response _responseUserRole = await http.post(
        Uri.parse('${_apiConfig['baseURL']}/role_user'),
        body: json.encode(userRole),
        headers: _apiConfig['headers'],
      );

      Map<String, dynamic> _responseUserRoleData =
          json.decode(_responseUserRole.body);
    }
    if (registerData!['imagepath'] != null) {
      var _id = _responseData['data']['id'].toString();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${_apiConfig['baseURL']}/upload_user_photo'),
      )
        ..fields['userid'] = _id
        // ..fields['attachment'] = registerData['imagepath']
        ..files.add(
          await http.MultipartFile.fromPath(
            'attachment',
            registerData['imagepath'],
          ),
        )
        ..headers.addAll(_apiConfig['headers']);
      http.StreamedResponse _responseImage = await request.send();
      http.Response response = await http.Response.fromStream(_responseImage);
      print(response.body);
    }
    return true;
  }

  Future<bool> sendCodeForResetPassword(
      {@required Map<String, dynamic>? email}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var sendMail = email!['email'];
    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/emails/reset_password/users/$sendMail'),
      // body: json.encode(email),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    return _responseData['success'];
  }

  Future<bool> verifyCode({@required Map<String, dynamic>? data}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var email = data!["email"];
    var code = data["code"];
    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/verify_code/users?email=$email&code=$code'),
      // body: json.encode(data),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    return _responseData['success'];
  }

  Future<bool> changePassword({@required Map<String, dynamic>? data}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var email = data!["email"];
    var password = data["password"];
    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/change_password/users?email=$email&password=$password'),
      // body: json.encode(data),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);

    return _responseData['success'];
  }
}

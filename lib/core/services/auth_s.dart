import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AuthService {
  final ConfigModel _configModel = locator<ConfigModel>();

  Future<void> getLoggedInUser(
      {@required Map<String, dynamic>? loginData}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    // print('Login Data');
    // print(loginData);
    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/login'),
      body: json.encode(loginData),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);

    if (_responseData['success'] == null) {
    } else if (_responseData['success']) {
      await _configModel.saveLoginData(newLoginData: loginData);
    }
    _configModel.saveUserData(responseData: _responseData);
  }

  Future<bool> registerUser(
      {@required Map<String, dynamic>? registerData}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    // print('Register Data');
    // print(registerData);

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/register-user'),
      body: json.encode(registerData),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_response.body);
    if (_responseData['success']) {
      var roleId;
      roleId = registerData!['role'] == 'Distributor' ? 3 : 6;
      var userRole = {
        'role_id': roleId,
        'user_id': _responseData['data']['id'],
      };
      await http.post(
        Uri.parse('${_apiConfig['baseURL']}/role_user'),
        body: json.encode(userRole),
        headers: _apiConfig['headers'],
      );
      var userCompany = {
        'company_id': 1,
        'user_id': _responseData['data']['id'],
      };
      await http.post(
        Uri.parse('${_apiConfig['baseURL']}/company_user'),
        body: json.encode(userCompany),
        headers: _apiConfig['headers'],
      );
    }
    // if (registerData!['imagepath'] != null ||
    //     registerData!['imagepath'] != 'null' ||
    //     registerData!['imagepath'] != '' ||
    //     registerData!['imagepath'].toString() != null ||
    //     registerData!['imagepath'].toString() != 'null' ||
    //     registerData!['imagepath'].toString() != '' ||
    //     registerData!['imagepath'].toString().isNotEmpty) {
    //   print(registerData!['imagepath']);
    //   var _id = _responseData['data']['id'].toString();
    //   var request = http.MultipartRequest(
    //     'POST',
    //     Uri.parse('${_apiConfig['baseURL']}/upload_user_photo'),
    //   )
    //     ..fields['userid'] = _id
    //     // ..fields['attachment'] = registerData['imagepath']
    //     ..files.add(
    //       await http.MultipartFile.fromPath(
    //         'attachment',
    //         registerData['imagepath'],
    //       ),
    //     )
    //     ..headers.addAll(_apiConfig['headers']);
    //   http.StreamedResponse _responseImage = await request.send();
    //   http.Response response = await http.Response.fromStream(_responseImage);
    //   print(response.body);
    // }
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

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  Future<Map<String, dynamic>> uploadImage({
    required File imageFile,
    required String userId,
  }) async {
    // try {
    // Get API configuration
    final Map<String, dynamic> apiConfig = _configModel.apiConfig;

    // Define the API endpoint
    final String uploadUrl = '${apiConfig['baseURL']}/upload_user_photo';

    // Create multipart request
    final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

    // Add userId field
    request.fields['userid'] = userId;

    // Add image file
    final multipartFile = await http.MultipartFile.fromPath(
      'imagepath', // Server-expected key
      imageFile.path,
      // contentType: mimeType,
    );
    request.files.add(multipartFile);

    // Add headers
    request.headers.addAll(Map<String, String>.from(apiConfig['headers']));

    // Send request and get response
    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    final responseData = json.decode(responseBody.body);

    Map<String, dynamic>? data = _configModel.user!.toJson();

    data['password'] = _configModel.loginData['password'];
    await _configModel.saveLoginData(newLoginData: data);
    _configModel.saveUserData(responseData: responseData);
    return {
      'success': true,
      'data': responseData,
    };
  }

  Future<bool> updateUser(
      {@required Map<String, dynamic>? updateUserData}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    var userId = _configModel.user!.id;
    http.Response _response = await http.patch(
      Uri.parse('${_apiConfig['baseURL']}/users/$userId'),
      body: json.encode(updateUserData),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData['success']);
    if (_responseData['success']) {
      // Map<String, dynamic> data = updateUserData!;
      updateUserData!['password'] = _configModel.loginData['password'];
      await _configModel.saveLoginData(newLoginData: updateUserData);
      _configModel.saveUserData(responseData: _responseData);
    }

    return _responseData['success'];
  }
}

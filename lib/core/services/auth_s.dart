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
    print('Login Data');
    print(loginData);
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
      http.Response _responseUserRole = await http.post(
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

      Map<String, dynamic> _responseUserRoleData =
          json.decode(_responseUserRole.body);
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
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    // Define the API endpoint for uploading the image
    final String uploadUrl =
        '${_apiConfig['baseURL']}/upload_user_photo'; // Adjust to your actual endpoint

    try {
      // Create a multipart request for the image upload
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Add the userId as a form field
      request.fields['userid'] = userId;

      // Attach the image file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'attachment', // The key expected by the server for the file
        imageFile.path,
      ));

      // Add headers
      request.headers.addAll(_apiConfig['headers']);

      // Send the request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        // Parse the response body
        var responseBody = await http.Response.fromStream(response);
        Map<String, dynamic> responseData = json.decode(responseBody.body);
        print('Image upload successful: $responseData');
        print('Image path successful: ${responseData['data']['image_path']}');
        _configModel.updateProfileImage(responseData['data']['image_path']);
        return {
          'success': true,
          'data': responseData,
          'image_path': responseData['data']['image_path']
        };
      } else {
        // If the upload fails, return an error message
        return {
          'success': false,
          'message':
              'Image upload failed with status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Handle any errors
      return {
        'success': false,
        'message': 'Error uploading image API: $e',
      };
    }
  }
}

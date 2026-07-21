import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:aadab/core/models/user.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/services/firebase_api.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final ConfigModel _configModel = locator<ConfigModel>();

  /// Force refresh FCM token on login to prevent SenderId mismatch issues
  Future<void> _refreshFcmTokenOnLogin() async {
    try {
      debugPrint('Refreshing FCM token on login...');
      final firebaseApi = FirebaseApi();
      final newToken = await firebaseApi.forceRefreshToken();

      if (newToken != null && newToken.isNotEmpty) {
        debugPrint('Got new FCM token, sending to server...');
        await updateFcmToken(newToken: newToken);
      } else {
        debugPrint('Failed to get new FCM token');
      }
    } catch (e) {
      debugPrint('Error refreshing FCM token on login: $e');
    }
  }

  Future<Map<String, dynamic>> getLoggedInUser(
      {@required Map<String, dynamic>? loginData}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    // print('Login Data');
    // print(loginData);

    try {
      http.Response _response = await http.post(
        Uri.parse('${_apiConfig['baseURL']}/login'),
        body: json.encode(loginData),
        headers: _apiConfig['headers'],
      );

      // Check if response is JSON
      if (_response.headers['content-type']?.contains('application/json') ??
          false) {
        Map<String, dynamic> _responseData = json.decode(_response.body);
        // print(_responseData);

        if (_responseData['success'] == null) {
          return {
            'success': false,
            'message': 'These credentials do not match our records'
          };
        } else if (_responseData['success']) {
          await _configModel.saveLoginData(newLoginData: loginData);
          _configModel.saveUserData(responseData: _responseData);

          // Force refresh FCM token on login to ensure fresh token
          _refreshFcmTokenOnLogin();

          return {
            'success': true,
            'message': _responseData['message'] ?? 'Login successful'
          };
        } else {
          _configModel.saveUserData(responseData: _responseData);
          return {
            'success': false,
            'message': _responseData['message'] ?? 'Login failed'
          };
        }
      } else {
        // Handle non-JSON response
        // print('Error: Server returned non-JSON response');
        // print('Status Code: ${_response.statusCode}');
        // print(
        //     'Response: ${_response.body.substring(0, _response.body.length > 200 ? 200 : _response.body.length)}...');

        // Save empty user data to indicate login failure
        _configModel.saveUserData(responseData: {
          'success': false,
          'message': 'Server error: Invalid response format'
        });

        return {
          'success': false,
          'message': 'Server error: Invalid response format'
        };
      }
    } catch (e) {
      print('Error during login: $e');
      // Save empty user data to indicate login failure
      String errorMessage = 'Network error: ${e.toString()}';
      _configModel.saveUserData(
          responseData: {'success': false, 'message': errorMessage});

      return {'success': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> registerUser(
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
    print('Registration response: ${_response.body}');
    // print('Status code: ${_response.statusCode}');

    // Handle different HTTP status codes
    if (_response.statusCode == 409) {
      // Conflict - User already exists
      throw Exception('User already registered');
    } else if (_response.statusCode == 422) {
      // Validation error
      throw Exception('Validation failed: ${_responseData['message']}');
    } else if (_response.statusCode >= 400) {
      // Other client/server errors
      throw Exception(_responseData['message'] ?? 'Registration failed');
    }

    // Additional check for error in response body (fallback)
    if (!_responseData['success'] && _responseData['message'] != null) {
      String errorMessage = _responseData['message'].toString().toLowerCase();
      if (errorMessage.contains('already exists') ||
          errorMessage.contains('duplicate') ||
          _responseData['error'] == 'USER_ALREADY_EXISTS' ||
          _responseData['error'] == 'EMAIL_ALREADY_EXISTS') {
        throw Exception('User already registered');
      }
      throw Exception(_responseData['message']);
    }

    String? userId;
    if (_responseData['success']) {
      userId = _responseData['data']['id'].toString();
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

    return {
      'success': _responseData['success'] ?? false,
      'userId': userId,
      'data': _responseData['data'],
    };
  }

  Future<bool> sendCodeForResetPassword(
      {@required Map<String, dynamic>? email}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/forgot_password'),
      body: json.encode({'email': email!['email']}),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    print('tstt $_responseData');
    return _response.statusCode == 200;
  }

  Future<bool> verifyCode({@required Map<String, dynamic>? data}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/verify_code'),
      body: json.encode({
        'email': data!['email'],
        'code': data['code'],
      }),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    return _response.statusCode == 200;
  }

  Future<bool> changePassword({@required Map<String, dynamic>? data}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/reset_password'),
      body: json.encode({
        'email': data!['email'],
        'code': data['code'],
        'password': data['password'],
        'password_confirmation': data['confirm_password'],
      }),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    return _response.statusCode == 200;
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      // Web client ID from google-services.json (client_type: 3)
      final googleSignIn = GoogleSignIn(
        scopes: ['email'],
        serverClientId:
            '990776187523-31hv31ogtp5c4pdpf5t5f4d687ve4tct.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

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

    Map<String, dynamic>? data = _configModel.user?.toJson();

    if (data != null) {
      data['password'] = _configModel.loginData['password'];
    }
    await _configModel.saveLoginData(newLoginData: data);
    _configModel.saveUserData(responseData: responseData);
    return {
      'success': true,
      'data': responseData,
    };
  }

  /// Upload wholesaler documents (visiting card and shop image)
  Future<Map<String, dynamic>> uploadWholesalerDocuments({
    required String userId,
    File? visitingCardImage,
    File? shopImage,
  }) async {
    try {
      final Map<String, dynamic> apiConfig = _configModel.apiConfig;
      final String uploadUrl =
          '${apiConfig['baseURL']}/upload_wholesaler_documents';

      print('Uploading to: $uploadUrl');
      print('User ID: $userId');
      print('Visiting card path: ${visitingCardImage?.path}');
      print('Shop image path: ${shopImage?.path}');

      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Add user ID field
      request.fields['user_id'] = userId;

      // Add visiting card image if provided
      if (visitingCardImage != null) {
        print('Adding visiting card file...');
        final visitingCardMultipart = await http.MultipartFile.fromPath(
          'visiting_card',
          visitingCardImage.path,
        );
        request.files.add(visitingCardMultipart);
      }

      // Add shop image if provided
      if (shopImage != null) {
        print('Adding shop image file...');
        final shopImageMultipart = await http.MultipartFile.fromPath(
          'shop_image',
          shopImage.path,
        );
        request.files.add(shopImageMultipart);
      }

      // Add headers (excluding content-type as MultipartRequest sets it automatically)
      final headers = Map<String, String>.from(apiConfig['headers']);
      headers.remove('Content-Type');
      request.headers.addAll(headers);

      print('Sending request with ${request.files.length} files...');

      // Send request
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      print('Response status: ${response.statusCode}');
      print('Response body: ${responseBody.body}');

      final responseData = json.decode(responseBody.body);

      return {
        'success': responseData['success'] ?? false,
        'message': responseData['message'] ?? 'Upload completed',
        'data': responseData['data'],
      };
    } catch (e) {
      print('Error uploading wholesaler documents: $e');
      debugPrint('Error uploading wholesaler documents: $e');
      return {
        'success': false,
        'message': 'Failed to upload documents: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> mapReferrer({
    required String referralCode,
    required int userId,
  }) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    try {
      // Using GET request with query parameters as per API definition check
      final String url =
          '${_apiConfig['baseURL']}/map_referrer?referral_code=$referralCode&user_id=$userId';

      http.Response _response = await http.get(
        Uri.parse(url),
        headers: _apiConfig['headers'],
      );

      Map<String, dynamic> _responseData = json.decode(_response.body);

      if (_response.statusCode == 200 && _responseData['success'] == true) {
        return {
          'success': true,
          'message': _responseData['message'] ?? 'Referral code applied!',
          'data': _responseData['data']
        };
      } else {
        return {
          'success': false,
          'message': _responseData['message'] ?? 'Failed to apply referral code'
        };
      }
    } catch (e) {
      print('Error mapping referrer: $e');
      return {
        'success': false,
        'message': 'Network error: Failed to apply referral code'
      };
    }
  }

  Future<Map<String, dynamic>> updateUser(
      {@required Map<String, dynamic>? updateUserData}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    // try {
    var userId = _configModel.user!.id;
    http.Response _response = await http.patch(
      Uri.parse('${_apiConfig['baseURL']}/users/$userId'),
      body: json.encode(updateUserData),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);

    if (_responseData['success']) {
      // Map<String, dynamic> data = updateUserData!;
      updateUserData!['password'] = _configModel.loginData['password'];
      await _configModel.saveLoginData(newLoginData: updateUserData);
      _configModel.saveUserData(responseData: _responseData);

      // Return success with message
      return {
        'success': true,
        'message': _responseData['message'] ?? 'Profile updated successfully',
      };
    } else {
      // Return failure with error message
      return {
        'success': false,
        'message': _responseData['message'] ?? 'Failed to update profile',
      };
    }
    // } catch (e) {
    //   print('Error updating user: $e');
    //   // Return failure with error message
    //   return {
    //     'success': false,
    //     'message': 'Network error: Failed to update profile',
    //   };
    // }
  }

  Future<void> markRegisterBonusSeen() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    try {
      var userId = _configModel.user!.id;
      final response = await http.post(
        Uri.parse('${_apiConfig['baseURL']}/users/mark_register_bonus_seen'),
        body: json.encode({'user_id': userId}),
        headers: _apiConfig['headers'],
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          // Update local user model
          _configModel.updateRegisterBonusSeen(true);
        }
      }
    } catch (e) {
      debugPrint('Error marking bonus as seen: $e');
    }
  }

  Future<void> updateFcmToken({required String newToken}) async {
    // Check if user is logged in
    if (_configModel.user == null || _configModel.user!.id == null) {
      debugPrint('Cannot update FCM token: User not logged in');
      return;
    }

    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    try {
      var userId = _configModel.user!.id;
      // We can use the existing update user endpoint since it accepts any field
      http.Response _response = await http.patch(
        Uri.parse('${_apiConfig['baseURL']}/users/$userId'),
        body: json.encode({'fcm_token': newToken}),
        headers: _apiConfig['headers'],
      );

      debugPrint('FCM Token Update Response: ${_response.body}');

      Map<String, dynamic> _responseData = json.decode(_response.body);
      if (_responseData['success']) {
        debugPrint('FCM token updated successfully on server');
      } else {
        debugPrint(
            'Failed to update FCM token on server: ${_responseData['message']}');
      }
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
    }
  }

  /// Update active role in the database
  Future<bool> updateActiveRole({required String role}) async {
    if (_configModel.user == null || _configModel.user!.id == null) {
      debugPrint('Cannot update active role: User not logged in');
      return false;
    }

    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    try {
      http.Response _response = await http.post(
        Uri.parse('${_apiConfig['baseURL']}/users/update_active_role'),
        body: json.encode({'role': role}),
        headers: _apiConfig['headers'],
      );

      Map<String, dynamic> _responseData = json.decode(_response.body);
      if (_responseData['success'] == true) {
        debugPrint('Active role updated to $role on server');
        return true;
      } else {
        debugPrint('Failed to update active role: ${_responseData['message']}');
        return false;
      }
    } catch (e) {
      debugPrint('Error updating active role: $e');
      return false;
    }
  }

  /// Add a new role to the current user
  Future<Map<String, dynamic>> addRole({required String role}) async {
    if (_configModel.user == null || _configModel.user!.id == null) {
      return {'success': false, 'message': 'User not logged in'};
    }

    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    try {
      http.Response _response = await http.post(
        Uri.parse('${_apiConfig['baseURL']}/users/add_role'),
        body: json.encode({'role': role}),
        headers: _apiConfig['headers'],
      );

      Map<String, dynamic> _responseData = json.decode(_response.body);
      print("Check Respo $_responseData");
      if (_responseData['success'] == true) {
        // Update local user data with new roles
        _configModel.saveUserData(responseData: _responseData);
        return {'success': true, 'message': _responseData['message']};
      } else {
        return {
          'success': false,
          'message': _responseData['message'] ?? 'Failed to add role'
        };
      }
    } catch (e) {
      debugPrint('Error adding role: $e');
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  /// Fetch fresh user details from server to ensure latest status (approved, blocked, rejected)
  Future<User?> fetchFreshUserData() async {
    if (_configModel.user == null || _configModel.user!.id == null) {
      return null;
    }

    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    try {
      http.Response _response = await http.get(
        Uri.parse('${_apiConfig['baseURL']}/users/${_configModel.user!.id}'),
        headers: _apiConfig['headers'],
      );

      if (_response.statusCode == 200) {
        Map<String, dynamic> _responseData = json.decode(_response.body);
        if (_responseData['success'] == true && _responseData['data'] != null) {
          User freshUser = User.fromJson(_responseData['data']);
          _configModel.user = freshUser;
          return freshUser;
        }
      }
    } catch (e) {
      debugPrint('Error fetching fresh user data: $e');
    }
    return _configModel.user;
  }
}

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:aadab/core/services/auth_s.dart';
import 'package:aadab/locator.dart';

class AuthModel with ChangeNotifier {
  final AuthService _authService = locator<AuthService>();
  bool _loading = false;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  AuthService get authService => _authService;
  bool get loading => _loading;
  Future<Map<String, dynamic>> login(
      {required Map<String, dynamic> loginData}) async {
    String? token;
    try {
      token = await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
      token = null;
    }
    loginData['fcm_token'] = token;
    // print(token);
    return await _authService.getLoggedInUser(
      loginData: loginData,
    );
  }

  Future<Map<String, dynamic>> register(
      {required Map<String, dynamic> registerData}) async {
    try {
      Map<String, dynamic> result =
          await _authService.registerUser(registerData: registerData);
      if (result['success'] == true) {
        return {
          'success': true,
          'message': 'Registration successful',
          'userId': result['userId'],
          'data': result['data'],
        };
      } else {
        return {
          'success': false,
          'message': 'Registration failed',
          'error': 'GENERAL_ERROR'
        };
      }
    } catch (e) {
      // Check if it's a duplicate user error
      String errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('already exists') ||
          errorMessage.contains('duplicate') ||
          errorMessage.contains('already registered')) {
        return {
          'success': false,
          'message': 'User already registered',
          'error': 'EMAIL_ALREADY_EXISTS'
        };
      }
      return {
        'success': false,
        'message': 'Registration failed',
        'error': 'GENERAL_ERROR'
      };
    }
  }

  Future<bool> sendCodeForResetPassword(
      {required Map<String, dynamic> email}) async {
    return await _authService.sendCodeForResetPassword(
      email: email,
    );
  }

  Future<bool> verifyCode({required Map<String, dynamic> data}) async {
    return await _authService.verifyCode(
      data: data,
    );
  }

  Future<bool> changePassword({required Map<String, dynamic> data}) async {
    return await _authService.changePassword(
      data: data,
    );
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      var userCredential = await _authService.signInWithGoogle();
      if (userCredential != null) {
        // Handle successful Google Sign-In (e.g., save user data or notify listeners)
        print("Google Sign-In successful: ${userCredential.user}");
        notifyListeners();
      }
      return userCredential;
    } catch (e) {
      // Handle error during Google Sign-In
      print("Error during Google Sign-In: $e");
      rethrow; // Optionally rethrow the error for further handling in the UI
    }
  }

  Future<Map<String, dynamic>> uploadImage({
    required File imageFile,
    required String userId,
  }) async {
    loading = true;
    // Call the uploadImage method from AuthService
    final response = await _authService.uploadImage(
      imageFile: imageFile,
      userId: userId,
    );

    // Optionally, handle any logic or state changes, then notify listeners
    if (response['success']) {
      // String selectedImage = response['image_path'];
      debugPrint("Image Path ${response}");
      notifyListeners();

      // Notify UI about any state changes if necessary
    }
    loading = false;
    return response;
  }

  Future<Map<String, dynamic>> updateUser(
      {required Map<String, dynamic> updateUserData}) async {
    return await _authService.updateUser(
      updateUserData: updateUserData,
    );
  }

  /// Upload wholesaler documents (visiting card and shop image)
  Future<Map<String, dynamic>> uploadWholesalerDocuments({
    required String userId,
    File? visitingCardImage,
    File? shopImage,
  }) async {
    loading = true;
    final response = await _authService.uploadWholesalerDocuments(
      userId: userId,
      visitingCardImage: visitingCardImage,
      shopImage: shopImage,
    );
    loading = false;
    notifyListeners();
    return response;
  }
}

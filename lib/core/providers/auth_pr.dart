import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sales_app/core/services/auth_s.dart';
import 'package:sales_app/locator.dart';

class AuthModel with ChangeNotifier {
  final AuthService _authService = locator<AuthService>();

  Future<void> login({required Map<String, dynamic> loginData}) async {
    await _authService.getLoggedInUser(
      loginData: loginData,
    );
  }

  Future<bool> register({required Map<String, dynamic> registerData}) async {
    return await _authService.registerUser(
      registerData: registerData,
    );
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

}

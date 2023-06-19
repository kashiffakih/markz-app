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
}

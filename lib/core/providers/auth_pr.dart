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
}

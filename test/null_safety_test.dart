import 'package:flutter_test/flutter_test.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/auth_pr.dart';
import 'package:aadab/core/models/user.dart';
import 'package:aadab/locator.dart';

void main() {
  group('Null Safety Tests', () {
    setUpAll(() {
      setupLocator();
    });

    test('ConfigModel handles null user correctly', () {
      final configModel = ConfigModel();
      
      // Test null user
      expect(configModel.user, isNull);
      expect(configModel.isLoggedIn, isFalse);
      
      // Test saveUserData with null success
      configModel.saveUserData(responseData: {'message': 'Failed'});
      expect(configModel.isLoggedIn, isFalse);
      expect(configModel.loginFailedMessage, equals('Failed'));
    });

    test('ConfigModel handles user with empty companies', () {
      final configModel = ConfigModel();
      
      // Create user with empty companies
      final testUser = User(
        id: 1,
        email: 'test@example.com',
        companies: [],
      );
      
      configModel.user = testUser;
      expect(configModel.user?.companies, isEmpty);
    });

    test('ConfigModel handles user with null companies', () {
      final configModel = ConfigModel();
      
      // Create user with null companies
      final testUser = User(
        id: 1,
        email: 'test@example.com',
        companies: null,
      );
      
      configModel.user = testUser;
      expect(configModel.user?.companies, isNull);
    });

    test('Login data initialization', () {
      final configModel = ConfigModel();
      
      // Check initial state
      expect(configModel.loginData, isEmpty);
      expect(configModel.apiConfig, isEmpty);
      expect(configModel.files, isEmpty);
    });

    test('AuthModel loading state', () {
      final authModel = AuthModel();
      
      // Test initial loading state
      expect(authModel.loading, isFalse);
      
      // Test loading state change
      authModel.loading = true;
      expect(authModel.loading, isTrue);
    });
  });
}
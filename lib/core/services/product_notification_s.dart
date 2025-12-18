import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';

class ProductNotificationService {
  final ConfigModel _configModel = locator<ConfigModel>();

  Future<Map<String, dynamic>> storeNotification({
    required int productId,
    required int productPackId,
    required int qty,
  }) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    
    // Ensure user is logged in
    if (_configModel.user == null) {
      return {
        'success': false,
        'message': 'Please login to subscribe for notifications.'
      };
    }

    try {
      final body = {
        'user_id': _configModel.user!.id,
        'product_id': productId,
        'product_pack_id': productPackId,
        'qty': qty,
      };

      http.Response _response = await http.post(
        Uri.parse('${_apiConfig['baseURL']}/product_notifications'),
        body: json.encode(body),
        headers: _apiConfig['headers'],
      );

      Map<String, dynamic> _responseData = json.decode(_response.body);

      if (_response.statusCode >= 200 && _response.statusCode < 300) {
        return {
          'success': true,
          'message': _responseData['message'] ?? 'Notification request saved.'
        };
      } else {
        return {
          'success': false,
          'message': _responseData['message'] ?? 'Failed to save request.'
        };
      }
    } catch (e) {
      print('Error storing notification: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }
}

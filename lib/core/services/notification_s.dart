import 'dart:convert';

import 'package:aadab/core/models/notification.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final ConfigModel _configModel = locator<ConfigModel>();
  List<MyNotification> _notifications = [];

  getMyNotifications() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var userId = _configModel.user!.id;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/notifications?userId=$userId'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _notifications = [];
      _responseData['data'].forEach((data) {
        _notifications.add(MyNotification.fromJson(data));
      });
    }
    print('user notification: ${_notifications.first.toJson()}');
    return _notifications;
  }
}

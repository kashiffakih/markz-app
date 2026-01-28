import 'dart:convert';

import 'package:aadab/core/models/notification.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final ConfigModel _configModel = locator<ConfigModel>();
  List<MyNotification> _notifications = [];

  int unreadCount = 0;
  int adminUnreadCount = 0;
  int systemUnreadCount = 0;

  getMyNotifications({String? sendBy}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    if (_configModel.user == null) {
      return <MyNotification>[];
    }

    var userId = _configModel.user!.id;
    String url = '${_apiConfig['baseURL']}/notifications?userId=$userId';

    if (sendBy != null) {
      url += '&send_by=$sendBy';
    }

    http.Response _response = await http.get(
      Uri.parse(url),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _notifications = [];
      if (_responseData['unread_count'] != null) {
        unreadCount = _responseData['unread_count'];
      }
      _responseData['data'].forEach((data) {
        _notifications.add(MyNotification.fromJson(data));
      });
    }
    return _notifications;
  }

  /// Fetch separate unread counts for Admin and System notifications
  fetchUnreadCounts() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    if (_configModel.user == null) return;

    var userId = _configModel.user!.id;

    // Fetch Admin count
    try {
      http.Response adminResponse = await http.get(
        Uri.parse(
            '${_apiConfig['baseURL']}/notifications?userId=$userId&send_by=Admin'),
        headers: _apiConfig['headers'],
      );
      Map<String, dynamic> adminData = json.decode(adminResponse.body);
      if (adminData['success'] && adminData['unread_count'] != null) {
        adminUnreadCount = adminData['unread_count'];
      }
    } catch (e) {
      print("Error fetching admin count: $e");
    }

    // Fetch System count
    try {
      http.Response systemResponse = await http.get(
        Uri.parse(
            '${_apiConfig['baseURL']}/notifications?userId=$userId&send_by=System'),
        headers: _apiConfig['headers'],
      );
      Map<String, dynamic> systemData = json.decode(systemResponse.body);
      if (systemData['success'] && systemData['unread_count'] != null) {
        systemUnreadCount = systemData['unread_count'];
      }
    } catch (e) {
      print("Error fetching system count: $e");
    }
  }

  markAllAsSeen({String? sendBy}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    if (_configModel.user == null) return;

    var userId = _configModel.user!.id;
    Map<String, dynamic> body = {'user_id': userId};
    if (sendBy != null) {
      body['send_by'] = sendBy;
    }

    try {
      final response = await http.post(
        Uri.parse('${_apiConfig['baseURL']}/notifications/mark_all_seen'),
        body: json.encode(body),
        headers: _apiConfig['headers'],
      );

      if (json.decode(response.body)['success']) {
        if (sendBy == 'Admin') {
          adminUnreadCount = 0;
        } else if (sendBy == 'System') {
          systemUnreadCount = 0;
        } else {
          unreadCount = 0;
          adminUnreadCount = 0;
          systemUnreadCount = 0;
        }
      }
    } catch (e) {
      print("Error marking seen: $e");
    }
  }
}

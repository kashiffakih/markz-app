import 'package:flutter/material.dart';
import 'package:aadab/core/models/notification.dart';
import 'package:aadab/core/services/notification_s.dart';
import 'package:aadab/locator.dart';

class NotificationModel with ChangeNotifier {
  final NotificationService _notificationService =
      locator<NotificationService>();

  bool notificationLoader = true;

  List<MyNotification>? _notifications;

  set notifications(List<MyNotification>? newNotification) {
    _notifications = newNotification;
    notificationLoader = false;
    notifyListeners();
  }

  List<MyNotification>? get notifications => _notifications;
  getMyNotifications() async {
    notifications = await _notificationService.getMyNotifications();
  }
}

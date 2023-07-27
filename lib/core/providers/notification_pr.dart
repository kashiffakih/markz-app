import 'package:flutter/material.dart';
import 'package:sales_app/core/models/notification.dart';
import 'package:sales_app/core/services/notification_s.dart';
import 'package:sales_app/locator.dart';

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

import 'package:flutter/material.dart';
import 'package:aadab/core/services/product_notification_s.dart';
import 'package:aadab/locator.dart';

class ProductNotificationModel extends ChangeNotifier {
  final ProductNotificationService _notificationService =
      locator<ProductNotificationService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> storeNotification({
    required int productId,
    required int productPackId,
    required int qty,
  }) async {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> result = await _notificationService.storeNotification(
      productId: productId,
      productPackId: productPackId,
      qty: qty,
    );

    _isLoading = false;
    notifyListeners();

    return result;
  }
}

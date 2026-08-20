import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineOrderService {
  static const String _offlineOrdersKey = 'offline_orders';

  Future<void> saveFailedOrder(Map<String, dynamic> orderData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> offlineOrders = prefs.getStringList(_offlineOrdersKey) ?? [];
      
      offlineOrders.add(jsonEncode(orderData));
      await prefs.setStringList(_offlineOrdersKey, offlineOrders);
      debugPrint("OfflineOrderService: Failed order saved locally.");
    } catch (e) {
      debugPrint("OfflineOrderService: Error saving failed order: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getFailedOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> offlineOrders = prefs.getStringList(_offlineOrdersKey) ?? [];
      
      return offlineOrders.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint("OfflineOrderService: Error getting failed orders: $e");
      return [];
    }
  }

  Future<void> removeFailedOrder(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> offlineOrders = prefs.getStringList(_offlineOrdersKey) ?? [];
      
      if (index >= 0 && index < offlineOrders.length) {
        offlineOrders.removeAt(index);
        await prefs.setStringList(_offlineOrdersKey, offlineOrders);
        debugPrint("OfflineOrderService: Removed order at index $index.");
      }
    } catch (e) {
      debugPrint("OfflineOrderService: Error removing failed order: $e");
    }
  }
  
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_offlineOrdersKey);
  }
}

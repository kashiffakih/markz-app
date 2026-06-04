import 'package:flutter/material.dart';
import 'package:aadab/core/models/add_to_cart.dart';
import 'package:aadab/core/models/order.dart';
import 'package:aadab/core/services/order_s.dart';
import 'package:aadab/locator.dart';

class OrderModel with ChangeNotifier {
  final OrderService _orderService = locator<OrderService>();

  bool orderLoader = true;

  // List of carts
  Order? _order;

  set order(Order? newOrder) {
    _order = newOrder;
    orderLoader = false;
    notifyListeners();
  }

  Order? get order => _order;

  Future<bool> placedOrder(
      List<AddToCart> cartItems,
      String cartTotal,
      addressId,
      isGift,
      userWalletUsed,
      couponId,
      String paymentOption,
      String deliveryMethod,
      [couponValue,
      gstAmount,
      platformFee,
      gstNumber,
      customDeliveryAmount]) async {
    return await _orderService.placedOrder(
        cartItems,
        cartTotal,
        addressId,
        isGift,
        userWalletUsed,
        couponId,
        paymentOption,
        deliveryMethod,
        couponValue,
        gstAmount,
        platformFee,
        gstNumber,
        customDeliveryAmount);
  }

  List<Order> _orders = [];

  set orders(List<Order> newOrder) {
    _orders = newOrder;
    orderLoader = false;
    notifyListeners();
  }

  List<Order> get orders => _orders;
  getOrder() async {
    debugPrint('OrderModel: Fetching orders...');
    final fetchedOrders = await _orderService.getOrders();
    debugPrint(
        'OrderModel: Received ${fetchedOrders.length} orders from service');
    orders = fetchedOrders;
    debugPrint('OrderModel: Set ${_orders.length} orders in state');
  }

  // Check coupon usage count
  Future<int> getCouponUsageCount(String couponId) async {
    return await _orderService.getCouponUsageCount(couponId);
  }

  // Cancel order
  Future<bool> cancelOrder(int orderId) async {
    return await _orderService.cancelOrder(orderId);
  }
}

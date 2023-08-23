import 'package:flutter/material.dart';
import 'package:sales_app/core/models/add_to_cart.dart';
import 'package:sales_app/core/models/order.dart';
import 'package:sales_app/core/services/order_s.dart';
import 'package:sales_app/locator.dart';

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

  Future<bool> placedOrder(List<AddToCart> cartItems, String cartTotal,
      addressId, isGift, userWalletUsed, couponId,
      [couponValue]) async {
    return await _orderService.placedOrder(cartItems, cartTotal, addressId,
        isGift, userWalletUsed, couponId, couponValue);
  }

  List<Order> _orders = [];

  set orders(List<Order> newOrder) {
    _orders = newOrder;
    orderLoader = false;
    notifyListeners();
  }

  List<Order> get orders => _orders;
  getOrder() async {
    orders = await _orderService.getOrders();
  }
}

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

  Future<bool> placedOrder(List<AddToCart> cartItems, String cartTotal) async {
    return await _orderService.placedOrder(cartItems, cartTotal);
    // notifyListeners();
    // Map<String, dynamic> _response =
    //     await _addToCartService.getAddToCart(productId, type);
    // addToCarts = _response['addToCarts'];
    // cartTotal = _response['cart_total'];
    // return order;
  }
}

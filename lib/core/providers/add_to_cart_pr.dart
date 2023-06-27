import 'package:flutter/material.dart';
import 'package:sales_app/core/models/add_to_cart.dart';
import 'package:sales_app/core/services/add_to_cart_s.dart';
import 'package:sales_app/locator.dart';

class AddToCartModel with ChangeNotifier {
  final AddToCartService _addToCartService = locator<AddToCartService>();

  // Add to Cart loader
  bool addToCartLoader = true;

  // List of carts
  List<AddToCart>? _addToCarts;

  set addToCarts(List<AddToCart>? newAddToCart) {
    _addToCarts = newAddToCart;
    addToCartLoader = false;
    notifyListeners();
  }

  List<AddToCart>? get addToCarts => _addToCarts;

  // List of carts
  String? _cartTotal;

  set cartTotal(String? newCartTotal) {
    _cartTotal = newCartTotal;
    addToCartLoader = false;
    notifyListeners();
  }

  String? get cartTotal => _cartTotal;

  getAddToCart(productId, type, cartData) async {
    // print(cartData.toString());
    Map<String, dynamic> _response =
        await _addToCartService.getAddToCart(productId, type, cartData);
    addToCarts = _response['addToCarts'];
    cartTotal = _response['cart_total'];
  }
}

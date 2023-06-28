import 'package:flutter/material.dart';
import 'package:sales_app/core/models/wish_list.dart';
import 'package:sales_app/core/services/wish_list_s.dart';
import 'package:sales_app/locator.dart';

class WishListModel with ChangeNotifier {
  final WishListService _wishListService = locator<WishListService>();

  bool wishListLoader = true;

  List<WishList>? _wishLists;

  set wishLists(List<WishList>? newWishList) {
    _wishLists = newWishList;
    wishListLoader = false;
    notifyListeners();
  }

  List<WishList>? get wishLists => _wishLists;

  getWishLists(productId) async {
    wishLists = await _wishListService.getWishLists(productId);
  }

  Future<bool> addAllToCart() async {
    return await _wishListService.addAllToCart();
  }
}

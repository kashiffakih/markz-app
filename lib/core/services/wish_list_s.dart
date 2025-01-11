import 'dart:convert';

import 'package:sales_app/core/models/wish_list.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;

class WishListService {
  final ConfigModel _configModel = locator<ConfigModel>();
  List<WishList> _wishLists = [];
  Future<List<WishList>> getWishLists(productId) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var userId = _configModel.user?.id;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/wishlists?userId=$userId&productId=$productId'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _wishLists = [];
      _responseData['data'].forEach((data) {
        _wishLists.add(WishList.fromJson(data));
      });
    }
    return _wishLists;
  }

  Future<bool> addAllToCart() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var userId = _configModel.user!.id;

    bool type = true;
    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/wishlist_to_all_add_to_cart?userId=$userId&type=$type'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);

    return _responseData['success'];
  }
}

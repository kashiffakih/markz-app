import 'dart:convert';

import 'package:aadab/core/models/wish_list.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;

class WishListService {
  final ConfigModel _configModel = locator<ConfigModel>();
  List<WishList> _wishLists = [];
  Future<List<WishList>> getWishLists(productId) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    // Return empty list if user is not logged in
    if (_configModel.user == null) {
      return <WishList>[];
    }

    var userId = _configModel.user!.id;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/wishlists?userId=$userId&productId=$productId'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    // print("wish list ${_responseData['data']}");
    if (_responseData['success'] == true && _responseData['data'] != null) {
      _wishLists = [];
      _responseData['data'].forEach((data) {
        _wishLists.add(WishList.fromJson(data));
      });
    }
    return _wishLists;
  }

  Future<bool> addAllToCart() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    if (_configModel.user == null) {
      return false;
    }
    var userId = _configModel.user!.id;
    var activeRole = _configModel.activeRole; // Get active role

    bool type = true;
    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/wishlist_to_all_add_to_cart?userId=$userId&type=$type&role=$activeRole'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);

    return _responseData['success'];
  }
}

import 'package:sales_app/core/models/add_to_cart.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddToCartService {
  final ConfigModel _configModel = locator<ConfigModel>();
  List<AddToCart> _addToCarts = [];
  Future<Map<String, dynamic>> getAddToCart(productId, [type]) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var userId = _configModel.user.id;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/add_to_cart?userId=$userId&productId=$productId&type=$type'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _addToCarts = [];
      _responseData['data'].forEach((data) {
        _addToCarts.add(AddToCart.fromJson(data));
      });
    }
    String _cartTotal = _responseData['cart_total'].toString();

    return {'addToCarts': _addToCarts, 'cart_total': _cartTotal};
  }
}

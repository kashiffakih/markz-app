import 'package:aadab/core/models/add_to_cart.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddToCartService {
  final ConfigModel _configModel = locator<ConfigModel>();
  List<AddToCart> _addToCarts = [];
  Future<Map<String, dynamic>> getAddToCart(productId, type, [cartData]) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    // Check if user is logged in before proceeding
    if (_configModel.user == null) {
      return {'addToCarts': <AddToCart>[], 'cart_total': '0'};
    }

    var userId = _configModel.user!.id;
    var activeRole = _configModel.activeRole; // Get active role
    // print('type $type');

    // Handle cart data safely
    if (cartData == null) {
      return {'addToCarts': <AddToCart>[], 'cart_total': '0'};
    }

    var kindOfFlower =
        cartData['kindOfFlower'] ?? cartData['kind_of_flower'] ?? '';
    var flavour = (cartData['flavour'] ?? '').toString();
    var writeOnCake = (cartData['writeOnCake'] ?? '').toString();
    var pack = (cartData['pack'] ?? '').toString();
    var points = cartData['points'] ?? 0;
    var productPrice = cartData['product_price'] ?? '';
    var isAddToCart = cartData['is_add_to_cart'] ?? false;
    print('Cart Data $cartData');
    print(
        'userId=$userId&productId=$productId&type=$type&kind_of_flower=$kindOfFlower&flavour=$flavour&write_on_cake=$writeOnCake&pack=$pack&points=$points&product_price=$productPrice&is_add_to_cart=$isAddToCart&role=$activeRole');

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/add_to_cart?userId=$userId&productId=$productId&type=$type&kind_of_flower=$kindOfFlower&flavour=$flavour&write_on_cake=$writeOnCake&pack=$pack&points=$points&product_price=$productPrice&is_add_to_cart=$isAddToCart&role=$activeRole'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    print('Add to cart $_responseData');
    if (_responseData['success']) {
      _addToCarts = [];
      _responseData['data'].forEach((data) {
        _addToCarts.add(AddToCart.fromJson(data));
      });
    }
    String _cartTotal = _responseData['cart_total'].toString();

    return {'addToCarts': _addToCarts, 'cart_total': _cartTotal};
    // return cartData;
  }
}

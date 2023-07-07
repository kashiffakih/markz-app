import 'dart:convert';

import 'package:sales_app/core/models/add_to_cart.dart';
import 'package:sales_app/core/models/order.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final ConfigModel _configModel = locator<ConfigModel>();

  Future<bool> placedOrder(List<AddToCart> cartItems, String cartTotal,
      [addressId]) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    print(addressId);
    var orderDetails = [];
    cartItems.forEach((item) {
      orderDetails.add({
        'cashback': 0,
        'order_detail_cost': item.product!.productPrices![0].price,
        'product_id': item.productId,
        'quantity': item.qty,
        'product_pack': item.pack != null ? item.pack : '1 Kg',
        'kind_of_flower': item.kindOfFlower,
        'flavour': item.flavour,
        'write_on_cake': item.writeOnCake,
      });
    });

    Order order = Order(
        couponAmount: 0,
        couponId: null,
        deliveryAmount: double.parse(
            _configModel.user.companies![0].deliveryCharges.toString()),
        details: '-',
        isApprovedByHotelier: 0,
        orderCost: int.parse(cartTotal),
        packagingAmount: _configModel.user.companies![0].packagingCharges,
        taxAmount: double.parse(cartTotal) /
            100 *
            double.parse(_configModel.user.companies![0].taxPercent.toString()),
        taxPercent: _configModel.user.companies![0].taxPercent.toString(),
        tipAmount: 0,
        totalAmount: double.parse(((double.parse(cartTotal)) +
                (double.parse(cartTotal) /
                    100 *
                    double.parse(
                        _configModel.user.companies![0].taxPercent.toString())))
            .toString()),
        totalCashback: 0,
        walletAmountUsed: 0,
        userId: _configModel.user.id,
        isDelivered: 0,
        isDeliveryBoyAccepted: 0,
        isDinein: 0,
        storePayableAmount: 0,
        comissionAmount: 0,
        paymentmode: 'cashondelivery',
        addressId: int.parse(addressId.toString()));

    var _orderJson = order.toJson();
    _orderJson['order_details'] = orderDetails;

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/orders'),
      body: json.encode(_orderJson),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);
    return _responseData['success'];
  }

  List<Order> _orders = [];

  getOrders() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var userId = _configModel.user.id;
    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/orders?userId=$userId'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _orders = [];
      _responseData['data'].forEach((data) {
        _orders.add(Order.fromJson(data));
      });
    }
    return _orders;
  }
}

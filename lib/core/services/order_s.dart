import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:aadab/core/models/add_to_cart.dart';
import 'package:aadab/core/models/order.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Future<bool> placedOrder(
  //   List<AddToCart> cartItems,
  //   String cartTotal,
  //   addressId,
  //   isGift,
  //   userWalletUsed,
  //   couponId,
  //   paymentOption,
  //   deliveryMethod,
  //   couponValue,
  // ) async {
  //   Map<String, dynamic> _apiConfig = _configModel.apiConfig;
  //   if (couponId.toString() == 'null' || couponId == null || couponId == '') {
  //     couponId = '';
  //   }
  //   var orderDetails = [];
  //   cartItems.forEach((item) {
  //     debugPrint("Item pack order s :${item.pack}");
  //     orderDetails.add({
  //       'cashback': item.points,
  //       'order_detail_cost': item.productPrice,
  //       'product_id': item.productId,
  //       'quantity': item.qty,
  //       'product_pack': item.pack,
  //       'kind_of_flower': item.kindOfFlower,
  //       'flavour': item.flavour,
  //       'write_on_cake': item.writeOnCake,
  //     });
  //   });

  //   Order order = Order(
  //       couponAmount: int.parse(couponValue),
  //       couponId: couponId,
  //       deliveryAmount: double.parse(
  //           _configModel.user!.companies![0].deliveryCharges.toString()),
  //       details: '-',
  //       isApprovedByHotelier: 0,
  //       orderCost: int.parse(cartTotal.toString()),
  //       packagingAmount: _configModel.user!.companies![0].packagingCharges,
  //       taxAmount: double.parse(cartTotal) /
  //           100 *
  //           double.parse(
  //               _configModel.user!.companies![0].taxPercent.toString()),
  //       taxPercent: _configModel.user!.companies![0].taxPercent.toString(),
  //       tipAmount: 0,
  //       totalAmount: double.parse(((double.parse(cartTotal)) +
  //               (double.parse(cartTotal) /
  //                   100 *
  //                   double.parse(_configModel.user!.companies![0].taxPercent
  //                       .toString())))
  //           .toString()),
  //       totalCashback: 0,
  //       walletAmountUsed: double.parse(userWalletUsed.toString()).toInt(),
  //       userId: _configModel.user!.id,
  //       isDelivered: 0,
  //       isDeliveryBoyAccepted: 0,
  //       isDinein: 0,
  //       storePayableAmount: 0,
  //       comissionAmount: 0,
  //       paymentmode: paymentOption.toString(),
  //       isGift: isGift,
  //       deliveryMethod: deliveryMethod.toString(),
  //       addressId: int.parse(addressId.toString()));

  //   var _orderJson = order.toJson();
  //   _orderJson['order_details'] = orderDetails;
  //   http.Response _response = await http.post(
  //     Uri.parse('${_apiConfig['baseURL']}/orders'),
  //     body: json.encode(_orderJson),
  //     headers: _apiConfig['headers'],
  //   );
  //   Map<String, dynamic> _responseData = json.decode(_response.body);
  //   print('Place order: $_responseData');
  //   // print(_responseData['success']);
  //   return _responseData['success'];
  // }

  Future<bool> placedOrder(
    List<AddToCart> cartItems,
    String cartTotal,
    addressId,
    isGift,
    userWalletUsed,
    couponId,
    paymentOption,
    deliveryMethod,
    couponValue,
  ) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    // Ensure `couponId` is not null or 'null'
    if (couponId == null ||
        couponId.toString().trim().isEmpty ||
        couponId.toString() == 'null') {
      couponId = '';
    }

    var orderDetails = cartItems.map((item) {
      debugPrint("Item pack order s :${item.pack}");
      return {
        'cashback': item.points,
        'order_detail_cost': item.productPrice,
        'product_id': item.productId,
        'quantity': item.qty,
        'product_pack': item.pack,
        'kind_of_flower': item.kindOfFlower,
        'flavour': item.flavour,
        'write_on_cake': item.writeOnCake,
      };
    }).toList();

    // Safe Parsing to avoid exceptions
    int parsedCouponAmount = int.tryParse(couponValue.toString()) ?? 0;
    int parsedCartTotal = int.tryParse(cartTotal.toString()) ?? 0;
    int parsedAddressId = int.tryParse(addressId.toString()) ?? 0;
    int parsedGst = (5 * parsedCartTotal / 100).toInt() ?? 0;
    double parsedDeliveryAmount = double.tryParse(
            _configModel.user?.companies?[0].deliveryCharges?.toString() ??
                '0') ??
        0.0;
    double parsedTaxPercent = double.tryParse(
            _configModel.user?.companies?[0].taxPercent?.toString() ?? '0') ??
        0.0;
    double parsedTaxAmount = (parsedCartTotal / 100) * parsedTaxPercent;
    int parsedWalletAmountUsed =
        double.tryParse(userWalletUsed.toString())?.toInt() ?? 0;

    double parsedTotalAmount = (parsedCartTotal + parsedTaxAmount + parsedGst);

    Order order = Order(
      couponAmount: parsedCouponAmount,
      couponId: couponId,
      deliveryAmount: parsedDeliveryAmount,
      details: '-',
      isApprovedByHotelier: 0,
      orderCost: parsedCartTotal,
      packagingAmount: _configModel.user?.companies?[0].packagingCharges ?? 0,
      taxAmount: parsedTaxAmount,
      taxPercent: parsedTaxPercent.toString(),
      tipAmount: 0,
      totalAmount: parsedTotalAmount,
      totalCashback: 0,
      walletAmountUsed: parsedWalletAmountUsed,
      userId: _configModel.user?.id ?? 0,
      isDelivered: 0,
      isDeliveryBoyAccepted: 0,
      isDinein: 0,
      storePayableAmount: 0,
      comissionAmount: 0,
      paymentmode: paymentOption.toString(),
      isGift: isGift,
      deliveryMethod: deliveryMethod.toString(),
      addressId: parsedAddressId,
    );

    var _orderJson = order.toJson();
    _orderJson['order_details'] = orderDetails;

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/orders'),
      body: json.encode(_orderJson),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    print('Place order: $_responseData');

    return _responseData['success'] ?? false;
  }

  List<Order> _orders = [];

  getOrders() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var userId = _configModel.user!.id;
    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/orders?userId=$userId'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _orders = [];
      _responseData['data'].forEach((data) {
        _orders.add(Order.fromJson(data));

        print(data);
        // debugPrint("gt orders data${data}");
      });
    }
    debugPrint(
        "gt orders----------${_orders.first.orderDetails?.first.product?.productImages?.first.imagepath}");
    return _orders;
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sales_app/core/models/my_order.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/core/models/order.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';

class MyOrderService {
  final ConfigModel _configModel = locator<ConfigModel>();

  saveOrder({required MyOrder? order, required var orderType, date}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    order!.orderType = orderType;

    print('Date');
    print(date);

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/orders?date=$date'),
      body: json.encode(order),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);
  }

  updatePreviousOrder({@required Order? order}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    // print(order.toJson());

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/orders'),
      body: json.encode(order!.toJson()),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);
  }
}

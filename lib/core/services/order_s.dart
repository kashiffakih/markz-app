import 'dart:convert';

import 'package:sales_app/core/models/order.dart';
import 'package:sales_app/core/models/reason.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class OrderService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // List of reasons
  late List<Reason> _reasons;

  Future<List<Reason>> getReasons() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/reasons'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);

    if (_responseData['success']) {
      _reasons = [];
      _responseData['data'].forEach((order) {
        _reasons.add(Reason.fromJson(order));
      });
    }

    return _reasons;
  }

  // List of orders of today
  List<Order> _orders = [];

  Future<List<Order>> fetchOrdersOfToday({@required date}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    User user = _configModel.user;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/orders?userId=${user.id}&date=$date'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);

    print(_responseData['data']);

    if (_responseData['success']) {
      _orders = [];
      _responseData['data'].forEach((order) {
        _orders.add(Order.fromJson(order));
      });
    }

    return _orders;
  }
}

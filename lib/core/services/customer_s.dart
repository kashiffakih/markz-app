import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sales_app/core/models/customer.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CustomerService {
  final ConfigModel _configModel = locator<ConfigModel>();

  List<Customer>? _customers;

  getCustomers() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    int? userId = _configModel.user.id;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/customers?userid=$userId&app=YES'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);
    if (_responseData['success']) {
      _customers = [];
      _responseData['data'].forEach((_notice) {
        _customers!.add(Customer.fromJson(_notice));
      });
    }

    print(_customers);

    return _customers;
  }

  customerCreate({@required Customer? customer}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    User user = _configModel.user;

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    customer!.companyId = _apiConfig['headers']['company-id'];
    customer.date = dateFormat.format(DateTime.now());
    customer.userId = user.id;
    print(customer.toJson());

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/customers'),
      body: json.encode(customer.toJson()),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    
  }
}

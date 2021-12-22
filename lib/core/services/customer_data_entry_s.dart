import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sales_app/core/models/customer.dart';
import 'package:sales_app/core/models/customer_data_entry.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CustomerDataEntryService {
  final ConfigModel _configModel = locator<ConfigModel>();

  List<CustomerDataEntry>? _customerDataEntries;

  getCustomerDataEntries() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    int? userId = _configModel.user.id;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/customer_data_entries?userid=$userId'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);
    if (_responseData['success']) {
      _customerDataEntries = [];
      _responseData['data'].forEach((_customerDataEntry) {
        _customerDataEntries!
            .add(CustomerDataEntry.fromJson(_customerDataEntry));
      });
    }

    print(_customerDataEntries);

    return _customerDataEntries;
  }

  customerDataEntryCreate(
      {@required CustomerDataEntry? customerDataEntry}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    User user = _configModel.user;

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    customerDataEntry!.companyId = _apiConfig['headers']['company-id'];
    customerDataEntry.userId = user.id;
    print(customerDataEntry.toJson());

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/customer_data_entries'),
      body: json.encode(customerDataEntry.toJson()),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);
  }
}

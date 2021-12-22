import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/models/visitor.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;

class VisitorService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Get Visitors
  late List<Visitor> _visitors;

  Future<List<Visitor>> getVisitors({@required retailerId}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var month = DateTime.now().month;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/visitors?retailerId=$retailerId&month=$month'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _visitors = [];
      _responseData['data'].forEach((_visitor) {
        _visitors.add(Visitor.fromJson(_visitor));
      });
    }

    return _visitors;
  }

  // Create visitor
  visitorCreate({@required Visitor? visitor}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    User user = _configModel.user;

    visitor!.userId = user.id;

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/visitors'),
      body: json.encode(visitor.toJson()),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);
  }

  // Single Visitor
  Future<Visitor> visitorId({@required int? visitorId}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    User user = _configModel.user;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/visitors/$visitorId'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);

    return Visitor.fromJson(_responseData['data']);
  }

  // Update Visitor
  visitorUpdate({@required Visitor? visitor}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    User user = _configModel.user;

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/visitors'),
      body: json.encode(visitor!.toJson()),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);
  }
}

import 'dart:convert';

import 'package:sales_app/core/models/requisition.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RequistionService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Get Requistions
  late List<Requisition> _requisitions;

  Future<List<Requisition>> getRequisitions() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/requisitions'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _requisitions = [];
      _responseData['data'].forEach((_requisition) {
        _requisitions.add(Requisition.fromJson(_requisition));
      });
    }

    return _requisitions;
  }

  // Create requisition
  requisitionCreate({@required Requisition? requisition}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    User user = _configModel.user;

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/requisitions?userId=${user.id}'),
      body: json.encode(requisition!.toJson()),
      headers: _apiConfig['headers'],
    );
  }

  // Single Requisition
  Future<Requisition> requisitionId({@required int? requisitionId}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    User user = _configModel.user;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/requisitions/$requisitionId'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);

    return Requisition.fromJson(_responseData['data']);
  }

  // Update Requisition
  requisitionUpdate({@required Requisition? requisition}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    User user = _configModel.user;

    await http.patch(
      Uri.parse('${_apiConfig['baseURL']}/requistions/${requisition!.id}'),
      body: json.encode(requisition.toJson()),
      headers: _apiConfig['headers'],
    );
  }
}

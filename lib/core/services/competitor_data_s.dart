import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sales_app/core/models/competitor_data.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CompetitorDataService {
  final ConfigModel _configModel = locator<ConfigModel>();

  List<CompetitorData>? _competitorData;

  getCompetitorDatas() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    int? userId = _configModel.user.id;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/competitor_datas?userid=$userId'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);
    if (_responseData['success']) {
      _competitorData = [];
      _responseData['data'].forEach((_notice) {
        _competitorData!.add(CompetitorData.fromJson(_notice));
      });
    }

    print(_competitorData);

    return _competitorData;
  }

  competitorDataCreate({@required CompetitorData? competitorData}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    User user = _configModel.user;

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    competitorData!.companyId = _apiConfig['headers']['company-id'];
    competitorData.userId = user.id;
    print(competitorData.toJson());

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/competitor_datas'),
      body: json.encode(competitorData.toJson()),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);
  }
}

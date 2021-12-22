import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sales_app/core/models/reference_plan.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/locator.dart';
import 'package:flutter/material.dart';

class ReferencePlanService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Get reference plans
  late List<ReferencePlan> _referencePlans;

  int weekNumber() {
    DateTime date = DateTime.now();
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  Future<List<ReferencePlan>> getReferencePlans() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    User user = _configModel.user;

    int weekNo = weekNumber();
    int day = DateTime.now().weekday;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/reference_plans?userId=${user.id}&weekNo=$weekNo&day=$day'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);

    if (_responseData['success']) {
      _referencePlans = [];
      _responseData['data'].forEach((_referencePlan) {
        _referencePlans.add(ReferencePlan.fromJson(_referencePlan));
      });
    }

    return _referencePlans;
  }

  // Add retailer image
  addRetailerImage(
      {@required Retailers? retailer, @required lat, @required lng}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${_apiConfig['baseURL']}/upload_retailer_image'),
    )
      ..fields['retailerid'] = retailer!.id.toString()
      ..fields['filename'] = _configModel.file.fileName.toString()
      ..fields['lat'] = lat
      ..fields['lng'] = lng
      ..files.add(
        await http.MultipartFile.fromPath(
          'imagepath',
          _configModel.file.file.toString(),
        ),
      )
      ..headers.addAll(_apiConfig['headers']);
    http.StreamedResponse _response = await request.send();
    var response = await http.Response.fromStream(_response);
    print(response.body);
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sales_app/core/models/daily_photo.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;

class DailyPhotoService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Get DailyPhoto
  List<DailyPhoto>? _dailyPhotos;

  getDailyPhotos({@required date}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    int? userId = _configModel.user.id;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/daily_photos?date=$date&userId=$userId'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _dailyPhotos = [];
      _responseData['data'].forEach((_notice) {
        _dailyPhotos!.add(DailyPhoto.fromJson(_notice));
      });
    }

    return _dailyPhotos;
  }

  dailyPhotoCreate({@required DailyPhoto? dailyPhoto}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    User user = _configModel.user;

    dailyPhoto!.userId = user.id;
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    dailyPhoto.date = dateFormat.format(DateTime.now());

    print(_configModel.file.file);
    print(dailyPhoto.date);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${_apiConfig['baseURL']}/daily_photos'),
    )
      ..fields['user_id'] = dailyPhoto.userId.toString()
      ..fields['date'] = dailyPhoto.date ?? ''
      ..fields['description'] = dailyPhoto.description ?? ''
      ..fields['filename'] = _configModel.file.fileName ?? ''
      ..files.add(
        await http.MultipartFile.fromPath(
          'imagepath',
          _configModel.file.file.toString(),
        ),
      )
      ..headers.addAll(_apiConfig['headers']);
    http.StreamedResponse _response = await request.send();
    var response = await http.Response.fromStream(_response);

    // _configModel.file = null;
    print(123);
    print(response.body);
  }
}

import 'dart:convert';

import 'package:sales_app/core/models/notice.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;

class NoticeService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Notice
  late List<Notice> _notices;

  getNotices() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/notices'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _notices = [];
      _responseData['data'].forEach((_notice) {
        _notices.add(Notice.fromJson(_notice));
      });
    }

    return _notices;
  }
}

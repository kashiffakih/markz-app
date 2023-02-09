import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sales_app/core/models/attendance_calendar.dart';
import 'package:sales_app/core/models/kpi_report.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnalyticsService {
  final ConfigModel _configModel = locator<ConfigModel>();

  int weekNumber() {
    DateTime date = DateTime.now();
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  // KPI Report
  late KpiReport _kpiReport;

  kpiReport({@required month}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    User user = _configModel.user;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/kpiReport?userId=${user.id}&month=$month'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _kpiReport = KpiReport.fromJson(_responseData['data']);
    }

    return _kpiReport;
  }

  List? _achievedDatas;

  getFocussedReport({@required month}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    User user = _configModel.user;

    print(user.id);

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/focussedKpiReport?userId=${user.id}&month=$month'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _achievedDatas = _responseData['data'];
    }

    return _achievedDatas;
  }

  // Attendance Calendar
  late AttendanceCalendar _attendanceCalendar;

  attendanceCalendar({@required month}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    User user = _configModel.user;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/attendanceCalendar?userId=${user.id}&month=$month'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);

    if (_responseData['success']) {
      _attendanceCalendar = AttendanceCalendar.fromJson(_responseData['data']);
    }

    return _attendanceCalendar;
  }
}

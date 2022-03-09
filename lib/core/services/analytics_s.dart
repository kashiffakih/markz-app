import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sales_app/core/models/attendance_calendar.dart';
import 'package:sales_app/core/models/billed_outlet.dart';
import 'package:sales_app/core/models/day_summary.dart';
import 'package:sales_app/core/models/invoice_detail.dart';
import 'package:sales_app/core/models/kpi_report.dart';
import 'package:sales_app/core/models/sales_trend.dart';
import 'package:sales_app/core/models/target_vs_achieved.dart';
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

  // Day Summary
  late DaySummary _daySummary;

  daySummary({@required date}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    User user = _configModel.user;

    int weekNo = weekNumber();
    int day = DateTime.now().weekday;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/daySummary?userId=${user.id}&date=$date&weekNo=$weekNo&day=$day'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _daySummary = DaySummary.fromJson(_responseData['data']);
    }

    return _daySummary;
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

  // Target Vs Achieved
  late TargetVsAchieved _targetVsAchieved;

  targetVsAchieved({@required month, @required beatIds}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    User user = _configModel.user;

    String beatIdsString = beatIds.join(', ');

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/targetVsAchieved?userId=${user.id}&month=$month&beatIds=$beatIdsString'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _targetVsAchieved = TargetVsAchieved.fromJson(_responseData['data']);
    }

    return _targetVsAchieved;
  }

  // Sales Trend
  late SalesTrend _salesTrend;

  salesTrend({@required month, @required beatIds}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    User user = _configModel.user;

    String beatIdsString = beatIds.join(', ');

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/salesTrend?userId=${user.id}&month=$month&beatIds=$beatIdsString'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _salesTrend = SalesTrend.fromJson(_responseData['data']);
    }

    return _salesTrend;
  }

  // Billed Outlets
  late BilledOutlet _billedOutlet;

  billedOutlet({@required month, @required beatIds}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    User user = _configModel.user;

    String beatIdsString = beatIds.join(', ');

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/billedOutlet?userId=${user.id}&month=$month&beatIds=$beatIdsString'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _billedOutlet = BilledOutlet.fromJson(_responseData['data']);
    }

    return _billedOutlet;
  }

  // Invoice Details
  late InvoiceDetail _invoiceDetail;

  invoiceDetail({@required month}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    User user = _configModel.user;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/invoiceDetail?userId=${user.id}&month=$month'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _invoiceDetail = InvoiceDetail.fromJson(_responseData['data']);
    }

    return _invoiceDetail;
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

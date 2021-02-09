import 'dart:convert';

import 'package:sales_app/core/models/user_attendance.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AttendanceService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Get Session Types
  List<String> _sessionTypes = [];
  Future<List<String>> getSessionTypes() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      '${_apiConfig['baseURL']}/user_attendances/masters',
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);

    if (_responseData['session_types'] != null) {
      _sessionTypes = [];
      _responseData['session_types'].forEach(
        (_sessionType) => _sessionTypes.add(_sessionType),
      );
    }
    return _sessionTypes;
  }

  // Save Attendance
  Future<void> saveAttendance({@required attendanceData}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    await http.post(
      '${_apiConfig['baseURL']}/user_attendances',
      headers: _apiConfig['headers'],
      body: json.encode(attendanceData),
    );
  }

  // Update Attendance
  Future<void> updateAttendance({@required attendanceData}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    await http.patch(
      '${_apiConfig['baseURL']}/user_attendances/${attendanceData['id']}',
      headers: _apiConfig['headers'],
      body: json.encode(attendanceData),
    );
  }

  // Get attendance of a day
  UserAttendance _userAttendance;

  Future<UserAttendance> getAttendance({@required date}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      '${_apiConfig['baseURL']}/user_attendances?date=$date',
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);

    if (_responseData['success']) {
      if (_responseData['data'].length > 0)
        _userAttendance = UserAttendance.fromJson(_responseData['data'][0]);
    }

    return _userAttendance;
  }
}

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
      Uri.parse('${_apiConfig['baseURL']}/user_attendances/masters'),
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
  Future<int> saveAttendance({@required attendanceData}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    print(attendanceData);

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/user_attendances'),
      headers: _apiConfig['headers'],
      body: json.encode(attendanceData),
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);

    return _responseData['data']['id'];
  }

  // Update Attendance
  Future<int> updateAttendance({@required attendanceData}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.patch(
      Uri.parse(
          '${_apiConfig['baseURL']}/user_attendances/${attendanceData['id']}'),
      headers: _apiConfig['headers'],
      body: json.encode(attendanceData),
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);

    return _responseData['data']['id'];
  }

  // Get attendance of a day
  late UserAttendance _userAttendance;

  Future<UserAttendance> getAttendance({@required date}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    String userId = _configModel.user.id.toString();

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/user_attendances?date=$date&userId=$userId'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);

    print(_responseData);

    if (_responseData['success']) {
      if (_responseData['data'].length > 0)
        _userAttendance = UserAttendance.fromJson(_responseData['data'][0]);
    }

    return _userAttendance;
  }

  // Add Attendance Selfie
  addUserAttendanceImage({required int userAttendanceId}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    print(_configModel.file.file);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${_apiConfig['baseURL']}/upload_user_attendance_selfie_image'),
    )
      ..fields['userAttendanceId'] = userAttendanceId.toString()
      ..fields['filename'] = _configModel.file.fileName.toString()
      ..files.add(
        await http.MultipartFile.fromPath(
          'imagepath',
          _configModel.file.file.toString(),
        ),
      )
      ..headers.addAll(_apiConfig['headers']);
    http.StreamedResponse _response = await request.send();
    var response = await http.Response.fromStream(_response);
    print(response);
  }

  // Add Attendance Selfie
  addUserAttendanceLogoutImage({required int userAttendanceId}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    print(_configModel.file.file);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '${_apiConfig['baseURL']}/upload_user_attendance_logout_selfie_image'),
    )
      ..fields['userAttendanceId'] = userAttendanceId.toString()
      ..fields['filename'] = _configModel.file.fileName.toString()
      ..files.add(
        await http.MultipartFile.fromPath(
          'imagepath',
          _configModel.file.file.toString(),
        ),
      )
      ..headers.addAll(_apiConfig['headers']);
    http.StreamedResponse _response = await request.send();
    var response = await http.Response.fromStream(_response);
    print(response);
  }
}

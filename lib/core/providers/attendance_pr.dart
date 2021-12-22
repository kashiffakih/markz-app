import 'package:flutter/material.dart';
import 'package:sales_app/core/models/file.dart';
import 'package:sales_app/core/models/user_attendance.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/services/attendance_s.dart';
import 'package:sales_app/locator.dart';

class AttendanceModel with ChangeNotifier {
  final _attendanceService = locator<AttendanceService>();
  final ConfigModel _configModel = locator<ConfigModel>();

  // Get Session types
  List<String> _sessionTypes = [];

  set sessionTypes(List<String> newSessionTypes) {
    _sessionTypes = newSessionTypes;
    notifyListeners();
  }

  List<String> get sessionTypes => _sessionTypes;

  Future<void> getSessionTypes() async {
    sessionTypes = await _attendanceService.getSessionTypes();
  }

  // Save Attendance
  void saveAttendance({@required attendanceData}) async {
    int _userAttendanceId = await _attendanceService.saveAttendance(
      attendanceData: attendanceData,
    );
    addUserAttendanceImage(userAttendanceId: _userAttendanceId);
  }

  // Update Attendance
  void updateAttendance({@required attendanceData}) async {
    int _userAttendanceId = await _attendanceService.updateAttendance(
      attendanceData: attendanceData,
    );
    addUserAttendanceLogoutImage(userAttendanceId: _userAttendanceId);
  }

  // Get attendance of a day
  UserAttendance? _todayAttendance;

  set todayAttendance(UserAttendance? newTodayAttendance) {
    _todayAttendance = newTodayAttendance;
    notifyListeners();
  }

  UserAttendance? get todayAttendance => _todayAttendance;
  Future<void> getAttendance({@required date}) async {
    todayAttendance = null;
    todayAttendance = await _attendanceService.getAttendance(
      date: date,
    );
    print('Today');
    print(todayAttendance);
  }

  // Add Attendance Selfie
  addUserAttendanceImage({required int userAttendanceId}) async {
    await _attendanceService.addUserAttendanceImage(
      userAttendanceId: userAttendanceId,
    );
    _configModel.file = File();
    notifyListeners();
  }

  // Add Attendance Logout Selfie
  addUserAttendanceLogoutImage({required int userAttendanceId}) async {
    await _attendanceService.addUserAttendanceLogoutImage(
      userAttendanceId: userAttendanceId,
    );
    _configModel.file = File();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:sales_app/core/models/user_attendance.dart';
import 'package:sales_app/core/services/attendance_s.dart';
import 'package:sales_app/locator.dart';

class AttendanceModel with ChangeNotifier {
  final _attendanceService = locator<AttendanceService>();

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
  void saveAttendance({@required attendanceData}) {
    _attendanceService.saveAttendance(
      attendanceData: attendanceData,
    );
  }

  // Update Attendance
  void updateAttendance({@required attendanceData}) {
    _attendanceService.updateAttendance(
      attendanceData: attendanceData,
    );
  }

  // Get attendance of a day
  UserAttendance _todayAttendance;

  set todayAttendance(UserAttendance newTodayAttendance) {
    _todayAttendance = newTodayAttendance;
    notifyListeners();
  }

  UserAttendance get todayAttendance => _todayAttendance;
  Future<void> getAttendance({@required date}) async {
    todayAttendance = null;
    todayAttendance = await _attendanceService.getAttendance(
      date: date,
    );
  }
}

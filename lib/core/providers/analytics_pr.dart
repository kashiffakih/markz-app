import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_app/core/models/attendance_calendar.dart';
import 'package:sales_app/core/models/kpi_report.dart';
import 'package:sales_app/core/services/analytics_s.dart';
import 'package:sales_app/locator.dart';

class AnalyticsModel with ChangeNotifier {
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  // KPI Report
  late KpiReport _kpiReport = KpiReport();

  set kpiReport(KpiReport newKpiReport) {
    _kpiReport = newKpiReport;
    notifyListeners();
  }

  KpiReport get kpiReport => _kpiReport;

  getKpiReport() async {
    DateFormat format = DateFormat('MM');
    String month = format.format(DateTime.now());

    kpiReport = await _analyticsService.kpiReport(month: month);
  }

  // Attendance Calendar
  late AttendanceCalendar _attendanceCalendar = AttendanceCalendar();

  set attendanceCalendar(AttendanceCalendar newAttendanceCalendar) {
    _attendanceCalendar = newAttendanceCalendar;
    notifyListeners();
  }

  AttendanceCalendar get attendanceCalendar => _attendanceCalendar;

  getAttendanceCalendar() async {
    DateFormat format = DateFormat('MM');
    String month = format.format(DateTime.now());

    attendanceCalendar =
        await _analyticsService.attendanceCalendar(month: month);
  }
}

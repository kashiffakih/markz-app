import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_app/core/models/attendance_calendar.dart';
import 'package:sales_app/core/models/billed_outlet.dart';
import 'package:sales_app/core/models/day_summary.dart';
import 'package:sales_app/core/models/invoice_detail.dart';
import 'package:sales_app/core/models/kpi_report.dart';
import 'package:sales_app/core/models/reference_plan.dart';
import 'package:sales_app/core/models/sales_trend.dart';
import 'package:sales_app/core/models/target_vs_achieved.dart';
import 'package:sales_app/core/services/analytics_s.dart';
import 'package:sales_app/core/services/reference_plan_s.dart';
import 'package:sales_app/locator.dart';

class AnalyticsModel with ChangeNotifier {
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final ReferencePlanService _referencePlanService =
      locator<ReferencePlanService>();

  // Day Summary
  late DaySummary _daySummary;

  set daySummary(DaySummary newDaySummary) {
    _daySummary = newDaySummary;
    notifyListeners();
  }

  DaySummary get daySummary => _daySummary;

  getDaySummary() async {
    DateFormat format = DateFormat('yyyy-MM-dd');
    String date = format.format(DateTime.now());

    daySummary = await _analyticsService.daySummary(date: date);
  }

  // MonthlySummary

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

  // Target Vs Achieved
  late TargetVsAchieved _targetVsAchieved;

  set targetVsAchieved(TargetVsAchieved newTargetVsAchieved) {
    _targetVsAchieved = newTargetVsAchieved;
    notifyListeners();
  }

  TargetVsAchieved get targetVsAchieved => _targetVsAchieved;

  getTargetVsAchieved() async {
    DateFormat format = DateFormat('MM');
    String month = format.format(DateTime.now());

    List<ReferencePlan> _referencePlans =
        await _referencePlanService.getReferencePlans();

    final beatIds =
        _referencePlans.map((_referencePlan) => _referencePlan.id).toList();

    targetVsAchieved = await _analyticsService.targetVsAchieved(
      month: month,
      beatIds: beatIds,
    );
  }

  // Sales Trend
  SalesTrend? _salesTrend;

  set salesTrend(SalesTrend? newSalesTrend) {
    _salesTrend = newSalesTrend;
    notifyListeners();
  }

  SalesTrend? get salesTrend => _salesTrend;

  getSalesTrend() async {
    DateFormat format = DateFormat('MM');
    String month = format.format(DateTime.now());

    List<ReferencePlan> _referencePlans =
        await _referencePlanService.getReferencePlans();

    final beatIds =
        _referencePlans.map((_referencePlan) => _referencePlan.id).toList();

    salesTrend = await _analyticsService.salesTrend(
      month: month,
      beatIds: beatIds,
    );
  }

  // Billed Oulet
  late BilledOutlet _billedOutlet;

  set billedOutlet(BilledOutlet newBilledOutlet) {
    _billedOutlet = newBilledOutlet;
    notifyListeners();
  }

  BilledOutlet get billedOutlet => _billedOutlet;

  getBilledOutlet() async {
    DateFormat format = DateFormat('MM');
    String month = format.format(DateTime.now());

    List<ReferencePlan> _referencePlans =
        await _referencePlanService.getReferencePlans();

    final beatIds =
        _referencePlans.map((_referencePlan) => _referencePlan.id).toList();

    billedOutlet = await _analyticsService.billedOutlet(
      month: month,
      beatIds: beatIds,
    );
  }

  // Invoice Detail
  late InvoiceDetail _invoiceDetail;

  set invoiceDetail(InvoiceDetail newInvoiceDetail) {
    _invoiceDetail = newInvoiceDetail;
    notifyListeners();
  }

  InvoiceDetail get invoiceDetail => _invoiceDetail;

  getInvoiceDetail() async {
    DateFormat format = DateFormat('MM');
    String month = format.format(DateTime.now());

    invoiceDetail = await _analyticsService.invoiceDetail(month: month);
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

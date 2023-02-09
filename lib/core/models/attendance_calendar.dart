class AttendanceCalendar {
  String? totalWorkedHrsDay;
  String? avgWorkingHrs;
  String? present;
  String? absent;
  String? lessThan5Hrs;
  String? greaterThan5Hrs;
  List<Attendances>? attendances;

  AttendanceCalendar(
      {this.totalWorkedHrsDay,
      this.avgWorkingHrs,
      this.present,
      this.absent,
      this.lessThan5Hrs,
      this.greaterThan5Hrs,
      this.attendances});

  AttendanceCalendar.fromJson(Map<String, dynamic> json) {
    totalWorkedHrsDay = json['total_worked_hrs_day'];
    avgWorkingHrs = json['avg_working_hrs'];
    present = json['present'];
    absent = json['absent'];
    lessThan5Hrs = json['less_than_5_hrs'];
    greaterThan5Hrs = json['greater_than_5_hrs'];
    if (json['attendances'] != null) {
      attendances = [];
      // attendances = new List<Attendances>();
      json['attendances'].forEach((v) {
        attendances!.add(new Attendances.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_worked_hrs_day'] = this.totalWorkedHrsDay;
    data['avg_working_hrs'] = this.avgWorkingHrs;
    data['present'] = this.present;
    data['absent'] = this.absent;
    data['less_than_5_hrs'] = this.lessThan5Hrs;
    data['greater_than_5_hrs'] = this.greaterThan5Hrs;
    if (this.attendances != null) {
      data['attendances'] = this.attendances!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attendances {
  String? date;
  String? status;
  String? color;

  Attendances({this.date, this.status, this.color});

  Attendances.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    status = json['status'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['status'] = this.status;
    data['color'] = this.color;
    return data;
  }
}

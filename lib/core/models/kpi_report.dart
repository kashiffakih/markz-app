class KpiReport {
  int target;
  int achieved;
  int percent;
  List<Days> days;

  KpiReport({this.target, this.achieved, this.percent, this.days});

  KpiReport.fromJson(Map<String, dynamic> json) {
    target = json['target'];
    achieved = json['achieved'];
    percent = json['percent'];
    if (json['days'] != null) {
      days = new List<Days>();
      json['days'].forEach((v) {
        days.add(new Days.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['target'] = this.target;
    data['achieved'] = this.achieved;
    data['percent'] = this.percent;
    if (this.days != null) {
      data['days'] = this.days.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Days {
  String date;
  int achieved;

  Days({this.date, this.achieved});

  Days.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    achieved = json['achieved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['achieved'] = this.achieved;
    return data;
  }
}

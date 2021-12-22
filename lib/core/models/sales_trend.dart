class SalesTrend {
  int? lastMonth;
  int? currentMonth;
  List<Outlets>? outlets;
  List<Months>? months;

  SalesTrend({this.lastMonth, this.currentMonth, this.outlets, this.months});

  SalesTrend.fromJson(Map<String, dynamic> json) {
    lastMonth = json['last_month'];
    currentMonth = json['current_month'];
    if (json['outlets'] != null) {
      outlets = [];
      json['outlets'].forEach((v) {
        outlets!.add(new Outlets.fromJson(v));
      });
    }
    if (json['months'] != null) {
      months = [];
      json['months'].forEach((v) {
        months!.add(new Months.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_month'] = this.lastMonth;
    data['current_month'] = this.currentMonth;
    if (this.outlets != null) {
      data['outlets'] = this.outlets!.map((v) => v.toJson()).toList();
    }
    if (this.months != null) {
      data['months'] = this.months!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Outlets {
  String? outlet;
  int? lastMonth;
  int? currentMonth;

  Outlets({this.outlet, this.lastMonth, this.currentMonth});

  Outlets.fromJson(Map<String, dynamic> json) {
    outlet = json['outlet'];
    lastMonth = json['last_month'];
    currentMonth = json['current_month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['outlet'] = this.outlet;
    data['last_month'] = this.lastMonth;
    data['current_month'] = this.currentMonth;
    return data;
  }
}

class Months {
  String? month;
  int? value;

  Months({this.month, this.value});

  Months.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['value'] = this.value;
    return data;
  }
}

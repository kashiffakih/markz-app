class DaySummary {
  List<String>? beatNames;
  int? totalOutlets;
  int? ordersNotTaken;
  int? ordersTaken;
  int? totalOrderValue;
  Coverage? coverage;
  Coverage? productivity;

  DaySummary(
      {this.beatNames,
      this.totalOutlets,
      this.ordersNotTaken,
      this.ordersTaken,
      this.totalOrderValue,
      this.coverage,
      this.productivity});

  DaySummary.fromJson(Map<String, dynamic> json) {
    beatNames = json['beat_names'].cast<String>();
    totalOutlets = json['total_outlets'];
    ordersNotTaken = json['orders_not_taken'];
    ordersTaken = json['orders_taken'];
    totalOrderValue = json['total_order_value'];
    coverage = json['coverage'] != null
        ? new Coverage.fromJson(json['coverage'])
        : null;
    productivity = json['productivity'] != null
        ? new Coverage.fromJson(json['productivity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beat_names'] = this.beatNames;
    data['total_outlets'] = this.totalOutlets;
    data['orders_not_taken'] = this.ordersNotTaken;
    data['orders_taken'] = this.ordersTaken;
    data['total_order_value'] = this.totalOrderValue;
    if (this.coverage != null) {
      data['coverage'] = this.coverage!.toJson();
    }
    if (this.productivity != null) {
      data['productivity'] = this.productivity!.toJson();
    }
    return data;
  }
}

class Coverage {
  int? percent;
  int? value;
  int? total;

  Coverage({this.percent, this.value, this.total});

  Coverage.fromJson(Map<String, dynamic> json) {
    percent = json['percent'];
    value = json['value'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['percent'] = this.percent;
    data['value'] = this.value;
    data['total'] = this.total;
    return data;
  }
}

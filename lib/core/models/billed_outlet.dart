class BilledOutlet {
  List<Outlets> outlets;
  List<Months> months;

  BilledOutlet({this.outlets, this.months});

  BilledOutlet.fromJson(Map<String, dynamic> json) {
    if (json['outlets'] != null) {
      outlets = new List<Outlets>();
      json['outlets'].forEach((v) {
        outlets.add(new Outlets.fromJson(v));
      });
    }
    if (json['months'] != null) {
      months = new List<Months>();
      json['months'].forEach((v) {
        months.add(new Months.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.outlets != null) {
      data['outlets'] = this.outlets.map((v) => v.toJson()).toList();
    }
    if (this.months != null) {
      data['months'] = this.months.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Outlets {
  String outlet;
  int noOfInv;
  int value;

  Outlets({this.outlet, this.noOfInv, this.value});

  Outlets.fromJson(Map<String, dynamic> json) {
    outlet = json['outlet'];
    noOfInv = json['no_of_inv'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['outlet'] = this.outlet;
    data['no_of_inv'] = this.noOfInv;
    data['value'] = this.value;
    return data;
  }
}

class Months {
  String month;
  int value;

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

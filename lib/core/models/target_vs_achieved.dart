class TargetVsAchieved {
  int? target;
  int? achieved;
  int? percent;
  List<Outlets>? outlets;

  TargetVsAchieved({this.target, this.achieved, this.percent, this.outlets});

  TargetVsAchieved.fromJson(Map<String, dynamic> json) {
    target = json['target'];
    achieved = json['achieved'];
    percent = json['percent'];
    if (json['outlets'] != null) {
      outlets = [];
      json['outlets'].forEach((v) {
        outlets!.add(new Outlets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['target'] = this.target;
    data['achieved'] = this.achieved;
    data['percent'] = this.percent;
    if (this.outlets != null) {
      data['outlets'] = this.outlets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Outlets {
  String? outlet;
  int? achieved;

  Outlets({this.outlet, this.achieved});

  Outlets.fromJson(Map<String, dynamic> json) {
    outlet = json['outlet'];
    achieved = json['achieved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['outlet'] = this.outlet;
    data['achieved'] = this.achieved;
    return data;
  }
}

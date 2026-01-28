class MyNotification {
  int? id;
  Null text;
  String? to;
  String? details;
  String? createdAt;
  String? updatedAt;
  String? title;
  int? sAll;
  int? sApproved;
  int? sEnabled;
  int? uAll;
  int? uDelivery;
  int? uCustomer;
  int? vA;
  int? vNa;
  int? uActive;
  int? uInactive;
  int? userId;
  int? isSeen;
  String? sendBy;

  MyNotification(
      {this.id,
      this.text,
      this.to,
      this.details,
      this.createdAt,
      this.updatedAt,
      this.title,
      this.sAll,
      this.sApproved,
      this.sEnabled,
      this.uAll,
      this.uDelivery,
      this.uCustomer,
      this.vA,
      this.vNa,
      this.uActive,
      this.uInactive,
      this.userId,
      this.isSeen,
      this.sendBy});

  MyNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    to = json['to'];
    details = json['details'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    sAll = json['s_all'];
    sApproved = json['s_approved'];
    sEnabled = json['s_enabled'];
    uAll = json['u_all'];
    uDelivery = json['u_delivery'];
    uCustomer = json['u_customer'];
    vA = json['v_a'];
    vNa = json['v_na'];
    uActive = json['u_active'];
    uInactive = json['u_inactive'];
    userId = json['user_id'];
    isSeen = json['is_seen'];
    sendBy = json['send_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['to'] = this.to;
    data['details'] = this.details;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['title'] = this.title;
    data['s_all'] = this.sAll;
    data['s_approved'] = this.sApproved;
    data['s_enabled'] = this.sEnabled;
    data['u_all'] = this.uAll;
    data['u_delivery'] = this.uDelivery;
    data['u_customer'] = this.uCustomer;
    data['v_a'] = this.vA;
    data['v_na'] = this.vNa;
    data['u_active'] = this.uActive;
    data['u_inactive'] = this.uInactive;
    data['user_id'] = this.userId;
    data['is_seen'] = this.isSeen;
    data['send_by'] = this.sendBy;
    return data;
  }
}

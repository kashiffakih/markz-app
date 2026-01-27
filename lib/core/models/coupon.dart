class Coupon {
  int? id;
  int? companyId;
  String? name;
  String? startDate;
  String? endDate;
  String? type;
  String? value;
  String? createdAt;
  String? updatedAt;
  int? noPerUser;
  int? minOrderValue;

  Coupon(
      {this.id,
      this.companyId,
      this.name,
      this.startDate,
      this.endDate,
      this.type,
      this.value,
      this.createdAt,
      this.updatedAt,
      this.noPerUser,
      this.minOrderValue});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    type = json['type'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    noPerUser = json['no_per_user'] != null
        ? int.tryParse(json['no_per_user'].toString())
        : null;
    minOrderValue = json['min_order_value'] != null
        ? int.tryParse(json['min_order_value'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['type'] = this.type;
    data['value'] = this.value;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['no_per_user'] = this.noPerUser;
    data['min_order_value'] = this.minOrderValue;
    return data;
  }
}

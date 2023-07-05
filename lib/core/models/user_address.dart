class UserAddress {
  int? userId;
  String? add1;
  String? add2;
  String? add3;
  String? state;
  String? city;
  String? nationality;
  String? pincode;
  int? addressId;
  String? updatedAt;
  String? createdAt;
  int? id;

  UserAddress(
      {this.userId,
      this.add1,
      this.add2,
      this.add3,
      this.state,
      this.city,
      this.nationality,
      this.pincode,
      this.addressId,
      this.updatedAt,
      this.createdAt,
      this.id});

  UserAddress.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    add1 = json['add_1'];
    add2 = json['add_2'];
    add3 = json['add_3'];
    state = json['state'];
    city = json['city'];
    nationality = json['nationality'];
    pincode = json['pincode'];
    addressId = json['address_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['add_1'] = this.add1;
    data['add_2'] = this.add2;
    data['add_3'] = this.add3;
    data['state'] = this.state;
    data['city'] = this.city;
    data['nationality'] = this.nationality;
    data['pincode'] = this.pincode;
    data['address_id'] = this.addressId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

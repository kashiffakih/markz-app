class UserAddress {
  int? userId;
  String? add1;
  String? add2;
  String? add3;
  String? label;
  String? state;
  String? city;
  String? nationality;
  String? pincode;
  int? addressId;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? fullName;
  String? phone;
  String? altPhone;
  int? isDeleted;
  int? isDefault;

  UserAddress(
      {this.userId,
      this.add1,
      this.add2,
      this.add3,
      this.city,
      this.state,
      this.nationality,
      this.pincode,
      this.addressId,
      this.label,
      this.fullName,
      this.phone,
      this.altPhone,
      this.isDeleted,
      this.isDefault});

  UserAddress.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    add1 = json['add_1'];
    add2 = json['add_2'];
    add3 = json['add_3'];
    city = json['city'];
    state = json['state'];
    nationality = json['nationality'];
    pincode = json['pincode'];
    addressId = json[
        'address_id']; // This might be 'id' based on the backend response, but keeping 'address_id' if that's what it was. WAIT. Backend UserAddress doesn't explicitly return address_id, it is 'id'. Checking earlier viewed files...
    // The previous code had this.addressId = json['address_id'];
    // Let's stick to previous code.
    label = json['label'];
    id = json['id'];
    fullName = json['full_name'];
    phone = json['phone'];
    altPhone = json['alt_phone'];
    isDeleted = json['is_deleted'];
    if (json['is_default'] != null) {
      if (json['is_default'] is bool) {
        isDefault = json['is_default'] ? 1 : 0;
      } else {
        isDefault = int.tryParse(json['is_default'].toString()) ?? 0;
      }
    } else {
      isDefault = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['add_1'] = this.add1;
    data['add_2'] = this.add2;
    data['add_3'] = this.add3;
    data['city'] = this.city;
    data['state'] = this.state;
    data['nationality'] = this.nationality;
    data['pincode'] = this.pincode;
    data['address_id'] = this.addressId;
    data['label'] = this.label;
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['alt_phone'] = this.altPhone;
    data['is_deleted'] = this.isDeleted;
    data['is_default'] = this.isDefault;
    return data;
  }
}

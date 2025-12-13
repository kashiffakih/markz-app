class Company {
  int? id;
  String? name;
  String? email;
  int? phone;
  String? address;
  String? logoPath;
  String? contactPerson;
  String? createdAt;
  String? updatedAt;
  String? timeZone;
  int? isCashbackApplicable;
  int? isDineInAndDelivery;
  int? isReferralAmountUsability;
  String? ownerName;
  String? add1;
  String? add2;
  String? add3;
  String? state;
  String? city;
  String? pincode;
  String? deliveryCharges;
  String? comissionType;
  String? comissionValue;
  String? rejectPenalty;
  String? position;
  int? isEnabled;
  int? isApproved;
  String? categoryId;
  int? cityId;
  String? accNo;
  String? accName;
  String? bank;
  String? branch;
  String? ifscCode;
  String? accType;
  String? deliveryDuration;
  String? shortAddress;
  String? openTimeHr;
  String? openTimeMin;
  String? openTimeAmPm;
  int? taxPercent;
  int? packagingCharges;
  int? freeDeliveryApplicable;
  int? freeDeliveryMinAmount;
  int? dineInMinAmount;
  String? shortCategory;
  int? isAvailable;
  String? imagepath;
  num? platformFee;

  Company(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.logoPath,
      this.contactPerson,
      this.createdAt,
      this.updatedAt,
      this.timeZone,
      this.isCashbackApplicable,
      this.isDineInAndDelivery,
      this.isReferralAmountUsability,
      this.ownerName,
      this.add1,
      this.add2,
      this.add3,
      this.state,
      this.city,
      this.pincode,
      this.deliveryCharges,
      this.comissionType,
      this.comissionValue,
      this.rejectPenalty,
      this.position,
      this.isEnabled,
      this.isApproved,
      this.categoryId,
      this.cityId,
      this.accNo,
      this.accName,
      this.bank,
      this.branch,
      this.ifscCode,
      this.accType,
      this.deliveryDuration,
      this.shortAddress,
      this.openTimeHr,
      this.openTimeMin,
      this.openTimeAmPm,
      this.taxPercent,
      this.packagingCharges,
      this.freeDeliveryApplicable,
      this.freeDeliveryMinAmount,
      this.dineInMinAmount,
      this.shortCategory,
      this.isAvailable,
      this.imagepath,
      this.platformFee});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    logoPath = json['logo_path'];
    contactPerson = json['contact_person'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    timeZone = json['time_zone'];
    isCashbackApplicable = json['is_cashback_applicable'];
    isDineInAndDelivery = json['is_dine_in_and_delivery'];
    isReferralAmountUsability = json['is_referral_amount_usability'];
    ownerName = json['owner_name'];
    add1 = json['add_1'];
    add2 = json['add_2'];
    add3 = json['add_3'];
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    deliveryCharges = json['delivery_charges'];
    comissionType = json['comission_type'];
    comissionValue = json['comission_value'];
    rejectPenalty = json['reject_penalty'];
    position = json['position'];
    isEnabled = json['is_enabled'];
    isApproved = json['is_approved'];
    categoryId = json['category_id']?.toString();
    cityId = json['city_id'];
    accNo = json['acc_no'];
    accName = json['acc_name'];
    bank = json['bank'];
    branch = json['branch'];
    ifscCode = json['ifsc_code'];
    accType = json['acc_type'];
    deliveryDuration = json['delivery_duration'];
    shortAddress = json['short_address'];
    openTimeHr = json['open_time_hr'];
    openTimeMin = json['open_time_min'];
    openTimeAmPm = json['open_time_am_pm'];
    taxPercent = json['tax_percent'];
    packagingCharges = json['packaging_charges'];
    freeDeliveryApplicable = json['free_delivery_applicable'];
    freeDeliveryMinAmount = json['free_delivery_min_amount'];
    dineInMinAmount = json['dine_in_min_amount'];
    shortCategory = json['short_category'];
    isAvailable = json['is_available'];
    imagepath = json['imagepath'];
    platformFee = json['platform_fee'] != null
        ? num.tryParse(json['platform_fee'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['logo_path'] = this.logoPath;
    data['contact_person'] = this.contactPerson;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['time_zone'] = this.timeZone;
    data['is_cashback_applicable'] = this.isCashbackApplicable;
    data['is_dine_in_and_delivery'] = this.isDineInAndDelivery;
    data['is_referral_amount_usability'] = this.isReferralAmountUsability;
    data['owner_name'] = this.ownerName;
    data['add_1'] = this.add1;
    data['add_2'] = this.add2;
    data['add_3'] = this.add3;
    data['state'] = this.state;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['delivery_charges'] = this.deliveryCharges;
    data['comission_type'] = this.comissionType;
    data['comission_value'] = this.comissionValue;
    data['reject_penalty'] = this.rejectPenalty;
    data['position'] = this.position;
    data['is_enabled'] = this.isEnabled;
    data['is_approved'] = this.isApproved;
    data['category_id'] = this.categoryId;
    data['city_id'] = this.cityId;
    data['acc_no'] = this.accNo;
    data['acc_name'] = this.accName;
    data['bank'] = this.bank;
    data['branch'] = this.branch;
    data['ifsc_code'] = this.ifscCode;
    data['acc_type'] = this.accType;
    data['delivery_duration'] = this.deliveryDuration;
    data['short_address'] = this.shortAddress;
    data['open_time_hr'] = this.openTimeHr;
    data['open_time_min'] = this.openTimeMin;
    data['open_time_am_pm'] = this.openTimeAmPm;
    data['tax_percent'] = this.taxPercent;
    data['packaging_charges'] = this.packagingCharges;
    data['free_delivery_applicable'] = this.freeDeliveryApplicable;
    data['free_delivery_min_amount'] = this.freeDeliveryMinAmount;
    data['dine_in_min_amount'] = this.dineInMinAmount;
    data['short_category'] = this.shortCategory;
    data['is_available'] = this.isAvailable;
    data['imagepath'] = this.imagepath;
    data['platform_fee'] = this.platformFee;
    return data;
  }
}

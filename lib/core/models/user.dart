import 'package:aadab/core/models/company.dart';

class User {
  int? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? emailVerifiedAt;
  int? active;
  String? phone;
  String? apiToken;
  String? gender;
  String? add1;
  String? add2;
  String? add3;
  String? state;
  String? city;
  String? nationality;
  String? pincode;
  int? isBillingSame;
  String? billFirstName;
  String? billMiddleName;
  String? billLastName;
  String? billAdd1;
  String? billAdd2;
  String? billAdd3;
  String? billState;
  String? billCity;
  String? billNationality;
  String? billEmail;
  String? billPhone;
  String? billPincode;
  String? createdAt;
  String? updatedAt;
  String? isAvailable;
  int? cityId;
  int? otp;
  String? accNo;
  String? accName;
  String? bank;
  String? branch;
  String? ifscCode;
  String? accType;
  int? isOccupied;
  String? vehicleType;
  String? vehicleNo;
  String? vehicleName;
  String? fcmToken;
  String? referredCode;
  int? referredCodeUser;
  String? imagepath;
  Location? location;
  List<Roles>? roles;
  List<Company>? companies;
  String? referralCode;
  int? referedById;
  int? isRegisterBonusSeen;
  String? gstNumber;
  String? businessName;
  String? tradeName;
  String? address;
  String? pincodeBusiness;
  String? stateBusiness;
  String? registrationDate;
  String? visitingCardPath;
  String? shopImagePath;
  int? isApproved;
  int? isBlocked;
  String? blockedReason;
  int? isRejected;
  String? rejectionReason;
  String? activeRole;

  User(
      {this.id,
      this.firstName,
      this.middleName,
      this.lastName,
      this.email,
      this.emailVerifiedAt,
      this.active,
      this.phone,
      this.apiToken,
      this.gender,
      this.add1,
      this.add2,
      this.add3,
      this.state,
      this.city,
      this.nationality,
      this.pincode,
      this.isBillingSame,
      this.billFirstName,
      this.billMiddleName,
      this.billLastName,
      this.billAdd1,
      this.billAdd2,
      this.billAdd3,
      this.billState,
      this.billCity,
      this.billNationality,
      this.billEmail,
      this.billPhone,
      this.billPincode,
      this.createdAt,
      this.updatedAt,
      this.isAvailable,
      this.cityId,
      this.otp,
      this.accNo,
      this.accName,
      this.bank,
      this.branch,
      this.ifscCode,
      this.accType,
      this.isOccupied,
      this.vehicleType,
      this.vehicleNo,
      this.vehicleName,
      this.fcmToken,
      this.referredCode,
      this.referredCodeUser,
      this.referralCode,
      this.referedById,
      this.imagepath,
      this.location,
      this.roles,
      this.isRegisterBonusSeen,
      this.gstNumber,
      this.businessName,
      this.tradeName,
      this.address,
      this.pincodeBusiness,
      this.stateBusiness,
      this.registrationDate,
      this.visitingCardPath,
      this.shopImagePath,
      this.isApproved,
      this.activeRole,
      this.companies});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    firstName = json['first_name']?.toString();
    middleName = json['middle_name']?.toString();
    lastName = json['last_name']?.toString();
    email = json['email']?.toString();
    emailVerifiedAt = json['email_verified_at']?.toString();
    active = json['active'] is int ? json['active'] : int.tryParse(json['active']?.toString() ?? '');
    phone = json['phone']?.toString();
    apiToken = json['api_token']?.toString();
    gender = json['gender']?.toString();
    add1 = json['add_1']?.toString();
    add2 = json['add_2']?.toString();
    add3 = json['add_3']?.toString();
    state = json['state']?.toString();
    city = json['city'] is Map ? json['city']['name']?.toString() : json['city']?.toString();
    nationality = json['nationality']?.toString();
    pincode = json['pincode']?.toString();
    isBillingSame = json['is_billing_same'] is int ? json['is_billing_same'] : int.tryParse(json['is_billing_same']?.toString() ?? '');
    billFirstName = json['bill_first_name']?.toString();
    billMiddleName = json['bill_middle_name']?.toString();
    billLastName = json['bill_last_name']?.toString();
    billAdd1 = json['bill_add_1']?.toString();
    billAdd2 = json['bill_add_2']?.toString();
    billAdd3 = json['bill_add_3']?.toString();
    billState = json['bill_state']?.toString();
    billCity = json['bill_city']?.toString();
    billNationality = json['bill_nationality']?.toString();
    billEmail = json['bill_email']?.toString();
    billPhone = json['bill_phone']?.toString();
    billPincode = json['bill_pincode']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    isAvailable = json['is_available']?.toString();
    cityId = json['city_id'] is int ? json['city_id'] : int.tryParse(json['city_id']?.toString() ?? '');
    otp = json['otp'] is int ? json['otp'] : int.tryParse(json['otp']?.toString() ?? '');
    accNo = json['acc_no']?.toString();
    accName = json['acc_name']?.toString();
    bank = json['bank']?.toString();
    branch = json['branch']?.toString();
    ifscCode = json['ifsc_code']?.toString();
    accType = json['acc_type']?.toString();
    isOccupied = json['is_occupied'] is int ? json['is_occupied'] : int.tryParse(json['is_occupied']?.toString() ?? '');
    vehicleType = json['vehicle_type']?.toString();
    vehicleNo = json['vehicle_no']?.toString();
    vehicleName = json['vehicle_name']?.toString();
    fcmToken = json['fcm_token']?.toString();
    referredCode = json['referred_code']?.toString();
    referredCodeUser = json['referred_code_user'] is int ? json['referred_code_user'] : int.tryParse(json['referred_code_user']?.toString() ?? '');
    referralCode = json['referral_code']?.toString();
    referedById = json['refered_by_id'] is int ? json['refered_by_id'] : int.tryParse(json['refered_by_id']?.toString() ?? '');
    isRegisterBonusSeen = json['is_register_bonus_seen'] is int ? json['is_register_bonus_seen'] : int.tryParse(json['is_register_bonus_seen']?.toString() ?? '');
    gstNumber = json['gst_number']?.toString();
    businessName = json['business_name']?.toString();
    tradeName = json['trade_name']?.toString();
    address = json['address']?.toString();
    pincodeBusiness = json['pincode_business']?.toString();
    stateBusiness = json['state_business']?.toString();
    registrationDate = json['registration_date']?.toString();
    visitingCardPath = json['visiting_card_path']?.toString();
    shopImagePath = json['shop_image_path']?.toString();
    isApproved = json['is_approved'] is bool ? (json['is_approved'] ? 1 : 0) : (json['is_approved'] is int ? json['is_approved'] : int.tryParse(json['is_approved']?.toString() ?? '') ?? 0);
    if (isApproved == 1) {
      isBlocked = 0;
      blockedReason = null;
      isRejected = 0;
      rejectionReason = null;
    } else {
      isBlocked = json['is_blocked'] is bool ? (json['is_blocked'] ? 1 : 0) : (json['is_blocked'] is int ? json['is_blocked'] : int.tryParse(json['is_blocked']?.toString() ?? '') ?? 0);
      blockedReason = json['blocked_reason']?.toString();
      isRejected = json['is_rejected'] is bool ? (json['is_rejected'] ? 1 : 0) : (json['is_rejected'] is int ? json['is_rejected'] : int.tryParse(json['is_rejected']?.toString() ?? '') ?? 0);
      rejectionReason = json['rejection_reason']?.toString();
    }
    activeRole = json['active_role']?.toString();
    imagepath = json['imagepath'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    if (json['roles'] != null) {
      roles = [];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
    if (json['companies'] != null) {
      companies = [];
      json['companies'].forEach((v) {
        companies!.add(new Company.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['active'] = this.active;
    data['phone'] = this.phone;
    data['api_token'] = this.apiToken;
    data['gender'] = this.gender;
    data['add_1'] = this.add1;
    data['add_2'] = this.add2;
    data['add_3'] = this.add3;
    data['state'] = this.state;
    data['city'] = this.city;
    data['nationality'] = this.nationality;
    data['pincode'] = this.pincode;
    data['is_billing_same'] = this.isBillingSame;
    data['bill_first_name'] = this.billFirstName;
    data['bill_middle_name'] = this.billMiddleName;
    data['bill_last_name'] = this.billLastName;
    data['bill_add_1'] = this.billAdd1;
    data['bill_add_2'] = this.billAdd2;
    data['bill_add_3'] = this.billAdd3;
    data['bill_state'] = this.billState;
    data['bill_city'] = this.billCity;
    data['bill_nationality'] = this.billNationality;
    data['bill_email'] = this.billEmail;
    data['bill_phone'] = this.billPhone;
    data['bill_pincode'] = this.billPincode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_available'] = this.isAvailable;
    data['city_id'] = this.cityId;
    data['otp'] = this.otp;
    data['acc_no'] = this.accNo;
    data['acc_name'] = this.accName;
    data['bank'] = this.bank;
    data['branch'] = this.branch;
    data['ifsc_code'] = this.ifscCode;
    data['acc_type'] = this.accType;
    data['is_occupied'] = this.isOccupied;
    data['vehicle_type'] = this.vehicleType;
    data['vehicle_no'] = this.vehicleNo;
    data['vehicle_name'] = this.vehicleName;
    data['fcm_token'] = this.fcmToken;
    data['referred_code'] = this.referredCode;
    data['referred_code_user'] = this.referredCodeUser;
    data['referral_code'] = this.referralCode;
    data['refered_by_id'] = this.referedById;
    data['is_register_bonus_seen'] = this.isRegisterBonusSeen;
    data['gst_number'] = this.gstNumber;
    data['business_name'] = this.businessName;
    data['trade_name'] = this.tradeName;
    data['address'] = this.address;
    data['pincode_business'] = this.pincodeBusiness;
    data['state_business'] = this.stateBusiness;
    data['registration_date'] = this.registrationDate;
    data['visiting_card_path'] = this.visitingCardPath;
    data['shop_image_path'] = this.shopImagePath;
    data['is_approved'] = this.isApproved;
    data['active_role'] = this.activeRole;
    data['imagepath'] = this.imagepath;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    if (this.companies != null) {
      data['companies'] = this.companies!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Roles {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Roles({this.id, this.name, this.createdAt, this.updatedAt});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Location {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Location({this.id, this.name, this.createdAt, this.updatedAt});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

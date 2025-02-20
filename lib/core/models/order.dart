import 'package:aadab/core/models/user.dart';
import 'package:aadab/core/models/user_address.dart';

import 'product.dart';

class Order {
  int? id;
  int? companyId;
  int? userId;
  String? details;
  int? orderCost;
  String? createdAt;
  String? updatedAt;
  String? paymentMode;
  int? totalCashback;
  int? deliveryBoyId;
  int? isDelivered;
  int? isDeliveryBoyAccepted;
  String? txnid;
  num? txnamount;
  String? paymentmode;
  String? currency;
  String? txndate;
  String? status;
  String? response;
  String? respmsg;
  String? gatewayname;
  String? banktxnid;
  String? bankname;
  int? couponAmount;
  String? couponId;
  num? taxAmount;
  int? packagingAmount;
  num? deliveryAmount;
  int? tipAmount;
  num? totalAmount;
  int? walletAmountUsed;
  int? isApprovedByHotelier;
  int? isDinein;
  int? storePayableAmount;
  int? comissionAmount;
  int? addressId;
  String? acceptedById;
  String? rpyPaymentStatus;
  String? rpyPaymentId;
  String? rpyOrderId;
  String? rpySignature;
  String? rpyCode;
  String? rpyMessage;
  bool? isGift;
  String? deliveryMethod;
  User? user;
  List<OrderDetails>? orderDetails;
  List<OrderStatuses>? orderStatuses;
  Company? company;
  String? deliveryBoy;
  UserAddress? address;

  Order(
      {this.id,
      this.companyId,
      this.userId,
      this.details,
      this.orderCost,
      this.createdAt,
      this.updatedAt,
      this.paymentMode,
      this.totalCashback,
      this.deliveryBoyId,
      this.isDelivered,
      this.isDeliveryBoyAccepted,
      this.txnid,
      this.txnamount,
      this.paymentmode,
      this.currency,
      this.txndate,
      this.status,
      this.response,
      this.respmsg,
      this.gatewayname,
      this.banktxnid,
      this.bankname,
      this.couponAmount,
      this.couponId,
      this.taxAmount,
      this.packagingAmount,
      this.deliveryAmount,
      this.tipAmount,
      this.totalAmount,
      this.walletAmountUsed,
      this.isApprovedByHotelier,
      this.isDinein,
      this.storePayableAmount,
      this.comissionAmount,
      this.addressId,
      this.acceptedById,
      this.rpyPaymentStatus,
      this.rpyPaymentId,
      this.rpyOrderId,
      this.rpySignature,
      this.rpyCode,
      this.rpyMessage,
      this.isGift,
      this.deliveryMethod,
      this.user,
      this.orderDetails,
      this.orderStatuses,
      this.company,
      this.deliveryBoy,
      required String taxPercent,
      this.address});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    details = json['details'];
    orderCost = json['order_cost'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paymentMode = json['payment_mode'];
    totalCashback = json['total_cashback'];
    deliveryBoyId = json['delivery_boy_id'];
    isDelivered = json['is_delivered'];
    isDeliveryBoyAccepted = json['is_delivery_boy_accepted'];
    txnid = json['txnid'];
    txnamount = json['txnamount'];
    paymentmode = json['paymentmode'];
    currency = json['currency'];
    txndate = json['txndate'];
    status = json['status'];
    response = json['response'];
    respmsg = json['respmsg'];
    gatewayname = json['gatewayname'];
    banktxnid = json['banktxnid'];
    bankname = json['bankname'];
    couponAmount = json['coupon_amount'];
    couponId = json['coupon_id'];
    taxAmount = json['tax_amount'];
    packagingAmount = json['packaging_amount'];
    deliveryAmount = json['delivery_amount'];
    tipAmount = json['tip_amount'];
    totalAmount = json['total_amount'];
    walletAmountUsed = json['wallet_amount_used'];
    isApprovedByHotelier = json['is_approved_by_hotelier'];
    isDinein = json['is_dinein'];
    storePayableAmount = json['store_payable_amount'];
    comissionAmount = json['comission_amount'];
    addressId = json['address_id'];
    acceptedById = json['accepted_by_id'];
    rpyPaymentStatus = json['rpy_payment_status'];
    rpyPaymentId = json['rpy_payment_id'];
    rpyOrderId = json['rpy_order_id'];
    rpySignature = json['rpy_signature'];
    rpyCode = json['rpy_code'];
    rpyMessage = json['rpy_message'];
    deliveryMethod = json['delivery_method'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['order_details'] != null) {
      orderDetails = <OrderDetails>[];
      json['order_details'].forEach((v) {
        orderDetails!.add(new OrderDetails.fromJson(v));
      });
    }
    if (json['order_statuses'] != null) {
      orderStatuses = <OrderStatuses>[];
      json['order_statuses'].forEach((v) {
        orderStatuses!.add(new OrderStatuses.fromJson(v));
      });
    }
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
    deliveryBoy = json['delivery_boy'];
    address = json['address'] != null
        ? new UserAddress.fromJson(json['address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['details'] = this.details;
    data['order_cost'] = this.orderCost;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['payment_mode'] = this.paymentMode;
    data['total_cashback'] = this.totalCashback;
    data['delivery_boy_id'] = this.deliveryBoyId;
    data['is_delivered'] = this.isDelivered;
    data['is_delivery_boy_accepted'] = this.isDeliveryBoyAccepted;
    data['txnid'] = this.txnid;
    data['txnamount'] = this.txnamount;
    data['paymentmode'] = this.paymentmode;
    data['currency'] = this.currency;
    data['txndate'] = this.txndate;
    data['status'] = this.status;
    data['response'] = this.response;
    data['respmsg'] = this.respmsg;
    data['gatewayname'] = this.gatewayname;
    data['banktxnid'] = this.banktxnid;
    data['bankname'] = this.bankname;
    data['coupon_amount'] = this.couponAmount;
    data['coupon_id'] = this.couponId;
    data['tax_amount'] = this.taxAmount;
    data['packaging_amount'] = this.packagingAmount;
    data['delivery_amount'] = this.deliveryAmount;
    data['tip_amount'] = this.tipAmount;
    data['total_amount'] = this.totalAmount;
    data['wallet_amount_used'] = this.walletAmountUsed;
    data['is_approved_by_hotelier'] = this.isApprovedByHotelier;
    data['is_dinein'] = this.isDinein;
    data['store_payable_amount'] = this.storePayableAmount;
    data['comission_amount'] = this.comissionAmount;
    data['address_id'] = this.addressId;
    data['accepted_by_id'] = this.acceptedById;
    data['rpy_payment_status'] = this.rpyPaymentStatus;
    data['rpy_payment_id'] = this.rpyPaymentId;
    data['rpy_order_id'] = this.rpyOrderId;
    data['rpy_signature'] = this.rpySignature;
    data['rpy_code'] = this.rpyCode;
    data['rpy_message'] = this.rpyMessage;
    data['is_gift'] = this.isGift;
    data['delivery_method'] = this.deliveryMethod;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.orderDetails != null) {
      data['order_details'] =
          this.orderDetails!.map((v) => v.toJson()).toList();
    }
    if (this.orderStatuses != null) {
      data['order_statuses'] =
          this.orderStatuses!.map((v) => v.toJson()).toList();
    }
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    data['delivery_boy'] = this.deliveryBoy;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
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

class OrderDetails {
  int? id;
  int? orderId;
  int? productId;
  int? quantity;
  int? orderDetailCost;
  String? createdAt;
  String? updatedAt;
  String? productPack;
  int? cashback;
  String? kindOfFlower;
  String? flavour;
  String? writeOnCake;
  Product? product;
  String? unit;

  OrderDetails(
      {this.id,
      this.orderId,
      this.productId,
      this.quantity,
      this.orderDetailCost,
      this.createdAt,
      this.updatedAt,
      this.productPack,
      this.cashback,
      this.kindOfFlower,
      this.flavour,
      this.writeOnCake,
      this.product,
      this.unit});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    orderDetailCost = json['order_detail_cost'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productPack = json['product_pack'];
    cashback = json['cashback'];
    kindOfFlower = json['kind_of_flower'];
    flavour = json['flavour'];
    writeOnCake = json['write_on_cake'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['order_detail_cost'] = this.orderDetailCost;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product_pack'] = this.productPack;
    data['cashback'] = this.cashback;
    data['kind_of_flower'] = this.kindOfFlower;
    data['flavour'] = this.flavour;
    data['write_on_cake'] = this.writeOnCake;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['unit'] = this.unit;
    return data;
  }
}

// class Product {
//   int? id;
//   int? companyId;
//   int? userId;
//   int? categoryId;
//   String? inventoryId;
//   String? name;
//   String? smallDescription;
//   String? description;
//   String? location;
//   int? isActive;
//   String? createdAt;
//   String? updatedAt;
//   String? imagepath1;
//   String? imagepath2;
//   String? imagepath3;
//   String? imagepath4;
//   int? subCategoryId;
//   String? position;
//   String? sub2CategoryId;
//   String? sub3CategoryId;
//   String? vegNonveg;
//   String? inventory;
//
//   Product(
//       {this.id,
//       this.companyId,
//       this.userId,
//       this.categoryId,
//       this.inventoryId,
//       this.name,
//       this.smallDescription,
//       this.description,
//       this.location,
//       this.isActive,
//       this.createdAt,
//       this.updatedAt,
//       this.imagepath1,
//       this.imagepath2,
//       this.imagepath3,
//       this.imagepath4,
//       this.subCategoryId,
//       this.position,
//       this.sub2CategoryId,
//       this.sub3CategoryId,
//       this.vegNonveg,
//       this.inventory});
//
//   Product.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     companyId = json['company_id'];
//     userId = json['user_id'];
//     categoryId = json['category_id'];
//     inventoryId = json['inventory_id'];
//     name = json['name'];
//     smallDescription = json['small_description'];
//     description = json['description'];
//     location = json['location'];
//     isActive = json['is_active'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     imagepath1 = json['imagepath1'];
//     imagepath2 = json['imagepath2'];
//     imagepath3 = json['imagepath3'];
//     imagepath4 = json['imagepath4'];
//     subCategoryId = json['sub_category_id'];
//     position = json['position'].toString();
//     sub2CategoryId = json['sub_2_category_id'];
//     sub3CategoryId = json['sub_3_category_id'];
//     vegNonveg = json['veg_nonveg'];
//     inventory = json['inventory'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['company_id'] = this.companyId;
//     data['user_id'] = this.userId;
//     data['category_id'] = this.categoryId;
//     data['inventory_id'] = this.inventoryId;
//     data['name'] = this.name;
//     data['small_description'] = this.smallDescription;
//     data['description'] = this.description;
//     data['location'] = this.location;
//     data['is_active'] = this.isActive;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['imagepath1'] = this.imagepath1;
//     data['imagepath2'] = this.imagepath2;
//     data['imagepath3'] = this.imagepath3;
//     data['imagepath4'] = this.imagepath4;
//     data['sub_category_id'] = this.subCategoryId;
//     data['position'] = this.position;
//     data['sub_2_category_id'] = this.sub2CategoryId;
//     data['sub_3_category_id'] = this.sub3CategoryId;
//     data['veg_nonveg'] = this.vegNonveg;
//     data['inventory'] = this.inventory;
//     return data;
//   }
// }

class OrderStatuses {
  int? id;
  int? orderId;
  int? statusId;
  String? date;
  String? description;
  String? createdAt;
  String? updatedAt;
  Location? status;

  OrderStatuses(
      {this.id,
      this.orderId,
      this.statusId,
      this.date,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.status});

  OrderStatuses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    statusId = json['status_id'];
    date = json['date'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status =
        json['status'] != null ? new Location.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['status_id'] = this.statusId;
    data['date'] = this.date;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    return data;
  }
}

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
  num? taxPercent;
  int? packagingCharges;
  int? freeDeliveryApplicable;
  int? freeDeliveryMinAmount;
  int? dineInMinAmount;
  String? shortCategory;
  int? isAvailable;
  String? imagepath;

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
      this.imagepath});

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
    categoryId = json['category_id'];
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
    return data;
  }
}

import 'sku.dart';
import 'package:flutter/material.dart';

class Order {
  int? id;
  int? companyId;
  int? distributorId;
  int? userId;
  int? retailerId;
  int? status;
  int? total;
  String? createdAt;
  String? updatedAt;
  var orderType;
  Ssm? ssm;
  Distributor? distributor;
  Retailer? retailer;
  List<OrderDetails>? orderDetails;

  Order(
      {this.id,
      this.companyId,
      this.distributorId,
      this.userId,
      this.retailerId,
      this.status,
      this.total,
      this.createdAt,
      this.updatedAt,
      this.orderType,
      this.ssm,
      this.distributor,
      this.retailer,
      this.orderDetails});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    distributorId = json['distributor_id'];
    userId = json['user_id'];
    retailerId = json['retailer_id'];
    status = json['status'];
    total = json['total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderType = json['order_type'];
    ssm = json['ssm'] != null ? new Ssm.fromJson(json['ssm']) : null;
    distributor = json['distributor'] != null
        ? new Distributor.fromJson(json['distributor'])
        : null;
    retailer = json['retailer'] != null
        ? new Retailer.fromJson(json['retailer'])
        : null;
    if (json['order_details'] != null) {
      orderDetails = [];
      json['order_details'].forEach((v) {
        orderDetails!.add(new OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['distributor_id'] = this.distributorId;
    data['user_id'] = this.userId;
    data['retailer_id'] = this.retailerId;
    data['status'] = this.status;
    data['total'] = this.total;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['order_type'] = this.orderType;
    if (this.ssm != null) {
      data['ssm'] = this.ssm!.toJson();
    }
    if (this.distributor != null) {
      data['distributor'] = this.distributor!.toJson();
    }
    if (this.retailer != null) {
      data['retailer'] = this.retailer!.toJson();
    }
    if (this.orderDetails != null) {
      data['order_details'] =
          this.orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ssm {
  int? id;
  String? name;
  String? email;
  int? distributorId;

  Ssm({this.id, this.name, this.email, this.distributorId});

  Ssm.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    distributorId = json['distributor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['distributor_id'] = this.distributorId;
    return data;
  }
}

class Distributor {
  int? id;
  String? name;
  String? email;

  Distributor({this.id, this.name, this.email});

  Distributor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}

class Retailer {
  int? id;
  String? name;
  String? address;
  String? createdAt;
  String? updatedAt;
  int? referencePlanId;
  String? retailerCode;
  String? proprietorName;
  int? phone;
  int? approved;

  Retailer(
      {this.id,
      this.name,
      this.address,
      this.createdAt,
      this.updatedAt,
      this.referencePlanId,
      this.retailerCode,
      this.proprietorName,
      this.phone,
      this.approved});

  Retailer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    referencePlanId = json['reference_plan_id'];
    retailerCode = json['retailer_code'];
    proprietorName = json['proprietor_name'];
    phone = json['phone'];
    approved = json['approved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['reference_plan_id'] = this.referencePlanId;
    data['retailer_code'] = this.retailerCode;
    data['proprietor_name'] = this.proprietorName;
    data['phone'] = this.phone;
    data['approved'] = this.approved;
    return data;
  }
}

class OrderDetails {
  int? id;
  int? orderId;
  int? skuId;
  int? qty;
  int? value;
  int? qtyDelivered;
  String? createdAt;
  String? updatedAt;
  Sku? sku;

  OrderDetails(
      {this.id,
      this.orderId,
      this.skuId,
      this.qty,
      this.value,
      this.qtyDelivered,
      this.createdAt,
      this.updatedAt,
      this.sku});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    skuId = json['sku_id'];
    qty = json['qty'];
    value = json['value'];
    qtyDelivered = json['qty_delivered'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sku = json['sku'] != null ? new Sku.fromJson(json['sku']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['sku_id'] = this.skuId;
    data['qty'] = this.qty;
    data['value'] = this.value;
    data['qty_delivered'] = this.qtyDelivered;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.sku != null) {
      data['sku'] = this.sku!.toJson();
    }
    return data;
  }
}

// class Sku {
//   int id;
//   String name;
//   String createdAt;
//   String updatedAt;
//   int productId;
//   int companyId;
//   int offerId;

//   Sku(
//       {this.id,
//       this.name,
//       this.createdAt,
//       this.updatedAt,
//       this.productId,
//       this.companyId,
//       this.offerId});

//   Sku.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     productId = json['product_id'];
//     companyId = json['company_id'];
//     offerId = json['offer_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['product_id'] = this.productId;
//     data['company_id'] = this.companyId;
//     data['offer_id'] = this.offerId;
//     return data;
//   }
// }

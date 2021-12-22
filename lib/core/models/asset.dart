import 'package:sales_app/core/models/asset_status.dart';
import 'package:sales_app/core/models/order.dart';
import 'package:sales_app/core/models/reference_plan.dart';

class Asset {
  int? id;
  int? companyId;
  int? retailerId;
  String? assetName;
  String? status;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? referencePlanId;
  String? uniqueId;
  String? size;
  int? manufacturerId;
  Retailer? retailer;
  ReferencePlan? referencePlan;
  Manufacturer? manufacturer;
  List<AssetStatus>? assetStatuses;

  Asset(
      {this.id,
      this.companyId,
      this.retailerId,
      this.assetName,
      this.status,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.referencePlanId,
      this.uniqueId,
      this.size,
      this.manufacturerId,
      this.retailer,
      this.referencePlan,
      this.manufacturer,
      this.assetStatuses});

  Asset.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    retailerId = json['retailer_id'];
    assetName = json['asset_name'];
    status = json['status'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    referencePlanId = json['reference_plan_id'];
    uniqueId = json['unique_id'];
    size = json['size'];
    manufacturerId = json['manufacturer_id'];
    retailer = json['retailer'] != null
        ? new Retailer.fromJson(json['retailer'])
        : null;
    referencePlan = json['reference_plan'] != null
        ? new ReferencePlan.fromJson(json['reference_plan'])
        : null;
    manufacturer = json['manufacturer'] != null
        ? new Manufacturer.fromJson(json['manufacturer'])
        : null;
    if (json['asset_statuses'] != null) {
      assetStatuses = [];
      json['asset_statuses'].forEach((v) {
        assetStatuses!.add(new AssetStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['retailer_id'] = this.retailerId;
    data['asset_name'] = this.assetName;
    data['status'] = this.status;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['reference_plan_id'] = this.referencePlanId;
    data['unique_id'] = this.uniqueId;
    data['size'] = this.size;
    data['manufacturer_id'] = this.manufacturerId;
    if (this.retailer != null) {
      data['retailer'] = this.retailer!.toJson();
    }
    if (this.referencePlan != null) {
      data['reference_plan'] = this.referencePlan!.toJson();
    }
    if (this.manufacturer != null) {
      data['manufacturer'] = this.manufacturer!.toJson();
    }
    if (this.assetStatuses != null) {
      data['asset_statuses'] =
          this.assetStatuses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Manufacturer {
  int? id;
  int? companyId;
  String? name;
  String? email;
  String? createdAt;
  String? updatedAt;

  Manufacturer(
      {this.id,
      this.companyId,
      this.name,
      this.email,
      this.createdAt,
      this.updatedAt});

  Manufacturer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

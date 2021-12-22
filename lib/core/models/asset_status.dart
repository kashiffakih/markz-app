import 'package:flutter/material.dart';

class AssetStatus {
  int? id;
  int? companyId;
  int? userId;
  int? assetId;
  String? status;
  String? description;
  String? date;
  String? createdAt;
  String? updatedAt;

  AssetStatus(
      {this.id,
      this.companyId,
      this.userId,
      this.assetId,
      this.status,
      this.description,
      this.date,
      this.createdAt,
      this.updatedAt});

  AssetStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    assetId = json['asset_id'];
    status = json['status'];
    description = json['description'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['asset_id'] = this.assetId;
    data['status'] = this.status;
    data['description'] = this.description;
    data['date'] = this.date;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

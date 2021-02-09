class ReferencePlan {
  int id;
  int companyId;
  String name;
  String createdAt;
  String updatedAt;
  String town;
  int totalOutlets;
  int billedOutlets;
  int unbilledOutlets;
  int mtd;
  int l3m;
  List<Retailers> retailers;

  ReferencePlan(
      {this.id,
      this.companyId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.town,
      this.totalOutlets,
      this.billedOutlets,
      this.unbilledOutlets,
      this.mtd,
      this.l3m,
      this.retailers});

  ReferencePlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    town = json['town'];
    totalOutlets = json['total_outlets'];
    billedOutlets = json['billed_outlets'];
    unbilledOutlets = json['unbilled_outlets'];
    mtd = json['mtd'];
    l3m = json['l3m'];
    if (json['retailers'] != null) {
      retailers = new List<Retailers>();
      json['retailers'].forEach((v) {
        retailers.add(new Retailers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['town'] = this.town;
    data['total_outlets'] = this.totalOutlets;
    data['billed_outlets'] = this.billedOutlets;
    data['unbilled_outlets'] = this.unbilledOutlets;
    data['mtd'] = this.mtd;
    data['l3m'] = this.l3m;
    if (this.retailers != null) {
      data['retailers'] = this.retailers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Retailers {
  int id;
  String name;
  String address;
  String createdAt;
  String updatedAt;
  int referencePlanId;
  String retailerCode;
  String proprietorName;
  int phone;
  String gstNo;
  String bankName;
  String acNo;
  String ifscCode;
  String branch;
  String chequePath;
  int retailerCategoryId;
  int retailerClassificationId;
  int lat;
  int lng;
  String imagePath;
  int approved;
  int mtd;
  int l3m;
  String isDone;
  RetailerCategory retailerCategory;
  RetailerCategory retailerClassification;

  Retailers(
      {this.id,
      this.name,
      this.address,
      this.createdAt,
      this.updatedAt,
      this.referencePlanId,
      this.retailerCode,
      this.proprietorName,
      this.phone,
      this.gstNo,
      this.bankName,
      this.acNo,
      this.ifscCode,
      this.branch,
      this.chequePath,
      this.retailerCategoryId,
      this.retailerClassificationId,
      this.lat,
      this.lng,
      this.imagePath,
      this.approved,
      this.mtd,
      this.l3m,
      this.isDone,
      this.retailerCategory,
      this.retailerClassification});

  Retailers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    referencePlanId = json['reference_plan_id'];
    retailerCode = json['retailer_code'];
    proprietorName = json['proprietor_name'];
    phone = json['phone'];
    gstNo = json['gst_no'];
    bankName = json['bank_name'];
    acNo = json['ac_no'];
    ifscCode = json['ifsc_code'];
    branch = json['branch'];
    chequePath = json['cheque_path'];
    retailerCategoryId = json['retailer_category_id'];
    retailerClassificationId = json['retailer_classification_id'];
    lat = json['lat'];
    lng = json['lng'];
    imagePath = json['image_path'];
    approved = json['approved'];
    mtd = json['mtd'];
    l3m = json['l3m'];
    isDone = json['is_done'];
    retailerCategory = json['retailer_category'] != null
        ? new RetailerCategory.fromJson(json['retailer_category'])
        : null;
    retailerClassification = json['retailer_classification'] != null
        ? new RetailerCategory.fromJson(json['retailer_classification'])
        : null;
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
    data['gst_no'] = this.gstNo;
    data['bank_name'] = this.bankName;
    data['ac_no'] = this.acNo;
    data['ifsc_code'] = this.ifscCode;
    data['branch'] = this.branch;
    data['cheque_path'] = this.chequePath;
    data['retailer_category_id'] = this.retailerCategoryId;
    data['retailer_classification_id'] = this.retailerClassificationId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['image_path'] = this.imagePath;
    data['approved'] = this.approved;
    data['mtd'] = this.mtd;
    data['l3m'] = this.l3m;
    data['is_done'] = this.isDone;
    if (this.retailerCategory != null) {
      data['retailer_category'] = this.retailerCategory.toJson();
    }
    if (this.retailerClassification != null) {
      data['retailer_classification'] = this.retailerClassification.toJson();
    }
    return data;
  }
}

class RetailerCategory {
  int id;
  int companyId;
  String name;
  String createdAt;
  String updatedAt;

  RetailerCategory(
      {this.id, this.companyId, this.name, this.createdAt, this.updatedAt});

  RetailerCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

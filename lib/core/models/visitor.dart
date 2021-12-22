class Visitor {
  var id;
  var companyId;
  var userId;
  var retailerId;
  var name;
  var description;
  var createdAt;
  var updatedAt;
  List<VisitorBas>? visitorBas;
  List<VisitorNpds>? visitorNpds;
  List<VisitorStocks>? visitorStocks;

  Visitor(
      {this.id,
      this.companyId,
      this.userId,
      this.retailerId,
      this.name,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.visitorBas,
      this.visitorNpds,
      this.visitorStocks});

  Visitor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    retailerId = json['retailer_id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['visitor_bas'] != null) {
      visitorBas = [];
      json['visitor_bas'].forEach((v) {
        visitorBas!.add(new VisitorBas.fromJson(v));
      });
    }
    if (json['visitor_npds'] != null) {
      visitorNpds = [];
      json['visitor_npds'].forEach((v) {
        visitorNpds!.add(new VisitorNpds.fromJson(v));
      });
    }
    if (json['visitor_stocks'] != null) {
      visitorStocks = [];
      json['visitor_stocks'].forEach((v) {
        visitorStocks!.add(new VisitorStocks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['retailer_id'] = this.retailerId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.visitorBas != null) {
      data['visitor_bas'] = this.visitorBas!.map((v) => v.toJson()).toList();
    }
    if (this.visitorNpds != null) {
      data['visitor_npds'] = this.visitorNpds!.map((v) => v.toJson()).toList();
    }
    if (this.visitorStocks != null) {
      data['visitor_stocks'] =
          this.visitorStocks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VisitorBas {
  var id;
  var visitorId;
  var baId;
  var baStatus;
  var isGrooming;
  var groomingValue;
  var isUniform;
  var isPlanogram;
  var productKnowledgeValue;
  var createdAt;
  var updatedAt;

  VisitorBas(
      {this.id,
      this.visitorId,
      this.baId,
      this.baStatus,
      this.isGrooming,
      this.groomingValue,
      this.isUniform,
      this.isPlanogram,
      this.productKnowledgeValue,
      this.createdAt,
      this.updatedAt});

  VisitorBas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitorId = json['visitor_id'];
    baId = json['ba_id'];
    baStatus = json['ba_status'];
    isGrooming = json['is_grooming'];
    groomingValue = json['grooming_value'];
    isUniform = json['is_uniform'];
    isPlanogram = json['is_planogram'];
    productKnowledgeValue = json['product_knowledge_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['visitor_id'] = this.visitorId;
    data['ba_id'] = this.baId;
    data['ba_status'] = this.baStatus;
    data['is_grooming'] = this.isGrooming;
    data['grooming_value'] = this.groomingValue;
    data['is_uniform'] = this.isUniform;
    data['is_planogram'] = this.isPlanogram;
    data['product_knowledge_value'] = this.productKnowledgeValue;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class VisitorNpds {
  var id;
  var visitorId;
  var skuId;
  var isListed;
  var isAvailable;
  var createdAt;
  var updatedAt;

  VisitorNpds(
      {this.id,
      this.visitorId,
      this.skuId,
      this.isListed,
      this.isAvailable,
      this.createdAt,
      this.updatedAt});

  VisitorNpds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitorId = json['visitor_id'];
    skuId = json['sku_id'];
    isListed = json['is_listed'];
    isAvailable = json['is_available'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['visitor_id'] = this.visitorId;
    data['sku_id'] = this.skuId;
    data['is_listed'] = this.isListed;
    data['is_available'] = this.isAvailable;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class VisitorStocks {
  var id;
  var visitorId;
  var skuId;
  var skuStatus;
  var createdAt;
  var updatedAt;

  VisitorStocks(
      {this.id,
      this.visitorId,
      this.skuId,
      this.skuStatus,
      this.createdAt,
      this.updatedAt});

  VisitorStocks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitorId = json['visitor_id'];
    skuId = json['sku_id'];
    skuStatus = json['sku_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['visitor_id'] = this.visitorId;
    data['sku_id'] = this.skuId;
    data['sku_status'] = this.skuStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

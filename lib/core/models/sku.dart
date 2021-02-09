class Sku {
  int id;
  String name;
  String createdAt;
  String updatedAt;
  int productId;
  int companyId;
  int offerId;
  int price;
  int offerPrice;
  int qty;
  Offer offer;

  Sku(
      {this.id,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.productId,
      this.companyId,
      this.offerId,
      this.price,
      this.offerPrice,
      this.qty,
      this.offer});

  Sku.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productId = json['product_id'];
    companyId = json['company_id'];
    offerId = json['offer_id'];
    price = json['price'];
    offerPrice = json['offer_price'];
    qty = json['qty'];
    offer = json['offer'] != null ? new Offer.fromJson(json['offer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product_id'] = this.productId;
    data['company_id'] = this.companyId;
    data['offer_id'] = this.offerId;
    data['price'] = this.price;
    data['offer_price'] = this.offerPrice;
    data['qty'] = this.qty;
    if (this.offer != null) {
      data['offer'] = this.offer.toJson();
    }
    return data;
  }
}

class Offer {
  int id;
  int companyId;
  int offerTypeId;
  int offer;
  String createdAt;
  String updatedAt;
  OfferType offerType;

  Offer(
      {this.id,
      this.companyId,
      this.offerTypeId,
      this.offer,
      this.createdAt,
      this.updatedAt,
      this.offerType});

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    offerTypeId = json['offer_type_id'];
    offer = json['offer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    offerType = json['offer_type'] != null
        ? new OfferType.fromJson(json['offer_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['offer_type_id'] = this.offerTypeId;
    data['offer'] = this.offer;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.offerType != null) {
      data['offer_type'] = this.offerType.toJson();
    }
    return data;
  }
}

class OfferType {
  int id;
  int companyId;
  String name;
  String createdAt;
  String updatedAt;

  OfferType(
      {this.id, this.companyId, this.name, this.createdAt, this.updatedAt});

  OfferType.fromJson(Map<String, dynamic> json) {
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

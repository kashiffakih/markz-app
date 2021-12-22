class Sku {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? productId;
  int? companyId;
  int? offerId;
  int? price;
  int? offerPrice;
  int? qty;
  int? enteredQty;
  var openingStock;
  var receivedStock;
  var purchaseReturnedStock;
  var salesStock;
  var returnedStock;
  var closingStock;
  var mainCategory;
  var category;
  Offer? offer;

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
      this.enteredQty,
      this.openingStock,
      this.receivedStock,
      this.purchaseReturnedStock,
      this.salesStock,
      this.returnedStock,
      this.closingStock,
      this.mainCategory,
      this.category,
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
    enteredQty = json['enteredQty'];
    openingStock = json['opening_stock'];
    receivedStock = json['received_stock'];
    purchaseReturnedStock = json['purchase_returned_stock'];
    salesStock = json['sales_stock'];
    returnedStock = json['returned_stock'];
    closingStock = json['closing_stock'];
    mainCategory = json['main_category'];
    category = json['category'];
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
    data['opening_stock'] = this.openingStock;
    data['received_stock'] = this.receivedStock;
    data['purchase_returned_stock'] = this.purchaseReturnedStock;
    data['sales_stock'] = this.salesStock;
    data['returned_stock'] = this.returnedStock;
    data['closing_stock'] = this.closingStock;
    data['main_category'] = this.mainCategory;
    data['category'] = this.category;
    data['qty'] = this.qty;
    data['enteredQty'] = this.enteredQty;
    data['opening_stock'] = openingStock;
    data['received_stock'] = receivedStock;
    data['purchase_returned_stock'] = purchaseReturnedStock;
    data['sales_stock'] = salesStock;
    data['returned_stock'] = returnedStock;
    data['closing_stock'] = closingStock;
    data['category'] = this.category;
    data['maincategory'] = this.mainCategory;
    if (this.offer != null) {
      data['offer'] = this.offer!.toJson();
    }
    return data;
  }
}

class Offer {
  int? id;
  int? companyId;
  int? offerTypeId;
  int? offer;
  String? itemName;
  String? createdAt;
  String? updatedAt;
  OfferType? offerType;

  Offer(
      {this.id,
      this.companyId,
      this.offerTypeId,
      this.offer,
      this.itemName,
      this.createdAt,
      this.updatedAt,
      this.offerType});

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    offerTypeId = json['offer_type_id'];
    offer = json['offer'];
    itemName = json['item_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    itemName = json['item_name'];
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
    data['item_name'] = this.itemName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['item_name'] = this.itemName;
    if (this.offerType != null) {
      data['offer_type'] = this.offerType!.toJson();
    }
    return data;
  }
}

class OfferType {
  int? id;
  int? companyId;
  String? name;
  String? createdAt;
  String? updatedAt;

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

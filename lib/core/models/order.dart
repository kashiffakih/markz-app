class Order {
  int? userId;
  String? details;
  int? orderCost;
  int? totalCashback;
  int? couponAmount;
  double? taxAmount;
  int? packagingAmount;
  String? deliveryAmount;
  int? tipAmount;
  String? totalAmount;
  int? walletAmountUsed;
  String? paymentMode;
  int? couponId;
  int? isApprovedByHotelier;
  int? companyId;
  String? updatedAt;
  String? createdAt;
  String? taxPercent;
  int? id;
  List<OrderDetails>? orderDetails;

  Order(
      {this.userId,
      this.details,
      this.orderCost,
      this.totalCashback,
      this.couponAmount,
      this.taxAmount,
      this.packagingAmount,
      this.deliveryAmount,
      this.tipAmount,
      this.totalAmount,
      this.walletAmountUsed,
      this.paymentMode,
      this.couponId,
      this.isApprovedByHotelier,
      this.companyId,
      this.updatedAt,
      this.createdAt,
      this.taxPercent,
      this.id,
      this.orderDetails});

  Order.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    details = json['details'];
    orderCost = json['order_cost'];
    totalCashback = json['total_cashback'];
    couponAmount = json['coupon_amount'];
    taxAmount = json['tax_amount'];
    packagingAmount = json['packaging_amount'];
    deliveryAmount = json['delivery_amount'];
    tipAmount = json['tip_amount'];
    totalAmount = json['total_amount'];
    walletAmountUsed = json['wallet_amount_used'];
    paymentMode = json['payment_mode'];
    couponId = json['coupon_id'];
    isApprovedByHotelier = json['is_approved_by_hotelier'];
    companyId = json['company_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    taxPercent = json['tax_percent'];
    id = json['id'];
    if (json['order_details'] != null) {
      orderDetails = <OrderDetails>[];
      json['order_details'].forEach((v) {
        orderDetails!.add(new OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['details'] = this.details;
    data['order_cost'] = this.orderCost;
    data['total_cashback'] = this.totalCashback;
    data['coupon_amount'] = this.couponAmount;
    data['tax_amount'] = this.taxAmount;
    data['packaging_amount'] = this.packagingAmount;
    data['delivery_amount'] = this.deliveryAmount;
    data['tip_amount'] = this.tipAmount;
    data['total_amount'] = this.totalAmount;
    data['wallet_amount_used'] = this.walletAmountUsed;
    data['payment_mode'] = this.paymentMode;
    data['coupon_id'] = this.couponId;
    data['is_approved_by_hotelier'] = this.isApprovedByHotelier;
    data['company_id'] = this.companyId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['tax_percent'] = this.taxPercent;
    data['id'] = this.id;
    if (this.orderDetails != null) {
      data['order_details'] =
          this.orderDetails!.map((v) => v.toJson()).toList();
    }
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
  Product? product;
  Null? unit;

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
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['unit'] = this.unit;
    return data;
  }
}

class Product {
  int? id;
  int? companyId;
  int? userId;
  int? categoryId;
  Null? inventoryId;
  String? name;
  String? smallDescription;
  String? description;
  Null? location;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  String? imagepath1;
  String? imagepath2;
  String? imagepath3;
  String? imagepath4;
  int? subCategoryId;
  Null? position;
  Null? sub2CategoryId;
  Null? sub3CategoryId;
  String? vegNonveg;
  Null? inventory;

  Product(
      {this.id,
      this.companyId,
      this.userId,
      this.categoryId,
      this.inventoryId,
      this.name,
      this.smallDescription,
      this.description,
      this.location,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.imagepath1,
      this.imagepath2,
      this.imagepath3,
      this.imagepath4,
      this.subCategoryId,
      this.position,
      this.sub2CategoryId,
      this.sub3CategoryId,
      this.vegNonveg,
      this.inventory});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    inventoryId = json['inventory_id'];
    name = json['name'];
    smallDescription = json['small_description'];
    description = json['description'];
    location = json['location'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imagepath1 = json['imagepath1'];
    imagepath2 = json['imagepath2'];
    imagepath3 = json['imagepath3'];
    imagepath4 = json['imagepath4'];
    subCategoryId = json['sub_category_id'];
    position = json['position'];
    sub2CategoryId = json['sub_2_category_id'];
    sub3CategoryId = json['sub_3_category_id'];
    vegNonveg = json['veg_nonveg'];
    inventory = json['inventory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['inventory_id'] = this.inventoryId;
    data['name'] = this.name;
    data['small_description'] = this.smallDescription;
    data['description'] = this.description;
    data['location'] = this.location;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['imagepath1'] = this.imagepath1;
    data['imagepath2'] = this.imagepath2;
    data['imagepath3'] = this.imagepath3;
    data['imagepath4'] = this.imagepath4;
    data['sub_category_id'] = this.subCategoryId;
    data['position'] = this.position;
    data['sub_2_category_id'] = this.sub2CategoryId;
    data['sub_3_category_id'] = this.sub3CategoryId;
    data['veg_nonveg'] = this.vegNonveg;
    data['inventory'] = this.inventory;
    return data;
  }
}

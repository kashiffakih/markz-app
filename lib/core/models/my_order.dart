import 'package:sales_app/core/models/sku.dart';

class MyOrder {
  int distributorId;
  int userId;
  int retailerId;
  int status;
  int total;
  int isOrderTaken;
  String reasonForNoOrder;
  List<OrderDetails> orderDetails;

  MyOrder(
      {this.distributorId,
      this.userId,
      this.retailerId,
      this.status,
      this.total,
      this.isOrderTaken,
      this.reasonForNoOrder,
      this.orderDetails});

  MyOrder.fromJson(Map<String, dynamic> json) {
    distributorId = json['distributor_id'];
    userId = json['user_id'];
    retailerId = json['retailer_id'];
    status = json['status'];
    total = json['total'];
    isOrderTaken = json['is_order_taken'];
    reasonForNoOrder = json['reason_for_no_order'];
    if (json['order_details'] != null) {
      orderDetails = new List<OrderDetails>();
      json['order_details'].forEach((v) {
        orderDetails.add(new OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distributor_id'] = this.distributorId;
    data['user_id'] = this.userId;
    data['retailer_id'] = this.retailerId;
    data['status'] = this.status;
    data['total'] = this.total;
    data['is_order_taken'] = this.isOrderTaken;
    data['reason_for_no_order'] = this.reasonForNoOrder;
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
  int skuId;
  int qty;
  int value;
  int qtyDelivered;
  Sku sku;

  OrderDetails({this.skuId, this.qty, this.value, this.qtyDelivered, this.sku});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    skuId = json['sku_id'];
    qty = json['qty'];
    value = json['value'];
    qtyDelivered = json['qty_delivered'];
    sku = json['sku'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku_id'] = this.skuId;
    data['qty'] = this.qty;
    data['value'] = this.value;
    data['qty_delivered'] = this.qtyDelivered;
    data['sku'] = this.sku;
    return data;
  }
}

import 'package:aadab/core/models/order.dart';
import 'package:intl/intl.dart';

class UserWallet {
  int? id;
  int? userId;
  String? source;
  String? amount;
  String? createdAt;
  String? updatedAt;
  int? noOfDays;
  int? orderId;
  Order? order;

  UserWallet(
      {this.id,
      this.userId,
      this.source,
      this.amount,
      this.createdAt,
      this.updatedAt,
      this.noOfDays,
      this.orderId,
      this.order});

  UserWallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    source = json['source'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    noOfDays = json['no_of_days'];
    orderId = json['order_id'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['source'] = this.source;
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['no_of_days'] = this.noOfDays;
    data['order_id'] = this.orderId;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
  
  String getFormattedCreatedAt() {
    if (createdAt == null || createdAt!.isEmpty) {
      return 'Unknown date';
    }
    
    try {
      // Parse the date string (assuming it's in a standard format)
      DateTime date = DateTime.parse(createdAt!);
      // Format it in a human-readable way
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      // If parsing fails, return the original string or a default message
      return createdAt!;
    }
  }
}

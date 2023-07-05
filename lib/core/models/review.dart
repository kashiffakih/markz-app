import 'package:sales_app/core/models/product.dart';
import 'package:sales_app/core/models/user.dart';

class Review {
  int? id;
  int? userId;
  int? productId;
  String? description;
  String? createdAt;
  String? updatedAt;
  User? user;
  Product? product;

  Review(
      {this.id,
      this.userId,
      this.productId,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.product});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

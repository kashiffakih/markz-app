import 'package:sales_app/core/models/product.dart';
import 'package:sales_app/core/models/user.dart';

class AddToCart {
  int? id;
  int? userId;
  int? productId;
  int? qty;
  String? createdAt;
  String? updatedAt;
  String? kindOfFlower;
  String? flavour;
  String? writeOnCake;
  String? pack;
  String? productPrice;
  int? points;
  User? user;
  Product? product;

  AddToCart(
      {this.id,
      this.userId,
      this.productId,
      this.qty,
      this.createdAt,
      this.updatedAt,
      this.kindOfFlower,
      this.flavour,
      this.writeOnCake,
      this.pack,
      this.points,
      this.productPrice,
      this.user,
      this.product});

  AddToCart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    qty = json['qty'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    kindOfFlower = json['kind_of_flower'];
    flavour = json['flavour'];
    writeOnCake = json['write_on_cake'];
    pack = json['pack'];
    points = json['points'];
    productPrice = json['product_price'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['qty'] = this.qty;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['kind_of_flower'] = this.kindOfFlower;
    data['flavour'] = this.flavour;
    data['write_on_cake'] = this.writeOnCake;
    data['pack'] = this.pack;
    data['product_price'] = this.productPrice;
    data['points'] = this.points;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

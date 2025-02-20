import 'package:aadab/core/models/product.dart';
import 'package:aadab/core/models/review_image.dart';
import 'package:aadab/core/models/user.dart';

class Review {
  int? id;
  int? userId;
  int? productId;
  String? description;
  String? rating;
  String? createdAt;
  String? updatedAt;
  User? user;
  Product? product;
  List<ReviewImages>? reviewImages;

  Review(
      {this.id,
      this.userId,
      this.productId,
      this.description,
      this.rating,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.product,
      this.reviewImages});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    description = json['description'];
    rating = json['rating'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    if (json['review_images'] != null) {
      reviewImages = <ReviewImages>[];
      json['review_images'].forEach((v) {
        reviewImages!.add(new ReviewImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.reviewImages != null) {
      data['review_images'] =
          this.reviewImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

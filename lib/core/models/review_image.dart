class ReviewImages {
  int? id;
  int? reviewId;
  String? imagePath;
  String? createdAt;
  String? updatedAt;

  ReviewImages(
      {this.id, this.reviewId, this.imagePath, this.createdAt, this.updatedAt});

  ReviewImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reviewId = json['review_id'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['review_id'] = this.reviewId;
    data['image_path'] = this.imagePath;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

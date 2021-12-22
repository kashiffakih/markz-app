class Requisition {
  int? id;
  int? companyId;
  String? title;
  String? description;
  String? requisitionType;
  String? imagePath;
  String? createdAt;
  String? updatedAt;
  String? userId;

  Requisition(
      {this.id,
      this.companyId,
      this.title,
      this.description,
      this.requisitionType,
      this.imagePath,
      this.createdAt,
      this.updatedAt,
      this.userId});

  Requisition.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    title = json['title'];
    description = json['description'];
    requisitionType = json['requisition_type'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['requisition_type'] = this.requisitionType;
    data['image_path'] = this.imagePath;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    return data;
  }
}

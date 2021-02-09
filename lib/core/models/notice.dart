class Notice {
  int id;
  int companyId;
  String name;
  String title;
  String description;
  String imagepath;
  String createdAt;
  String updatedAt;

  Notice(
      {this.id,
      this.companyId,
      this.name,
      this.title,
      this.description,
      this.imagepath,
      this.createdAt,
      this.updatedAt});

  Notice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    title = json['title'];
    description = json['description'];
    imagepath = json['imagepath'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['title'] = this.title;
    data['description'] = this.description;
    data['imagepath'] = this.imagepath;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
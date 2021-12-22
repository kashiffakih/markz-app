class DailyPhoto {
  var id;
  var companyId;
  var userId;
  var imagePath;
  var imagePath1;
  var imagePath2;
  var imagePath3;
  var imagePath4;
  var description;
  var date;
  var title;

  DailyPhoto(
      {this.id,
      this.companyId,
      this.userId,
      this.imagePath,
      this.imagePath1,
      this.imagePath2,
      this.imagePath3,
      this.imagePath4,
      this.description,
      this.date,
      this.title});

  DailyPhoto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    imagePath = json['image_path'];
    imagePath1 = json['image_path_1'];
    imagePath2 = json['image_path_2'];
    imagePath3 = json['image_path_3'];
    imagePath4 = json['image_path_4'];
    description = json['description'];
    date = json['date'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['image_path'] = this.imagePath;
    data['image_path_1'] = this.imagePath1;
    data['image_path_2'] = this.imagePath2;
    data['image_path_3'] = this.imagePath3;
    data['image_path_4'] = this.imagePath4;
    data['description'] = this.description;
    data['date'] = this.date;
    data['title'] = this.title;
    return data;
  }
}

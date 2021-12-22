class Course {
  var id;
  var siteId;
  var courseName;
  var description;
  var instructor;
  var noOfHrs;
  var imagepath;
  var createdAt;
  var updatedAt;
  List<CourseDetails>? courseDetails;

  Course(
      {this.id,
      this.siteId,
      this.courseName,
      this.description,
      this.instructor,
      this.noOfHrs,
      this.imagepath,
      this.createdAt,
      this.updatedAt,
      this.courseDetails});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteId = json['site_id'];
    courseName = json['course_name'];
    description = json['description'];
    instructor = json['instructor'];
    noOfHrs = json['no_of_hrs'];
    imagepath = json['imagepath'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['course_details'] != null) {
      courseDetails = [];
      json['course_details'].forEach((v) {
        courseDetails!.add(new CourseDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site_id'] = this.siteId;
    data['course_name'] = this.courseName;
    data['description'] = this.description;
    data['instructor'] = this.instructor;
    data['no_of_hrs'] = this.noOfHrs;
    data['imagepath'] = this.imagepath;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.courseDetails != null) {
      data['course_details'] =
          this.courseDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CourseDetails {
  int? id;
  int? courseId;
  String? title;
  String? description;
  String? noOfHrs;
  String? imagepath;
  String? videolink;
  String? createdAt;
  String? updatedAt;

  CourseDetails(
      {this.id,
      this.courseId,
      this.title,
      this.description,
      this.noOfHrs,
      this.imagepath,
      this.videolink,
      this.createdAt,
      this.updatedAt});

  CourseDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['course_id'];
    title = json['title'];
    description = json['description'];
    noOfHrs = json['no_of_hrs'];
    imagepath = json['imagepath'];
    videolink = json['videolink'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_id'] = this.courseId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['no_of_hrs'] = this.noOfHrs;
    data['imagepath'] = this.imagepath;
    data['videolink'] = this.videolink;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

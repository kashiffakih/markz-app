class File {
  String file;
  String fileName;

  File({this.file, this.fileName});

  File.fromJson(Map<String, dynamic> json) {
    file = json['file'];
    fileName = json['file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file'] = this.file;
    data['file_name'] = this.fileName;
    return data;
  }
}

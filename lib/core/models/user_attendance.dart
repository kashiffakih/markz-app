class UserAttendance {
  int id;
  int userId;
  String date;
  String loginTime;
  String logoutTime;
  String loginLat;
  String logoutLat;
  String loginLng;
  String logoutLng;
  String createdAt;
  String updatedAt;
  String battery;
  String sessionType;
  String remarks;
  String loginAddress;
  String logoutAddress;

  UserAttendance(
      {this.id,
      this.userId,
      this.date,
      this.loginTime,
      this.logoutTime,
      this.loginLat,
      this.logoutLat,
      this.loginLng,
      this.logoutLng,
      this.createdAt,
      this.updatedAt,
      this.battery,
      this.sessionType,
      this.remarks,
      this.loginAddress,
      this.logoutAddress});

  UserAttendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    date = json['date'];
    loginTime = json['login_time'];
    logoutTime = json['logout_time'];
    loginLat = json['login_lat'];
    logoutLat = json['logout_lat'];
    loginLng = json['login_lng'];
    logoutLng = json['logout_lng'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    battery = json['battery'];
    sessionType = json['session_type'];
    remarks = json['remarks'];
    loginAddress = json['login_address'];
    logoutAddress = json['logout_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['date'] = this.date;
    data['login_time'] = this.loginTime;
    data['logout_time'] = this.logoutTime;
    data['login_lat'] = this.loginLat;
    data['logout_lat'] = this.logoutLat;
    data['login_lng'] = this.loginLng;
    data['logout_lng'] = this.logoutLng;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['battery'] = this.battery;
    data['session_type'] = this.sessionType;
    data['remarks'] = this.remarks;
    data['login_address'] = this.loginAddress;
    data['logout_address'] = this.logoutAddress;
    return data;
  }
}

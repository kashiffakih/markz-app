class CompetitorData {
  var id;
  var companyId;
  var userId;
  var competitor;
  var amount;
  var month;
  var year;

  CompetitorData(
      {this.id,
      this.companyId,
      this.userId,
      this.competitor,
      this.amount,
      this.month,
      this.year});

  CompetitorData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    competitor = json['competitor'];
    amount = json['amount'];
    month = json['month'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['competitor'] = this.competitor;
    data['amount'] = this.amount;
    data['month'] = this.month;
    data['year'] = this.year;
    return data;
  }
}

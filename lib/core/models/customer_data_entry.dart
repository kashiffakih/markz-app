class CustomerDataEntry {
  var id;
  var companyId;
  var userId;
  var name;
  var number;
  var email;
  var productBrought;
  var sampleGiven;
  var createdAt;

  CustomerDataEntry({
    this.id,
    this.companyId,
    this.userId,
    this.name,
    this.number,
    this.email,
    this.productBrought,
    this.sampleGiven,
    this.createdAt,
  });

  CustomerDataEntry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    name = json['name'];
    number = json['number'];
    email = json['email'];
    productBrought = json['product_brought'];
    sampleGiven = json['sample_given'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['number'] = this.number;
    data['email'] = this.email;
    data['product_brought'] = this.productBrought;
    data['sample_given'] = this.sampleGiven;
    data['created_at'] = this.createdAt;
    return data;
  }
}

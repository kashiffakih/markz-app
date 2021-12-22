class Customer {
  var id;
  var companyId;
  var userId;
  var date;
  var noOfCustomer;
  var noOfBilledCustomer;
  var moreThanTwo;

  Customer(
      {this.id,
      this.companyId,
      this.userId,
      this.date,
      this.noOfCustomer,
      this.noOfBilledCustomer,
      this.moreThanTwo});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    date = json['date'];
    noOfCustomer = json['no_of_customer'];
    noOfBilledCustomer = json['no_of_billed_customer'];
    moreThanTwo = json['more_than_two'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['date'] = this.date;
    data['no_of_customer'] = this.noOfCustomer;
    data['no_of_billed_customer'] = this.noOfBilledCustomer;
    data['more_than_two'] = this.moreThanTwo;
    return data;
  }
}

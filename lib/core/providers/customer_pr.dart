import 'package:flutter/material.dart';
import 'package:sales_app/core/models/customer.dart';
import 'package:sales_app/core/services/customer_s.dart';
import 'package:sales_app/locator.dart';

class CustomerModel with ChangeNotifier {
  final CustomerService _customerService = locator<CustomerService>();

  bool customersLoader = true;

  List<Customer> _customers = [];
  set customers(List<Customer> newCustomers) {
    _customers = newCustomers;
    customersLoader = false;
    notifyListeners();
  }

  List<Customer> get customers => _customers;

  getCustomers({@required monthId, @required year}) async {
    customersLoader = false;
    notifyListeners();
    customers = await _customerService.getCustomers(
      monthId: monthId,
      year: year,
    );
  }

  Future<void> customerCreate({@required Customer? customer}) async {
    await _customerService.customerCreate(customer: customer);
  }
}

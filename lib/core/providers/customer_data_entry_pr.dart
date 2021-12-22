import 'package:flutter/material.dart';
import 'package:sales_app/core/models/customer.dart';
import 'package:sales_app/core/models/customer_data_entry.dart';
import 'package:sales_app/core/services/customer_data_entry_s.dart';
import 'package:sales_app/core/services/customer_s.dart';
import 'package:sales_app/locator.dart';

class CustomerDataEntryModel with ChangeNotifier {
  final CustomerDataEntryService _customerDataEntryService =
      locator<CustomerDataEntryService>();

  bool customerDataEntriesLoader = true;

  List<CustomerDataEntry> _customerDataEntries = [];
  set customerDataEntries(List<CustomerDataEntry> newCustomerDataEntries) {
    _customerDataEntries = newCustomerDataEntries;
    customerDataEntriesLoader = false;
    notifyListeners();
  }

  List<CustomerDataEntry> get customerDataEntries => _customerDataEntries;

  getCustomerDataEntries() async {
    customerDataEntries =
        await _customerDataEntryService.getCustomerDataEntries();
  }

  Future<void> customerDataEntryCreate(
      {@required CustomerDataEntry? customerDataEntry}) async {
    await _customerDataEntryService.customerDataEntryCreate(
        customerDataEntry: customerDataEntry);
  }
}

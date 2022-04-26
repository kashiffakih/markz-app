import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/customer.dart';
import 'package:sales_app/core/models/customer_data_entry.dart';
import 'package:sales_app/core/providers/customer_data_entry_pr.dart';
import 'package:sales_app/core/providers/customer_pr.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

class CustomerDataEntryCreatePage extends StatefulWidget {
  @override
  _CustomerDataEntryCreatePageState createState() =>
      _CustomerDataEntryCreatePageState();
}

class _CustomerDataEntryCreatePageState
    extends State<CustomerDataEntryCreatePage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _customerDataEntryModel =
        Provider.of<CustomerDataEntryModel>(context);
    CustomerDataEntry _customerDataEntry = CustomerDataEntry();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Customer Data',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.backgroundImg),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Name',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Name'),
                              validator: (value) {
                                if (value!.isEmpty) return 'Please name';
                                return null;
                              },
                              onSaved: (value) {
                                _customerDataEntry.name = value;
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Email'),
                              validator: (value) {
                                if (value!.isEmpty) return 'Please enter email';
                                return null;
                              },
                              onSaved: (value) {
                                _customerDataEntry.email = value;
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Phone',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Phone'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) return 'Please enter phone';
                                return null;
                              },
                              onSaved: (value) {
                                _customerDataEntry.number = value;
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Freebies',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              maxLines: 2,
                              decoration:
                                  InputDecoration(labelText: 'Products'),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Please enter products';
                                return null;
                              },
                              onSaved: (value) {
                                _customerDataEntry.productBrought = value;
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _isLoading
                          ? Text('Saving Data...')
                          : ElevatedButton(
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  _key.currentState!.save();
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await _customerDataEntryModel
                                      .customerDataEntryCreate(
                                          customerDataEntry:
                                              _customerDataEntry);

                                  _customerDataEntryModel
                                      .getCustomerDataEntries();

                                  Navigator.pop(context);

                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                              child: Text('Add Customer Data'),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/customer.dart';
import 'package:sales_app/core/providers/customer_pr.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

class ProductivityCreatePage extends StatefulWidget {
  @override
  _ProductivityCreatePageState createState() => _ProductivityCreatePageState();
}

class _ProductivityCreatePageState extends State<ProductivityCreatePage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _customerModel = Provider.of<CustomerModel>(context);
    Customer _customer = Customer();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Data',
          style: TextStyle(
            fontSize: 15,
          ),
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
                            flex: 4,
                            child: Text(
                              'Customers Approached',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'No.'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) return 'Please enter value';
                                return null;
                              },
                              onSaved: (value) {
                                _customer.noOfCustomer = value;
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Billed Customers',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'No.'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) return 'Please enter value';
                                return null;
                              },
                              onSaved: (value) {
                                _customer.noOfBilledCustomer = value;
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Customers with >2 pcs',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'No.'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) return 'Please enter value';
                                return null;
                              },
                              onSaved: (value) {
                                _customer.moreThanTwo = value;
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
                                  await _customerModel.customerCreate(
                                    customer: _customer,
                                  );

                                  _customerModel.getCustomers();

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

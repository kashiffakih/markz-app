import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/customer_pr.dart';

class ProductivityIndexPage extends StatelessWidget {
  const ProductivityIndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _customerModel = Provider.of<CustomerModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Productivity'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _customerModel.customersLoader
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  child: Card(
                    elevation: 10,
                    child: Column(
                      children: [
                        Container(
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Date',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Cust.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Billed',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '>2',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ..._customerModel.customers
                            .map(
                              (_customer) => Container(
                                decoration: _customerModel.customers
                                                .indexOf(_customer) %
                                            2 !=
                                        0
                                    ? BoxDecoration(color: Colors.grey[400])
                                    : BoxDecoration(color: Colors.white),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            _customer.date.toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _customer.noOfCustomer.toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _customer.noOfBilledCustomer
                                                .toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _customer.moreThanTwo.toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Divider(),
                                  ],
                                ),
                              ),
                            )
                            .toList()
                      ],
                    ),
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.add),
        backgroundColor: new Color(0xFFE57373),
        onPressed: () {
          Navigator.pushNamed(context, '/productivityCreate');
        },
      ),
    );
  }
}

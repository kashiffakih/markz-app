import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/customer_data_entry_pr.dart';
import 'package:sales_app/core/providers/customer_pr.dart';

class CustomerDataEntryPage extends StatelessWidget {
  const CustomerDataEntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _customerDataEntryModel =
        Provider.of<CustomerDataEntryModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _customerDataEntryModel.customerDataEntriesLoader
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
                                flex: 2,
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
                                  'Name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Phone',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ..._customerDataEntryModel.customerDataEntries
                            .map(
                              (_customerDataEntry) => Container(
                                decoration: _customerDataEntryModel
                                                .customerDataEntries
                                                .indexOf(_customerDataEntry) %
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
                                            _customerDataEntry.createdAt
                                                .toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _customerDataEntry.name.toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _customerDataEntry.email.toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _customerDataEntry.number
                                                .toString(),
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
          Navigator.pushNamed(context, '/customerDataEntryCreate');
        },
      ),
    );
  }
}

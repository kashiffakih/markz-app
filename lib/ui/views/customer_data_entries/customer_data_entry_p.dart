import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/customer_data_entry_pr.dart';
import 'package:sales_app/core/providers/customer_pr.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

class CustomerDataEntryPage extends StatelessWidget {
  const CustomerDataEntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _customerDataEntryModel =
        Provider.of<CustomerDataEntryModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customers',
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
                                  child: Text(
                                    'Date',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Email',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Phone',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Products',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
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
                                            child: Text(
                                              _customerDataEntry.createdAt
                                                  .toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _customerDataEntry.name
                                                  .toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _customerDataEntry.email
                                                  .toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _customerDataEntry.number
                                                  .toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _customerDataEntry
                                                          .productBrought !=
                                                      null
                                                  ? _customerDataEntry
                                                      .productBrought
                                                  : '',
                                              style: TextStyle(fontSize: 15),
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

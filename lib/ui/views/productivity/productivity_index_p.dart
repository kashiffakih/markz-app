import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/customer_pr.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

class ProductivityIndexPage extends StatefulWidget {
  const ProductivityIndexPage({Key? key}) : super(key: key);

  @override
  State<ProductivityIndexPage> createState() => _ProductivityIndexPageState();
}

class _ProductivityIndexPageState extends State<ProductivityIndexPage> {
  List<dynamic> _months = [
    {'name': 'January', 'value': '1'},
    {'name': 'February', 'value': '2'},
    {'name': 'March', 'value': '3'},
    {'name': 'April', 'value': '4'},
    {'name': 'May', 'value': '5'},
    {'name': 'June', 'value': '6'},
    {'name': 'July', 'value': '7'},
    {'name': 'August', 'value': '8'},
    {'name': 'September', 'value': '9'},
    {'name': 'October', 'value': '10'},
    {'name': 'November', 'value': '11'},
    {'name': 'December', 'value': '12'},
  ];
  List<dynamic> _years = [
    {'name': '2022', 'value': '2022'},
  ];

  DateFormat format = DateFormat('M');
  String selectedYear = DateTime.now().year.toString();

  @override
  Widget build(BuildContext context) {
    String selectedMonthId = format.format(DateTime.now());

    final _customerModel = Provider.of<CustomerModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Productivity',
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
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButtonFormField(
                                            decoration: InputDecoration(
                                                labelText: 'Select month'),
                                            value: selectedMonthId,
                                            items: _months
                                                .map(
                                                  (_month) => DropdownMenuItem(
                                                    value: _month['value'],
                                                    child: Text(
                                                      _month['name'],
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            validator: (value) {
                                              if (value == null)
                                                return 'Please select month';
                                              return null;
                                            },
                                            onChanged: (value) {
                                              setState(() async {
                                                selectedMonthId =
                                                    value.toString();
                                                await _customerModel
                                                    .getCustomers(
                                                  monthId: selectedMonthId,
                                                  year: selectedYear,
                                                );
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: DropdownButtonFormField(
                                            decoration: InputDecoration(
                                                labelText: 'Select year'),
                                            value: selectedYear,
                                            items: _years
                                                .map(
                                                  (_year) => DropdownMenuItem(
                                                    value: _year['value'],
                                                    child: Text(
                                                      _year['name'],
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            validator: (value) {
                                              if (value == null)
                                                return 'Please select year';
                                              return null;
                                            },
                                            onChanged: (value) async {
                                              setState(() async {
                                                selectedYear = value.toString();
                                                await _customerModel
                                                    .getCustomers(
                                                  monthId: selectedMonthId,
                                                  year: selectedYear,
                                                );
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
                                    'Cust.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Billed',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '>2',
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
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _customer.noOfCustomer.toString(),
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _customer.noOfBilledCustomer
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _customer.moreThanTwo.toString(),
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
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
          Navigator.pushNamed(context, '/productivityCreate');
        },
      ),
    );
  }
}

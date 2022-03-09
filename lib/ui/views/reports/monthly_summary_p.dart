import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/order_pr.dart';

class MonthlySummaryPage extends StatefulWidget {
  const MonthlySummaryPage({Key? key}) : super(key: key);

  @override
  State<MonthlySummaryPage> createState() => _MonthlySummaryPageState();
}

class _MonthlySummaryPageState extends State<MonthlySummaryPage> {
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
  List<dynamic> _dataTypes = [
    {'name': 'Opening', 'value': 'Opening Stock'},
    {'name': 'Stock Received', 'value': 'Stock Received'},
    {'name': 'Stocks Returned', 'value': 'Purchase Returned'},
    {'name': 'Offtakes', 'value': 'Sales'},
    {'name': 'Offtake Returned', 'value': 'Stock Returned'},
  ];

  // DateFormat format = DateFormat('M');

  String selectedMonthId = '2';
  // DateFormat yearFormat = DateFormat('Y');
  String selectedYear = DateTime.now().year.toString();
  String selectedDataType = 'Sales';

  @override
  Widget build(BuildContext context) {
    final _orderModel = Provider.of<OrderModel>(context);

    int? totalAmount = 0;

    _orderModel.orders.forEach((_order) {
      totalAmount = totalAmount! + int.parse(_order.total.toString());
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Summary'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
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
                                      selectedMonthId = value.toString();
                                      await _orderModel.fetchOrdersOfMonth(
                                        monthId: selectedMonthId,
                                        year: selectedYear,
                                        dataType: selectedDataType,
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
                                  decoration:
                                      InputDecoration(labelText: 'Select year'),
                                  value: selectedYear,
                                  items: _years
                                      .map(
                                        (_year) => DropdownMenuItem(
                                          value: _year['value'],
                                          child: Text(
                                            _year['name'],
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
                                      await _orderModel.fetchOrdersOfMonth(
                                        monthId: selectedMonthId,
                                        year: selectedYear,
                                        dataType: selectedDataType,
                                      );
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField(
                                  value: selectedDataType,
                                  decoration: InputDecoration(
                                      labelText: 'Select data type'),
                                  items: _dataTypes
                                      .map(
                                        (_dataType) => DropdownMenuItem(
                                          value: _dataType['value'],
                                          child: Text(
                                            _dataType['name'],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  validator: (value) {
                                    if (value == null)
                                      return 'Please select data type';
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() async {
                                      selectedDataType = value.toString();
                                      await _orderModel.fetchOrdersOfMonth(
                                        monthId: selectedMonthId,
                                        year: selectedYear,
                                        dataType: selectedDataType,
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
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            color: Theme.of(context).primaryColor,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  // flex: 2,
                                  child: Text(
                                    'DATE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'ITEMS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'VALUE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_orderModel.ordersLoader == true)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            )
                          else
                            ..._orderModel.orders
                                .map(
                                  (_order) => InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/orderDetailItems',
                                          arguments: {
                                            'order': _order,
                                          });
                                    },
                                    child: Container(
                                      decoration: _orderModel.orders
                                                      .indexOf(_order) %
                                                  2 !=
                                              0
                                          ? BoxDecoration(
                                              color: Colors.grey[400])
                                          : BoxDecoration(color: Colors.white),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                // flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _order.createdAt
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Text(_order
                                                      .orderDetails!.length
                                                      .toString()),
                                                ),
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    '₹. ' +
                                                        _order.total.toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Divider(),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF6200EE),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {},
        items: [
          BottomNavigationBarItem(
            title: Text(
              'Total',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            icon: Icon(Icons.arrow_right),
          ),
          BottomNavigationBarItem(
            title: Text(
              '₹.' + totalAmount.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            icon: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }
}

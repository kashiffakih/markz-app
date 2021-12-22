import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/order_pr.dart';

class OrderDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _orderModel = Provider.of<OrderModel>(context);
    DateFormat format = DateFormat('dd-MM-yyyy');

    String todayDate = format.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Offtake Summary | ' + todayDate),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _orderModel.ordersLoader
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
                                  'STORE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'TYPE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'NO OF ITEMS',
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
                                      ? BoxDecoration(color: Colors.grey[400])
                                      : BoxDecoration(color: Colors.white),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _order.retailer!.name
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  _order.retailer!.address
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          if (_order.orderType ==
                                              'Opening Stock')
                                            Expanded(
                                              child: Center(
                                                child: Text('Opening'),
                                              ),
                                            ),
                                          if (_order.orderType ==
                                              'Stock Received')
                                            Expanded(
                                              child: Center(
                                                child: Text('Stock Received'),
                                              ),
                                            ),
                                          if (_order.orderType ==
                                              'Purchase Returned')
                                            Expanded(
                                              child: Center(
                                                child: Text('Stocks Returned'),
                                              ),
                                            ),
                                          if (_order.orderType == 'Sales')
                                            Expanded(
                                              child: Center(
                                                child: Text('Offtake'),
                                              ),
                                            ),
                                          if (_order.orderType ==
                                              'Stock Returned')
                                            Expanded(
                                              child: Center(
                                                child: Text('Offtake Returned'),
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
                                                '₹. ' + _order.total.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
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
      ),
    );
  }
}

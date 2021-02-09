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
        title: Text('Daily Orders Summary | ' + todayDate),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _orderModel.orders == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'OUTLET',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'NO OF ITEMS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'VALUE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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
                              Navigator.pushNamed(context, '/orderDetailItems',
                                  arguments: {
                                    'order': _order,
                                  });
                            },
                            child: Container(
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
                                              _order.retailer.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              _order.retailer.address,
                                              style: TextStyle(
                                                fontSize: 10,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(_order.orderDetails.length
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
                                  Divider(),
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
    );
  }
}

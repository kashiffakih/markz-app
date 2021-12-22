import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/order.dart';
import 'package:sales_app/core/providers/my_order_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';

class OrderDetailItemsPage extends StatefulWidget {
  final arguments; // order

  OrderDetailItemsPage({@required this.arguments});

  @override
  _OrderDetailItemsPageState createState() => _OrderDetailItemsPageState();
}

class _OrderDetailItemsPageState extends State<OrderDetailItemsPage> {
  @override
  Widget build(BuildContext context) {
    final _orderModel = Provider.of<OrderModel>(context);
    final _myOrderModel = Provider.of<MyOrderModel>(context);

    Order _order = _orderModel.orders
        .firstWhere((_order) => _order.id == widget.arguments['order'].id);

    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text('Details'),
          bottom: PreferredSize(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Product Name',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Qty',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '*',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Price',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ':',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Amount',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(40),
          ),
        ),
        preferredSize: Size.fromHeight(100),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Card(
              elevation: 10,
              child: Column(
                children: _order == null
                    ? []
                    : _order.orderDetails!
                        .map(
                          (_orderDetail) => Container(
                            decoration:
                                _order.orderDetails!.indexOf(_orderDetail) %
                                            2 !=
                                        0
                                    ? BoxDecoration(color: Colors.grey[400])
                                    : BoxDecoration(color: Colors.white),
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_orderDetail.sku!.offerId == null)
                                  Text(
                                    _orderDetail.sku!.name.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                else if (_orderDetail
                                        .sku!.offer!.offerType!.name ==
                                    'FLAT')
                                  Text(
                                    _orderDetail.sku!.name! +
                                        ' (₹.' +
                                        _orderDetail.sku!.offer!.offer
                                            .toString() +
                                        ' OFF)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                else if (_orderDetail
                                        .sku!.offer!.offerType!.name ==
                                    'PERCENT')
                                  Text(
                                    _orderDetail.sku!.name! +
                                        ' (' +
                                        _orderDetail.sku!.offer!.offer
                                            .toString() +
                                        '% OFF)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                else if (_orderDetail
                                        .sku!.offer!.offerType!.name ==
                                    'FREE GIFT')
                                  Text(
                                    _orderDetail.sku!.name! +
                                        ' (' +
                                        _orderDetail.sku!.offer!.itemName
                                            .toString() +
                                        ')',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                else if (_orderDetail
                                        .sku!.offer!.offerType!.name ==
                                    'FREE QTY')
                                  Text(
                                    _orderDetail.sku!.name! +
                                        ' (' +
                                        _orderDetail.sku!.offer!.itemName
                                            .toString() +
                                        ')',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                // Text(
                                //   _orderDetail.sku.name,
                                //   style: TextStyle(
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        // decoration: BoxDecoration(
                                        //   border: Border.all(),
                                        //   borderRadius: BorderRadius.all(
                                        //     Radius.circular(5),
                                        //   ),
                                        // ),
                                        child: TextFormField(
                                          initialValue:
                                              _orderDetail.qty.toString(),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Enter Qty',
                                            // border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value != '' && value != '0') {
                                                double pricePerUnit =
                                                    _orderDetail.value! /
                                                        int.parse(_orderDetail
                                                            .qty
                                                            .toString());
                                                _orderDetail.qty =
                                                    int.parse(value);
                                                _orderDetail.value =
                                                    _orderDetail.qty! *
                                                        pricePerUnit.toInt();
                                                _order.total = 0;
                                                _order.orderDetails!
                                                    .forEach((_detail) {
                                                  _order.total = _order.total! +
                                                      int.parse(_detail.value
                                                          .toString());
                                                });
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '*',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '₹. ' +
                                            (_orderDetail.value! /
                                                    int.parse(_orderDetail.qty
                                                        .toString()))
                                                .toString(),
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '₹. ' + _orderDetail.value.toString(),
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Divider()
                              ],
                            ),
                          ),
                        )
                        .toList(),
              ),
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
        onTap: (value) {
          if (value == 1) {
            _myOrderModel.updatePreviousOrder(order: _order);
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Offtake updated successfully'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      // Navigator.pushReplacementNamed(context, '/orderDetails');
                    },
                    child: Text('Ok'),
                  ),
                ],
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            title: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Count: ' +
                              (_order != null
                                  ? _order.orderDetails!.length.toString()
                                  : ''),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Total: ₹. ' +
                              (_order != null ? _order.total.toString() : '') +
                              '/-',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            icon: Icon(Icons.arrow_right),
          ),
          BottomNavigationBarItem(
            title: Text(
              'UPDATE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            icon: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }
}

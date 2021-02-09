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
          title: Text('Order Details'),
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
          child: Column(
            children: _order == null
                ? []
                : _order.orderDetails
                    .map(
                      (_orderDetail) => Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _orderDetail.sku.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _orderDetail.qty.toString(),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Enter Qty',
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != '' && value != '0') {
                                          double pricePerUnit =
                                              _orderDetail.value /
                                                  _orderDetail.qty;
                                          _orderDetail.qty = int.parse(value);
                                          _orderDetail.value =
                                              _orderDetail.qty *
                                                  pricePerUnit.toInt();
                                          _order.total = 0;
                                          _order.orderDetails
                                              .forEach((_detail) {
                                            _order.total += _detail.value;
                                          });
                                        }
                                      });
                                    },
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
                                        (_orderDetail.value / _orderDetail.qty)
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
                            Divider()
                          ],
                        ),
                      ),
                    )
                    .toList(),
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
              child: AlertDialog(
                title: Text('Order updated successfully'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/orderDetails');
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
                                  ? _order.orderDetails.length.toString()
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

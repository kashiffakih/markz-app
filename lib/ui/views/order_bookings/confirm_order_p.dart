import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/my_order_pr.dart';

class ConfirmOrderPage extends StatefulWidget {
  final arguments; // beat, outlet

  ConfirmOrderPage({@required this.arguments});

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  @override
  Widget build(BuildContext context) {
    final _myOrderModel = Provider.of<MyOrderModel>(context);

    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text('Order Confirmation: ' + widget.arguments['outlet'].name),
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
            children: _myOrderModel.order == null
                ? []
                : _myOrderModel.order.orderDetails
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
                                  child: Text(
                                    _orderDetail.qty.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
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
                                        (_orderDetail.sku.offerPrice != null
                                            ? _orderDetail.sku.offerPrice
                                                .toString()
                                            : _orderDetail.sku.price
                                                .toString()),
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
            _myOrderModel.saveOrder();
            showDialog(
              context: context,
              child: AlertDialog(
                title: Text('Order Successfully placed'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      _myOrderModel.emptyOrder();
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/home');
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
                              (_myOrderModel.order != null
                                  ? _myOrderModel.order.orderDetails.length
                                      .toString()
                                  : ''),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Total: ₹. ' +
                              (_myOrderModel.order != null
                                  ? _myOrderModel.order.total.toString()
                                  : '') +
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
              'SUBMIT/CONFIRM',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            icon: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/my_order_pr.dart';
import 'package:sales_app/core/providers/sku_pr.dart';

class OrderPage extends StatefulWidget {
  final arguments; // beat, outlet

  OrderPage({@required this.arguments});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    final _skuModel = Provider.of<SkuModel>(context);
    final _myOrderModel = Provider.of<MyOrderModel>(context);

    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text('Order Booking: ' + widget.arguments['outlet'].name),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () {},
          //   ),
          // ],
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
                          'MRP',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'PTR W-Tax',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Qty. Av.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Qty',
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
            children: _skuModel.skus
                .map(
                  (_sku) => Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _sku.name,
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
                                '₹. ' + _sku.price.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (_sku.offerPrice == null)
                              Expanded(
                                child: Text(
                                  '₹. ' + _sku.price.toString(),
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                child: Text(
                                  '₹. ' + (_sku.offerPrice).toString(),
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                _sku.qty.toString(),
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Qty',
                                  ),
                                  onChanged: (value) {
                                    if (_myOrderModel.order == null)
                                      _myOrderModel.updateOrder(
                                        retailerId:
                                            widget.arguments['outlet'].id,
                                      );
                                    if (_myOrderModel.order.retailerId ==
                                        widget.arguments['outlet'].id) {
                                      _myOrderModel.addOrUpdateOrderDetail(
                                        sku: _sku,
                                        qty: value == '' ? 0 : int.parse(value),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        child: AlertDialog(
                                          title: Text(
                                              'Order from another retailer is already there in the cart. Do you want to reset the order'),
                                          actions: [
                                            FlatButton(
                                              onPressed: () {
                                                _myOrderModel.emptyOrder();
                                                Navigator.pop(context);
                                              },
                                              child: Text('Yes'),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pushNamed(
                                                    context, '/beats');
                                              },
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  },
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
          if (_myOrderModel.order == null ||
              _myOrderModel.order.orderDetails.length == 0)
            showDialog(
              context: context,
              child: AlertDialog(
                title: Text('Order Empty'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Ok')),
                ],
              ),
            );
          else if (value == 1) {
            Navigator.pushNamed(context, '/confirmOrder', arguments: {
              'beat': widget.arguments['beat'],
              'outlet': widget.arguments['outlet'],
            });
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
              'NEXT',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            icon: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }
}

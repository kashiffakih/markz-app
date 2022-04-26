import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/order.dart';
import 'package:sales_app/core/providers/my_order_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

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

    DateFormat format = DateFormat('dd-MM-yyyy');

    String todayDate = format.format(DateTime.now());

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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '*',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Price',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ':',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Amount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
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
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.backgroundImg),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              child: Card(
                elevation: 10,
                child: Column(
                  children: _order.id == null
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
                                        fontSize: 15,
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
                                        fontSize: 15,
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
                                        fontSize: 15,
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
                                        fontSize: 15,
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
                                        fontSize: 15,
                                      ),
                                    ),
                                  // Text(
                                  //   _orderDetail.sku!.name!,
                                  //   style: TextStyle(fontSize: 15),
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
                                          child: format.format(DateTime.parse(
                                                      _order.createdAt
                                                          .toString())) !=
                                                  todayDate
                                              ? Text(
                                                  _orderDetail.qty.toString(),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                )
                                              : TextFormField(
                                                  initialValue: _orderDetail.qty
                                                      .toString(),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    labelText: 'Enter Qty',
                                                    // border: InputBorder.none,
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (value != '' &&
                                                          value != '0') {
                                                        double pricePerUnit =
                                                            _orderDetail
                                                                    .value! /
                                                                int.parse(
                                                                    _orderDetail
                                                                        .qty
                                                                        .toString());
                                                        _orderDetail.qty =
                                                            int.parse(value);
                                                        _orderDetail.value =
                                                            _orderDetail.qty! *
                                                                pricePerUnit
                                                                    .toInt();
                                                        _order.total = 0;
                                                        _order.orderDetails!
                                                            .forEach((_detail) {
                                                          _order.total = _order
                                                                  .total! +
                                                              int.parse(_detail
                                                                  .value
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
                                            fontSize: 15,
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
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          ':',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '₹. ' + _orderDetail.value.toString(),
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
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
      ),
    );
  }
}

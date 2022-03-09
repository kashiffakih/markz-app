import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/my_order_pr.dart';

class ConfirmOrderPage extends StatefulWidget {
  final arguments; // beat, outlet, order_type

  ConfirmOrderPage({@required this.arguments});

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  bool _isLoading = false;

  DateTime _selectedDate = DateTime.now();

  //Method for showing the date picker
  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
      });
    });
  }

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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            child: Text('Add Date'),
                            onPressed: _pickDateDialog,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                  ),
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
            preferredSize: Size.fromHeight(80),
          ),
        ),
        preferredSize: Size.fromHeight(160),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              elevation: 10,
              child: Column(
                children: _myOrderModel.order == null
                    ? []
                    : _myOrderModel.order!.orderDetails!
                        .map(
                          (_orderDetail) => Container(
                            decoration: _myOrderModel.order!.orderDetails!
                                            .indexOf(_orderDetail) %
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
                                        .sku!.offer!.offerType!.name
                                        .toString() ==
                                    'FLAT')
                                  Text(
                                    _orderDetail.sku!.name.toString() +
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
                                            (_orderDetail.sku!.offerPrice !=
                                                    null
                                                ? _orderDetail.sku!.offerPrice
                                                    .toString()
                                                : _orderDetail.sku!.price
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
                                          // color: Colors.green,
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
        onTap: (value) async {
          if (value == 2) {
            if (!_isLoading) {
              setState(() {
                _isLoading = true;
              });
              await _myOrderModel.saveOrder(
                orderType: widget.arguments['order_type'],
                date: _selectedDate,
              );
              print(_isLoading);
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Offtake successfully updated'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        _myOrderModel.emptyOrder();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // Navigator.pop(context);
                        // Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: Text('Ok'),
                    ),
                  ],
                ),
              );
            }
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
                                  ? _myOrderModel.order!.orderDetails!.length
                                      .toString()
                                  : ''),
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
            title: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Total: ₹. ' +
                              (_myOrderModel.order != null
                                  ? _myOrderModel.order!.total.toString()
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
          if (!_isLoading)
            BottomNavigationBarItem(
              title: Text(
                'SUBMIT/CONFIRM',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              icon: Icon(Icons.arrow_right),
            ),
          if (_isLoading)
            BottomNavigationBarItem(
              title: Text(
                'SAVING...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              icon: Icon(Icons.arrow_right),
            ),
        ],
      ),
    );
  }
}

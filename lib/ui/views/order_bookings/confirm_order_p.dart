import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/my_order_pr.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

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
          title: Text(
            'Order Confirmation: ' + widget.arguments['outlet'].name,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          bottom: PreferredSize(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: RaisedButton(
                      //       child: Text('Add Date'),
                      //       onPressed: _pickDateDialog,
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: Text(
                          'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
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
            preferredSize: Size.fromHeight(80),
          ),
        ),
        preferredSize: Size.fromHeight(160),
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
                                        fontSize: 15,
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
                                            fontSize: 15,
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
                                              (_orderDetail.sku!.offerPrice !=
                                                      null
                                                  ? _orderDetail.sku!.offerPrice
                                                      .toString()
                                                  : _orderDetail.sku!.price
                                                      .toString()),
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
                                            // color: Colors.green,
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

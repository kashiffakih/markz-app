import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/order.dart';
import 'package:sales_app/core/models/sku.dart';
import 'package:sales_app/core/providers/my_order_pr.dart';
import 'package:sales_app/core/providers/sku_pr.dart';

class OrderPage extends StatefulWidget {
  final arguments; // beat, outlet, order type

  OrderPage({@required this.arguments});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController _controller = TextEditingController();

  List<Sku>? _skus = [];
  bool _isSkuFilled = false;

  @override
  void initState() {
    _skus = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _skuModel = Provider.of<SkuModel>(context);
    final _myOrderModel = Provider.of<MyOrderModel>(context);

    List<String> _mainCategories = [
      'All',
      'Baby',
      'Body',
      'Face',
      'Hair',
      'Derma'
    ];

    setState(() {
      if (_skuModel.skus != null && !_isSkuFilled) {
        _isSkuFilled = true;
        _skus = _skuModel.skus;
        _skus!.forEach((_sku) {
          if (_myOrderModel.order != null) {
            var _orderDetails = _myOrderModel.order!.orderDetails!
                .where(
                  (_orderDetail) => _sku.id == _orderDetail.skuId,
                )
                .toList();
            if (_orderDetails.length > 0)
              _sku.enteredQty = _orderDetails[0].qty;
          }
        });
      }
    });

    String title = '-';

    if (widget.arguments['order_type'] == 'Opening Stock')
      title = 'Opening: ' + widget.arguments['outlet'].name;
    if (widget.arguments['order_type'] == 'Stock Received')
      title = 'Stocks Received';
    if (widget.arguments['order_type'] == 'Purchase Returned')
      title = 'Stocks Returned';
    if (widget.arguments['order_type'] == 'Sales')
      title = 'Offtake: ' + widget.arguments['outlet'].name;
    if (widget.arguments['order_type'] == 'Stock Returned')
      title = 'Offtake Returned';

    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text(title),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter search text',
                          ),
                          controller: _controller,
                        ),
                        SizedBox(height: 10),
                        Text('-- or --'),
                        DropdownButtonFormField(
                          decoration:
                              InputDecoration(labelText: 'Select category'),
                          items: _mainCategories
                              .map(
                                (_mainCategory) => DropdownMenuItem(
                                  value: _mainCategory,
                                  child: Text(_mainCategory),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              if (value == 'All')
                                _skus = _skuModel.skus;
                              else
                                _skus = _skuModel.skus!
                                    .where((sku) => sku.mainCategory == value)
                                    .toList();

                              _skus!.forEach((_sku) {
                                if (_myOrderModel.order != null) {
                                  var _orderDetails =
                                      _myOrderModel.order!.orderDetails!
                                          .where(
                                            (_orderDetail) =>
                                                _sku.id == _orderDetail.skuId,
                                          )
                                          .toList();
                                  if (_orderDetails.length > 0)
                                    _sku.enteredQty = _orderDetails[0].qty;
                                }
                              });

                              Navigator.pop(context);
                            });
                          },
                        )
                      ],
                    ),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          print(_controller.text);
                          if (_controller.text == '') {
                            setState(() {
                              _skus = _skuModel.skus;
                            });
                          } else {
                            setState(() {
                              _skus = _skuModel.skus!
                                  .where((sku) => sku.name!
                                      .toLowerCase()
                                      .contains(_controller.text))
                                  .toList();

                              _skus!.forEach((_sku) {
                                if (_myOrderModel.order != null) {
                                  var _orderDetails =
                                      _myOrderModel.order!.orderDetails!
                                          .where(
                                            (_orderDetail) =>
                                                _sku.id == _orderDetail.skuId,
                                          )
                                          .toList();
                                  if (_orderDetails.length > 0)
                                    _sku.enteredQty = _orderDetails[0].qty;
                                }
                              });
                            });
                          }
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Text('SEARCH'),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('CANCEL'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
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
                      // Expanded(
                      //   flex: 1,
                      //   child: Text(
                      //     'PTR W-Tax',
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      // ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Qty. Available',
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
          child: Container(
            child: Card(
              elevation: 10,
              child: _skus!.length == 0
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: _skus!
                          .map(
                            (_sku) => Container(
                              decoration: _skus!.indexOf(_sku) % 2 != 0
                                  ? BoxDecoration(color: Colors.grey[400])
                                  : BoxDecoration(color: Colors.white),
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_sku.offerId == null)
                                    Text(
                                      _sku.name.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  else if (_sku.offer!.offerType!.name ==
                                      'FLAT')
                                    Text(
                                      _sku.name! +
                                          ' (₹.' +
                                          _sku.offer!.offer.toString() +
                                          ' OFF)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  else if (_sku.offer!.offerType!.name ==
                                      'PERCENT')
                                    Text(
                                      _sku.name! +
                                          ' (' +
                                          _sku.offer!.offer.toString() +
                                          '% OFF)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  else if (_sku.offer!.offerType!.name ==
                                      'FREE GIFT')
                                    Text(
                                      _sku.name! +
                                          ' (' +
                                          _sku.offer!.itemName.toString() +
                                          ')',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  else if (_sku.offer!.offerType!.name ==
                                      'FREE QTY')
                                    Text(
                                      _sku.name! +
                                          ' (' +
                                          _sku.offer!.itemName.toString() +
                                          ')',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  Text(_sku.mainCategory != null
                                      ? '( ' + _sku.mainCategory + ' )'
                                      : ''),
                                  // SizedBox(
                                  //   height: 8,
                                  // ),
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
                                      // if (_sku.offerPrice == null)
                                      //   Expanded(
                                      //     child: Text(
                                      //       '₹. ' + _sku.price.toString(),
                                      //       style: TextStyle(
                                      //         color: Colors.red,
                                      //         fontWeight: FontWeight.bold,
                                      //       ),
                                      //     ),
                                      //   )
                                      // else
                                      //   Expanded(
                                      //     child: Text(
                                      //       '₹. ' + (_sku.offerPrice).toString(),
                                      //       style: TextStyle(
                                      //         color: Colors.red,
                                      //         fontWeight: FontWeight.bold,
                                      //       ),
                                      //     ),
                                      //   ),
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
                                        child: (_sku.qty! <= 0 &&
                                                (widget.arguments[
                                                            'order_type'] ==
                                                        'Sales' ||
                                                    widget.arguments[
                                                            'order_type'] ==
                                                        'Purchase Returned'))
                                            ? Text('')
                                            : Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0,
                                                          right: 15.0),
                                                  child: Center(
                                                    child: TextFormField(
                                                      initialValue:
                                                          _sku.enteredQty !=
                                                                  null
                                                              ? _sku.enteredQty
                                                                  .toString()
                                                              : '',
                                                      textAlign:
                                                          TextAlign.center,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ], // Only numbers
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Enter Qty',
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      onChanged: (value) {
                                                        if (value.length >= 3) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                              title: Text(
                                                                  'The quantity entered is more than or equal to 3 digits. Please check again before proceeding further.'),
                                                              actions: [
                                                                FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      'OK'),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                        if (_myOrderModel
                                                                .order ==
                                                            null) {
                                                          _myOrderModel
                                                              .updateOrder(
                                                            retailerId: widget
                                                                .arguments[
                                                                    'outlet']
                                                                .id,
                                                          );
                                                        }
                                                        if (_myOrderModel.order!
                                                                .retailerId ==
                                                            widget
                                                                .arguments[
                                                                    'outlet']
                                                                .id) {
                                                          _myOrderModel
                                                              .addOrUpdateOrderDetail(
                                                            sku: _sku,
                                                            qty: value == ''
                                                                ? 0
                                                                : int.parse(
                                                                    value),
                                                          );
                                                        } else {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                              title: Text(
                                                                  'Order from another retailer is already there in the cart. Do you want to reset the order'),
                                                              actions: [
                                                                FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    _myOrderModel
                                                                        .emptyOrder();
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      'Yes'),
                                                                ),
                                                                FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pushNamed(
                                                                        context,
                                                                        '/beats');
                                                                  },
                                                                  child: Text(
                                                                      'No'),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
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
          if (_myOrderModel.order == null ||
              _myOrderModel.order!.orderDetails!.length == 0)
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
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
              'order_type': widget.arguments['order_type'],
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
                                  ? _myOrderModel.order!.orderDetails!.length
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

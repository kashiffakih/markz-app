import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/order_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/profile/order-details-processing.dart';

class OrdersPage extends StatefulWidget {
  final isProfile;

  OrdersPage({Key? key, this.isProfile}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  DateFormat? _format;
  bool _isPageLoading = false;

  @override
  void initState() {
    super.initState();
    _format = DateFormat('yyyy-MM-dd');
    setState(() {
      _isPageLoading = true;
    });
    Provider.of<OrderModel>(context, listen: false).getOrder();
    setState(() {
      _isPageLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderModel _orderModel =
        Provider.of<OrderModel>(context, listen: false);

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (widget.isProfile['isProfile'] == true) {
            Navigator.pushNamed(context, '/profilePage');
          } else {
            Navigator.pushReplacementNamed(context, '/homePage');
          }
          return false;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  // Title
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            if (widget.isProfile['isProfile'] == true) {
                              Navigator.pushNamed(context, '/profilePage');
                            } else {
                              Navigator.pushReplacementNamed(
                                  context, '/homePage');
                            }
                          },
                          child: Container(
                            width: 15,
                            height: 15,
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 18,
                              color: Color(0xffEED056),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Text(
                                'Orders',
                                textAlign: TextAlign.center,
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1e232c),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Body
                  Container(
                    child: DefaultTabController(
                      length: 4,
                      child: Column(
                        children: [
                          // Tabs
                          Container(
                            child: TabBar(
                              labelPadding: EdgeInsets.all(8),
                              indicatorColor: Colors.black,
                              isScrollable: true,
                              tabs: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    'Order Placed',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    'Processing',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    'Delivered',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    'Cancelled',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Tab Content
                          _isPageLoading == true
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Column(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      child: TabBarView(
                                        children: [
                                          _orderModel.orders.isEmpty
                                              ? SizedBox(
                                                  height: 60,
                                                  child: Center(
                                                      child: Text(
                                                          "No Order Placed Yet")),
                                                )
                                              // Text('Order Placed'),
                                              : SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      ..._orderModel.orders
                                                          .where((_orderStatus) =>
                                                              _orderStatus
                                                                  .orderStatuses!
                                                                  .isEmpty)
                                                          .map(
                                                            (_order) => Column(
                                                                children: [
                                                                  Container(
                                                                    height: 130,
                                                                    margin: EdgeInsets
                                                                        .all(
                                                                            10),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              Color(0xffc7b456)),
                                                                      color: Color(
                                                                          0xffffffff),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            5),
                                                                      ),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color:
                                                                              Color(0x338a959e),
                                                                          offset: Offset(
                                                                              0,
                                                                              7.6690645218),
                                                                          blurRadius:
                                                                              19.1726608276,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                'Order No: ' + _order.id.toString(),
                                                                                style: MyGoogleFontStyle(
                                                                                  fontFamily: 'Urbanist',
                                                                                  fontWeight: FontWeight.w700,
                                                                                  color: Color(0xff232323),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                _format!.format(DateTime.parse(_order.createdAt.toString())),
                                                                                textAlign: TextAlign.right,
                                                                                style: MyGoogleFontStyle(
                                                                                  fontFamily: 'Poppins',
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Color(0xff909090),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Divider(
                                                                          thickness:
                                                                              1,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: RichText(
                                                                                text: TextSpan(
                                                                                  style: MyGoogleFontStyle(
                                                                                    fontFamily: 'Poppins',
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: Color(0xff000000),
                                                                                  ),
                                                                                  children: [
                                                                                    TextSpan(
                                                                                      text: 'Quantity: ',
                                                                                      style: MyGoogleFontStyle(
                                                                                        fontFamily: 'Urbanist',
                                                                                        fontWeight: FontWeight.w400,
                                                                                        color: Color(0xffaaaaaa),
                                                                                      ),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: _order.orderDetails!.length.toString(),
                                                                                      style: MyGoogleFontStyle(
                                                                                        fontFamily: 'Poppins',
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: Color(0xff000000),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: RichText(
                                                                                textAlign: TextAlign.right,
                                                                                text: TextSpan(
                                                                                  style: MyGoogleFontStyle(
                                                                                    fontFamily: 'Poppins',
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: Color(0xff000000),
                                                                                  ),
                                                                                  children: [
                                                                                    TextSpan(
                                                                                      text: 'Total Amount: ',
                                                                                      style: MyGoogleFontStyle(
                                                                                        fontFamily: 'Urbanist',
                                                                                        fontWeight: FontWeight.w400,
                                                                                        color: Color(0xffaaaaaa),
                                                                                      ),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: _order.orderCost.toString(),
                                                                                      style: MyGoogleFontStyle(
                                                                                        fontFamily: 'Poppins',
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: Color(0xff000000),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {
                                                                                final filteredImages = _order.orderDetails?.first.product?.productImages;

                                                                                Navigator.of(context).push(MaterialPageRoute(
                                                                                    builder: (context) => OrderDetailsPage(arguments: {
                                                                                          'order': _order.toJson(),
                                                                                          "product_images": filteredImages,
                                                                                          'status': 'Order Placed'
                                                                                        })));
                                                                              },
                                                                              child: Container(
                                                                                width: 74.5,
                                                                                height: 30,
                                                                                decoration: BoxDecoration(
                                                                                  color: Color(0xff232323),
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    'Detail',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: MyGoogleFontStyle(
                                                                                      fontFamily: 'Poppins',
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      color: Color(0xffffffff),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                'Order Placed',
                                                                                textAlign: TextAlign.right,
                                                                                style: MyGoogleFontStyle(
                                                                                  fontFamily: 'Poppins',
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ]),
                                                          )
                                                          .toList(),
                                                    ],
                                                  ),
                                                ),
                                          _orderModel.orders.isEmpty
                                              ? SizedBox(
                                                  height: 60,
                                                  child: Center(
                                                      child: Text(
                                                          "No Order Placed Yet")),
                                                )
                                              // Text('Order Placed'),
                                              : SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      ..._orderModel.orders
                                                          .map(
                                                            (_order) => Column(
                                                              children: _order
                                                                  .orderStatuses!
                                                                  .where((_orderStatus) =>
                                                                      _orderStatus
                                                                          .status!
                                                                          .name ==
                                                                      'Order Processing')
                                                                  .map(
                                                                    (_orderStatus) =>
                                                                        Container(
                                                                      height:
                                                                          130,
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              10),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                Color(0xffc7b456)),
                                                                        color: Color(
                                                                            0xffffffff),
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              5),
                                                                        ),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Color(0x338a959e),
                                                                            offset:
                                                                                Offset(0, 7.6690645218),
                                                                            blurRadius:
                                                                                19.1726608276,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  'Order No: ' + _order.id.toString(),
                                                                                  style: MyGoogleFontStyle(
                                                                                    fontFamily: 'Urbanist',
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: Color(0xff232323),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  _format!.format(DateTime.parse(_order.createdAt.toString())),
                                                                                  textAlign: TextAlign.right,
                                                                                  style: MyGoogleFontStyle(
                                                                                    fontFamily: 'Poppins',
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: Color(0xff909090),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Divider(
                                                                            thickness:
                                                                                1,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: RichText(
                                                                                  text: TextSpan(
                                                                                    style: MyGoogleFontStyle(
                                                                                      fontFamily: 'Poppins',
                                                                                      fontWeight: FontWeight.w700,
                                                                                      color: Color(0xff000000),
                                                                                    ),
                                                                                    children: [
                                                                                      TextSpan(
                                                                                        text: 'Quantity: ',
                                                                                        style: MyGoogleFontStyle(
                                                                                          fontFamily: 'Urbanist',
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: Color(0xffaaaaaa),
                                                                                        ),
                                                                                      ),
                                                                                      TextSpan(
                                                                                        text: _order.orderDetails!.length.toString(),
                                                                                        style: MyGoogleFontStyle(
                                                                                          fontFamily: 'Poppins',
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Color(0xff000000),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: RichText(
                                                                                  textAlign: TextAlign.right,
                                                                                  text: TextSpan(
                                                                                    style: MyGoogleFontStyle(
                                                                                      fontFamily: 'Poppins',
                                                                                      fontWeight: FontWeight.w700,
                                                                                      color: Color(0xff000000),
                                                                                    ),
                                                                                    children: [
                                                                                      TextSpan(
                                                                                        text: 'Total Amount: ',
                                                                                        style: MyGoogleFontStyle(
                                                                                          fontFamily: 'Urbanist',
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: Color(0xffaaaaaa),
                                                                                        ),
                                                                                      ),
                                                                                      TextSpan(
                                                                                        text: _order.totalAmount.toString(),
                                                                                        style: MyGoogleFontStyle(
                                                                                          fontFamily: 'Poppins',
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Color(0xff000000),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  final filteredImages = _order.orderDetails?.first.product?.productImages;

                                                                                  Navigator.of(context).push(MaterialPageRoute(
                                                                                      builder: (context) => OrderDetailsPage(arguments: {
                                                                                            'order': _order.toJson(),
                                                                                            "product_images": filteredImages,
                                                                                            'status': 'Order Processing'
                                                                                          })));
                                                                                },
                                                                                child: Container(
                                                                                  width: 74.5,
                                                                                  height: 30,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Color(0xff232323),
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      'Detail',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: MyGoogleFontStyle(
                                                                                        fontFamily: 'Poppins',
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.w400,
                                                                                        color: Color(0xffffffff),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  _orderStatus.status!.name.toString(),
                                                                                  textAlign: TextAlign.right,
                                                                                  style: MyGoogleFontStyle(
                                                                                    fontFamily: 'Poppins',
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: Colors.green,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                            ),
                                                          )
                                                          .toList(),
                                                    ],
                                                  ),
                                                ),
                                          _orderModel.orders.isEmpty
                                              ? SizedBox(
                                                  height: 60,
                                                  child: Center(
                                                      child: Text(
                                                          "No Order Placed Yet")),
                                                )
                                              // Text('Order Placed'),
                                              : SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      ..._orderModel.orders
                                                          .map(
                                                            (_order) => Column(
                                                              children: _order
                                                                  .orderStatuses!
                                                                  .where((_orderStatus) =>
                                                                      _orderStatus
                                                                          .status!
                                                                          .name ==
                                                                      'Delivered')
                                                                  .map(
                                                                    (_orderStatus) =>
                                                                        Container(
                                                                      height:
                                                                          130,
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              10),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                Color(0xffc7b456)),
                                                                        color: Color(
                                                                            0xffffffff),
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              5),
                                                                        ),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Color(0x338a959e),
                                                                            offset:
                                                                                Offset(0, 7.6690645218),
                                                                            blurRadius:
                                                                                19.1726608276,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  'Order No: ' + _order.id.toString(),
                                                                                  style: MyGoogleFontStyle(
                                                                                    fontFamily: 'Urbanist',
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: Color(0xff232323),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  _format!.format(DateTime.parse(_order.createdAt.toString())),
                                                                                  textAlign: TextAlign.right,
                                                                                  style: MyGoogleFontStyle(
                                                                                    fontFamily: 'Poppins',
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: Color(0xff909090),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Divider(
                                                                            thickness:
                                                                                1,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: RichText(
                                                                                  text: TextSpan(
                                                                                    style: MyGoogleFontStyle(
                                                                                      fontFamily: 'Poppins',
                                                                                      fontWeight: FontWeight.w700,
                                                                                      color: Color(0xff000000),
                                                                                    ),
                                                                                    children: [
                                                                                      TextSpan(
                                                                                        text: 'Quantity: ',
                                                                                        style: MyGoogleFontStyle(
                                                                                          fontFamily: 'Urbanist',
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: Color(0xffaaaaaa),
                                                                                        ),
                                                                                      ),
                                                                                      TextSpan(
                                                                                        text: _order.orderDetails!.length.toString(),
                                                                                        style: MyGoogleFontStyle(
                                                                                          fontFamily: 'Poppins',
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Color(0xff000000),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: RichText(
                                                                                  textAlign: TextAlign.right,
                                                                                  text: TextSpan(
                                                                                    style: MyGoogleFontStyle(
                                                                                      fontFamily: 'Poppins',
                                                                                      fontWeight: FontWeight.w700,
                                                                                      color: Color(0xff000000),
                                                                                    ),
                                                                                    children: [
                                                                                      TextSpan(
                                                                                        text: 'Total Amount: ',
                                                                                        style: MyGoogleFontStyle(
                                                                                          fontFamily: 'Urbanist',
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: Color(0xffaaaaaa),
                                                                                        ),
                                                                                      ),
                                                                                      TextSpan(
                                                                                        text: _order.totalAmount.toString(),
                                                                                        style: MyGoogleFontStyle(
                                                                                          fontFamily: 'Poppins',
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Color(0xff000000),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  final filteredImages = _order.orderDetails?.first.product?.productImages;

                                                                                  Navigator.of(context).push(MaterialPageRoute(
                                                                                      builder: (context) => OrderDetailsPage(arguments: {
                                                                                            'order': _order.toJson(),
                                                                                            "product_images": filteredImages,
                                                                                            'status': 'Delivered'
                                                                                          })));
                                                                                },
                                                                                child: Container(
                                                                                  width: 74.5,
                                                                                  height: 30,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Color(0xff232323),
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      'Detail',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: MyGoogleFontStyle(
                                                                                        fontFamily: 'Poppins',
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.w400,
                                                                                        color: Color(0xffffffff),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  _orderStatus.status!.name.toString(),
                                                                                  textAlign: TextAlign.right,
                                                                                  style: MyGoogleFontStyle(
                                                                                    fontFamily: 'Poppins',
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: Colors.orange,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                            ),
                                                          )
                                                          .toList(),
                                                    ],
                                                  ),
                                                ),
                                          _orderModel.orders.isEmpty
                                              ? SizedBox(
                                                  height: 60,
                                                  child: Center(
                                                      child: Text(
                                                          "No Order Placed Yet")),
                                                )
                                              // Text('Order Placed'),
                                              : SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      ..._orderModel.orders
                                                          .map(
                                                            (_order) => Column(
                                                              children: _order
                                                                  .orderStatuses!
                                                                  .where((_orderStatus) =>
                                                                      _orderStatus
                                                                          .status!
                                                                          .name ==
                                                                      'Cancelled')
                                                                  .map(
                                                                    (_orderStatus) =>
                                                                        Container(
                                                                      height:
                                                                          130,
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              10),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                Color(0xffc7b456)),
                                                                        color: Color(
                                                                            0xffffffff),
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              5),
                                                                        ),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Color(0x338a959e),
                                                                            offset:
                                                                                Offset(0, 7.6690645218),
                                                                            blurRadius:
                                                                                19.1726608276,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  'Order No: ' + _order.id.toString(),
                                                                                  style: MyGoogleFontStyle(
                                                                                    fontFamily: 'Urbanist',
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: Color(0xff232323),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  _format!.format(DateTime.parse(_order.createdAt.toString())),
                                                                                  textAlign: TextAlign.right,
                                                                                  style: MyGoogleFontStyle(
                                                                                    fontFamily: 'Poppins',
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: Color(0xff909090),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Divider(
                                                                            thickness:
                                                                                1,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: RichText(
                                                                                  text: TextSpan(
                                                                                    style: MyGoogleFontStyle(
                                                                                      fontFamily: 'Poppins',
                                                                                      fontWeight: FontWeight.w700,
                                                                                      color: Color(0xff000000),
                                                                                    ),
                                                                                    children: [
                                                                                      TextSpan(
                                                                                        text: 'Quantity: ',
                                                                                        style: MyGoogleFontStyle(
                                                                                          fontFamily: 'Urbanist',
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: Color(0xffaaaaaa),
                                                                                        ),
                                                                                      ),
                                                                                      TextSpan(
                                                                                        text: _order.orderDetails!.length.toString(),
                                                                                        style: MyGoogleFontStyle(
                                                                                          fontFamily: 'Poppins',
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Color(0xff000000),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: RichText(
                                                                                  textAlign: TextAlign.right,
                                                                                  text: TextSpan(
                                                                                    style: MyGoogleFontStyle(
                                                                                      fontFamily: 'Poppins',
                                                                                      fontWeight: FontWeight.w700,
                                                                                      color: Color(0xff000000),
                                                                                    ),
                                                                                    children: [
                                                                                      TextSpan(
                                                                                        text: 'Total Amount: ',
                                                                                        style: MyGoogleFontStyle(
                                                                                          fontFamily: 'Urbanist',
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: Color(0xffaaaaaa),
                                                                                        ),
                                                                                      ),
                                                                                      TextSpan(
                                                                                        text: _order.totalAmount.toString(),
                                                                                        style: MyGoogleFontStyle(
                                                                                          fontFamily: 'Poppins',
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Color(0xff000000),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  final filteredImages = _order.orderDetails?.first.product?.productImages;

                                                                                  Navigator.of(context).push(MaterialPageRoute(
                                                                                      builder: (context) => OrderDetailsPage(arguments: {
                                                                                            'order': _order.toJson(),
                                                                                            "product_images": filteredImages,
                                                                                            'status': 'Cancelled'
                                                                                          })));
                                                                                },
                                                                                child: Container(
                                                                                  width: 74.5,
                                                                                  height: 30,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Color(0xff232323),
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      'Detail',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: MyGoogleFontStyle(
                                                                                        fontFamily: 'Poppins',
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.w400,
                                                                                        color: Color(0xffffffff),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  _orderStatus.status!.name.toString(),
                                                                                  textAlign: TextAlign.right,
                                                                                  style: MyGoogleFontStyle(
                                                                                    fontFamily: 'Poppins',
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: Colors.red,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                            ),
                                                          )
                                                          .toList(),
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   elevation: 10,
      //   iconSize: 30,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.black,
      //   selectedFontSize: 14,
      //   unselectedFontSize: 14,
      //   onTap: (value) async {
      //     if (value == 0) {
      //       Navigator.pushNamed(context, '/homePage');
      //     }
      //     if (value == 1) {
      //       Navigator.pushNamed(context, '/wishlistPage');
      //     }

      //     if (value == 2) {
      //       Map<String, dynamic> _CartData = {
      //         'kindOfFlower': '',
      //         'flavour': '',
      //         'writeOnCake': '',
      //         'pack': ''
      //       };
      //       await _addToCartModel.getAddToCart('', '', _CartData);
      //       Navigator.pushNamed(context, '/cartPage');
      //     }
      //     if (value == 3) {
      //       Navigator.pushNamed(context, '/profilePage');
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: Iconoir(Iconoir.home_simple),
      //       // icon: Icon(DonIcons.wap_home, size: 23),
      //     ),
      //     BottomNavigationBarItem(label: 'Saved', icon: Iconoir(Iconoir.heart)),
      //     BottomNavigationBarItem(
      //       label: 'Cart',
      //       icon: Iconoir(Iconoir.shopping_bag),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Profile',
      //       icon: Icon(
      //         DonIcons.user_o,
      //         size: 23,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

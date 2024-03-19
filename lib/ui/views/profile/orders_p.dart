import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/profile/order-details-processing.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  DateFormat? _format;
  @override
  void initState() {
    super.initState();
    _format = DateFormat('yyyy-MM-dd');
    Provider.of<OrderModel>(context, listen: false).getOrder();
  }

  @override
  Widget build(BuildContext context) {
    final OrderModel _orderModel = Provider.of<OrderModel>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                // Title
                Container(
                  // margin: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
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
                                  'Delivered',
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
                                  'Cancelled',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tab Content
                        Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 30,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
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
                                const SizedBox(width: 15),
                                Container(
                                  width: 258,
                                  height: 38,
                                  padding: const EdgeInsets.only(
                                    left: 21,
                                    right: 20.70,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 0.50,
                                          color: Color(0xFFC7B456)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, // Center vertically
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: 'Search',
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 18,
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w600,
                                              // letterSpacing: -0.36,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                          'assets/images/Search-1.png',
                                          height: 20,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // const SizedBox(width: 10),
                                // Container(
                                //   width: 20,
                                //   height: 20,
                                //   child: Column(
                                //     mainAxisSize: MainAxisSize.min,
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.center, // Center vertically
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Image.asset(
                                //         'assets/images/filter.png',
                                //         height: 20,
                                //         fit: BoxFit.cover,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height - 200,
                              child: TabBarView(
                                children: [
                                  _orderModel.orders.isEmpty
                                      ? SizedBox(
                                          height: 60,
                                          child: Center(
                                              child:
                                                  Text("No Order Placed Yet")),
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
                                                            margin:
                                                                EdgeInsets.all(
                                                                    10),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Color(
                                                                      0xffc7b456)),
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
                                                                  color: Color(
                                                                      0x338a959e),
                                                                  offset: Offset(
                                                                      0,
                                                                      7.6690645218),
                                                                  blurRadius:
                                                                      19.1726608276,
                                                                ),
                                                              ],
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Order No: ' +
                                                                            _order.id.toString(),
                                                                        style:
                                                                            MyGoogleFontStyle(
                                                                          fontFamily:
                                                                              'Urbanist',
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          color:
                                                                              Color(0xff232323),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        _format!.format(DateTime.parse(_order
                                                                            .createdAt
                                                                            .toString())),
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style:
                                                                            MyGoogleFontStyle(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Color(0xff909090),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color:
                                                                                Color(0xff000000),
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
                                                                      child:
                                                                          RichText(
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        text:
                                                                            TextSpan(
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color:
                                                                                Color(0xff000000),
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
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context).push(MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                OrderDetailsPage(arguments: {
                                                                                  'order': _order.toJson(),
                                                                                  'status': 'Order Placed'
                                                                                })));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            74.5,
                                                                        height:
                                                                            30,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(0xff232323),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Detail',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                MyGoogleFontStyle(
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
                                                                      child:
                                                                          Text(
                                                                        'Order Placed',
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style:
                                                                            MyGoogleFontStyle(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Colors.black,
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
                                              child:
                                                  Text("No Order Placed Yet")),
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
                                                          .where(
                                                              (_orderStatus) =>
                                                                  _orderStatus
                                                                      .status!
                                                                      .name ==
                                                                  'Delivered')
                                                          .map(
                                                            (_orderStatus) =>
                                                                Container(
                                                              height: 130,
                                                              margin: EdgeInsets
                                                                  .all(10),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(
                                                                        0xffc7b456)),
                                                                color: Color(
                                                                    0xffffffff),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                                ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color(
                                                                        0x338a959e),
                                                                    offset: Offset(
                                                                        0,
                                                                        7.6690645218),
                                                                    blurRadius:
                                                                        19.1726608276,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          'Order No: ' +
                                                                              _order.id.toString(),
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Urbanist',
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color:
                                                                                Color(0xff232323),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          _format!.format(DateTime.parse(_order
                                                                              .createdAt
                                                                              .toString())),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                Color(0xff909090),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                    thickness:
                                                                        1,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            style:
                                                                                MyGoogleFontStyle(
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
                                                                        child:
                                                                            RichText(
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          text:
                                                                              TextSpan(
                                                                            style:
                                                                                MyGoogleFontStyle(
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
                                                                    height: 15,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.of(context).push(MaterialPageRoute(
                                                                              builder: (context) => OrderDetailsPage(arguments: {
                                                                                    'order': _order.toJson(),
                                                                                    'status': 'Delivered'
                                                                                  })));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              74.5,
                                                                          height:
                                                                              30,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xff232323),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
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
                                                                        child:
                                                                            Text(
                                                                          _orderStatus
                                                                              .status!
                                                                              .name
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                Colors.green,
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
                                              child:
                                                  Text("No Order Placed Yet")),
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
                                                              height: 130,
                                                              margin: EdgeInsets
                                                                  .all(10),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(
                                                                        0xffc7b456)),
                                                                color: Color(
                                                                    0xffffffff),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                                ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color(
                                                                        0x338a959e),
                                                                    offset: Offset(
                                                                        0,
                                                                        7.6690645218),
                                                                    blurRadius:
                                                                        19.1726608276,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          'Order No: ' +
                                                                              _order.id.toString(),
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Urbanist',
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color:
                                                                                Color(0xff232323),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          _format!.format(DateTime.parse(_order
                                                                              .createdAt
                                                                              .toString())),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                Color(0xff909090),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                    thickness:
                                                                        1,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            style:
                                                                                MyGoogleFontStyle(
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
                                                                        child:
                                                                            RichText(
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          text:
                                                                              TextSpan(
                                                                            style:
                                                                                MyGoogleFontStyle(
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
                                                                    height: 15,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.of(context).push(MaterialPageRoute(
                                                                              builder: (context) => OrderDetailsPage(arguments: {
                                                                                    'order': _order.toJson(),
                                                                                    'status': 'Order in processing'
                                                                                  })));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              74.5,
                                                                          height:
                                                                              30,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xff232323),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
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
                                                                        child:
                                                                            Text(
                                                                          _orderStatus
                                                                              .status!
                                                                              .name
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                Colors.orange,
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
                                              child:
                                                  Text("No Order Placed Yet")),
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
                                                          .where(
                                                              (_orderStatus) =>
                                                                  _orderStatus
                                                                      .status!
                                                                      .name ==
                                                                  'Cancelled')
                                                          .map(
                                                            (_orderStatus) =>
                                                                Container(
                                                              height: 130,
                                                              margin: EdgeInsets
                                                                  .all(10),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(
                                                                        0xffc7b456)),
                                                                color: Color(
                                                                    0xffffffff),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                                ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color(
                                                                        0x338a959e),
                                                                    offset: Offset(
                                                                        0,
                                                                        7.6690645218),
                                                                    blurRadius:
                                                                        19.1726608276,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          'Order No: ' +
                                                                              _order.id.toString(),
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Urbanist',
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color:
                                                                                Color(0xff232323),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          _format!.format(DateTime.parse(_order
                                                                              .createdAt
                                                                              .toString())),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                Color(0xff909090),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                    thickness:
                                                                        1,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            style:
                                                                                MyGoogleFontStyle(
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
                                                                        child:
                                                                            RichText(
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          text:
                                                                              TextSpan(
                                                                            style:
                                                                                MyGoogleFontStyle(
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
                                                                    height: 15,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.of(context).push(MaterialPageRoute(
                                                                              builder: (context) => OrderDetailsPage(arguments: {
                                                                                    'order': _order.toJson(),
                                                                                    'status': 'Cancelled'
                                                                                  })));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              74.5,
                                                                          height:
                                                                              30,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xff232323),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
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
                                                                        child:
                                                                            Text(
                                                                          _orderStatus
                                                                              .status!
                                                                              .name
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          style:
                                                                              MyGoogleFontStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                Colors.red,
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

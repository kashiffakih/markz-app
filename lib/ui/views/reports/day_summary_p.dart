import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/analytics_pr.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DaySummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _analyticsModel = Provider.of<AnalyticsModel>(context);

    DateFormat format = DateFormat('dd-MM-yyyy');

    String todayDate = format.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Day Summary | ' + todayDate),
      ),
      body: SingleChildScrollView(
        child: _analyticsModel.daySummary == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '₹ ' +
                                    _analyticsModel.daySummary.totalOrderValue
                                        .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Total Orders Value',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RaisedButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/orderDetails');
                                },
                                child: Text(
                                  'View All Orders',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 150,
                          child: SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 150,
                                ranges: <GaugeRange>[
                                  GaugeRange(
                                    startValue: 0,
                                    endValue: 150,
                                    color: Colors.orange,
                                    startWidth: 10,
                                    endWidth: 10,
                                  ),
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                    widget: Container(
                                      child: Text(
                                        _analyticsModel
                                                .daySummary.coverage.percent
                                                .toString() +
                                            ' %',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    angle: 90,
                                    positionFactor: 0.1,
                                  ),
                                  GaugeAnnotation(
                                    widget: Container(
                                      child: const Text(
                                        'Coverage',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    angle: 90,
                                    positionFactor: 1,
                                  ),
                                  GaugeAnnotation(
                                    widget: Container(
                                      child: Text(
                                        _analyticsModel
                                                .daySummary.coverage.value
                                                .toString() +
                                            '/' +
                                            _analyticsModel
                                                .daySummary.coverage.total
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    angle: 90,
                                    positionFactor: 1.5,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 150,
                          child: SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 150,
                                ranges: <GaugeRange>[
                                  GaugeRange(
                                    startValue: 0,
                                    endValue: 150,
                                    color: Colors.green,
                                    startWidth: 10,
                                    endWidth: 10,
                                  ),
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                    widget: Container(
                                      child: Text(
                                        _analyticsModel
                                                .daySummary.productivity.percent
                                                .toString() +
                                            ' %',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    angle: 90,
                                    positionFactor: 0.1,
                                  ),
                                  GaugeAnnotation(
                                    widget: Container(
                                      child: const Text(
                                        'Productivity',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    angle: 90,
                                    positionFactor: 1,
                                  ),
                                  GaugeAnnotation(
                                    widget: Container(
                                      child: Text(
                                        _analyticsModel
                                                .daySummary.productivity.value
                                                .toString() +
                                            '/' +
                                            _analyticsModel
                                                .daySummary.productivity.total
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    angle: 90,
                                    positionFactor: 1.5,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Divider(),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             '₹ 0.00 L',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //           Text(
                  //             'Cash Total',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             '₹ 00 L',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //           Text(
                  //             'Cheque Total',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             '₹ 0.00 L',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //           Text(
                  //             'Total Collection',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Divider(),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            color: Colors.orange,
                            textColor: Colors.white,
                            child: Icon(
                              Icons.location_history,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(16),
                            shape: CircleBorder(),
                          ),
                          Expanded(
                            child: Text(
                              'Beat Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            _analyticsModel.daySummary.beatNames
                                .map((_beatName) => _beatName)
                                .toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Icon(
                              Icons.shopping_basket_outlined,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(16),
                            shape: CircleBorder(),
                          ),
                          Expanded(
                            child: Text(
                              'Total Outlets',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            _analyticsModel.daySummary.totalOutlets.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            color: Colors.red,
                            textColor: Colors.white,
                            child: Icon(
                              Icons.shopping_cart,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(16),
                            shape: CircleBorder(),
                          ),
                          Expanded(
                            child: Text(
                              'Order Taken',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            _analyticsModel.daySummary.ordersTaken.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            color: Colors.green,
                            textColor: Colors.white,
                            child: Icon(
                              Icons.shopping_bag,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(16),
                            shape: CircleBorder(),
                          ),
                          Expanded(
                            child: Text(
                              'Order Not Taken',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            _analyticsModel.daySummary.ordersNotTaken
                                .toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

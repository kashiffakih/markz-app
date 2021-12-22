import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/analytics_pr.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TargetVsAchievedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _analyticsModel = Provider.of<AnalyticsModel>(context);

    DateFormat format = DateFormat('MMMM yy');
    String month = format.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Target Vs Achievement | ' + month),
      ),
      body: SingleChildScrollView(
        child: _analyticsModel.targetVsAchieved == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            child: SfRadialGauge(
                              axes: <RadialAxis>[
                                RadialAxis(
                                  minimum: 0,
                                  maximum: 150,
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                      startValue: 0,
                                      endValue: 50,
                                      color: Colors.green,
                                      startWidth: 10,
                                      endWidth: 10,
                                    ),
                                    GaugeRange(
                                      startValue: 50,
                                      endValue: 100,
                                      color: Colors.orange,
                                      startWidth: 10,
                                      endWidth: 10,
                                    ),
                                    GaugeRange(
                                      startValue: 100,
                                      endValue: 150,
                                      color: Colors.red,
                                      startWidth: 10,
                                      endWidth: 10,
                                    )
                                  ],
                                  pointers: <GaugePointer>[
                                    NeedlePointer(
                                        value: double.parse(_analyticsModel
                                            .targetVsAchieved.percent
                                            .toString())),
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                      widget: Container(
                                        child: Text(
                                          _analyticsModel
                                                  .targetVsAchieved.percent
                                                  .toString() +
                                              ' %',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      angle: 90,
                                      positionFactor: 0.5,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {},
                                      color: Colors.orange,
                                      textColor: Colors.white,
                                      child: Icon(
                                        Icons.table_chart,
                                        size: 20,
                                      ),
                                      padding: EdgeInsets.all(16),
                                      shape: CircleBorder(),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '₹ ' +
                                              _analyticsModel
                                                  .targetVsAchieved.target
                                                  .toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Target',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {},
                                      color: Colors.orange,
                                      textColor: Colors.white,
                                      child: Icon(
                                        Icons.bar_chart,
                                        size: 20,
                                      ),
                                      padding: EdgeInsets.all(16),
                                      shape: CircleBorder(),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '₹ ' +
                                              _analyticsModel
                                                  .targetVsAchieved.achieved
                                                  .toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Achieved',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Divider()
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          Container(
                            color: Theme.of(context).primaryColor,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'Stores',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'Achieved',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ..._analyticsModel.targetVsAchieved.outlets!
                              .map(
                                (_outlet) => Column(
                                  children: [
                                    Container(
                                      decoration: _analyticsModel
                                                      .targetVsAchieved.outlets!
                                                      .indexOf(_outlet) %
                                                  2 !=
                                              0
                                          ? BoxDecoration(
                                              color: Colors.grey[400])
                                          : BoxDecoration(color: Colors.white),
                                      padding: EdgeInsets.all(7),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                  _outlet.outlet.toString()),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                '₹ ' +
                                                    _outlet.achieved.toString(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Divider()
                                  ],
                                ),
                              )
                              .toList()
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/analytics_pr.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class KpiReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _analyticsModel = Provider.of<AnalyticsModel>(context);
    DateFormat format = DateFormat('MMMM yy');
    String month = format.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KPI Report | ' + month,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.backgroundImg),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: _analyticsModel.kpiReport.achieved == null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
                    _analyticsModel.focussedDatas == null
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                            padding: EdgeInsets.all(8),
                            child: Card(
                              elevation: 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Theme.of(context).primaryColor,
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Category',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Acheived',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '%',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ..._analyticsModel.focussedDatas!
                                      .map(
                                        (_data) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(7),
                                              decoration: _analyticsModel
                                                              .focussedDatas!
                                                              .indexOf(_data) %
                                                          2 !=
                                                      0
                                                  ? BoxDecoration(
                                                      color: Colors.grey[400])
                                                  : BoxDecoration(
                                                      color: Colors.white),
                                              child: Row(
                                                children: [
                                                  // Expanded(
                                                  //   child: Center(
                                                  //     child: Text(_data['store_name']),
                                                  //   ),
                                                  // ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      _data['target_category']
                                                          .toString()
                                                          .replaceAll(
                                                              RegExp('_'), ' ')
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      _data['achieved']
                                                              .toString() +
                                                          '/' +
                                                          _data['target']
                                                              .toString(),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      _data['percent']
                                                              .toString() +
                                                          "%",
                                                      style: TextStyle(
                                                        fontSize: 15,
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
                                      .toList(),
                                ],
                              ),
                            ),
                          ),
                    // Padding(
                    //   padding: EdgeInsets.all(10),
                    //   child: Card(
                    //     elevation: 10,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         ElevatedButton(
                    //           onPressed: () {
                    //             Navigator.pushNamed(
                    //                 context, '/focussedTargetVsAchieved');
                    //           },
                    //           child: Text('Focussed Targets'),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Card(
                        elevation: 10,
                        child: Column(
                          children: [
                            // Container(
                            //   height: 200,
                            //   child: SfRadialGauge(
                            //     axes: <RadialAxis>[
                            //       RadialAxis(
                            //         minimum: 0,
                            //         maximum: 150,
                            //         ranges: <GaugeRange>[
                            //           GaugeRange(
                            //             startValue: 0,
                            //             endValue: 50,
                            //             color: Colors.green,
                            //             startWidth: 10,
                            //             endWidth: 10,
                            //           ),
                            //           GaugeRange(
                            //             startValue: 50,
                            //             endValue: 100,
                            //             color: Colors.orange,
                            //             startWidth: 10,
                            //             endWidth: 10,
                            //           ),
                            //           GaugeRange(
                            //             startValue: 100,
                            //             endValue: 150,
                            //             color: Colors.red,
                            //             startWidth: 10,
                            //             endWidth: 10,
                            //           )
                            //         ],
                            //         pointers: <GaugePointer>[
                            //           NeedlePointer(
                            //               value: double.parse(_analyticsModel
                            //                   .kpiReport.percent
                            //                   .toString())),
                            //         ],
                            //         annotations: <GaugeAnnotation>[
                            //           GaugeAnnotation(
                            //             widget: Container(
                            //               child: Text(
                            //                 _analyticsModel.kpiReport.percent
                            //                         .toString() +
                            //                     ' %',
                            //                 style: TextStyle(
                            //                   fontSize: 25,
                            //                   fontWeight: FontWeight.bold,
                            //                 ),
                            //               ),
                            //             ),
                            //             angle: 90,
                            //             positionFactor: 0.5,
                            //           )
                            //         ],
                            //       )
                            //     ],
                            //   ),
                            // ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Target',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            '₹ ' +
                                                _analyticsModel.kpiReport.target
                                                    .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Achieved',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            '₹ ' +
                                                _analyticsModel
                                                    .kpiReport.achieved
                                                    .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            ('(' +
                                                _analyticsModel
                                                    .kpiReport.percent
                                                    .toString() +
                                                '%)'),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Card(
                        elevation: 10,
                        child: Column(
                          children: [
                            Container(
                              color: Theme.of(context).primaryColor,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Date',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Achieved',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ..._analyticsModel.kpiReport.days!
                                .map(
                                  (_day) => Column(
                                    children: [
                                      Container(
                                        decoration: _analyticsModel
                                                        .kpiReport.days!
                                                        .indexOf(_day) %
                                                    2 !=
                                                0
                                            ? BoxDecoration(
                                                color: Colors.grey[400])
                                            : BoxDecoration(
                                                color: Colors.white),
                                        padding: EdgeInsets.all(7),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  _day.date.toString(),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '₹ ' + _day.achieved.toString(),
                                                style: TextStyle(
                                                  fontSize: 15,
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
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

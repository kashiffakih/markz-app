import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/analytics_pr.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class SaleTrendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _analyticsModel = Provider.of<AnalyticsModel>(context);
    DateFormat format = DateFormat('MMMM yy');
    String month = format.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Offtake Trends | ' + month),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _analyticsModel.salesTrend == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SfCartesianChart(
                      title: ChartTitle(text: 'Offtake Trend'),
                      // Initialize category axis
                      primaryXAxis: CategoryAxis(
                        title: AxisTitle(
                          text: 'Month',
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        isVisible: false,
                      ),
                      series: <ChartSeries>[
                        // Initialize line series
                        ColumnSeries<SalesData, String>(
                          dataSource: _analyticsModel.salesTrend.months!
                              .map((_month) => SalesData(
                                    _month.month.toString(),
                                    double.parse(_month.value.toString()),
                                  ))
                              .toList(),
                          xValueMapper: (SalesData sales, _) => sales.year,
                          yValueMapper: (SalesData sales, _) => sales.sales,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        )
                      ],
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '₹ ' +
                                        _analyticsModel.salesTrend.lastMonth
                                            .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Last Month',
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
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₹ ' +
                                          _analyticsModel
                                              .salesTrend.currentMonth
                                              .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Current Month',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    // Container(
                    //   color: Theme.of(context).primaryColor,
                    //   padding: EdgeInsets.all(10),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Center(
                    //           child: Text(
                    //             'Outlets',
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Center(
                    //           child: Text(
                    //             'Last Month',
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Center(
                    //           child: Text(
                    //             'Current Month',
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // ..._analyticsModel.salesTrend.outlets
                    //     .map(
                    //       (_outlet) => Container(
                    //         decoration: _analyticsModel.salesTrend.outlets
                    //                         .indexOf(_outlet) %
                    //                     2 !=
                    //                 0
                    //             ? BoxDecoration(color: Colors.grey[400])
                    //             : BoxDecoration(color: Colors.white),
                    //         child: Column(
                    //           children: [
                    //             Container(
                    //               padding: EdgeInsets.all(7),
                    //               child: Row(
                    //                 children: [
                    //                   Expanded(
                    //                     child: Center(
                    //                       child: Text(_outlet.outlet),
                    //                     ),
                    //                   ),
                    //                   Expanded(
                    //                     child: Center(
                    //                       child: Text(
                    //                         '₹ ' + _outlet.lastMonth.toString(),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Expanded(
                    //                     child: Center(
                    //                       child: Text(
                    //                         '₹ ' +
                    //                             _outlet.currentMonth.toString(),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             // Divider()
                    //           ],
                    //         ),
                    //       ),
                    //     )
                    //     .toList()
                  ],
                ),
        ),
      ),
    );
  }
}

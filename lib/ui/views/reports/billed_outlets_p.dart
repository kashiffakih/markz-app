import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/analytics_pr.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  SalesData(this.year, this.sales, [this.color = Colors.red]);
  // SalesData(this.year, this.sales);
  final String year;
  final double sales;
  final Color color;
}

class BilledOutletsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _analyticsModel = Provider.of<AnalyticsModel>(context);
    DateFormat format = DateFormat('MMMM yy');
    String month = format.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Billed Outlets | ' + month),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _analyticsModel.billedOutlet == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        child: Container(
                          height: 300,
                          child: SfCircularChart(
                            // Enables the tooltip for all the series in chart
                            tooltipBehavior: TooltipBehavior(enable: true),
                            legend: Legend(
                              isVisible: true,
                              position: LegendPosition.bottom,
                            ),
                            series: <CircularSeries>[
                              // Initialize line series
                              PieSeries<SalesData, String>(
                                // Enables the tooltip for individual series
                                enableTooltip: true,
                                dataSource: _analyticsModel.billedOutlet.months!
                                    .map((_month) => SalesData(
                                          _month.month.toString(),
                                          double.parse(_month.value.toString()),
                                        ))
                                    .toList(),
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                                emptyPointSettings: EmptyPointSettings(
                                    mode: EmptyPointMode.average),
                                pointColorMapper: (SalesData sales, _) =>
                                    sales.color,
                                xValueMapper: (SalesData sales, _) =>
                                    sales.year,
                                yValueMapper: (SalesData sales, _) =>
                                    sales.sales,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Divider(),
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
                                        'Outlets',
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
                                        'No. of INV.',
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
                                        'Sales Value',
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
                            ..._analyticsModel.billedOutlet.outlets!
                                .map(
                                  (_outlet) => Column(
                                    children: [
                                      Container(
                                        decoration: _analyticsModel
                                                        .billedOutlet.outlets!
                                                        .indexOf(_outlet) %
                                                    2 !=
                                                0
                                            ? BoxDecoration(
                                                color: Colors.grey[400])
                                            : BoxDecoration(
                                                color: Colors.white),
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
                                                  _outlet.noOfInv.toString(),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  '₹ ' +
                                                      _outlet.value.toString(),
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
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

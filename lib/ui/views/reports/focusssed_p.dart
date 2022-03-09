import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/analytics_pr.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FocussedReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _analyticsModel = Provider.of<AnalyticsModel>(context);
    DateFormat format = DateFormat('MMMM yy');
    String month = format.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Focussed Report | ' + month),
      ),
      body: SingleChildScrollView(
        child: _analyticsModel.focussedDatas == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
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
                              children: [
                                // Expanded(
                                //   child: Center(
                                //     child: Text(
                                //       'Store',
                                //       style: TextStyle(
                                //         color: Colors.white,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'Target',
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
                          ..._analyticsModel.focussedDatas!
                              .map(
                                (_data) => Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(7),
                                      child: Row(
                                        children: [
                                          // Expanded(
                                          //   child: Center(
                                          //     child: Text(_data['store_name']),
                                          //   ),
                                          // ),
                                          Expanded(
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    _data['target'].toString(),
                                                  ),
                                                  if (_data[
                                                          'target_category'] !=
                                                      '-')
                                                    Text(
                                                      '(' +
                                                          _data['target_category']
                                                              .toString() +
                                                          ')',
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                  _data['achieved'].toString()),
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
    );
  }
}

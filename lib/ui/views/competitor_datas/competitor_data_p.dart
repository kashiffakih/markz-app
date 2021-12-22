import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/competitor_data_pr.dart';
import 'package:sales_app/core/providers/customer_pr.dart';

class CompetitorDataPage extends StatelessWidget {
  const CompetitorDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _competitorDataModel = Provider.of<CompetitorDataModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Competitors'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _competitorDataModel.competitorDatasLoader
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
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
                                child: Text(
                                  'Comp.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Amount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Month',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ..._competitorDataModel.competitotDatas
                            .map(
                              (_competitorData) => Container(
                                decoration: _competitorDataModel.competitotDatas
                                                .indexOf(_competitorData) %
                                            2 !=
                                        0
                                    ? BoxDecoration(color: Colors.grey[400])
                                    : BoxDecoration(color: Colors.white),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(_competitorData.competitor
                                              .toString()),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _competitorData.amount.toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _competitorData.month.toString() +
                                                '/' +
                                                _competitorData.year.toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Divider(),
                                  ],
                                ),
                              ),
                            )
                            .toList()
                      ],
                    ),
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.add),
        backgroundColor: new Color(0xFFE57373),
        onPressed: () {
          Navigator.pushNamed(context, '/competitorDataCreate');
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';

class BeatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _referencePlanModel = Provider.of<ReferencePlanModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Beats'),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: _referencePlanModel.referencePlans == null
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      ],
                    ),
                  )
                : Column(
                    children: _referencePlanModel.referencePlans
                        .map(
                          (_referencePlan) => InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/beatOutlets',
                                  arguments: {
                                    'beat': _referencePlan,
                                  });
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(8),
                                      color: Theme.of(context).primaryColor,
                                      child: Column(
                                        children: [
                                          Text(
                                            _referencePlan.name +
                                                ' | ' +
                                                _referencePlan.town,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                '#Total Outlets',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(_referencePlan.totalOutlets
                                                  .toString()),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                '#Billed Outlets',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(_referencePlan.billedOutlets
                                                  .toString()),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                '#UnBilled Outlets',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(_referencePlan
                                                  .unbilledOutlets
                                                  .toString()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              'MTD: ₹ ' +
                                                  _referencePlan.mtd.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              'Avg. L3M: ₹ ' +
                                                  _referencePlan.l3m.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList()),
          ),
        ));
  }
}

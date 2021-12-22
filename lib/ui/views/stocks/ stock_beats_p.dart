import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';

class StockBeatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _referencePlanModel = Provider.of<ReferencePlanModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Locations'),
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
                              Navigator.pushNamed(context, '/stockBeatOutlets',
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
                                            _referencePlan.name! +
                                                ' | ' +
                                                _referencePlan.town.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/requisition_pr.dart';

class VisitorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RequisitionModel _requisitionModel =
        Provider.of<RequisitionModel>(context);

    DateFormat format = DateFormat('MMMM-yyyy');
    String todayDate = format.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Visitor List | ' + todayDate),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 7,
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
                              'Sr. No',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Center(
                            child: Text(
                              'Details',
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
                  _requisitionModel.requisitions == null
                      ? CircularProgressIndicator()
                      : Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: _requisitionModel.requisitions
                                .map(
                                  (_requisition) => InkWell(
                                    onTap: () {
                                      // Navigator.pushNamed(
                                      //   context,
                                      //   '/visitorId',
                                      //   arguments: {
                                      //     'visitor': _requisition,
                                      //   },
                                      // );
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text((_requisitionModel
                                                            .requisitions
                                                            .indexOf(
                                                                _requisition) +
                                                        1)
                                                    .toString()),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Center(
                                                child: Text(_requisition.title
                                                    .toString()),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        )
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
          Navigator.pushNamed(context, '/visitorCreate');
        },
      ),
    );
  }
}

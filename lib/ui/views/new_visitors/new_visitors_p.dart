import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/requisition_pr.dart';
import 'package:sales_app/core/providers/visitor_pr.dart';

class NewVisitorsPage extends StatelessWidget {
  final arguments;
  NewVisitorsPage({@required this.arguments});
  @override
  Widget build(BuildContext context) {
    final VisitorModel _visitorModel = Provider.of<VisitorModel>(context);

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
                          child: Text(
                            'Sr. No',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
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
                  _visitorModel.visitors == null
                      ? CircularProgressIndicator()
                      : Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: _visitorModel.visitors!
                                .map(
                                  (_visitor) => InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/visitorId',
                                        arguments: {
                                          'visitor': _visitor,
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text((_visitorModel
                                                          .visitors!
                                                          .indexOf(_visitor) +
                                                      1)
                                                  .toString()),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(_visitor.name),
                                                  Text(_visitor.description),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                onPressed: () {
                                                  Navigator.pushNamed(context,
                                                      '/newVisitorDetails',
                                                      arguments: {
                                                        'visitor': _visitor,
                                                        'beat':
                                                            arguments['beat'],
                                                        'outlet':
                                                            arguments['outlet'],
                                                      });
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .arrow_right_alt_outlined,
                                                ),
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
          Navigator.pushNamed(context, '/newVisitorCreate', arguments: {
            'beat': arguments['beat'],
            'outlet': arguments['outlet'],
          });
        },
      ),
    );
  }
}

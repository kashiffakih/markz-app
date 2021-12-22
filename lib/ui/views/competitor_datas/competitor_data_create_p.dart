import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/competitor_data.dart';
import 'package:sales_app/core/models/customer.dart';
import 'package:sales_app/core/providers/competitor_data_pr.dart';
import 'package:sales_app/core/providers/customer_pr.dart';

class CompetitorDataCreatePage extends StatefulWidget {
  @override
  _CompetitorDataCreatePageState createState() =>
      _CompetitorDataCreatePageState();
}

class _CompetitorDataCreatePageState extends State<CompetitorDataCreatePage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isLoading = false;

  List<String> _competitors = [
    'Biotech',
    'Derma fique',
    'Nivea',
    'Neutrogena',
    'Olay',
    'Plum'
  ];
  List<dynamic> _months = [
    {'name': 'January', 'value': '1'},
    {'name': 'February', 'value': '2'},
    {'name': 'March', 'value': '3'},
    {'name': 'April', 'value': '4'},
    {'name': 'May', 'value': '5'},
    {'name': 'June', 'value': '6'},
    {'name': 'July', 'value': '7'},
    {'name': 'August', 'value': '8'},
    {'name': 'September', 'value': '9'},
    {'name': 'October', 'value': '10'},
    {'name': 'November', 'value': '11'},
    {'name': 'December', 'value': '12'},
  ];
  List<dynamic> _years = [
    {'name': '2021', 'value': '2021'},
    {'name': '2022', 'value': '2022'},
  ];

  @override
  Widget build(BuildContext context) {
    final _competitorDataModel = Provider.of<CompetitorDataModel>(context);
    CompetitorData _competitor = CompetitorData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Competitor Data'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Competitor',
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonFormField(
                            decoration:
                                InputDecoration(labelText: 'Select competitor'),
                            items: _competitors
                                .map(
                                  (_competitor) => DropdownMenuItem(
                                    value: _competitor,
                                    child: Text(
                                      _competitor,
                                    ),
                                  ),
                                )
                                .toList(),
                            validator: (value) {
                              if (value == null)
                                return 'Please select competitor';
                              return null;
                            },
                            onChanged: (value) {
                              setState(() async {
                                _competitor.competitor = value.toString();
                              });
                            },
                            onSaved: (value) {
                              _competitor.competitor = value.toString();
                            },
                          ),
                        ),
                        // Expanded(
                        //   child: TextFormField(
                        //     decoration:
                        //         InputDecoration(labelText: 'Competitor'),
                        //     validator: (value) {
                        //       if (value!.isEmpty) return 'Please enter value';
                        //       return null;
                        //     },
                        //     onSaved: (value) {
                        //       _competitor.competitor = value;
                        //     },
                        //   ),
                        // )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Amount',
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Amount'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) return 'Please enter value';
                              return null;
                            },
                            onSaved: (value) {
                              _competitor.amount = value;
                            },
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Month',
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonFormField(
                            decoration:
                                InputDecoration(labelText: 'Select month'),
                            items: _months
                                .map(
                                  (_month) => DropdownMenuItem(
                                    value: _month['value'],
                                    child: Text(
                                      _month['name'],
                                    ),
                                  ),
                                )
                                .toList(),
                            validator: (value) {
                              if (value == null) return 'Please select month';
                              return null;
                            },
                            onChanged: (value) {
                              setState(() async {
                                _competitor.month = value.toString();
                              });
                            },
                            onSaved: (value) {
                              _competitor.month = value.toString();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Year',
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonFormField(
                            decoration:
                                InputDecoration(labelText: 'Select year'),
                            items: _years
                                .map(
                                  (_year) => DropdownMenuItem(
                                    value: _year['value'],
                                    child: Text(
                                      _year['name'],
                                    ),
                                  ),
                                )
                                .toList(),
                            validator: (value) {
                              if (value == null) return 'Please select year';
                              return null;
                            },
                            onChanged: (value) async {
                              setState(() async {
                                _competitor.year = value.toString();
                              });
                            },
                            onSaved: (value) {
                              _competitor.year = value.toString();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _isLoading
                        ? Text('Saving Data...')
                        : ElevatedButton(
                            onPressed: () async {
                              if (_key.currentState!.validate()) {
                                _key.currentState!.save();
                                setState(() {
                                  _isLoading = true;
                                });
                                await _competitorDataModel.competitorDataCreate(
                                  competitorData: _competitor,
                                );

                                _competitorDataModel.getCompetitorDatas();

                                Navigator.pop(context);

                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            child: Text('Add Competitor Data'),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

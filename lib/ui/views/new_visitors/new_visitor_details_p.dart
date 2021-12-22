import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/visitor.dart';
import 'package:sales_app/core/providers/visitor_pr.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class NewVisitorDetailsPage extends StatefulWidget {
  var arguments; // visitor

  NewVisitorDetailsPage({@required this.arguments});
  @override
  _NewVisitorDetailsPageState createState() => _NewVisitorDetailsPageState();
}

class _NewVisitorDetailsPageState extends State<NewVisitorDetailsPage> {
  bool isBaPresent = false;
  bool isGrooming = false;
  bool isUniform = false;
  bool isPlanogram = false;
  bool isNpd = false;

  late Visitor _visitor;
  VisitorBas _bas = VisitorBas(
    baStatus: false,
    isUniform: false,
    isPlanogram: false,
  );

  @override
  void initState() {
    _visitor = widget.arguments['visitor'];
    setState(() {
      _bas.visitorId = _visitor.id;

      _visitor.visitorBas = [];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final VisitorModel _visitorModel = Provider.of<VisitorModel>(context);

    bool _isLoading = false;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Visitor Details'),
        bottom: PreferredSize(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Description',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      'Status',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(40),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Card(
                  elevation: 10,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Is BA Present',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Switch(
                            value: _bas.baStatus,
                            onChanged: (value) {
                              setState(() {
                                _bas.baStatus = !_bas.baStatus;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Grooming',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                _bas.groomingValue = rating;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Uniform',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Switch(
                            value: _bas.isUniform,
                            onChanged: (value) {
                              setState(() {
                                _bas.isUniform = !_bas.isUniform;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Uniform',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Switch(
                            value: _bas.isPlanogram,
                            onChanged: (value) {
                              setState(() {
                                _bas.isPlanogram = !_bas.isPlanogram;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Product Knowledge',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              _bas.productKnowledgeValue = rating;
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(8),
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          children: [
                            Text(
                              'NPD',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(8),
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          children: [
                            Text(
                              'Stock Status',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(8),
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          children: [
                            Text(
                              'Tester Availability',
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
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: Font.primaryFont,
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                  _visitor.visitorBas!.add(_bas);
                                  print(_visitor.toJson());
                                });

                                await _visitorModel.visitorUpdate(
                                  visitor: _visitor,
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text('Saved Successfully'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pushReplacementNamed(
                                              context, '/newVisitors',
                                              arguments: {
                                                'beat':
                                                    widget.arguments['beat'],
                                                'outlet':
                                                    widget.arguments['outlet'],
                                              });
                                        },
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
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

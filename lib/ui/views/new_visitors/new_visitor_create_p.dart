import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/requisition.dart';
import 'package:sales_app/core/models/visitor.dart';
import 'package:sales_app/core/providers/requisition_pr.dart';
import 'package:sales_app/core/providers/visitor_pr.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class NewVisitorCreatePage extends StatefulWidget {
  final arguments;

  NewVisitorCreatePage({@required this.arguments});

  @override
  _NewVisitorCreatePageState createState() => _NewVisitorCreatePageState();
}

class _NewVisitorCreatePageState extends State<NewVisitorCreatePage> {
  Visitor _visitor = Visitor();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final VisitorModel _visitorModel = Provider.of<VisitorModel>(context);

    bool _isLoading = false;

    DateFormat _format = DateFormat('dd-MM-yyyy');
    String todayDate = _format.format(DateTime.now());

    _visitor.retailerId = widget.arguments['outlet'].id;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Visitor | ' + todayDate),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            elevation: 7,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter name';
                        return null;
                      },
                      onSaved: (value) {
                        _visitor.name = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter description',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter description';
                        return null;
                      },
                      onSaved: (value) {
                        _visitor.description = value;
                      },
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
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() {
                                  _isLoading = true;
                                });
                                await _visitorModel.visitorCreate(
                                    visitor: _visitor);
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
                              }
                            },
                          )
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

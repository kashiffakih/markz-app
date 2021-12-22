import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/requisition.dart';
import 'package:sales_app/core/providers/requisition_pr.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class VisitorIdPage extends StatefulWidget {
  final arguments; // visitor

  VisitorIdPage({@required this.arguments});

  @override
  _VisitorIdPageState createState() => _VisitorIdPageState();
}

class _VisitorIdPageState extends State<VisitorIdPage> {
  Requisition _requistion = Requisition();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Requisition _requisition;

  @override
  void initState() {
    super.initState();
    _requisition = widget.arguments['visitor'];
  }

  @override
  Widget build(BuildContext context) {
    final RequisitionModel _requisitionModel =
        Provider.of<RequisitionModel>(context);

    bool _isLoading = false;

    DateFormat _format = DateFormat('dd-MM-yyyy');
    String todayDate = _format.format(DateTime.now());

    List<String> _requisitionTypes = [
      'Store visit',
    ];

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
                        labelText: 'Enter details',
                      ),
                      initialValue: _requisition.title,
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter details';
                        return null;
                      },
                      onSaved: (value) {
                        _requistion.title = value;
                      },
                    ),
                    DropdownButtonFormField(
                      value: _requisition.requisitionType,
                      decoration: InputDecoration(
                          labelText: 'Please enter requisition type'),
                      items: _requisitionTypes
                          .map(
                            (_requisitionType) => DropdownMenuItem(
                              value: _requisitionType,
                              child: Text(_requisitionType),
                            ),
                          )
                          .toList(),
                      validator: (value) {
                        if (value == null)
                          return 'Please select the requistion type';
                        return null;
                      },
                      onSaved: (value) {
                        _requistion.requisitionType = value.toString();
                      },
                      onChanged: (value) {
                        _requistion.requisitionType = value.toString();
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
                                await _requisitionModel.requisitionCreate(
                                    requisition: _requistion);
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
                                              context, '/visitors');
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

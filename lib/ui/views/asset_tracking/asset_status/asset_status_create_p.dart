import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/asset.dart';
import 'package:sales_app/core/models/asset_status.dart';
import 'package:sales_app/core/providers/asset_pr.dart';

class AssetStatusCreatePage extends StatefulWidget {
  final arguments; // asset

  AssetStatusCreatePage({@required this.arguments});

  @override
  _AssetStatusCreatePageState createState() => _AssetStatusCreatePageState();
}

class _AssetStatusCreatePageState extends State<AssetStatusCreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AssetStatus _assetStatus = AssetStatus();

  bool _isLoading = false;

  List<String> _statuses = [
    'WORKING',
    'NOT WORKING',
    'MAINTENANCE REQUIRED',
  ];

  @override
  Widget build(BuildContext context) {
    final AssetModel _assetModel = Provider.of<AssetModel>(context);
    Asset _asset = widget.arguments['asset'];

    _assetStatus.assetId = _asset.id;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Asset Status'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: 'Select Status'),
                      value: _assetStatus.status,
                      items: _statuses
                          .map((_status) => DropdownMenuItem(
                                value: _status,
                                child: Text(_status),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) return 'Please select status';
                        return null;
                      },
                      onChanged: (value) {
                        _assetStatus.status = value.toString();
                      },
                      onSaved: (value) {
                        _assetStatus.status = value.toString();
                      },
                    ),
                    TextFormField(
                      initialValue: _assetStatus.description,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Enter description',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter description';
                        return null;
                      },
                      onSaved: (value) {
                        _assetStatus.description = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() {
                                  _isLoading = true;
                                });
                                await _assetModel.assetStatusCreate(
                                  asset: _asset,
                                  assetStatus: _assetStatus,
                                );
                                _assetModel.getAssets();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text(
                                      'Saved Successfully',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  ),
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}

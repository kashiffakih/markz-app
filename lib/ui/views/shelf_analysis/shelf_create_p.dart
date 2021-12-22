import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/asset.dart';
import 'package:sales_app/core/models/reference_plan.dart';
import 'package:sales_app/core/providers/asset_pr.dart';
import 'package:sales_app/core/providers/manufacturer_pr.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';

class ShelfCreatePage extends StatefulWidget {
  final arguments; // beat, outlet

  ShelfCreatePage({@required this.arguments});

  @override
  _ShelfCreatePageState createState() => _ShelfCreatePageState();
}

class _ShelfCreatePageState extends State<ShelfCreatePage> {
  Asset _asset = Asset();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> _statuses = [
    'WORKING',
    'NOT WORKING',
    'MAINTENANCE REQUIRED',
  ];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _assetModel = Provider.of<AssetModel>(context);
    final _manufacturerModel = Provider.of<ManufacturerModel>(context);
    final _referencePlanModel = Provider.of<ReferencePlanModel>(context);

    ReferencePlan _referencePlan = _referencePlanModel.referencePlans
        .firstWhere((_rf) => _rf.id == widget.arguments['beat'].id);

    Retailers _retailer = _referencePlan.retailers!
        .firstWhere((_r) => _r.id == widget.arguments['outlet'].id);

    _asset.referencePlanId = _referencePlan.id;
    _asset.retailerId = _retailer.id;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add an asset'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Card(
              elevation: 7,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Enter asset name'),
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter asset name';
                          return null;
                        },
                        onChanged: (value) {
                          _asset.assetName = value;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              initialValue: _asset.uniqueId,
                              decoration: InputDecoration(
                                  labelText: 'Enter asset unique id'),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Please enter asset unique id';
                                return null;
                              },
                              onSaved: (value) {
                                _asset.uniqueId = value;
                              },
                            ),
                          ),
                          // Expanded(
                          //   child: IconButton(
                          //     icon: Icon(Icons.qr_code),
                          //     onPressed: () async {
                          //       String barcodeScanRes =
                          //           await FlutterBarcodeScanner.scanBarcode(
                          //         "#ff6666",
                          //         "Cancel",
                          //         true,
                          //         ScanMode.BARCODE,
                          //       );
                          //       _asset.uniqueId = barcodeScanRes;
                          //     },
                          //   ),
                          // )
                        ],
                      ),
                      TextFormField(
                        initialValue: _asset.size,
                        decoration:
                            InputDecoration(labelText: 'Enter asset size'),
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter asset size';
                          return null;
                        },
                        onSaved: (value) {
                          _asset.size = value;
                        },
                      ),
                      if (_manufacturerModel.manufacturers != null)
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              labelText: 'Please select manufacturer'),
                          value: _asset.manufacturerId,
                          items: _manufacturerModel.manufacturers
                              .map((_manufacturer) => DropdownMenuItem(
                                    value: _manufacturer.id,
                                    child: Text(_manufacturer.name.toString()),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null)
                              return 'Please select manufacturer';
                            return null;
                          },
                          onChanged: (value) {
                            _asset.manufacturerId = int.parse(value.toString());
                          },
                          onSaved: (value) {
                            _asset.manufacturerId = int.parse(value.toString());
                          },
                        ),
                      if (_statuses.length > 0)
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: 'Status'),
                          value: _asset.status,
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
                          onSaved: (value) {
                            _asset.status = value.toString();
                          },
                          onChanged: (value) {
                            _asset.status = value.toString();
                          },
                        ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Enter asset description'),
                        maxLines: 2,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please enter asset description';
                          return null;
                        },
                        onChanged: (value) {
                          _asset.description = value;
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
                                  await _assetModel.assetCreate(asset: _asset);
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
        ),
      ),
    );
  }
}

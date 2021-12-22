import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/asset.dart';
import 'package:sales_app/core/models/reference_plan.dart';
import 'package:sales_app/core/providers/asset_pr.dart';
import 'package:sales_app/core/providers/manufacturer_pr.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';

class AssetEditPage extends StatefulWidget {
  final arguments; // asset // beat // outlet

  AssetEditPage({@required this.arguments});

  @override
  _AssetEditPageState createState() => _AssetEditPageState();
}

class _AssetEditPageState extends State<AssetEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> _statuses = [
    'WORKING',
    'NOT WORKING',
    'MAINTENANCE REQUIRED',
  ];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Asset _asset = widget.arguments['asset'];

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
        title: Text('Edit an asset'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  elevation: 7,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: _asset.assetName,
                            decoration:
                                InputDecoration(labelText: 'Enter asset name'),
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please enter asset name';
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
                              if (value!.isEmpty)
                                return 'Please enter asset size';
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
                                        child:
                                            Text(_manufacturer.name.toString()),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null)
                                  return 'Please select manufacturer';
                                return null;
                              },
                              onChanged: (value) {
                                _asset.manufacturerId =
                                    int.parse(value.toString());
                              },
                              onSaved: (value) {
                                _asset.manufacturerId =
                                    int.parse(value.toString());
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
                                if (value == null)
                                  return 'Please select status';
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
                            initialValue: _asset.description,
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
                          Row(
                            children: [
                              _isLoading
                                  ? CircularProgressIndicator()
                                  : Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          color: Theme.of(context).primaryColor,
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              await _assetModel.assetUpdate(
                                                  asset: _asset);
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: Text(
                                                    'Update Successfully',
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
                                              _assetModel.getAssets();
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            }
                                          },
                                          child: Text(
                                            'Update',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    child: Text(
                                      'Upload Images',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/assetImages',
                                          arguments: {
                                            'beat': _referencePlan,
                                            'outlet': _retailer,
                                            'asset': _asset,
                                          });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    child: Text(
                                      'Status',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/assetStatusCreate',
                                          arguments: {
                                            'asset': _asset,
                                          });
                                    },
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
                Card(
                  elevation: 7,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Asset Status',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Sr. No.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'Date',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'Status',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'Description',
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
                      ..._asset.assetStatuses!
                          .map(
                            (_assetStatus) => Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (_asset.assetStatuses!
                                                    .indexOf(_assetStatus) +
                                                1)
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        _assetStatus.date.toString(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        _assetStatus.status.toString(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        _assetStatus.description.toString(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

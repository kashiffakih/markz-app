import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/reference_plan.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';
import 'package:sales_app/core/providers/sku_pr.dart';

class DamageStocksCreatePage extends StatefulWidget {
  @override
  _DamageStocksCreatePageState createState() => _DamageStocksCreatePageState();
}

class _DamageStocksCreatePageState extends State<DamageStocksCreatePage> {
  TextEditingController _manufacturingDateController = TextEditingController();

  Map<String, dynamic> _damageStockData = {
    'reference_plan_id': null,
    'sku_id': '',
    'qty': '',
    'mrp': '',
    'manufacturing_date': '',
  };

  List<Retailers>? _retailers = [];

  _selectManufacturingDate(BuildContext context) async {
    DateTime now = DateTime.now();
    // final DateTime _pickedManufacturingDate = await showDatePicker(
    //   context: context,
    //   initialDate: now,
    //   firstDate: now.subtract(
    //     Duration(
    //       days: 365,
    //     ),
    //   ),
    //   lastDate: now.add(
    //     Duration(
    //       days: 365,
    //     ),
    //   ),
    // );

    // if (_pickedManufacturingDate != null) {
    //   setState(() {
    //     DateFormat format = DateFormat('yyyy-MM-dd');
    //     _manufacturingDateController.text =
    //         format.format(_pickedManufacturingDate);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _damageStockKey = GlobalKey<FormState>();

    final _skuModel = Provider.of<SkuModel>(context);
    final _referencePlanModel = Provider.of<ReferencePlanModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Damage Stock'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _damageStockKey,
              child: Column(
                children: [
                  if (_referencePlanModel.referencePlans != null)
                    DropdownButtonFormField(
                      value: _damageStockData['reference_plan_id'],
                      decoration: InputDecoration(labelText: 'Select Beat'),
                      items: _referencePlanModel.referencePlans
                          .map((_referencePlan) => DropdownMenuItem(
                                child: Text(_referencePlan.name.toString()),
                                value: _referencePlan.id,
                              ))
                          .toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          _damageStockData['reference_plan_id'] = value;
                          print(_damageStockData);
                          ReferencePlan _referencePlan = _referencePlanModel
                              .referencePlans
                              .singleWhere((_rp) => _rp.id == value);
                          _retailers = _referencePlan.retailers;
                        });
                      },
                    ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: 'Select Retailer'),
                    items: _retailers!
                        .map((_retailer) => DropdownMenuItem(
                              child: Text(_retailer.name.toString()),
                              value: _retailer.id,
                            ))
                        .toList(),
                    onChanged: (value) {
                      print(value);
                    },
                  ),
                  DropdownButtonFormField(
                      decoration: InputDecoration(labelText: 'Select SKU'),
                      items: _skuModel.skus!
                          .map((_sku) => DropdownMenuItem(
                                child: Text(_sku.name.toString()),
                                value: _sku.id,
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) return 'Select SKU';
                        return null;
                      },
                      onChanged: (value) {
                        _damageStockData['sku_id'] = value;
                      }),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Enter qty'),
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter qty';
                      return null;
                    },
                    onSaved: (value) {
                      _damageStockData['qty'] = value;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Enter MRP'),
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter MRP';
                      return null;
                    },
                    onSaved: (value) {
                      _damageStockData['mrp'] = value;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Manufacturing date (yyyy-mm-dd)'),
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Enter Manufacturing Date';
                            return null;
                          },
                          controller: _manufacturingDateController,
                          enabled: false,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          color: Theme.of(context).primaryColor,
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectManufacturingDate(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_damageStockKey.currentState!.validate()) {
                        _damageStockKey.currentState!.save();
                        _damageStockData['manufacturing_date'] =
                            _manufacturingDateController.text;
                        print(_damageStockData);
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
      )),
    );
  }
}

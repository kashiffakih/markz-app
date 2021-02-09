import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/sku_pr.dart';

class DamageStocksCreatePage extends StatefulWidget {
  @override
  _DamageStocksCreatePageState createState() => _DamageStocksCreatePageState();
}

class _DamageStocksCreatePageState extends State<DamageStocksCreatePage> {
  Map<String, dynamic> _damageStockData = {
    'sku_id': '',
    'qty': '',
    'mrp': '',
    'manufacturing_date': '',
  };
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _damageStockKey = GlobalKey<FormState>();

    final _skuModel = Provider.of<SkuModel>(context);

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
                  
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Enter qty'),
                    validator: (value) {
                      if (value.isEmpty) return 'Enter qty';
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
                      if (value.isEmpty) return 'Enter MRP';
                      return null;
                    },
                    onSaved: (value) {
                      _damageStockData['mrp'] = value;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Manufacturing date (yyyy-mm-dd)'),
                    validator: (value) {
                      if (value.isEmpty) return 'Enter Manufacturing Date';
                      return null;
                    },
                    onSaved: (value) {
                      _damageStockData['manufacturing_date'] = value;
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/reference_plan.dart';
import 'package:sales_app/core/models/sku.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';
import 'package:sales_app/core/providers/sku_availability_pr.dart';
import 'package:sales_app/core/providers/sku_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/core/providers/config_pr.dart';

class StockReportPage extends StatefulWidget {
  final arguments; // beat, outlet

  StockReportPage({@required this.arguments});

  @override
  _StockReportPageState createState() => _StockReportPageState();
}

class _StockReportPageState extends State<StockReportPage> {
  final _configModel = locator<ConfigModel>();

  List<Sku>? _skus = [];
  bool _isSkuFilled = false;

  @override
  void initState() {
    _skus = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _skuModel = Provider.of<SkuModel>(context);

    TextEditingController _controller = TextEditingController();

    List<String> _mainCategories = [
      'All',
      'Baby',
      'Body',
      'Face',
      'Hair',
      'Derma'
    ];

    setState(() {
      if (!_isSkuFilled && _skuModel.skus != null) {
        _isSkuFilled = true;
        _skus = _skuModel.skus;
      }
    });

    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text('SKU Availability: ' + widget.arguments['outlet'].name),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter search text',
                          ),
                          controller: _controller,
                        ),
                        SizedBox(height: 10),
                        Text('-- or --'),
                        DropdownButtonFormField(
                          decoration:
                              InputDecoration(labelText: 'Select category'),
                          items: _mainCategories
                              .map(
                                (_mainCategory) => DropdownMenuItem(
                                  value: _mainCategory,
                                  child: Text(_mainCategory),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              if (value == 'All')
                                _skus = _skuModel.skus;
                              else
                                _skus = _skuModel.skus!
                                    .where((sku) => sku.mainCategory == value)
                                    .toList();
                              Navigator.pop(context);
                            });
                          },
                        )
                      ],
                    ),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          print(_controller.text);
                          if (_controller.text == '') {
                            setState(() {
                              _skus = _skuModel.skus;
                            });
                          } else {
                            setState(() {
                              _skus = _skuModel.skus!
                                  .where((sku) => sku.name!
                                      .toLowerCase()
                                      .contains(_controller.text))
                                  .toList();
                            });
                          }
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Text('SEARCH'),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('CANCEL'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            _configModel.user.email.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _configModel.user.baName != null
                                ? _configModel.user.baName.toString()
                                : '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(40),
          ),
        ),
        preferredSize: Size.fromHeight(100),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: _skus!.length == 0
                    ? Center(child: CircularProgressIndicator())
                    : Card(
                        elevation: 10,
                        child: _skus == null
                            ? CircularProgressIndicator()
                            : Column(
                                children: _skus!.map((_sku) {
                                  return Container(
                                    decoration: _skus!.indexOf(_sku) % 2 != 0
                                        ? BoxDecoration(color: Colors.grey[400])
                                        : BoxDecoration(color: Colors.white),
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              if (_sku.offerId == null)
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    _sku.name.toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              else if (_sku
                                                      .offer!.offerType!.name ==
                                                  'FLAT')
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    _sku.name! +
                                                        ' (₹.' +
                                                        _sku.offer!.offer
                                                            .toString() +
                                                        ' OFF)',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              else if (_sku
                                                      .offer!.offerType!.name ==
                                                  'PERCENT')
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    _sku.name! +
                                                        ' (' +
                                                        _sku.offer!.offer
                                                            .toString() +
                                                        '% OFF)',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              else if (_sku
                                                      .offer!.offerType!.name ==
                                                  'FREE GIFT')
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    _sku.name! +
                                                        ' (' +
                                                        _sku.offer!.itemName
                                                            .toString() +
                                                        ')',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              else if (_sku
                                                      .offer!.offerType!.name ==
                                                  'FREE QTY')
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    _sku.name! +
                                                        ' (' +
                                                        _sku.offer!.itemName
                                                            .toString() +
                                                        ')',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Op.',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    Text(
                                                      _sku.openingStock
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Rec.',
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    Text(
                                                      _sku.receivedStock
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Stk Ret.',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    Text(
                                                      _sku.purchaseReturnedStock
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Off.',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    Text(
                                                      _sku.salesStock
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Off Ret.',
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    Text(
                                                      _sku.returnedStock
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Cl.',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    Text(
                                                      _sku.closingStock
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/sku_pr.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

class ProductsMasterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _skuModel = Provider.of<SkuModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Master'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _skuModel.skus == null
              ? Center(
                  child: SingleChildScrollView(),
                )
              : Column(
                  children: _skuModel.skus!
                      .map(
                        (_sku) => Card(
                          child: Container(
                            decoration: _skuModel.skus!.indexOf(_sku) % 2 != 0
                                ? BoxDecoration(color: Colors.grey[400])
                                : BoxDecoration(color: Colors.white),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _sku.name.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 8.0,
                                        right: 8.0,
                                        bottom: 8.0,
                                      ),
                                      child: CircleAvatar(
                                        radius: 32,
                                        backgroundImage:
                                            AssetImage(Images.product),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: Text(_sku.price
                                                          .toString()),
                                                    ),
                                                    Text(
                                                      'MRP',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: Text(_sku
                                                                  .offerPrice ==
                                                              null
                                                          ? _sku.price
                                                              .toString()
                                                          : _sku.offerPrice
                                                              .toString()),
                                                    ),
                                                    Text(
                                                      'PTR',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            children: [
                                              // Expanded(
                                              //   child: Column(
                                              //     children: [
                                              //       Center(
                                              //         child: Text('10.00'),
                                              //       ),
                                              //       Text(
                                              //         'UOM',
                                              //         style: TextStyle(
                                              //           fontWeight:
                                              //               FontWeight.bold,
                                              //         ),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                          _sku.qty.toString()),
                                                    ),
                                                    Text(
                                                      'In-Stock',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
    );
  }
}

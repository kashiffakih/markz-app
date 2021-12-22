import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/reference_plan.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';
import 'package:sales_app/core/providers/sku_availability_pr.dart';
import 'package:sales_app/core/providers/sku_pr.dart';

class SkuAvailabilityPage extends StatefulWidget {
  final arguments; // beat, outlet

  SkuAvailabilityPage({@required this.arguments});

  @override
  _SkuAvailabilityPageState createState() => _SkuAvailabilityPageState();
}

class _SkuAvailabilityPageState extends State<SkuAvailabilityPage> {
  Map<String, dynamic> _skuAvailabilityMap = {};

  @override
  Widget build(BuildContext context) {
    final _skuAvailabilityModel = Provider.of<SkuAvailabilityModel>(context);

    final _referencePlanModel = Provider.of<ReferencePlanModel>(context);

    ReferencePlan _referencePlan = _referencePlanModel.referencePlans
        .firstWhere((_rf) => _rf.id == widget.arguments['beat'].id);

    Retailers _retailer = _referencePlan.retailers!
        .firstWhere((_r) => _r.id == widget.arguments['outlet'].id);

    DateFormat format = DateFormat('dd-MM-yyyy');
    String todayDate = format.format(DateTime.now());

    _skuAvailabilityMap['reference_plan_id'] = _referencePlan.id;
    _skuAvailabilityMap['retailer_id'] = _retailer.id;
    _skuAvailabilityMap['date'] = todayDate;

    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text('SKU Availability: ' + widget.arguments['outlet'].name),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () {},
          //   ),
          // ],
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
                          'Product Name',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        'Available',
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
        preferredSize: Size.fromHeight(100),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Card(
              elevation: 10,
              child: _skuAvailabilityModel.skuAvailabilities == null
                  ? CircularProgressIndicator()
                  : Column(
                      children: _skuAvailabilityModel.skuAvailabilities
                          .map((_skuAvailability) {
                        return Container(
                          decoration: _skuAvailabilityModel.skuAvailabilities
                                          .indexOf(_skuAvailability) %
                                      2 !=
                                  0
                              ? BoxDecoration(color: Colors.grey[400])
                              : BoxDecoration(color: Colors.white),
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    if (_skuAvailability.offerId == null)
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          _skuAvailability.name.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    else if (_skuAvailability
                                            .offer!.offerType!.name ==
                                        'FLAT')
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          _skuAvailability.name! +
                                              ' (₹.' +
                                              _skuAvailability.offer!.offer
                                                  .toString() +
                                              ' OFF)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    else if (_skuAvailability
                                            .offer!.offerType!.name ==
                                        'PERCENT')
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          _skuAvailability.name! +
                                              ' (' +
                                              _skuAvailability.offer!.offer
                                                  .toString() +
                                              '% OFF)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    // else if (_skuAvailability
                                    //         .offer!.offerType!.name ==
                                    //     'FREE GIFT')
                                    //   Expanded(
                                    //     flex: 2,
                                    //     child: Text(
                                    //       _skuAvailability.name! +
                                    //           ' (' +
                                    //           _skuAvailability.offer.itemName +
                                    //           ')',
                                    //       style: TextStyle(
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //   )
                                    // else if (_skuAvailability
                                    //         .offer!.offerType!.name ==
                                    //     'FREE QTY')
                                    //   Expanded(
                                    //     flex: 2,
                                    //     child: Text(
                                    //       _skuAvailability.name! +
                                    //           ' (' +
                                    //           _skuAvailability!
                                    //               .offer!.itemName +
                                    //           ')',
                                    //       style: TextStyle(
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // Switch(
                                    //   value: _skuAvailability!.isAvailable,
                                    //   onChanged: (value) {
                                    //     setState(() {
                                    //       _skuAvailability.isAvailable =
                                    //           !_skuAvailability.isAvailable;
                                    //       _skuAvailabilityMap['id'] =
                                    //           _skuAvailability.id;
                                    //       _skuAvailabilityMap['sku_id'] =
                                    //           _skuAvailability.skuId;
                                    //       _skuAvailabilityMap['is_available'] =
                                    //           value;
                                    //       _skuAvailabilityModel
                                    //           .updateSkuAvailability(
                                    //         skuAvailability:
                                    //             _skuAvailabilityMap,
                                    //       );
                                    //     });
                                    //   },
                                    // ),
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
        ),
      ),
    );
  }
}

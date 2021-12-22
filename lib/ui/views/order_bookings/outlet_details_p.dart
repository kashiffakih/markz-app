import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/reference_plan.dart';
import 'package:sales_app/core/providers/my_order_pr.dart';
import 'package:sales_app/core/providers/order_pr.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'package:sales_app/ui/widgets/take_image_w.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:url_launcher/url_launcher.dart';

class OutletDetailsPage extends StatefulWidget {
  final arguments; // beat, outlet

  OutletDetailsPage({@required this.arguments});

  @override
  _OutletDetailsPageState createState() => _OutletDetailsPageState();
}

class _OutletDetailsPageState extends State<OutletDetailsPage> {
  bool isUploadingImage = false;
  late String _reason;

  List<Map<String, dynamic>> buttons = [
    {
      'title': 'Opening Stock',
      'key': 'Opening Stock',
      'color': Colors.green[400],
    },
    {
      'title': 'Stock Received',
      'key': 'Stock Received',
      'color': Colors.green[400]
    },
    {
      'title': 'Stock Returned',
      'key': 'Purchase Returned',
      'color': Colors.red[400],
    },
    {
      'title': 'Offtake',
      'key': 'Sales',
      'color': Colors.red[400],
    },
    {
      'title': 'Offtake Returned',
      'key': 'Stock Returned',
      'color': Colors.green[400]
    },
  ];

  _launchURL({@required url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final _configModel = locator<ConfigModel>();
    final _myOrderModel = Provider.of<MyOrderModel>(context);
    final _referencePlanModel = Provider.of<ReferencePlanModel>(context);
    final _orderModel = Provider.of<OrderModel>(context);

    ReferencePlan _referencePlan = _referencePlanModel.referencePlans
        .firstWhere((_rf) => _rf.id == widget.arguments['beat'].id);

    Retailers _retailer = _referencePlan.retailers!
        .firstWhere((_r) => _r.id == widget.arguments['outlet'].id);

    return Scaffold(
      appBar: AppBar(
        title: Text(_retailer.name! + ' Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        if (_retailer.imagePath == null)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 8.0,
                                right: 8.0,
                                bottom: 8.0,
                              ),
                              child: CircleAvatar(
                                radius: 100,
                                backgroundImage: AssetImage(Images.product),
                              ),
                            ),
                          ),
                        if (_retailer.imagePath != null)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 8.0,
                                right: 8.0,
                                bottom: 8.0,
                              ),
                              child: CircleAvatar(
                                radius: 100,
                                backgroundImage: NetworkImage(
                                  _configModel.apiConfig['mediaURL'] +
                                      _retailer.imagePath,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _retailer.name.toString(),
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          if (_retailer.lat != null &&
                                              _retailer.lng != null)
                                            IconButton(
                                              icon: Icon(
                                                Icons.location_on,
                                                color: Colors.pink,
                                              ),
                                              onPressed: () {
                                                String url =
                                                    'https://www.google.com/maps/?q=${_retailer.lat},${_retailer.lng}';
                                                _launchURL(url: url);
                                              },
                                            ),
                                          if (_retailer.isDone == 'Y')
                                            Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          else
                                            Icon(
                                              Icons.warning,
                                              color: Colors.red,
                                            )
                                        ],
                                      ),
                                      Text(
                                        'RETAILER',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        _retailer.address.toString(),
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'Avg. L3M: ₹ ' + _retailer.l3m.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'MTD: ₹ ' + _retailer.mtd.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_retailer.imagePath == null)
                      Column(
                        children: [
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TakeImageWidget(imagePath: ''),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: isUploadingImage
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : RaisedButton(
                                          color: Theme.of(context).primaryColor,
                                          onPressed: () async {
                                            if (_configModel.file == null) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title:
                                                      Text('Please add image'),
                                                  actions: [
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                isUploadingImage = true;
                                              });
                                              await _referencePlanModel
                                                  .addRetailerImage(
                                                      retailer: _retailer);
                                              setState(() {
                                                isUploadingImage = false;
                                              });
                                            }
                                          },
                                          child: Text(
                                            'Upload Image',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: Font.primaryFont,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    Divider(),
                    ...buttons
                        .map(
                          (_b) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: RaisedButton(
                                    color: _b['color'],
                                    onPressed: () {
                                      if (_retailer.imagePath == null) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: Text(
                                                'Please upload the image first!!!'),
                                            actions: [
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Ok'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        if (_myOrderModel.order == null) {
                                          Navigator.pushNamed(context, '/order',
                                              arguments: {
                                                'beat': _referencePlan,
                                                'outlet': _retailer,
                                                'order_type': _b['key'],
                                              });
                                        } else if (_myOrderModel
                                                .order!.retailerId ==
                                            _retailer.id) {
                                          Navigator.pushNamed(context, '/order',
                                              arguments: {
                                                'beat': _referencePlan,
                                                'outlet': _retailer,
                                                'order_type': _b['key'],
                                              });
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: Text(
                                                  'Order from another retailer is already there in the cart. Do you want to reset the order'),
                                              actions: [
                                                FlatButton(
                                                  onPressed: () {
                                                    _myOrderModel.emptyOrder();
                                                    Navigator.pop(context);
                                                    Navigator.pushNamed(
                                                        context, '/order',
                                                        arguments: {
                                                          'beat':
                                                              _referencePlan,
                                                          'outlet': _retailer,
                                                        });
                                                  },
                                                  child: Text('Yes'),
                                                ),
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.pushNamed(
                                                        context, '/beats');
                                                  },
                                                  child: Text('No'),
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      _b['title'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: Font.primaryFont,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: RaisedButton(
                    //           color: Theme.of(context).primaryColor,
                    //           onPressed: () {
                    //             if (_retailer.imagePath == null) {
                    //               showDialog(
                    //                 context: context,
                    //                 builder: (BuildContext context) =>
                    //                     AlertDialog(
                    //                   title: Text(
                    //                       'Please upload the image first!!!'),
                    //                   actions: [
                    //                     FlatButton(
                    //                       onPressed: () {
                    //                         Navigator.pop(context);
                    //                       },
                    //                       child: Text('Ok'),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               );
                    //             } else {
                    //               if (_myOrderModel.order == null) {
                    //                 Navigator.pushNamed(context, '/order',
                    //                     arguments: {
                    //                       'beat': _referencePlan,
                    //                       'outlet': _retailer,
                    //                       'order_type': 'Sales',
                    //                     });
                    //               } else if (_myOrderModel.order.retailerId ==
                    //                   _retailer.id) {
                    //                 Navigator.pushNamed(context, '/order',
                    //                     arguments: {
                    //                       'beat': _referencePlan,
                    //                       'outlet': _retailer,
                    //                       'order_type': 'Sales',
                    //                     });
                    //               } else {
                    //                 showDialog(
                    //                   context: context,
                    //                   builder: (BuildContext context) =>
                    //                       AlertDialog(
                    //                     title: Text(
                    //                         'Order from another retailer is already there in the cart. Do you want to reset the order'),
                    //                     actions: [
                    //                       FlatButton(
                    //                         onPressed: () {
                    //                           _myOrderModel.emptyOrder();
                    //                           Navigator.pop(context);
                    //                           Navigator.pushNamed(
                    //                               context, '/order',
                    //                               arguments: {
                    //                                 'beat': _referencePlan,
                    //                                 'outlet': _retailer,
                    //                               });
                    //                         },
                    //                         child: Text('Yes'),
                    //                       ),
                    //                       FlatButton(
                    //                         onPressed: () {
                    //                           Navigator.pop(context);
                    //                           Navigator.pushNamed(
                    //                               context, '/beats');
                    //                         },
                    //                         child: Text('No'),
                    //                       )
                    //                     ],
                    //                   ),
                    //                 );
                    //               }
                    //             }
                    //           },
                    //           child: Text(
                    //             'Add Offtake',
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontFamily: Font.primaryFont,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: RaisedButton(
                    //           color: Colors.cyan,
                    //           onPressed: () {
                    //             if (_retailer.imagePath == null) {
                    //               showDialog(
                    //                 context: context,
                    //                 builder: (BuildContext context) =>
                    //                     AlertDialog(
                    //                   title: Text(
                    //                       'Please upload the image first!!!'),
                    //                   actions: [
                    //                     FlatButton(
                    //                       onPressed: () {
                    //                         Navigator.pop(context);
                    //                       },
                    //                       child: Text('Ok'),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               );
                    //             } else {
                    //               if (_myOrderModel.order == null) {
                    //                 Navigator.pushNamed(context, '/order',
                    //                     arguments: {
                    //                       'beat': _referencePlan,
                    //                       'outlet': _retailer,
                    //                       'order_type': 'Stock Received',
                    //                     });
                    //               } else if (_myOrderModel.order.retailerId ==
                    //                   _retailer.id) {
                    //                 Navigator.pushNamed(context, '/order',
                    //                     arguments: {
                    //                       'beat': _referencePlan,
                    //                       'outlet': _retailer,
                    //                       'order_type': 'Stock Received',
                    //                     });
                    //               } else {
                    //                 showDialog(
                    //                   context: context,
                    //                   builder: (BuildContext context) =>
                    //                       AlertDialog(
                    //                     title: Text(
                    //                         'Order from another retailer is already there in the cart. Do you want to reset the order'),
                    //                     actions: [
                    //                       FlatButton(
                    //                         onPressed: () {
                    //                           _myOrderModel.emptyOrder();
                    //                           Navigator.pop(context);
                    //                           Navigator.pushNamed(
                    //                               context, '/order',
                    //                               arguments: {
                    //                                 'beat': _referencePlan,
                    //                                 'outlet': _retailer,
                    //                               });
                    //                         },
                    //                         child: Text('Yes'),
                    //                       ),
                    //                       FlatButton(
                    //                         onPressed: () {
                    //                           Navigator.pop(context);
                    //                           Navigator.pushNamed(
                    //                               context, '/beats');
                    //                         },
                    //                         child: Text('No'),
                    //                       )
                    //                     ],
                    //                   ),
                    //                 );
                    //               }
                    //             }
                    //           },
                    //           child: Text(
                    //             'Stocks Received',
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontFamily: Font.primaryFont,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: RaisedButton(
                    //           color: Colors.orange,
                    //           onPressed: () {
                    //             if (_retailer.imagePath == null) {
                    //               showDialog(
                    //                 context: context,
                    //                 builder: (BuildContext context) =>
                    //                     AlertDialog(
                    //                   title: Text(
                    //                       'Please upload the image first!!!'),
                    //                   actions: [
                    //                     FlatButton(
                    //                       onPressed: () {
                    //                         Navigator.pop(context);
                    //                       },
                    //                       child: Text('Ok'),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               );
                    //             } else {
                    //               if (_myOrderModel.order == null) {
                    //                 Navigator.pushNamed(context, '/order',
                    //                     arguments: {
                    //                       'beat': _referencePlan,
                    //                       'outlet': _retailer,
                    //                       'order_type': 'Stock Returned',
                    //                     });
                    //               } else if (_myOrderModel.order.retailerId ==
                    //                   _retailer.id) {
                    //                 Navigator.pushNamed(context, '/order',
                    //                     arguments: {
                    //                       'beat': _referencePlan,
                    //                       'outlet': _retailer,
                    //                       'order_type': 'Stock Returned',
                    //                     });
                    //               } else {
                    //                 showDialog(
                    //                   context: context,
                    //                   builder: (BuildContext context) =>
                    //                       AlertDialog(
                    //                     title: Text(
                    //                         'Order from another retailer is already there in the cart. Do you want to reset the order'),
                    //                     actions: [
                    //                       FlatButton(
                    //                         onPressed: () {
                    //                           _myOrderModel.emptyOrder();
                    //                           Navigator.pop(context);
                    //                           Navigator.pushNamed(
                    //                               context, '/order',
                    //                               arguments: {
                    //                                 'beat': _referencePlan,
                    //                                 'outlet': _retailer,
                    //                               });
                    //                         },
                    //                         child: Text('Yes'),
                    //                       ),
                    //                       FlatButton(
                    //                         onPressed: () {
                    //                           Navigator.pop(context);
                    //                           Navigator.pushNamed(
                    //                               context, '/beats');
                    //                         },
                    //                         child: Text('No'),
                    //                       )
                    //                     ],
                    //                   ),
                    //                 );
                    //               }
                    //             }
                    //           },
                    //           child: Text(
                    //             'Returned Stocks',
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontFamily: Font.primaryFont,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

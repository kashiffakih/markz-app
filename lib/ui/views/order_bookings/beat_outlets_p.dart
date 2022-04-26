import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/reference_plan.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:url_launcher/url_launcher.dart';

class BeatOutletsPage extends StatelessWidget {
  final arguments; // reference plan, tag

  BeatOutletsPage({@required this.arguments});

  _launchURL({@required url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget build(BuildContext context) {
    final _referencePlanModel = Provider.of<ReferencePlanModel>(context);
    final _configModel = locator<ConfigModel>();

    ReferencePlan? _referencePlan;

    if (_referencePlanModel.referencePlansLoader == false)
      _referencePlan = _referencePlanModel.referencePlans[0];

    if (_referencePlanModel.referencePlansLoader) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Location'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text(
            (_referencePlan)!.name! + ' | ' + (_referencePlan).town.toString(),
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () {},
          //   ),
          // ],
          bottom: PreferredSize(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Pending: ' +
                            (_referencePlan).unbilledOutlets.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Completed: ' +
                            (_referencePlan).billedOutlets.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(40),
          ),
        ),
        preferredSize: Size.fromHeight(80),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.backgroundImg),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: _referencePlan.retailers!
                  .map(
                    (_retailer) => InkWell(
                      onTap: () {
                        print(arguments);
                        if (arguments['tab']['name'] == 'Visitors')
                          Navigator.pushNamed(context, '/newVisitors',
                              arguments: {
                                'beat': _referencePlan,
                                'outlet': _retailer,
                              });
                        if (arguments['tab']['name'] ==
                            'Daily Activity') if (_retailer.isDone == 'Y') {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text(
                                      'Offtake for this outlet has already been updated. Do you want to replace the offtake again?',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, '/outletDetails',
                                              arguments: {
                                                'beat': _referencePlan,
                                                'outlet': _retailer,
                                              });
                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                        } else {
                          Navigator.pushNamed(context, '/outletDetails',
                              arguments: {
                                'beat': _referencePlan,
                                'outlet': _retailer,
                              });
                        }
                      },
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Text(_retailer.imagePath.toString()),
                                  if (_retailer.imagePath == null)
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
                                  if (_retailer.imagePath != null)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 8.0,
                                        right: 8.0,
                                        bottom: 8.0,
                                      ),
                                      child: CircleAvatar(
                                        radius: 32,
                                        backgroundImage: NetworkImage(
                                          _configModel.apiConfig['mediaURL'] +
                                              _retailer.imagePath,
                                        ),
                                      ),
                                    ),
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
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
                                        // Text(
                                        //   'RETAILER',
                                        //   style: TextStyle(
                                        //     color: Colors.grey,
                                        //   ),
                                        // ),
                                        // Text(
                                        //   _retailer.address.toString(),
                                        //   style: TextStyle(
                                        //     color: Colors.red,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: Center(
                              //         child: Text(
                              //           'Avg. L3M: ₹ ' + _retailer.l3m.toString(),
                              //           style: TextStyle(
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     Expanded(
                              //       child: Center(
                              //         child: Text(
                              //           'MTD: ₹ ' + _retailer.mtd.toString(),
                              //           style: TextStyle(
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

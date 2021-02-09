import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/reference_plan.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:url_launcher/url_launcher.dart';

class BeatOutletsPage extends StatelessWidget {
  final arguments; // reference plan

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

    ReferencePlan _referencePlan = _referencePlanModel.referencePlans
        .firstWhere((_rf) => _rf.id == arguments['beat'].id);

    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text((_referencePlan).name + ' | ' + (_referencePlan).town),
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
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Completed: ' +
                            (_referencePlan).billedOutlets.toString(),
                        style: TextStyle(color: Colors.white),
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
        child: SingleChildScrollView(
          child: Column(
            children: (_referencePlan)
                .retailers
                .map(
                  (_retailer) => InkWell(
                    onTap: () {
                      if (_retailer.isDone == 'Y') {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text(
                                  'Order for this outlet has already been placed. Do you want to place the order again?'),
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
                                  child: Text('Yes'),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No'),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
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
                                    backgroundImage: _retailer.imagePath == null
                                        ? AssetImage(Images.product)
                                        : NetworkImage(
                                            _configModel.apiConfig['mediaURL'] +
                                                _retailer.imagePath,
                                          ),
                                  ),
                                ),
                                // MaterialButton(
                                //   onPressed: () {},
                                //   color: Theme.of(context).primaryColor,
                                //   textColor: Colors.white,
                                //   child: Text(
                                //     'CC',
                                //     style: TextStyle(
                                //       fontSize: 20,
                                //     ),
                                //   ),
                                //   padding: EdgeInsets.all(16),
                                //   shape: CircleBorder(),
                                // ),
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
                                              _retailer.name,
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
                                        _retailer.address,
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
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

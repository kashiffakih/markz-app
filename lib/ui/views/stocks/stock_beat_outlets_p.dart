import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/reference_plan.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sales_app/core/providers/config_pr.dart';

class StockBeatOutletsPage extends StatelessWidget {
  final arguments; // reference plan

  StockBeatOutletsPage({@required this.arguments});

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

    // ReferencePlan _referencePlan = _referencePlanModel.referencePlans
    //     .firstWhere((_rf) => _rf.id == arguments['beat'].id);

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
      appBar: AppBar(
        title: Text(
            (_referencePlan)!.name! + ' | ' + (_referencePlan).town.toString()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: (_referencePlan)
                .retailers!
                .map(
                  (_retailer) => InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/stockReport', arguments: {
                        'beat': _referencePlan,
                        'outlet': _retailer,
                      });
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          // if (_retailer.lat != null &&
                                          //     _retailer.lng != null)
                                          //   IconButton(
                                          //     icon: Icon(
                                          //       Icons.location_on,
                                          //       color: Colors.pink,
                                          //     ),
                                          //     onPressed: () {
                                          //       String url =
                                          //           'https://www.google.com/maps/?q=${_retailer.lat},${_retailer.lng}';
                                          //       _launchURL(url: url);
                                          //     },
                                          //   ),
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

import 'package:flutter/material.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

class DrawerWidget extends StatelessWidget {
  final ConfigModel _configModel = locator<ConfigModel>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Row(
                  children: <Widget>[
                    if (_configModel.user.imagePath != null)
                      InkWell(
                        onTap: () {},
                        child: Hero(
                          tag: '123',
                          child: CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(
                              _configModel.apiConfig['mediaURL'] +
                                  _configModel.user.imagePath,
                            ),
                          ),
                        ),
                      ),
                    if (_configModel.user.imagePath == null)
                      InkWell(
                        onTap: () {},
                        child: Hero(
                          tag: '123',
                          child: CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage(Images.avatar),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _configModel.user.name.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _configModel.user.roles!.length > 0
                                ? _configModel.user.roles![0].name.toString()
                                : '',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
              title: Text('Home'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
              title: Text('Profile'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/attendance');
              },
              title: Text('Attendance'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/targetVsAchieved');
              },
              title: Text('Target Vs Achievement'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/saleTrends');
              },
              title: Text('Offtake Trend'),
            ),
            // ListTile(
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.pushNamed(context, '/billedOutlets');
            //   },
            //   title: Text('Billed Outlets'),
            // ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/orderDetails');
              },
              title: Text('Daily Order Summary'),
            ),
            // ListTile(
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.pushNamed(context, '/invoiceDetails');
            //   },
            //   title: Text('Invoice Details'),
            // ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/productsMaster');
              },
              title: Text('Product Master'),
            ),
            // ListTile(
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.pushNamed(context, '/schemeProducts');
            //   },
            //   title: Text('Scheme Products'),
            // ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/beats');
              },
              title: Text('Offtake Booking'),
            ),
            // ListTile(
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.pushNamed(context, '/damageStocks');
            //   },
            //   title: Text('Damage Stocks'),
            // ),
            // ListTile(
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.pushNamed(context, '/outletVisit');
            //   },
            //   title: Text('Sales Return'),
            // ),
            // ListTile(
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.pushNamed(context, '/faqs');
            //   },
            //   title: Text('FAQs'),
            // ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('NO'),
                      ),
                      FlatButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _configModel.removeLoginData();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text('YES'),
                      ),
                    ],
                  ),
                );
              },
              title: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

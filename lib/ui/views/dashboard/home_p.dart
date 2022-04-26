import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/analytics_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/notice_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'package:sales_app/ui/widgets/drawer_w.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ConfigModel _configModel = locator<ConfigModel>();

  final List<List<Map<String, dynamic>>> _menuItems = [
    [
      {
        'icon': Icons.access_alarms,
        'color': Colors.cyan[200],
        'name': 'Attendance',
        'url': '/attendance',
      },
      {
        'icon': Icons.photo_album,
        'color': Colors.green[200],
        'name': 'Training',
        'url': '/trainingVideos',
      },
      {
        'icon': Icons.people,
        'color': Colors.amber[200],
        'name': 'Visitors',
        'url': '/beatOutlets',
      },
    ],
  ];

  var format = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    final _analyticsModel = Provider.of<AnalyticsModel>(context);
    final _noticeModel = Provider.of<NoticeModel>(context);

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text(
          'BD APP',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.sync),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Syncing data...'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Ok'),
                    )
                  ],
                ),
              );
            },
          ),
        ],
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
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(Images.background),
                ),
                Card(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Hi, ${_configModel.user.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Menu",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              format.format(DateTime.now()),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _menuItems
                            .map(
                              (_menuItem) => Row(
                                children: _menuItem
                                    .map(
                                      (_item) => Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, _item['url'],
                                                arguments: {
                                                  'tab': _item,
                                                });
                                          },
                                          child: Container(
                                            // decoration: BoxDecoration(
                                            //   border: Border.all(
                                            //     color: Colors.green[300]!,
                                            //   ),
                                            // ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Icon(
                                                  _item['icon'],
                                                  color: _item['color'],
                                                  size: 25,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  _item['name'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

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
        'icon': Icons.summarize,
        'color': Colors.amber,
        'name': 'Summary',
        'url': '/monthlySummary',
      },
      // {
      //   'icon': Icons.note,
      //   'color': Colors.teal[200],
      //   'name': 'Daily Summary',
      //   'url': '/daySummary',
      // },
      {
        'icon': Icons.chat_rounded,
        'color': Colors.blue[200],
        'name': 'Trend',
        'url': '/saleTrends',
      },
      {
        'icon': Icons.auto_graph,
        'color': Colors.red[200],
        'name': 'T Vs A',
        'url': '/kpiReport',
      },
    ],
    // [
    //   {
    //     'icon': Icons.shopping_basket,
    //     'color': Colors.blue[200],
    //     'name': 'SKU Tracking',
    //     'url': '/skuBeats',
    //   },
    //   {
    //     'icon': Icons.ac_unit,
    //     'color': Colors.blue[200],
    //     'name': 'Asset Tracking',
    //     'url': '/assetBeats',
    //   },
    //   {
    //     'icon': Icons.location_history,
    //     'color': Colors.green[200],
    //     'name': 'Photos',
    //     'url': '/dailyPhotos',
    //   },
    // ],
    [
      {
        'icon': Icons.photo,
        'color': Colors.amber[200],
        'name': 'Photos',
        'url': '/dailyPhotos',
      },
      {
        'icon': Icons.local_grocery_store,
        'color': Colors.green[200],
        'name': 'Store',
        'url': '/beats',
      },
      {
        'icon': Icons.production_quantity_limits,
        'color': Colors.blue[200],
        'name': 'Stocks',
        'url': '/stockBeats',
      },
    ],
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
        'name': 'Videos',
        'url': '/trainingVideos',
      },
      {
        'icon': Icons.people,
        'color': Colors.amber[200],
        'name': 'Visitors',
        'url': '/beats',
      },
    ],
    [
      {
        'icon': Icons.poll_rounded,
        'color': Colors.blue[200],
        'name': 'Productivity',
        'url': '/productivityIndex',
      },
      {
        'icon': Icons.dashboard_customize_rounded,
        'color': Colors.red[200],
        'name': 'Customers',
        'url': '/customerDataEntryIndex',
      },
      {
        'icon': Icons.person_add_alt_outlined,
        'color': Colors.green[200],
        'name': 'Competitors',
        'url': '/competitorDataIndex',
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
        title: Text('BA Channel'),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(Images.background),
              ),
              Card(
                child: Column(
                  children: [
                    Text(
                      'Hi, ${_configModel.user.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
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
                              ),
                            ),
                          ),
                          Text(
                            format.format(DateTime.now()),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
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
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]!),
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Icon(
                                                _item['icon'],
                                                color: _item['color'],
                                                size: 30,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                _item['name'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
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
              Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Notifications",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    if (_noticeModel.notices.length > 0)
                      ..._noticeModel.notices
                          .map(
                            (_notice) => Container(
                              decoration:
                                  _noticeModel.notices.indexOf(_notice) % 2 != 0
                                      ? BoxDecoration(color: Colors.grey[400])
                                      : BoxDecoration(color: Colors.white),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            if (_notice.imagepath != null)
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                                child: CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: NetworkImage(
                                                    _configModel.apiConfig[
                                                            'mediaURL'] +
                                                        _notice.imagepath,
                                                  ),
                                                ),
                                              ),
                                            if (_notice.name != null)
                                              Text(
                                                _notice.name.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text(_notice.title.toString()),
                                              Text(_notice.description
                                                  .toString()),
                                              if (_notice.link != null)
                                                RaisedButton(
                                                  color: Colors.blue,
                                                  onPressed: () {
                                                    launch(_notice.link
                                                        .toString());
                                                  },
                                                  child: Text(
                                                    'Visit Link',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Divider(),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    Center(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.pushNamed(context, '/notifications');
                        },
                        child: Text(
                          'VIEW ALL NOTIFICATIONS',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/analytics_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/notice_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'package:sales_app/ui/widgets/drawer_w.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ConfigModel _configModel = locator<ConfigModel>();

  final List<List<Map<String, dynamic>>> _menuItems = [
    [
      {
        'icon': Icons.dashboard,
        'color': Colors.amber,
        'name': 'Dashboard',
        'url': '/dashboard',
      },
      {
        'icon': Icons.note,
        'color': Colors.teal[200],
        'name': 'Day Summary',
        'url': '/daySummary',
      },
      {
        'icon': Icons.report,
        'color': Colors.red[200],
        'name': 'KPI Report',
        'url': '/kpiReport',
      },
    ],
    [
      {
        'icon': Icons.calendar_today,
        'color': Colors.blue[200],
        'name': 'Att. Calendar',
        'url': '/attendanceCalendar',
      },
      {
        'icon': Icons.location_history,
        'color': Colors.green[200],
        'name': 'Outlet Visit',
        'url': '/beats',
      },
      {
        'icon': Icons.access_alarms,
        'color': Colors.cyan[200],
        'name': 'Attendance',
        'url': '/attendance',
      },
    ]
  ];

  var format = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    final _analyticsModel = Provider.of<AnalyticsModel>(context);
    final _noticeModel = Provider.of<NoticeModel>(context);

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Sales Register'),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text("Today's Beat"),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text("Outlet to be covered"),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/beats');
                                  },
                                  child: Center(
                                    child: Text(
                                      _analyticsModel.daySummary != null
                                          ? _analyticsModel.daySummary.beatNames
                                              .map((_beatName) => _beatName)
                                              .toString()
                                          : '-',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "-",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
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
                                              context, _item['url']);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]),
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
                    if (_noticeModel.notices != null)
                      ..._noticeModel.notices
                          .map(
                            (_notice) => Column(
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
                                                backgroundImage: _notice
                                                            .imagepath ==
                                                        null
                                                    ? AssetImage(Images.product)
                                                    : NetworkImage(
                                                        _configModel.apiConfig[
                                                                'mediaURL'] +
                                                            _notice.imagepath,
                                                      ),
                                              ),
                                            ),
                                          if (_notice.name != null)
                                            Text(
                                              _notice.name,
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
                                            Text(_notice.title),
                                            Text(_notice.description),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                              ],
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
}

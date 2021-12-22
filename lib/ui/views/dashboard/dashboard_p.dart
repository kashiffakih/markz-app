import 'package:flutter/material.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'package:sales_app/ui/widgets/drawer_w.dart';

class DashboardPage extends StatelessWidget {
  final List<List<Map<String, dynamic>>> _menuItems = [
    [
      {
        'icon': Icons.bar_chart,
        'color': Colors.amber,
        'name': 'T Vs A',
        'url': '/targetVsAchieved',
      },
      // {
      //   'icon': Icons.print,
      //   'color': Colors.teal[200],
      //   'name': 'Billed Stores',
      //   'url': '/billedOutlets',
      // },
      // {
      //   'icon': Icons.book,
      //   'color': Colors.red[200],
      //   'name': 'Invoice Details',
      //   'url': '/invoiceDetails',
      // },
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(Images.analysis),
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
            ],
          ),
        ),
      ),
    );
  }
}

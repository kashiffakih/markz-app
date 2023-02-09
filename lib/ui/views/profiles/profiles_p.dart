import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/profiles_pr.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

class ProfilesPage extends StatelessWidget {
  const ProfilesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _profileModel = Provider.of<ProfilesModel>(context);

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        title: Text('Profiles'),
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
          child: !_profileModel.isProfilesFetched
              ? Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(children: [
                    ..._profileModel.profiles
                        .map(
                          (_profile) => InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/profileId',
                                  arguments: {
                                    'profile': _profile,
                                  });
                            },
                            child: Card(
                              elevation: 20,
                              child: Container(
                                decoration: _profile.status == 'HOT'
                                    ? BoxDecoration(color: Colors.green[200])
                                    : _profile.status == 'COLD'
                                        ? BoxDecoration(color: Colors.red[200])
                                        : BoxDecoration(
                                            color: Colors.orange[200]),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.date_range),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Date: ' +
                                                      (_profile.date != null
                                                          ? _profile.date!
                                                          : ''),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.school),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Company: ' +
                                                      (_profile.companyName !=
                                                              null
                                                          ? _profile
                                                              .companyName!
                                                          : ''),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons
                                                    .production_quantity_limits),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  (_profile.productOffered !=
                                                          null
                                                      ? _profile.productOffered!
                                                      : ''),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList()
                  ]),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.add),
        backgroundColor: new Color(0xFFE57373),
        onPressed: () {
          Navigator.pushNamed(context, '/profileCreate');
        },
      ),
    );
  }
}

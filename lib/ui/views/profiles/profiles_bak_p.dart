import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/profiles_pr.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

class ProfilesBakPage extends StatelessWidget {
  const ProfilesBakPage({Key? key}) : super(key: key);

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
          child: Card(
            color: Color.fromRGBO(255, 255, 255, 0.6),
            elevation: 10,
            child: !_profileModel.isProfilesFetched
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(children: [
                      Container(
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'ID',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Date',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Description',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              'Action',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      ..._profileModel.profiles
                          .map(
                            (_profile) => Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _profile.id.toString(),
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      _profile.date != null
                                          ? _profile.date!
                                          : '',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _profile.mobile1 != null
                                              ? _profile.mobile1.toString()
                                              : '',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          _profile.email1 != null
                                              ? _profile.email1.toString()
                                              : '',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/profileId',
                                          arguments: {
                                            'profile': _profile,
                                          });
                                    },
                                    icon: Icon(
                                      Icons.arrow_right_alt_outlined,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                          .toList()
                    ]),
                  ),
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

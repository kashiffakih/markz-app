import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/daily_photo_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/core/providers/config_pr.dart';

class DailyPhotosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _dailyPhotoModel = Provider.of<DailyPhotoModel>(context);
    final _configModel = locator<ConfigModel>();

    DateFormat format = DateFormat('dd-MM-yyyy');
    String todayDate = format.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Photos | ' + todayDate),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          child: Card(
            elevation: 10,
            child: _dailyPhotoModel.dailyPhotosLoader
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: _dailyPhotoModel.dailyPhotos
                        .map(
                          (_dailyPhoto) => Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(_dailyPhoto.description),
                                    ),
                                    Container(
                                      height: 50,
                                      child: Image.network(
                                        _configModel.apiConfig['mediaURL'] +
                                            _dailyPhoto.imagePath,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.add),
        backgroundColor: new Color(0xFFE57373),
        onPressed: () {
          Navigator.pushNamed(context, '/dailyPhotosCreate');
        },
      ),
    );
  }
}

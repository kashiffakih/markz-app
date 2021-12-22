import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/daily_photo.dart';
import 'package:sales_app/core/providers/daily_photo_pr.dart';
import 'package:sales_app/ui/widgets/take_image_w.dart';

class DailyPhotosBakPage extends StatefulWidget {
  @override
  _DailyPhotosPageState createState() => _DailyPhotosPageState();
}

class _DailyPhotosPageState extends State<DailyPhotosBakPage> {
  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat('dd-MM-yyyy');
    String todayDate = format.format(DateTime.now());
    bool _isLoading = false;

    final _dailyPhotoModel = Provider.of<DailyPhotoModel>(context);

    final GlobalKey<FormState> _key = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Photos | ' + todayDate),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Display Photo From Front'),
                        ),
                        TakeImageWidget(imagePath: ''),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Lotion Category'),
                        ),
                        TakeImageWidget(imagePath: ''),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Hair Category'),
                        ),
                        TakeImageWidget(imagePath: ''),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Baby Category'),
                        ),
                        TakeImageWidget(imagePath: ''),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Competition Stocking Photo'),
                        ),
                        TakeImageWidget(imagePath: ''),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              _key.currentState!.save();
                              setState(() {
                                _isLoading = true;
                              });

                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          child: Text('Add/Update Photos'),
                        ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
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

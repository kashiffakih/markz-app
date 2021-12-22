import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/daily_photo.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/daily_photo_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/widgets/take_image_w.dart';

class DailyPhotosCreatePage extends StatefulWidget {
  @override
  _DailyPhotosCreatePageState createState() => _DailyPhotosCreatePageState();
}

class _DailyPhotosCreatePageState extends State<DailyPhotosCreatePage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool _isLoading = false;

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    String date = dateFormat.format(DateTime.now());
    final _dailyPhotoModel =
        Provider.of<DailyPhotoModel>(context, listen: false);
    final _configModel = locator<ConfigModel>();

    DailyPhoto _dailyPhoto = DailyPhoto(
      description: null,
    );

    List<String> _descriptions = [
      'Display Photo From Front',
      'Lotion Category',
      'Hair Category',
      'Baby Category',
      'Competition Stocking Photo',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Photo'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Card(
              elevation: 7,
              child: Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'Select description',
                        ),
                        value: _dailyPhoto.description,
                        items: _descriptions
                            .map(
                              (_description) => DropdownMenuItem(
                                value: _description,
                                child: Text(_description),
                              ),
                            )
                            .toList(),
                        validator: (value) {
                          if (value == null) return 'Please enter description';
                          return null;
                        },
                        onChanged: (value) {
                          _dailyPhoto.description = value;
                        },
                        onSaved: (value) {
                          _dailyPhoto.description = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Take Image'),
                          ),
                          TakeImageWidget(
                            imagePath: '',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _isLoading
                          ? Text('Saving Data...')
                          : ElevatedButton(
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  _key.currentState!.save();
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  if (_configModel.file == null)
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: Text('Please upload image'),
                                        actions: [
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      ),
                                    );
                                  else
                                    await _dailyPhotoModel.dailyPhotoCreate(
                                        dailyPhoto: _dailyPhoto);

                                  _dailyPhotoModel.getDailyPhotos(date: date);

                                  Navigator.pop(context);

                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                              child: Text('Add Photo'),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

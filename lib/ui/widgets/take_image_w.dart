import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/core/models/file.dart' as myFile;

class TakeImageWidget extends StatefulWidget {
  final String imagePath;

  TakeImageWidget({
    @required this.imagePath,
  });
  @override
  _TakeImageWidgetState createState() => _TakeImageWidgetState();
}

class _TakeImageWidgetState extends State<TakeImageWidget> {
  File _storedFile;

  @override
  Widget build(BuildContext context) {
    final _configModel = locator<ConfigModel>();

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            (widget.imagePath != null && widget.imagePath != '')
                ? Container(
                    height: 50,
                    child: Image.network(
                      _configModel.apiConfig['baseURL'] +
                          '/storage/' +
                          widget.imagePath,
                    ),
                  )
                : (_storedFile != null)
                    ? Container(
                        height: 50,
                        child: Image.file(_storedFile),
                      )
                    : Text(''),
            IconButton(
              color: Colors.blue,
              icon: Icon(Icons.camera),
              onPressed: () async {
                final imageFile = await ImagePicker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 100,
                );
                setState(() {
                  _storedFile = imageFile;
                  print(imageFile);
                  _configModel.file = myFile.File(
                    file: imageFile.path,
                    fileName: 'photo' + DateTime.now().toString() + '.jpg',
                  );
                  print(_configModel.file.toJson());
                });
              },
            ),
            // IconButton(
            //   color: Colors.blue,
            //   icon: Icon(Icons.photo),
            //   onPressed: () async {
            //     final imageFile = await ImagePicker.pickImage(
            //       source: ImageSource.gallery,
            //       imageQuality: 100,
            //     );
            //     setState(() {
            //       _storedFile = imageFile;
            //       _configModel.file = myFile.File(
            //         file: imageFile.path,
            //         fileName: 'photo' + DateTime.now().toString() + '.jpg',
            //       );
            //       print(_configModel.file.toJson());
            //     });
            //   },
            // ),
          ],
        ),
      ],
    );
  }
}

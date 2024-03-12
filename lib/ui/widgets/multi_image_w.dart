import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/providers/config_pr.dart';
import '../../locator.dart';
import 'package:sales_app/core/models/file.dart' as myFile;

class MultipleImageUploadPage extends StatefulWidget {
  @override
  State<MultipleImageUploadPage> createState() =>
      _MultipleImageUploadPageState();
}

class _MultipleImageUploadPageState extends State<MultipleImageUploadPage> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  final _configModel = locator<ConfigModel>();

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }

    setState(() {});
  }

  void removeImage(int index) {
    setState(() {
      imageFileList!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _configModel.files = [];
      imageFileList!.forEach((imageFile) {
        _configModel.files.add(
          myFile.File(
            file: imageFile.path,
            fileName: 'photo' + DateTime.now().toString() + '.jpg',
          ),
        );
      });
    });
    print("Image List Length:" + _configModel.files.length.toString());
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            selectImages();
          },
          child: Text('Select Images'),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: imageFileList!.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  children: [
                    Image.file(
                      File(imageFileList![index].path),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          removeImage(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

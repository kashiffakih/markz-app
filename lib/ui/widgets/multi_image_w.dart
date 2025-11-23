import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MultipleImageUploadPage extends StatefulWidget {
  final Function(List<String>)? onImagesSelected;
  
  const MultipleImageUploadPage({Key? key, this.onImagesSelected}) : super(key: key);
  
  @override
  State<MultipleImageUploadPage> createState() =>
      _MultipleImageUploadPageState();
}

class _MultipleImageUploadPageState extends State<MultipleImageUploadPage> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        imageFileList.addAll(selectedImages);
      });
      
      // Call the callback with the updated image paths
      if (widget.onImagesSelected != null) {
        widget.onImagesSelected!(imageFileList.map((e) => e.path).toList());
      }
    }
  }

  void removeImage(int index) {
    setState(() {
      imageFileList.removeAt(index);
    });
    
    // Call the callback with the updated image paths
    if (widget.onImagesSelected != null) {
      widget.onImagesSelected!(imageFileList.map((e) => e.path).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            selectImages();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Select Images',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Expanded(
          child: imageFileList.isEmpty
              ? Center(
                  child: Text(
                    'No images selected',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: imageFileList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(imageFileList[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              removeImage(index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
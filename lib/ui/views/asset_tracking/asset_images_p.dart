import 'package:flutter/material.dart';
import 'package:sales_app/core/models/asset.dart';
import 'package:sales_app/ui/widgets/take_image_w.dart';

class AssetImagesPage extends StatefulWidget {
  final arguments; // asset // beat // outlet

  AssetImagesPage({@required this.arguments});

  @override
  _AssetImagesPageState createState() => _AssetImagesPageState();
}

class _AssetImagesPageState extends State<AssetImagesPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.arguments);
    final Asset _asset = widget.arguments['asset'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add asset images'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Center(child: Text(_asset.assetName.toString())),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(border: Border.all()),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(child: Text('Image 1:')),
                            Expanded(child: TakeImageWidget(imagePath: '')),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all()),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(child: Text('Image 2:')),
                            Expanded(
                              child: TakeImageWidget(imagePath: ''),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all()),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(child: Text('Image 3:')),
                            Expanded(
                              child: TakeImageWidget(imagePath: ''),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all()),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(child: Text('Image 4:')),
                            Expanded(
                              child: TakeImageWidget(imagePath: ''),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

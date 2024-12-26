import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key, required this.image}) : super(key: key);
  final String image;
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: PinchZoom(
              child: Image.network(
                widget.image,
                fit: BoxFit
                    .contain, // Ensures the image fits within the container
              ),
              // Optionally, you can adjust the behavior of pinch zoom with these properties
              maxScale: 6.0, // Maximum scale for zoom
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:aadab/ui/shared/images_sh.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppPage extends StatelessWidget {
  launchUrlMethod(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update App'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  if (Platform.isAndroid)
                    Image.asset(
                      Images.logoIOS,
                      height: 150,
                    ),
                  if (Platform.isIOS)
                    Image.asset(
                      Images.logoIOS,
                      height: 150,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Play Store Link:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          // color: Colors.blue,
                          onPressed: () {
                            launchUrl(Uri.parse(
                                'https://play.google.com/store/apps/details?id=org.pms.mamaearth'));
                          },
                          child: Text(
                            'Visit Store',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'App Store Link:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          // color: Colors.green,
                          onPressed: () {
                            launchUrl(Uri.parse(
                                'https://apps.apple.com/us/app/ba-channel/id1586774436'));
                          },
                          child: Text(
                            'Visit Store',
                            style: TextStyle(color: Colors.white),
                          ),
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
    );
  }
}

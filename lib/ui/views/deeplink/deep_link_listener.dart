import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:aadab/ui/views/home/home_p.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeepLinkListener extends StatefulWidget {
  const DeepLinkListener({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<DeepLinkListener> createState() => _DeepLinkListenerState();
}

class _DeepLinkListenerState extends State<DeepLinkListener> {
  @override
  void initState() {
    // TODO: implement initState

    final appLinks = AppLinks(); // AppLinks is singleton

    // Handle initial link (Cold start)
    appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });

    // Subscribe to all events (Stream)
    appLinks.uriLinkStream.listen((uri) {
      log('URI: ${uri.toString()}');
      _handleDeepLink(uri);
    });

    super.initState();
  }

  void _handleDeepLink(Uri uri) async {
    if (uri.queryParameters.containsKey('referral_code')) {
      final code = uri.queryParameters['referral_code'];
      if (code != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pending_referral_code', code);
      }
    }

    if (uri.pathSegments.isNotEmpty) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
      // ... logic for other path segments can remain or be updated
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

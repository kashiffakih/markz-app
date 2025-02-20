import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:aadab/ui/views/home/home_p.dart';

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

// Subscribe to all events (initial link and further)
    final sub = appLinks.uriLinkStream.listen((uri) {
      log('URI: ${uri.toString()}');
      if (uri.pathSegments.isNotEmpty) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage()));
        final id = uri.pathSegments.lastOrNull;
        if (id != null && int.tryParse(id) != null) {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => O(bookId: id)));
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

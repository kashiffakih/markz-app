import 'package:flutter/material.dart';

class AllPagesPage extends StatelessWidget {
  const AllPagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _pages = [
      {'name': 'Splash Page', 'url': '/splashPage'},
      {'name': 'Splash 2 Page', 'url': '/splash2Page'},
      {'name': 'Login Page', 'url': '/loginPage'},
      {'name': 'Register Page', 'url': '/registerPage'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('All Pages'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _pages
                .map((_page) => ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, _page['url']);
                      },
                      child: Text(
                        _page['name'],
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

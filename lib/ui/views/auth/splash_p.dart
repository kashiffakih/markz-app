import 'package:flutter/material.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: SizedBox(
                    width: 200,
                    height: 300,
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                ),
                Text(
                  'Loading...',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    color: Color(0xff000000),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Color(0xffd9d9d9),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: LinearProgressIndicator(
                      color: Color(0xff232323),
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

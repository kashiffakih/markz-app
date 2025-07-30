import 'package:aadab/ui/views/profile/orders_p.dart';
import 'package:flutter/material.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/homePage');
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SUCCESS!',
                    textAlign: TextAlign.center,
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff303030),
                    ),
                  ),
                  Image.asset(
                    'assets/images/graphics.png',
                    width: 268.98,
                    height: 248.44,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your order will be delivered soon.\nThank you for choosing Aadab!',
                    textAlign: TextAlign.center,
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w500,
                      color: Color(0xff909090),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0.89, 20, 0, 0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrdersPage(isProfile: {'isProfile': false}),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: 321,
                        height: 53,
                        decoration: BoxDecoration(
                          color: Color(0xff1e1e1e),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Track You Order',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w700,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0.89, 10, 0, 0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: 321,
                        height: 53,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff000000)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Back to home',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w700,
                              color: Color(0xff1e1e1e),
                            ),
                          ),
                        ),
                      ),
                    ),
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

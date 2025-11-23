import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class FailurePage extends StatelessWidget {
  const FailurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Payment Failed',
                  textAlign: TextAlign.center,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffFF3B30),
                  ),
                ),
                Image.asset(
                  'assets/images/payment_failed.png', // Replace with your failure image
                  width: 268.98,
                  height: 248.44,
                ),
                SizedBox(height: 10),
                Text(
                  'Your payment could not be completed.\nPlease try again.',
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
                      Navigator.pushReplacementNamed(context, '/checkout');
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Container(
                      width: 321,
                      height: 53,
                      decoration: BoxDecoration(
                        color: Color(0xff1e1e1e),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Try Again',
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
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
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
    );
  }
}

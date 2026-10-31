import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class NoNetworkPage extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoNetworkPage({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // No network icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Icon(
                    Icons.wifi_off,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 30),

                // Title
                Text(
                  'No Internet Connection',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
                  ),
                ),
                SizedBox(height: 15),

                // Description
                Text(
                  'Please check your internet connection\nand try again',
                  textAlign: TextAlign.center,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 40),

                // Retry button
                if (onRetry != null)
                  ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff232323),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Retry',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 20),

                // Additional info
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'You need an active internet connection to use Markz',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
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

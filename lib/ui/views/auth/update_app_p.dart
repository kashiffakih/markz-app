import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class UpdateAppPage extends StatelessWidget {
  final Map<String, dynamic>? arguments;

  const UpdateAppPage({Key? key, this.arguments}) : super(key: key);

  Future<void> _launchStore(String url) async {
    if (url.isEmpty) return;
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = arguments ?? {};
    final String androidUrl = args['android_update_url'] ??
        'https://play.google.com/store/apps/details?id=com.crazzycode.aadab&pcampaignid=web_share';
    final String iosUrl = args['ios_update_url'] ??
        'https://apps.apple.com/app/id123456789';
    final String message = args['force_update_message'] ??
        'A new mandatory update is available. Please update the application to continue.';
    final String currentVersion = args['current_version'] ?? '';
    final String requiredVersion = args['required_version'] ?? '';

    final String targetUrl = Platform.isIOS ? iosUrl : androidUrl;

    return PopScope(
      canPop: false, // Compulsory update cannot be dismissed
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // App Branding / Logo
                Container(
                  width: 140.0.w,
                  height: 140.0.w,
                  padding: EdgeInsets.all(16.0.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF7),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEED056).withOpacity(0.25),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/aadab-logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 32.0.h),
                // Update Icon Badge
                Container(
                  padding: EdgeInsets.all(14.0.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC7B456).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.system_update_rounded,
                    size: 40.0.sp,
                    color: const Color(0xFFC7B456),
                  ),
                ),
                SizedBox(height: 20.0.h),
                // Title
                Text(
                  'Update Required',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 24.0.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 12.0.h),
                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[700]!,
                    height: 1.5,
                  ),
                ),
                if (currentVersion.isNotEmpty && requiredVersion.isNotEmpty) ...[
                  SizedBox(height: 16.0.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 8.0.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20.0.r),
                    ),
                    child: Text(
                      'Installed: v$currentVersion  •  Required: v$requiredVersion',
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                const Spacer(flex: 3),
                // Update Now Button
                SizedBox(
                  width: double.infinity,
                  height: 52.0.h,
                  child: ElevatedButton(
                    onPressed: () => _launchStore(targetUrl),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC7B456),
                      elevation: 4,
                      shadowColor: const Color(0xFFC7B456).withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Platform.isIOS ? Icons.apple : Icons.shop_two,
                          color: Colors.white,
                          size: 22.0.sp,
                        ),
                        SizedBox(width: 10.0.w),
                        Text(
                          'Update Now',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.0.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

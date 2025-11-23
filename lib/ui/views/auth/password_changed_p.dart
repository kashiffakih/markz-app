import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class PasswordChangesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Container(
          // passwordchangedWzi (318:2094)
          padding:
              EdgeInsets.fromLTRB(26.0.w, 242.0.w, 26.0.w, 146.0.w),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // successmarkdZY (318:2101)
                margin:
                    EdgeInsets.fromLTRB(0.0.w, 0.0.w, 0.0.w, 35.0.w),
                width: 100.0.w,
                height: 100.0.w,
                child: Image.asset(
                  'assets/images/successmark.png',
                  width: 100.0.w,
                  height: 100.0.w,
                ),
              ),
              Container(
                // textk8N (318:2098)
                margin:
                    EdgeInsets.fromLTRB(29.0.w, 0.0.w, 29.0.w, 40.0.w),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // passwordchangedgGv (318:2100)
                      margin: EdgeInsets.fromLTRB(
                          0.0.w, 0.0.w, 0.0.w, 12.0.w),
                      child: Text(
                        'Password Changed!',
                        textAlign: TextAlign.center,
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 28.0.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: Color(0xff1e232c),
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 195.0.w),
                      child: Text(
                        'Your password has been changed successfully.',
                        textAlign: TextAlign.center,
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13.0.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: Color(0xff8390a1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                // backtologinbuttonUCn (318:2095)
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: double.infinity,
                  height: 52.0.w,
                  decoration: BoxDecoration(
                    color: Color(0xff0f0f0f),
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                  child: Center(
                    child: Text(
                      'Back to Login',
                      textAlign: TextAlign.center,
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 15.0.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

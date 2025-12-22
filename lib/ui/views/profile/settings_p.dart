import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/user_wallet_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/profile/setting_id.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ConfigModel _configModel = locator<ConfigModel>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/profilePage');
        return false;
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFEF9), Color(0xFFFFFDF7), Colors.white],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: 80.h),
                child: Column(
                  children: [
                    // Title Header
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, '/profilePage'),
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFEED056)
                                        .withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18.sp,
                                color: const Color(0xFFEED056),
                              ),
                            ),
                          ),
                          Text(
                            'Settings',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                              color: const Color(0xFF1E232C),
                            ),
                          ),
                          // Edit Button
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SettingUpdatePage(
                                          arguments: {
                                            'user': _configModel.user!
                                          })));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEED056).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                size: 20.sp,
                                color: const Color(0xFFEED056),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Main Content
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Header
                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
                            child: Text(
                              'Personal Information',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E232C),
                              ),
                            ),
                          ),

                          // Profile Info Card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFFEED056).withOpacity(0.08),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                              border: Border.all(
                                color: const Color(0xFFEED056).withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildProfileRow(
                                  icon: Icons.person_outline_rounded,
                                  label: 'Full Name',
                                  value:
                                      _configModel.user!.firstName.toString(),
                                ),
                                Divider(height: 32.h, color: Colors.grey[100]),
                                _buildProfileRow(
                                  icon: Icons.email_outlined,
                                  label: 'Email Address',
                                  value: _configModel.user!.email.toString(),
                                ),
                                Divider(height: 32.h, color: Colors.grey[100]),
                                _buildProfileRow(
                                  icon: Icons.phone_iphone_rounded,
                                  label: 'Phone Number',
                                  value: _configModel.user!.phone.toString(),
                                ),
                                Divider(height: 32.h, color: Colors.grey[100]),
                                _buildProfileRow(
                                  icon: Icons.confirmation_number_outlined,
                                  label: 'Referral Code',
                                  value: _configModel.user!.referralCode
                                          ?.toString() ??
                                      'N/A',
                                  isLast: true,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Redeem Referral Section
                          if (_configModel.user?.referedById == null ||
                              _configModel.user?.referedById.toString() ==
                                  'null' ||
                              _configModel.user?.referedById == '')
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFEED056).withOpacity(0.1),
                                    const Color(0xFFFFC107).withOpacity(0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color:
                                      const Color(0xFFEED056).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEED056),
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        child: Icon(
                                          Icons.card_giftcard_rounded,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Have a Referral Code?',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF1E232C),
                                            ),
                                          ),
                                          Text(
                                            'Redeem it to get existing rewards',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF8391A1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          _showRedeemDialog(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFEED056),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'Redeem Now',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for profile rows
  Widget _buildProfileRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8F9),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFEED056),
            size: 22.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8391A1),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E232C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to show redeem dialog
  void _showRedeemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController referralCodeController = TextEditingController();

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Redeem Code',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E232C),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Enter your referral code below',
                  textAlign: TextAlign.center,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8391A1),
                  ),
                ),
                SizedBox(height: 24.h),
                TextField(
                  controller: referralCodeController,
                  decoration: InputDecoration(
                    hintText: 'Enter Code',
                    hintStyle: TextStyle(color: Color(0xFF8391A1)),
                    filled: true,
                    fillColor: Color(0xFFF7F8F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Color(0xFFEED056)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF8391A1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          String referralCode = referralCodeController.text;
                          if (referralCode.isNotEmpty) {
                            Navigator.pop(context); // Close input dialog
                            _processRedemption(referralCode);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter a valid code')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEED056),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          elevation: 0,
                        ),
                        child: Text(
                          'Redeem',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _processRedemption(String code) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
          child: CircularProgressIndicator(color: Color(0xFFEED056))),
    );

    try {
      Map<String, dynamic> response =
          await Provider.of<UserWalletModel>(context, listen: false)
              .mapRedeemReferralCode(code);

      Navigator.pop(context); // Close loading
      _showReferralResponseDialog(context, response);
    } catch (e) {
      Navigator.pop(context); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  // Show referral response dialog with appropriate styling
  void _showReferralResponseDialog(
      BuildContext context, Map<String, dynamic> response) {
    bool isSuccess = response['success'] == true;
    String errorType = response['error'] ?? '';

    Color backgroundColor;
    IconData iconData;
    String title;
    String message = response['message'] ?? 'Unknown error occurred';

    // Determine dialog style based on response type
    if (isSuccess) {
      backgroundColor = const Color(0xFF4CAF50);
      iconData = Icons.check_circle;
      title = 'Success!';
    } else if (errorType == 'SELF_REFERRAL_NOT_ALLOWED') {
      backgroundColor = const Color(0xFFFF9800);
      iconData = Icons.warning;
      title = 'Cannot Use Own Code';
    } else if (errorType == 'REFERRAL_ALREADY_USED') {
      backgroundColor = const Color(0xFFFF9800);
      iconData = Icons.info;
      title = 'Already Used';
    } else if (errorType == 'INVALID_REFERRAL_CODE') {
      backgroundColor = const Color(0xFFFF5252);
      iconData = Icons.error;
      title = 'Invalid Code';
    } else {
      backgroundColor = const Color(0xFFFF5252);
      iconData = Icons.error;
      title = 'Error';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    iconData,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Message
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Action Button
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // If successful, refresh the wallet data
                      if (isSuccess) {
                        Provider.of<UserWalletModel>(context, listen: false)
                            .getMyUserWallets();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isSuccess ? 'Great!' : 'OK',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

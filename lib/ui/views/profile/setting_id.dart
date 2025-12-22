import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/user.dart';
import 'package:aadab/core/providers/auth_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class SettingUpdatePage extends StatefulWidget {
  final arguments;
  const SettingUpdatePage({Key? key, required this.arguments})
      : super(key: key);

  @override
  State<SettingUpdatePage> createState() => _SettingUpdatePageState();
}

class _SettingUpdatePageState extends State<SettingUpdatePage> {
  File? galleryFile;
  final picker = ImagePicker();
  User _user = User();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _user = widget.arguments['user'];
  }

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    AuthModel _userModel = Provider.of<AuthModel>(context, listen: false);
    final ConfigModel _configModel = locator<ConfigModel>();

    return Scaffold(
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
              padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 80.h),
              child: Column(
                children: [
                  // Title Header
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 24.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFFEED056).withOpacity(0.15),
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
                          'Update Profile',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            color: const Color(0xFF1E232C),
                          ),
                        ),
                        SizedBox(width: 40.w), // Spacer for centering
                      ],
                    ),
                  ),

                  // Form Body
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Full Name'),
                        SizedBox(height: 8.h),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFFEED056).withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.1)),
                          ),
                          child: TextFormField(
                            initialValue: _user.firstName,
                            decoration: InputDecoration(
                              hintText: 'Enter your full name',
                              hintStyle: TextStyle(
                                color: Color(0xFF8391A1),
                                fontSize: 14.sp,
                                fontFamily: 'Urbanist',
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                                color: Color(0xFFEED056),
                                size: 20.sp,
                              ),
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E232C),
                            ),
                            cursorColor: const Color(0xFFEED056),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Full name cannot be empty";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _user.firstName = value;
                            },
                          ),
                        ),

                        SizedBox(height: 24.h),

                        _buildLabel('Phone Number'),
                        SizedBox(height: 8.h),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFFEED056).withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.1)),
                          ),
                          child: TextFormField(
                            initialValue: _user.phone.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: InputDecoration(
                              hintText: 'Enter your phone number',
                              hintStyle: TextStyle(
                                color: Color(0xFF8391A1),
                                fontSize: 14.sp,
                                fontFamily: 'Urbanist',
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.phone_android_rounded,
                                color: Color(0xFFEED056),
                                size: 20.sp,
                              ),
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E232C),
                            ),
                            cursorColor: const Color(0xFFEED056),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Phone cannot be empty";
                              }
                              if (value.length != 10) {
                                return "Phone number must be 10 digits";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _user.phone = value.toString();
                            },
                          ),
                        ),

                        SizedBox(height: 48.h),

                        // Update Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                setState(() {
                                  _loading = true;
                                });

                                _user.referedById =
                                    _configModel.user!.referedById ?? 0;
                                Map<String, dynamic> response = await _userModel
                                    .updateUser(updateUserData: _user.toJson());

                                if (!mounted) return;

                                if (response['success'] == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        response['message'] ??
                                            'Profile updated successfully',
                                        style:
                                            TextStyle(fontFamily: 'Urbanist'),
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  );
                                  Navigator.pushNamed(context, '/settingsPage');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        response['message'] ??
                                            'Failed to update profile',
                                        style:
                                            TextStyle(fontFamily: 'Urbanist'),
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  );
                                }
                                setState(() {
                                  _loading = false;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEED056),
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              elevation: 0,
                              shadowColor:
                                  const Color(0xFFEED056).withOpacity(0.4),
                            ),
                            child: _loading
                                ? SizedBox(
                                    height: 24.h,
                                    width: 24.h,
                                    child: const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Update Profile',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: MyGoogleFontStyle(
        fontFamily: 'Urbanist',
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF8391A1),
      ),
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}

import 'dart:io';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/auth_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class RegisterPage extends StatefulWidget {
  final argument;
  const RegisterPage({Key? key, this.argument}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  ConfigModel _configModel = locator<ConfigModel>();
  final ImagePicker _picker = ImagePicker();

  // Image files for wholesaler
  File? _visitingCardImage;
  File? _shopImage;

  bool _hasGst = false;
  String countryValue = "India";
  String stateValue = "";
  String cityValue = "";

  // Bottom sheet wholesaler form state
  bool _bsHasGst = false;
  File? _bsVisitingCardImage;
  File? _bsShopImage;
  final Map<String, dynamic> _bsWholesalerData = {
    'phone': '',
    'gst_number': '',
    'business_name': '',
    'trade_name': '',
    'address': '',
    'pincode_business': '',
    'state_business': '',
    'registration_date': '',
  };

  Map<String, dynamic> _registerData = {
    'first_name': '',
    'email': '',
    'phone': '',
    'password': '',
    'confirm_password': '',
    // Wholesaler specific fields
    'gst_number': '',
    'business_name': '',
    'trade_name': '',
    'address': '',
    'pincode_business': '',
    'state_business': '',
    'registration_date': '',
  };
  Map<String, dynamic> _loginData = {};
  bool _isLoading = false;

  bool _isValidEmail(String input) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(emailPattern).hasMatch(input);
  }

  /// Picks an image from the specified source (camera or gallery).
  Future<void> _pickImage({required bool isVisitingCard}) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 50,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      if (isVisitingCard) {
                        _visitingCardImage = File(pickedFile.path);
                      } else {
                        _shopImage = File(pickedFile.path);
                      }
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Select from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      if (isVisitingCard) {
                        _visitingCardImage = File(pickedFile.path);
                      } else {
                        _shopImage = File(pickedFile.path);
                      }
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(6, 36, 6, 80),
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Image.asset(
                              'assets/images/vector-GJ4.png',
                              height: 15,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Register',
                            textAlign: TextAlign.center,
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e232c),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Hello !',
                  textAlign: TextAlign.center,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1e232c),
                  ),
                ),
              ),
              Container(
                child: Text(
                  'Register to get started',
                  textAlign: TextAlign.center,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1e232c),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _registerKey,
                child: Column(
                  children: [
                    // Full Name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff7f8f9),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffe8ecf4)),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffe8ecf4)),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(
                              17.94.w, 16.34.w, 17.94.w, 17.66.w),
                          hintText: 'Full Name',
                          hintStyle: TextStyle(color: Color(0xff8390a1)),
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                          color: Color(0xff000000),
                        ),
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Full name cannot be empty';
                          return null;
                        },
                        onSaved: (value) {
                          _registerData['first_name'] = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10),

                    // Email
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff7f8f9),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffe8ecf4)),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffe8ecf4)),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(
                              17.94.w, 16.34.w, 17.94.w, 17.66.w),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Color(0xff8390a1)),
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                          color: Color(0xff000000),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return 'Email cannot be empty';
                          if (!_isValidEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _registerData['email'] = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10),

                    // Phone
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff7f8f9),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffe8ecf4)),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffe8ecf4)),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(
                              17.94.w, 16.34.w, 17.94.w, 17.66.w),
                          hintText: 'Phone',
                          hintStyle: TextStyle(color: Color(0xff8390a1)),
                          counterText: '',
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                          color: Color(0xff000000),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return 'Phone cannot be empty';
                          if (value.length != 10)
                            return "Phone number must be exactly 10 digits";
                          if (!RegExp(r'^[0-9]+$').hasMatch(value))
                            return "Phone number must contain only digits";
                          return null;
                        },
                        onSaved: (value) {
                          _registerData['phone'] = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10),

                    // Password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff7f8f9),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffe8ecf4)),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffe8ecf4)),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(
                              17.94.w, 16.34.w, 17.94.w, 17.66.w),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Color(0xff8390a1)),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                          color: Color(0xff000000),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return 'Password cannot be empty';
                          if (value.length < 6)
                            return 'Password must be at least 6 characters';
                          _registerData['password'] =
                              value; // Update password for comparison
                          return null;
                        },
                        onChanged: (value) {
                          _registerData['password'] = value;
                          _registerKey.currentState!
                              .validate(); // Revalidate form
                        },
                        onSaved: (value) {
                          _registerData['password'] = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    // Confirm Password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff7f8f9),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffe8ecf4)),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffe8ecf4)),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(7.66),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(
                              17.94.w, 16.34.w, 17.94.w, 17.66.w),
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: Color(0xff8390a1)),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            child: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                          color: Color(0xff000000),
                        ),
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Confirm password cannot be empty';
                          if (value.length < 6)
                            return 'Password must be at least 6 characters';
                          if (value != _registerData['password']) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _registerKey.currentState!
                              .validate(); // Revalidate form
                        },
                        onSaved: (value) {
                          _registerData['confirm_password'] = value;
                        },
                      ),
                    ),
                    // Wholesaler specific fields (shown only for Distributor role)
                    if (widget.argument?['role'] == 'Distributor') ...[
                      // Section Header
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Text(
                          'Business Details',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e232c),
                          ),
                        ),
                      ),
                      // Business Name (Always required for Wholesalers)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xfff7f8f9),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffe8ecf4)),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffe8ecf4)),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(
                                17.94.w, 16.34.w, 17.94.w, 17.66.w),
                            hintText: 'Business Name',
                            hintStyle: TextStyle(color: Color(0xff8390a1)),
                          ),
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                            color: Color(0xff000000),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Business Name is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _registerData['business_name'] = value;
                          },
                        ),
                      ),
                      SizedBox(height: 10),

                      // Trade Name (Optional)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xfff7f8f9),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffe8ecf4)),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffe8ecf4)),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(
                                17.94.w, 16.34.w, 17.94.w, 17.66.w),
                            hintText: 'Trade Name',
                            hintStyle: TextStyle(color: Color(0xff8390a1)),
                          ),
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                            color: Color(0xff000000),
                          ),
                          onSaved: (value) {
                            _registerData['trade_name'] = value;
                          },
                        ),
                      ),
                      SizedBox(height: 10),

                      // Registration Date
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: _registerData['registration_date'] ?? '',
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xfff7f8f9),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffe8ecf4)),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffe8ecf4)),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(
                                17.94.w, 16.34.w, 17.94.w, 17.66.w),
                            hintText: 'Registration Date',
                            hintStyle: TextStyle(color: Color(0xff8390a1)),
                            suffixIcon: Icon(Icons.calendar_today,
                                color: Color(0xff8390a1)),
                          ),
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                            color: Color(0xff000000),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _registerData['registration_date'] =
                                    '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),

                      // GST Checkbox
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _hasGst,
                              onChanged: (value) {
                                setState(() {
                                  _hasGst = value!;
                                  if (!_hasGst) {
                                    _registerData['gst_number'] = '';
                                  }
                                });
                              },
                              activeColor: Color(0xff1A1A1A),
                            ),
                            Text(
                              'I have GST Number',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_hasGst)
                        // GST Number
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xfff7f8f9),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffe8ecf4)),
                                borderRadius: BorderRadius.circular(7.66),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffe8ecf4)),
                                borderRadius: BorderRadius.circular(7.66),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(7.66),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(7.66),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(
                                  17.94.w, 16.34.w, 17.94.w, 17.66.w),
                              hintText: 'GST Number',
                              hintStyle: TextStyle(color: Color(0xff8390a1)),
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.25,
                              color: Color(0xff000000),
                            ),
                            validator: (value) {
                              if (_hasGst &&
                                  (value == null || value.trim().isEmpty)) {
                                return 'GST Number is required';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _registerData['gst_number'] = value;
                            },
                          ),
                        ),
                      if (_hasGst) SizedBox(height: 10),
                      // Address
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          maxLines: 3,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xfff7f8f9),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffe8ecf4)),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffe8ecf4)),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(7.66),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(
                                17.94.w, 16.34.w, 17.94.w, 17.66.w),
                            hintText: 'Business Address',
                            hintStyle: TextStyle(color: Color(0xff8390a1)),
                          ),
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                            color: Color(0xff000000),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'Address is required';
                            return null;
                          },
                          onSaved: (value) {
                            _registerData['address'] = value;
                          },
                        ),
                      ),
                      SizedBox(height: 10),

                      // Pincode and Location Section
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pincode
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xfff7f8f9),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffe8ecf4)),
                                    borderRadius: BorderRadius.circular(7.66),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffe8ecf4)),
                                    borderRadius: BorderRadius.circular(7.66),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(7.66),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(7.66),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      17.94.w, 16.34.w, 17.94.w, 17.66.w),
                                  hintText: 'Pincode',
                                  hintStyle:
                                      TextStyle(color: Color(0xff8390a1)),
                                  counterText: '',
                                ),
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                  color: Color(0xff000000),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) return 'Pincode required';
                                  if (value.length != 6)
                                    return 'Invalid pincode';
                                  return null;
                                },
                                onSaved: (value) {
                                  _registerData['pincode_business'] = value;
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            // CSC Picker for State and City
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: CSCPickerPlus(
                                layout: Layout.vertical,
                                showStates: true,
                                showCities: true,
                                flagState: CountryFlag.DISABLE,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.66),
                                  color: Color(0xfff7f8f9),
                                  border: Border.all(color: Color(0xffe8ecf4)),
                                ),
                                disabledDropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.66),
                                  color: Color(0xfff7f8f9),
                                  border: Border.all(color: Color(0xffe8ecf4)),
                                ),
                                countrySearchPlaceholder: "Search Country",
                                stateSearchPlaceholder: "Search State",
                                citySearchPlaceholder: "Search City",
                                countryDropdownLabel: "Select Country",
                                stateDropdownLabel: "Select State",
                                cityDropdownLabel: "Select City",
                                defaultCountry: CscCountry.India,
                                disableCountry: false,
                                selectedItemStyle: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff000000),
                                ),
                                dropdownHeadingStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                dropdownItemStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                dropdownDialogRadius: 10.0,
                                searchBarRadius: 10.0,
                                onCountryChanged: (value) {
                                  setState(() {
                                    countryValue = value;
                                  });
                                },
                                onStateChanged: (value) {
                                  setState(() {
                                    stateValue =
                                        value != null ? value.toString() : "";
                                    _registerData['state_business'] =
                                        stateValue;
                                    _registerData['state'] = stateValue;
                                  });
                                },
                                onCityChanged: (value) {
                                  setState(() {
                                    cityValue =
                                        value != null ? value.toString() : "";
                                    _registerData['city_business'] = cityValue;
                                    _registerData['city'] = cityValue;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Image Upload Section
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          'Upload Documents',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e232c),
                          ),
                        ),
                      ),
                      // Visiting Card Upload
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Visiting Card',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13.0.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff8390a1),
                              ),
                            ),
                            SizedBox(height: 8),
                            InkWell(
                              onTap: () => _pickImage(isVisitingCard: true),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xffe8ecf4), width: 2),
                                  color: Color(0xfff7f8f9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _visitingCardImage != null
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              _visitingCardImage!,
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _visitingCardImage = null;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.cloud_upload_outlined,
                                              color: Color(0xff8390a1),
                                              size: 28),
                                          SizedBox(width: 10),
                                          Text(
                                            'Tap to upload visiting card',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 14.0.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff8390a1),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Shop Image Upload
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shop Image',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13.0.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff8390a1),
                              ),
                            ),
                            SizedBox(height: 8),
                            InkWell(
                              onTap: () => _pickImage(isVisitingCard: false),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xffe8ecf4), width: 2),
                                  color: Color(0xfff7f8f9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _shopImage != null
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              _shopImage!,
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _shopImage = null;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.cloud_upload_outlined,
                                              color: Color(0xff8390a1),
                                              size: 28),
                                          SizedBox(width: 10),
                                          Text(
                                            'Tap to upload shop image',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 14.0.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff8390a1),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Container(
                      margin:
                          EdgeInsets.fromLTRB(20.0.w, 10.0.w, 20.0.w, 46.0.w),
                      width: double.infinity,
                      height: 52.0.w,
                      decoration: BoxDecoration(
                        color: Color(0xff0f0f0f),
                        borderRadius: BorderRadius.circular(7.6632652283.r),
                      ),
                      child: Consumer<AuthModel>(
                        builder: (context, authModel, child) => MaterialButton(
                          height: 52.0.w,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  new BorderRadius.circular(7.6632652283.w)),
                          minWidth: 0.8.sw,
                          color: Color(0xff0f0f0f),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            if (_registerKey.currentState!.validate()) {
                              _registerKey.currentState!.save();
                              _registerData['role'] = widget.argument['role'];

                              print(_registerData);
                              Map<String, dynamic> response = await authModel
                                  .register(registerData: _registerData);
                              print('Registration response: $response');
                              if (response['success'] == true) {
                                final userId = response['userId'] ??
                                    response['data']?['id'];
                                // Upload wholesaler documents if this is a Distributor
                                if (widget.argument['role'] == 'Distributor' &&
                                    userId != null) {
                                  print(
                                      'Distributor registration - userId: $userId');
                                  print(
                                      'Visiting card image: $_visitingCardImage');
                                  print('Shop image: $_shopImage');
                                  if (_visitingCardImage != null ||
                                      _shopImage != null) {
                                    print('Uploading wholesaler documents...');
                                    var uploadResponse = await authModel
                                        .uploadWholesalerDocuments(
                                      userId: userId.toString(),
                                      visitingCardImage: _visitingCardImage,
                                      shopImage: _shopImage,
                                    );
                                    print(
                                        'Document upload response: $uploadResponse');
                                  } else {
                                    print('No images to upload');
                                  }
                                }
                                // Mark user as new for welcome bonus
                                await _configModel.setNewUserFlag(true);
                                if (widget.argument['role'] == 'Distributor') {
                                  _showWholesalerPendingDialog();
                                } else {
                                  _showSuccessDialog();
                                }
                              } else if (response['error'] ==
                                  'EMAIL_ALREADY_EXISTS') {
                                _showAlreadyRegisteredDialog();
                              } else {
                                _showErrorDialog(response['message'] ??
                                    'Registration failed! Please try again.');
                              }
                            }

                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: _isLoading
                              ? SizedBox(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                  height: 20,
                                  width: 20,
                                )
                              : Text(
                                  'Sign Up',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 15.0.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Or Register with section (hidden for Distributor role)
              if (widget.argument?['role'] != 'Distributor' &&
                  widget.argument != 'Distributor') ...[
                Container(
                  margin: EdgeInsets.fromLTRB(0.0.w, 0.0.w, 12.36.w, 0.0.w),
                  child: Text(
                    'Or Register with',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12.792224884.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: Color(0xff6a707c),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: InkWell(
                    onTap: () async {
                      try {
                        // Web client ID from google-services.json (client_type: 3)
                        final googleSignIn = GoogleSignIn(
                          scopes: ['email'],
                          serverClientId:
                              '990776187523-31hv31ogtp5c4pdpf5t5f4d687ve4tct.apps.googleusercontent.com',
                        );
                        await googleSignIn.signOut();
                        final googleAccount = await googleSignIn.signIn();
                        if (googleAccount == null) {
                          return;
                        }

                        final googleAuth = await googleAccount.authentication;

                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );

                        final userCredential = await FirebaseAuth.instance
                            .signInWithCredential(credential);

                        print(userCredential.user?.email);

                        setState(() {
                          _isLoading = true;
                        });

                        String displayName = userCredential.user?.displayName ??
                            googleAccount.displayName ??
                            '';
                        String firstName = '';
                        String lastName = '';
                        if (displayName.trim().isNotEmpty) {
                          List<String> parts =
                              displayName.trim().split(RegExp(r'\s+'));
                          firstName = parts.first;
                          if (parts.length > 1) {
                            lastName = parts.sublist(1).join(' ');
                          }
                        }

                        _loginData['email'] = userCredential.user?.email;
                        _loginData['phone'] =
                            userCredential.user?.phoneNumber ?? '';
                        _loginData['first_name'] = firstName;
                        _loginData['last_name'] = lastName;
                        _loginData['is_social_login'] = true;
                        _loginData['is_social_register'] = true;
                        _loginData['social_login_name'] = "GOOGLE";
                        _loginData['role'] = widget.argument?['role'];
                        print('Google Login Data ${_loginData}');
                        var authModel =
                            Provider.of<AuthModel>(context, listen: false);

                        Map<String, dynamic> loginResponse =
                            await authModel.login(loginData: _loginData);
                        if (_configModel.isLoggedIn) {
                          // Mark as new user for welcome bonus (social registration)
                          await _configModel.setNewUserFlag(true);

                          // If wholesaler, check status and show business details form
                          if (widget.argument?['role'] == 'Distributor') {
                            final user = _configModel.user;
                            if (user?.isBlocked == 1) {
                              await FirebaseAuth.instance.signOut();
                              await GoogleSignIn().signOut();
                              await _configModel.removeLoginData();
                              setState(() => _isLoading = false);
                              _showErrorDialog(
                                  'Your wholesaler account has been blocked.\nReason: ${user?.blockedReason ?? "No reason provided"}');
                              return;
                            }
                            if (user?.isRejected == 1) {
                              await FirebaseAuth.instance.signOut();
                              await GoogleSignIn().signOut();
                              await _configModel.removeLoginData();
                              setState(() => _isLoading = false);
                              _showErrorDialog(
                                  'Your wholesaler account request has been rejected.\nReason: ${user?.rejectionReason ?? "No reason provided"}');
                              return;
                            }

                            // Check if submitted business details (business name or address)
                            bool hasSubmittedBusinessDetails =
                                (user?.businessName != null &&
                                        user!.businessName!
                                            .trim()
                                            .isNotEmpty) ||
                                    (user?.address != null &&
                                        user!.address!.trim().isNotEmpty);

                            if (!hasSubmittedBusinessDetails) {
                              setState(() => _isLoading = false);
                              _showWholesalerRequestBottomSheet(
                                userId: _configModel.user?.id?.toString() ?? '',
                                isFromGoogle: true,
                                googleName: displayName,
                                googleEmail: userCredential.user?.email ??
                                    googleAccount.email,
                              );
                              return;
                            } else if (user?.isApproved != 1) {
                              // Completed profile, but pending admin approval
                              await FirebaseAuth.instance.signOut();
                              await GoogleSignIn().signOut();
                              await _configModel.removeLoginData();
                              setState(() => _isLoading = false);
                              _showWholesalerPendingDialog();
                              return;
                            }

                            Navigator.pushReplacementNamed(
                              context,
                              '/',
                            );
                            return;
                          }

                          Navigator.pushReplacementNamed(
                            context,
                            '/',
                          );
                        } else {
                          String errorMessage =
                              loginResponse['message'] ?? 'Login failed';
                          if (loginResponse['error'] == 'ACCOUNT_BLOCKED' ||
                              errorMessage.toLowerCase().contains('blocked')) {
                            _showErrorDialog(
                                'Your wholesaler account has been blocked.\nReason: ${loginResponse['blocked_reason'] ?? "No reason provided"}');
                          } else if (loginResponse['error'] ==
                                  'ACCOUNT_REJECTED' ||
                              errorMessage.toLowerCase().contains('rejected')) {
                            _showErrorDialog(
                                'Your wholesaler account request has been rejected.\nReason: ${loginResponse['rejection_reason'] ?? "No reason provided"}');
                          } else if (loginResponse['error'] ==
                                  'EMAIL_ALREADY_EXISTS' ||
                              errorMessage
                                  .toLowerCase()
                                  .contains('already exists') ||
                              errorMessage
                                  .toLowerCase()
                                  .contains('already registered')) {
                            _showSocialLoginExistingUserDialog();
                          } else {
                            _showErrorDialog(errorMessage);
                          }
                        }
                      } catch (e) {
                        print('Social login error: $e');
                        _showErrorDialog(
                            'Failed to sign in with Google. Please try again.');
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.fromLTRB(
                          30.99.w, 15.25.w, 35.7.w, 15.25.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffe8ecf4)),
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(7.5407857895.r),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 22.28.w,
                          height: 22.28.w,
                          child: Image.asset(
                            'assets/images/googleic-3Lc.png',
                            width: 22.28.w,
                            height: 22.28.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/loginPage');
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: MyGoogleFontStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.0.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.399999912,
                      letterSpacing: 0.13.w,
                      color: Color(0xff1e232c),
                    ),
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13.0.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.399999912,
                          letterSpacing: 0.13.w,
                          color: Color(0xff1e232c),
                        ),
                      ),
                      TextSpan(
                        text: 'Login Now',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13.0.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.399999912,
                          letterSpacing: 0.13.w,
                          color: Color(0xffc9b758),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Picks an image for the wholesaler bottom sheet form
  Future<void> _bsPickImage(
      {required bool isVisitingCard,
      required StateSetter setModalState}) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 50,
                  );
                  if (pickedFile != null) {
                    setModalState(() {
                      if (isVisitingCard) {
                        _bsVisitingCardImage = File(pickedFile.path);
                      } else {
                        _bsShopImage = File(pickedFile.path);
                      }
                    });
                    setState(() {});
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Select from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                  );
                  if (pickedFile != null) {
                    setModalState(() {
                      if (isVisitingCard) {
                        _bsVisitingCardImage = File(pickedFile.path);
                      } else {
                        _bsShopImage = File(pickedFile.path);
                      }
                    });
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Show wholesaler request bottom sheet after Google sign-in
  void _showWholesalerRequestBottomSheet({
    required String userId,
    bool isFromGoogle = true,
    String? googleName,
    String? googleEmail,
  }) {
    final bsFormKey = GlobalKey<FormState>();
    bool bsLoading = false;
    TextEditingController regDateController = TextEditingController(
      text: _bsWholesalerData['registration_date'] ?? '',
    );

    bool bsObscurePassword = true;
    bool bsObscureConfirmPassword = true;
    String? bsErrorMessage;

    final user = _configModel.user;
    String resolvedGoogleFullName =
        (googleName != null && googleName.trim().isNotEmpty)
            ? googleName.trim()
            : (user != null
                ? '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim()
                : (_loginData['first_name'] ?? ''));

    String resolvedGoogleEmail =
        (googleEmail != null && googleEmail.trim().isNotEmpty)
            ? googleEmail.trim()
            : (user?.email ?? _loginData['email'] ?? '');

    String initialName = (_bsWholesalerData['first_name'] != null &&
            _bsWholesalerData['first_name'].toString().trim().isNotEmpty)
        ? _bsWholesalerData['first_name'].toString().trim()
        : resolvedGoogleFullName;

    String initialEmail = (_bsWholesalerData['email'] != null &&
            _bsWholesalerData['email'].toString().trim().isNotEmpty)
        ? _bsWholesalerData['email'].toString().trim()
        : resolvedGoogleEmail;

    TextEditingController fullNameController =
        TextEditingController(text: initialName);
    TextEditingController emailController =
        TextEditingController(text: initialEmail);

    if (isFromGoogle) {
      _bsWholesalerData['first_name'] = initialName;
      _bsWholesalerData['email'] = initialEmail;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bsContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Color(0xffDDDDDD),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFF9A825).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.store,
                              color: Color(0xFFF9A825), size: 22),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wholesaler Request',
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1e232c),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Fill in your business details to complete registration',
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff8390a1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 24, color: Color(0xffF0F0F0)),
                  // Inline error message banner
                  if (bsErrorMessage != null)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              bsErrorMessage!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setModalState(() => bsErrorMessage = null);
                            },
                            child: Icon(Icons.close,
                                color: Colors.red.shade700, size: 18),
                          ),
                        ],
                      ),
                    ),
                  // Scrollable form
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Form(
                        key: bsFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Full Name (Required)
                            _buildBsTextField(
                              hintText: 'Full Name',
                              controller: fullNameController,
                              readOnly: isFromGoogle,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Full name cannot be empty';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['first_name'] =
                                      value?.trim() ?? fullNameController.text,
                            ),
                            SizedBox(height: 10),
                            // Email (Required)
                            _buildBsTextField(
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              readOnly: isFromGoogle,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email cannot be empty';
                                }
                                if (!_isValidEmail(value.trim())) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (value) => _bsWholesalerData['email'] =
                                  value?.trim() ?? emailController.text,
                            ),
                            SizedBox(height: 10),
                            // Phone Number (Required)
                            _buildBsTextField(
                              hintText: 'Phone Number',
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (value.trim().length < 10) {
                                  return 'Please enter a valid 10-digit phone number';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['phone'] = value?.trim(),
                            ),
                            SizedBox(height: 10),
                            // Password (Required)
                            _buildBsTextField(
                              hintText: 'Password',
                              obscureText: bsObscurePassword,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    bsObscurePassword = !bsObscurePassword;
                                  });
                                },
                                child: Icon(
                                  bsObscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Color(0xff8390a1),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password cannot be empty';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                _bsWholesalerData['password'] = value;
                                return null;
                              },
                              onChanged: (value) {
                                _bsWholesalerData['password'] = value;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['password'] = value,
                            ),
                            SizedBox(height: 10),
                            // Confirm Password (Required)
                            _buildBsTextField(
                              hintText: 'Confirm Password',
                              obscureText: bsObscureConfirmPassword,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    bsObscureConfirmPassword =
                                        !bsObscureConfirmPassword;
                                  });
                                },
                                child: Icon(
                                  bsObscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Color(0xff8390a1),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm password cannot be empty';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                if (value != _bsWholesalerData['password']) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['confirm_password'] = value,
                            ),
                            SizedBox(height: 10),
                            // Business Name (Required)
                            _buildBsTextField(
                              hintText: 'Business Name',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Business Name is required';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['business_name'] = value,
                            ),
                            SizedBox(height: 10),
                            // Trade Name (Optional)
                            _buildBsTextField(
                              hintText: 'Trade Name',
                              onSaved: (value) =>
                                  _bsWholesalerData['trade_name'] = value,
                            ),
                            SizedBox(height: 10),
                            // Registration Date (Optional)
                            TextFormField(
                              readOnly: true,
                              controller: regDateController,
                              decoration: _bsInputDecoration(
                                hintText: 'Registration Date',
                                suffixIcon: Icon(Icons.calendar_today,
                                    color: Color(0xff8390a1)),
                              ),
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                                color: Color(0xff000000),
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  setModalState(() {
                                    _bsWholesalerData['registration_date'] =
                                        '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                                    regDateController.text =
                                        _bsWholesalerData['registration_date'];
                                  });
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            // GST Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: _bsHasGst,
                                  onChanged: (value) {
                                    setModalState(() {
                                      _bsHasGst = value!;
                                      if (!_bsHasGst) {
                                        _bsWholesalerData['gst_number'] = '';
                                      }
                                    });
                                  },
                                  activeColor: Color(0xff1A1A1A),
                                ),
                                Text(
                                  'I have GST Number',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff1A1A1A),
                                  ),
                                ),
                              ],
                            ),
                            if (_bsHasGst) ...[
                              _buildBsTextField(
                                hintText: 'GST Number',
                                textCapitalization:
                                    TextCapitalization.characters,
                                validator: (value) {
                                  if (_bsHasGst &&
                                      (value == null || value.trim().isEmpty)) {
                                    return 'GST Number is required';
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    _bsWholesalerData['gst_number'] = value,
                              ),
                              SizedBox(height: 10),
                            ],
                            // Address
                            _buildBsTextField(
                              hintText: 'Business Address',
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Address is required';
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['address'] = value,
                            ),
                            SizedBox(height: 10),
                            // Pincode
                            _buildBsTextField(
                              hintText: 'Pincode',
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Pincode required';
                                if (value.length != 6) return 'Invalid pincode';
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['pincode_business'] = value,
                            ),
                            SizedBox(height: 10),
                            // State & City picker
                            CSCPickerPlus(
                              layout: Layout.vertical,
                              showStates: true,
                              showCities: true,
                              flagState: CountryFlag.DISABLE,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.66),
                                color: Color(0xfff7f8f9),
                                border: Border.all(color: Color(0xffe8ecf4)),
                              ),
                              disabledDropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.66),
                                color: Color(0xfff7f8f9),
                                border: Border.all(color: Color(0xffe8ecf4)),
                              ),
                              countrySearchPlaceholder: "Search Country",
                              stateSearchPlaceholder: "Search State",
                              citySearchPlaceholder: "Search City",
                              countryDropdownLabel: "Select Country",
                              stateDropdownLabel: "Select State",
                              cityDropdownLabel: "Select City",
                              defaultCountry: CscCountry.India,
                              disableCountry: false,
                              selectedItemStyle: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff000000),
                              ),
                              dropdownHeadingStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              dropdownItemStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              dropdownDialogRadius: 10.0,
                              searchBarRadius: 10.0,
                              onCountryChanged: (value) {
                                // Country value tracked by picker
                              },
                              onStateChanged: (value) {
                                setModalState(() {
                                  _bsWholesalerData['state_business'] =
                                      value?.toString() ?? "";
                                });
                              },
                              onCityChanged: (value) {
                                // City value tracked by picker
                              },
                            ),
                            SizedBox(height: 16),
                            // Upload Documents header
                            Text(
                              'Upload Documents',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1e232c),
                              ),
                            ),
                            SizedBox(height: 10),
                            // Visiting Card
                            Text(
                              'Visiting Card',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13.0.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff8390a1),
                              ),
                            ),
                            SizedBox(height: 8),
                            InkWell(
                              onTap: () => _bsPickImage(
                                  isVisitingCard: true,
                                  setModalState: setModalState),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xffe8ecf4), width: 2),
                                  color: Color(0xfff7f8f9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _bsVisitingCardImage != null
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              _bsVisitingCardImage!,
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setModalState(() {
                                                  _bsVisitingCardImage = null;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.cloud_upload_outlined,
                                              color: Color(0xff8390a1),
                                              size: 28),
                                          SizedBox(width: 10),
                                          Text(
                                            'Tap to upload visiting card',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 14.0.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff8390a1),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            SizedBox(height: 12),
                            // Shop Image
                            Text(
                              'Shop Image',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13.0.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff8390a1),
                              ),
                            ),
                            SizedBox(height: 8),
                            InkWell(
                              onTap: () => _bsPickImage(
                                  isVisitingCard: false,
                                  setModalState: setModalState),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xffe8ecf4), width: 2),
                                  color: Color(0xfff7f8f9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _bsShopImage != null
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              _bsShopImage!,
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setModalState(() {
                                                  _bsShopImage = null;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.cloud_upload_outlined,
                                              color: Color(0xff8390a1),
                                              size: 28),
                                          SizedBox(width: 10),
                                          Text(
                                            'Tap to upload shop image',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 14.0.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff8390a1),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Submit button
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: bsLoading
                              ? null
                              : () async {
                                  if (bsFormKey.currentState!.validate()) {
                                    bsFormKey.currentState!.save();
                                    setModalState(() => bsLoading = true);

                                    try {
                                      var authModel = Provider.of<AuthModel>(
                                          context,
                                          listen: false);

                                      // Upload documents
                                      if (userId.isNotEmpty &&
                                          (_bsVisitingCardImage != null ||
                                              _bsShopImage != null)) {
                                        await authModel
                                            .uploadWholesalerDocuments(
                                          userId: userId,
                                          visitingCardImage:
                                              _bsVisitingCardImage,
                                          shopImage: _bsShopImage,
                                        );
                                      }

                                      // Update user with business details
                                      if (userId.isNotEmpty) {
                                        final updateRes =
                                            await authModel.updateUser(
                                          updateUserData: _bsWholesalerData,
                                        );

                                        if (updateRes['success'] != true) {
                                          setModalState(() {
                                            bsLoading = false;
                                            bsErrorMessage = updateRes[
                                                    'message'] ??
                                                'Failed to submit details. Please try again.';
                                          });
                                          return;
                                        }
                                      }

                                      // Close bottom sheet
                                      Navigator.of(bsContext).pop();

                                      // Logout user (wholesaler needs approval first)
                                      await FirebaseAuth.instance.signOut();
                                      await GoogleSignIn().signOut();
                                      await _configModel.removeLoginData();

                                      // Show pending approval dialog
                                      _showWholesalerPendingDialog();
                                    } catch (e) {
                                      print('Wholesaler request error: $e');
                                      setModalState(() {
                                        bsLoading = false;
                                        bsErrorMessage =
                                            'Failed to submit. Please try again.';
                                      });
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff0f0f0f),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: bsLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Submit Wholesaler Request',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 15.0.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Builds a styled text field for the wholesaler bottom sheet
  Widget _buildBsTextField({
    required String hintText,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    bool obscureText = false,
    bool readOnly = false,
    Widget? suffixIcon,
    TextEditingController? controller,
    String? initialValue,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      readOnly: readOnly,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: _bsInputDecoration(
          hintText: hintText, suffixIcon: suffixIcon, readOnly: readOnly),
      style: MyGoogleFontStyle(
        fontFamily: 'Urbanist',
        fontSize: 14.0.sp,
        fontWeight: FontWeight.w500,
        height: 1.25,
        color: readOnly ? Color(0xff8390a1) : Color(0xff000000),
      ),
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }

  /// Standard InputDecoration for the bottom sheet form
  InputDecoration _bsInputDecoration(
      {required String hintText, Widget? suffixIcon, bool readOnly = false}) {
    return InputDecoration(
      filled: true,
      fillColor: readOnly ? Color(0xffeef0f2) : Color(0xfff7f8f9),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffe8ecf4)),
        borderRadius: BorderRadius.circular(7.66),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffe8ecf4)),
        borderRadius: BorderRadius.circular(7.66),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(7.66),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(7.66),
      ),
      contentPadding: EdgeInsets.fromLTRB(17.94.w, 16.34.w, 17.94.w, 17.66.w),
      hintText: hintText,
      hintStyle: TextStyle(color: Color(0xff8390a1)),
      counterText: '',
      suffixIcon: suffixIcon,
    );
  }

  /// Show "Pending Approval" dialog after wholesaler request
  void _showWholesalerPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9A825),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.hourglass_empty,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Request Submitted!',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your wholesaler request has been submitted successfully. Please wait for admin approval. You will be notified once your account is approved and ready to use.',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_configModel.isLoggedIn) {
                        Navigator.of(context).pop();
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (route) => false);
                        }
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/loginPage',
                          (route) => false,
                          arguments: {'role': widget.argument?['role']},
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc9b758),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _configModel.isLoggedIn
                          ? 'Go to Profile'
                          : 'Back to Login',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
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

  void _showSuccessDialog() {
    final bool isWholesaler = widget.argument?['role'] == 'Distributor';

    showDialog(
      context: context,
      barrierDismissible: false,
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isWholesaler
                        ? const Color(0xFFF9A825)
                        : const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isWholesaler ? Icons.hourglass_empty : Icons.check,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isWholesaler
                      ? 'Registration Submitted!'
                      : 'Registration Successful!',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  isWholesaler
                      ? 'Your registration has been submitted successfully. Please wait for admin approval. You will be notified once your account is approved and ready to use.'
                      : 'Your account has been created successfully. You can now login with your credentials.',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_configModel.isLoggedIn) {
                        Navigator.of(context).pop();
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (route) => false);
                        }
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/loginPage',
                          (route) => false,
                          arguments: {'role': widget.argument?['role']},
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc9b758),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _configModel.isLoggedIn
                          ? 'Go to Profile'
                          : (isWholesaler
                              ? 'Back to Login'
                              : 'Continue to Login'),
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
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

  void _showErrorDialog(String message) {
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5252),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Registration Failed',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5252),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Try Again',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
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

  void _showAlreadyRegisteredDialog() {
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9800),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Already Registered!',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'An account with this email or phone number already exists. Please use different credentials or try logging in instead.',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFF9800)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: Text(
                            'Try Again',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFF9800),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/loginPage',
                                arguments: {'role': widget.argument['role']});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffc9b758),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Go to Login',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
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

  void _showSocialLoginExistingUserDialog() {
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9800),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Account Already Exists!',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'An account with this email already exists. Please login with your existing credentials or use a different Google account.',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/loginPage',
                                arguments: {'role': widget.argument['role']});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffc9b758),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Go to Login',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
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
}

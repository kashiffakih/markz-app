import 'dart:io';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  User _user = User();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  bool _hasGst = false;

  File? _visitingCardImage;
  File? _shopImage;
  final ImagePicker _picker = ImagePicker();

  // CSC Picker values
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  // Controllers for fields that need initial values
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _gstController;
  late TextEditingController _businessNameController;
  late TextEditingController _tradeNameController;
  late TextEditingController _addressController;
  late TextEditingController _pincodeController;
  late TextEditingController _registrationDateController;

  @override
  void initState() {
    super.initState();
    final ConfigModel configModel = locator<ConfigModel>();
    if (widget.arguments != null &&
        widget.arguments is Map &&
        widget.arguments['user'] != null) {
      _user = widget.arguments['user'];
    } else if (configModel.user != null) {
      _user = configModel.user!;
    } else {
      _user = User();
    }

    // Initialize GST checkbox based on existing data
    _hasGst = _user.gstNumber != null && _user.gstNumber!.isNotEmpty;

    // Initialize CSC values
    _selectedCountry = _user.nationality ?? 'India';
    _selectedState = _user.stateBusiness ?? _user.state;
    _selectedCity = _user.city;

    // Initialize controllers with existing values
    _nameController = TextEditingController(text: _user.firstName ?? '');
    _emailController = TextEditingController(text: _user.email ?? '');
    _phoneController = TextEditingController(text: _user.phone ?? '');
    _gstController = TextEditingController(text: _user.gstNumber ?? '');
    _businessNameController =
        TextEditingController(text: _user.businessName ?? '');
    _tradeNameController = TextEditingController(text: _user.tradeName ?? '');
    _addressController = TextEditingController(text: _user.address ?? '');
    _pincodeController = TextEditingController(
        text: _user.pincodeBusiness ?? _user.pincode ?? '');
    _registrationDateController =
        TextEditingController(text: _user.registrationDate ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _gstController.dispose();
    _businessNameController.dispose();
    _tradeNameController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _registrationDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthModel _userModel = Provider.of<AuthModel>(context, listen: false);
    final ConfigModel _configModel = Provider.of<ConfigModel>(context);
    bool isDistributor = _configModel.activeRole == 'Distributor';

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
                        SizedBox(width: 40.w),
                      ],
                    ),
                  ),

                  // Form Body
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name
                        _buildLabel('Full Name'),
                        SizedBox(height: 8.h),
                        _buildTextField(
                          controller: _nameController,
                          hintText: 'Enter your full name',
                          icon: Icons.person_outline_rounded,
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Full name cannot be empty";
                            return null;
                          },
                          onSaved: (value) => _user.firstName = value,
                        ),

                        SizedBox(height: 16.h),

                        // Email Address
                        _buildLabel('Email Address'),
                        SizedBox(height: 8.h),
                        _buildTextField(
                          controller: _emailController,
                          hintText: 'Email address',
                          icon: Icons.email_outlined,
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                              if (!RegExp(emailPattern).hasMatch(value.trim())) {
                                return 'Please enter a valid email address';
                              }
                            }
                            return null;
                          },
                          onSaved: (value) => _user.email = value?.trim(),
                        ),

                        SizedBox(height: 16.h),

                        // Phone Number
                        _buildLabel('Phone Number'),
                        SizedBox(height: 8.h),
                        _buildTextField(
                          controller: _phoneController,
                          hintText: 'Phone number',
                          icon: Icons.phone_android_rounded,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              if (value.trim().length < 10) {
                                return 'Please enter a valid 10-digit phone number';
                              }
                            }
                            return null;
                          },
                          onSaved: (value) => _user.phone = value?.trim(),
                        ),

                        SizedBox(height: 24.h),

                        // GST & Business Section - Only for Distributors (Wholesalers)
                        if (isDistributor) ...[
                          SizedBox(height: 24.h),
                          _buildGstCheckbox(),

                          if (_hasGst) ...[
                            SizedBox(height: 16.h),

                            // GST Number
                            _buildLabel('GST Number'),
                            SizedBox(height: 8.h),
                            _buildTextField(
                              controller: _gstController,
                              hintText: 'Enter GST Number',
                              icon: Icons.receipt_long_rounded,
                              textCapitalization: TextCapitalization.characters,
                              validator: (value) {
                                if (_hasGst && (value == null || value.isEmpty)) {
                                  return 'GST Number is required';
                                }
                                return null;
                              },
                              onSaved: (value) => _user.gstNumber = value,
                            ),
                          ],

                          SizedBox(height: 24.h),
                          _buildSectionDivider('Business Details'),
                          SizedBox(height: 16.h),

                          // Business Name
                          _buildLabel('Business Name'),
                          SizedBox(height: 8.h),
                          _buildTextField(
                            controller: _businessNameController,
                            hintText: 'Enter Business Name',
                            icon: Icons.business_rounded,
                            onSaved: (value) => _user.businessName = value,
                          ),

                          SizedBox(height: 16.h),

                          // Trade Name
                          _buildLabel('Trade Name'),
                          SizedBox(height: 8.h),
                          _buildTextField(
                            controller: _tradeNameController,
                            hintText: 'Enter Trade Name',
                            icon: Icons.store_rounded,
                            onSaved: (value) => _user.tradeName = value,
                          ),

                          SizedBox(height: 16.h),

                          // Registration Date
                          _buildLabel('Registration Date'),
                          SizedBox(height: 8.h),
                          _buildDateField(),

                          SizedBox(height: 16.h),

                          // Address Section
                          _buildSectionDivider('Address Details'),
                          SizedBox(height: 16.h),

                          // Address
                          _buildLabel('Address'),
                          SizedBox(height: 8.h),
                          _buildTextField(
                            controller: _addressController,
                            hintText: 'Enter Address',
                            icon: Icons.location_on_rounded,
                            maxLines: 3,
                            onSaved: (value) => _user.address = value,
                          ),

                          SizedBox(height: 16.h),

                          // Location (State & City)
                          _buildLabel('Location'),
                          SizedBox(height: 8.h),
                          _buildCscPicker(isDistributor: isDistributor),

                          SizedBox(height: 16.h),

                          // Pincode
                          _buildLabel('Pincode'),
                          SizedBox(height: 8.h),
                          _buildTextField(
                            controller: _pincodeController,
                            hintText: 'Enter Pincode',
                            icon: Icons.pin_drop_rounded,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            validator: (value) {
                              if (value!.isNotEmpty && value.length != 6) {
                                return 'Invalid pincode';
                              }
                              return null;
                            },
                            onSaved: (value) => _user.pincodeBusiness = value,
                          ),
                        ],

                        // Documents Section (Visiting Card & Store/Shop Image) - Only for Distributors (Wholesalers)
                        if (isDistributor) ...[
                          SizedBox(height: 24.h),
                          _buildSectionDivider('Business & Store Documents'),
                          SizedBox(height: 16.h),

                          // Visiting Card Preview & Upload
                          _buildLabel('Visiting Card'),
                          SizedBox(height: 8.h),
                          _buildImagePreview(
                            label: 'Visiting Card',
                            imagePath: _user.visitingCardPath,
                            configModel: _configModel,
                            isVisitingCard: true,
                          ),

                          SizedBox(height: 16.h),

                          // Store / Shop Image Preview & Upload
                          _buildLabel('Store / Shop Image'),
                          SizedBox(height: 8.h),
                          _buildImagePreview(
                            label: 'Store / Shop Image',
                            imagePath: _user.shopImagePath,
                            configModel: _configModel,
                            isVisitingCard: false,
                          ),
                        ],

                        SizedBox(height: 48.h),

                        // Update Button
                        _buildUpdateButton(_userModel, _configModel),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? const Color(0xFFF5F6F8) : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEED056).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          hintText: hintText,
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
          prefixIcon: Icon(icon, color: Color(0xFFEED056), size: 20.sp),
          suffixIcon: readOnly
              ? Icon(Icons.lock_outline_rounded, color: Color(0xFF8391A1), size: 18.sp)
              : null,
        ),
        style: MyGoogleFontStyle(
          fontFamily: 'Urbanist',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: readOnly ? const Color(0xFF6A707C) : const Color(0xFF1E232C),
        ),
        cursorColor: const Color(0xFFEED056),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildGstCheckbox() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEED056).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _hasGst = !_hasGst;
            if (!_hasGst) {
              _gstController.clear();
            }
          });
        },
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: _hasGst ? const Color(0xFFEED056) : Colors.transparent,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: _hasGst
                      ? const Color(0xFFEED056)
                      : const Color(0xFF8391A1),
                  width: 2,
                ),
              ),
              child: _hasGst
                  ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              'I have GST Number',
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
    );
  }

  Widget _buildDateField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEED056).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: TextFormField(
        controller: _registrationDateController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Select Registration Date',
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
          prefixIcon: Icon(Icons.calendar_today_rounded,
              color: Color(0xFFEED056), size: 20.sp),
        ),
        style: MyGoogleFontStyle(
          fontFamily: 'Urbanist',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E232C),
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
              _registrationDateController.text =
                  '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
              _user.registrationDate = _registrationDateController.text;
            });
          }
        },
      ),
    );
  }

  Widget _buildCscPicker({required bool isDistributor}) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEED056).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: CSCPickerPlus(
        layout: Layout.vertical,
        showStates: true,
        showCities: true,
        flagState: CountryFlag.DISABLE,
        currentState: _selectedState,
        currentCity: _selectedCity,
        currentCountry: _selectedCountry,
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Color(0xfff7f8f9),
          border: Border.all(color: Color(0xffe8ecf4)),
        ),
        disabledDropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
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
        disableCountry: true,
        selectedItemStyle: MyGoogleFontStyle(
          fontFamily: 'Urbanist',
          fontSize: 14.sp,
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
            _selectedCountry = value;
            _user.nationality = value;
          });
        },
        onStateChanged: (value) {
          setState(() {
            _selectedState = value;
            _user.stateBusiness = value;
            _user.state = value;
          });
        },
        onCityChanged: (value) {
          setState(() {
            _selectedCity = value;
            _user.city = value;
          });
        },
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context,
      {required bool isVisitingCard}) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isVisitingCard ? 'Select Visiting Card' : 'Select Shop Image',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E232C),
                  ),
                ),
                SizedBox(height: 20.h),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEED056).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_rounded,
                        color: Color(0xFFEED056)),
                  ),
                  title: Text(
                    'Take a Photo',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final XFile? pickedFile = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 70,
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
                  leading: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEED056).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.photo_library_rounded,
                        color: Color(0xFFEED056)),
                  ),
                  title: Text(
                    'Select from Gallery',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final XFile? pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 70,
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
          ),
        );
      },
    );
  }

  Widget _buildImagePreview({
    required String label,
    String? imagePath,
    required ConfigModel configModel,
    required bool isVisitingCard,
  }) {
    File? selectedLocalFile = isVisitingCard ? _visitingCardImage : _shopImage;

    String? imageUrl;
    if (imagePath != null && imagePath.trim().isNotEmpty) {
      Map<String, dynamic> apiConfig = configModel.apiConfig;
      String baseUrl = (apiConfig['baseURL'] ?? '')
          .toString()
          .replaceAll(RegExp(r'/api/?$'), '');
      if (baseUrl.endsWith('/')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      }

      String cleanPath = imagePath.trim().replaceAll(RegExp(r'^/+'), '');
      if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
        imageUrl = cleanPath;
      } else {
        if (cleanPath.startsWith('storage/')) {
          cleanPath = cleanPath.substring(8);
        }
        if (!cleanPath.startsWith('Aadab/')) {
          cleanPath = 'Aadab/$cleanPath';
        }
        imageUrl = '$baseUrl/storage/$cleanPath';
      }
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEED056).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          if (selectedLocalFile != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: GestureDetector(
                onTap: () => _showLocalFullImage(context, selectedLocalFile),
                child: Image.file(
                  selectedLocalFile,
                  height: 160.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _showLocalFullImage(context, selectedLocalFile),
                    icon: Icon(Icons.visibility_outlined,
                        size: 16.sp, color: const Color(0xFF1E232C)),
                    label: Text(
                      'View Image',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13.sp,
                          color: const Color(0xFF1E232C),
                          fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE8ECF4)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      minimumSize: Size(double.infinity, 40.h),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showImageSourceActionSheet(context,
                        isVisitingCard: isVisitingCard),
                    icon: Icon(Icons.upload_file_rounded,
                        size: 16.sp, color: Colors.white),
                    label: Text(
                      'Upload Image',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEED056),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      minimumSize: Size(double.infinity, 40.h),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: GestureDetector(
                onTap: () => _showFullImage(context, imageUrl!),
                child: Image.network(
                  imageUrl,
                  height: 160.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 160.h,
                      color: const Color(0xFFF7F8F9),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: const Color(0xFFEED056),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    String imgUrl = imageUrl ?? '';
                    String fallbackUrl = imgUrl;
                    if (imgUrl.contains('/storage/Aadab/')) {
                      fallbackUrl =
                          imgUrl.replaceFirst('/storage/Aadab/', '/storage/');
                    } else if (imgUrl.contains('/storage/')) {
                      fallbackUrl =
                          imgUrl.replaceFirst('/storage/', '/storage/Aadab/');
                    }
                    return Image.network(
                      fallbackUrl,
                      height: 160.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, err2, stack2) {
                        return _buildNoImagePlaceholder(label,
                            isVisitingCard: isVisitingCard);
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 12.h),
            ElevatedButton.icon(
              onPressed: () => _showImageSourceActionSheet(context,
                  isVisitingCard: isVisitingCard),
              icon: Icon(Icons.upload_file_rounded,
                  size: 16.sp, color: Colors.white),
              label: Text(
                'Upload Image',
                style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEED056),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                minimumSize: Size(double.infinity, 40.h),
              ),
            ),
          ] else ...[
            _buildNoImagePlaceholder(label, isVisitingCard: isVisitingCard),
          ],
        ],
      ),
    );
  }

  void _showLocalFullImage(BuildContext context, File localFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.file(localFile, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    String fallbackUrl = imageUrl;
    if (imageUrl.contains('/storage/Aadab/')) {
      fallbackUrl = imageUrl.replaceFirst('/storage/Aadab/', '/storage/');
    } else if (imageUrl.contains('/storage/')) {
      fallbackUrl = imageUrl.replaceFirst('/storage/', '/storage/Aadab/');
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 300.h,
                      width: 300.w,
                      color: Colors.white,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFEED056),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      fallbackUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 300.h,
                          width: 300.w,
                          color: Colors.white,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFEED056),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, err2, stack2) {
                        return Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.broken_image_rounded,
                                  size: 48, color: Colors.grey),
                              const SizedBox(height: 8),
                              const Text('Failed to load image',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoImagePlaceholder(String label,
      {required bool isVisitingCard}) {
    return InkWell(
      onTap: () =>
          _showImageSourceActionSheet(context, isVisitingCard: isVisitingCard),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8F9),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
              color: const Color(0xFFEED056).withOpacity(0.4),
              style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEED056).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_a_photo_outlined,
                color: const Color(0xFFEED056),
                size: 26.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Upload $label',
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E232C),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Tap to choose image from camera or gallery',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 12.sp,
                color: const Color(0xFF8391A1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDivider(String title) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            title,
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFEED056),
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
      ],
    );
  }

  Widget _buildUpdateButton(AuthModel userModel, ConfigModel configModel) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            setState(() {
              _loading = true;
            });

            // Set GST number if checkbox is unchecked
            if (!_hasGst) {
              _user.gstNumber = null;
            }

            _user.referedById = configModel.user?.referedById ?? 0;

            // Update user profile data
            Map<String, dynamic> response = await userModel.updateUser(
              updateUserData: _user.toJson(),
            );

            // Upload Visiting Card and/or Shop Image if selected
            if (response['success'] == true &&
                (_visitingCardImage != null || _shopImage != null)) {
              Map<String, dynamic> docResponse =
                  await userModel.uploadWholesalerDocuments(
                userId: _user.id.toString(),
                visitingCardImage: _visitingCardImage,
                shopImage: _shopImage,
              );

              if (docResponse['success'] == true &&
                  docResponse['data'] != null) {
                final data = docResponse['data'];
                if (data['visiting_card_path'] != null) {
                  _user.visitingCardPath = data['visiting_card_path'];
                  configModel.user?.visitingCardPath =
                      data['visiting_card_path'];
                }
                if (data['shop_image_path'] != null) {
                  _user.shopImagePath = data['shop_image_path'];
                  configModel.user?.shopImagePath = data['shop_image_path'];
                }
                configModel.user = configModel.user;
              }
            }

            if (!mounted) return;

            if (response['success'] == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    response['message'] ?? 'Profile updated successfully',
                    style: TextStyle(fontFamily: 'Urbanist'),
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              Navigator.pushNamed(context, '/settingsPage');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    response['message'] ?? 'Failed to update profile',
                    style: TextStyle(fontFamily: 'Urbanist'),
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
          shadowColor: const Color(0xFFEED056).withOpacity(0.4),
        ),
        child: _loading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
    );
  }
}

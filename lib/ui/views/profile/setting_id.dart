import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  // CSC Picker values
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  // Controllers for fields that need initial values
  late TextEditingController _nameController;
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
    _user = widget.arguments['user'];

    // Initialize GST checkbox based on existing data
    _hasGst = _user.gstNumber != null && _user.gstNumber!.isNotEmpty;

    // Initialize CSC values
    _selectedCountry = _user.nationality ?? 'India';
    _selectedState = _user.stateBusiness ?? _user.state;
    _selectedCity = _user.city;

    // Initialize controllers with existing values
    _nameController = TextEditingController(text: _user.firstName ?? '');
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
    final ConfigModel _configModel = locator<ConfigModel>();
    bool isDistributor = _configModel.user?.activeRole == 'Distributor';

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

                        SizedBox(height: 20.h),

                        // Phone Number
                        _buildLabel('Phone Number'),
                        SizedBox(height: 8.h),
                        _buildTextField(
                          controller: _phoneController,
                          hintText: 'Enter your phone number',
                          icon: Icons.phone_android_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) return "Phone cannot be empty";
                            if (value.length != 10)
                              return "Phone number must be 10 digits";
                            return null;
                          },
                          onSaved: (value) => _user.phone = value,
                        ),

                        SizedBox(height: 24.h),

                        // GST Section - For all users
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

                        // Distributor-specific fields
                        if (isDistributor) ...[
                          SizedBox(height: 24.h),
                          _buildSectionDivider('Business Details'),
                          SizedBox(height: 16.h),

                          if (_hasGst) ...[
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
                          ],

                          // Business Address
                          _buildLabel('Business Address'),
                          SizedBox(height: 8.h),
                          _buildTextField(
                            controller: _addressController,
                            hintText: 'Enter Business Address',
                            icon: Icons.location_on_rounded,
                            maxLines: 3,
                            onSaved: (value) => _user.address = value,
                          ),

                          SizedBox(height: 16.h),

                          // Location (State & City)
                          _buildLabel('Location'),
                          SizedBox(height: 8.h),
                          _buildCscPicker(isDistributor: true),

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

                          SizedBox(height: 24.h),
                          _buildSectionDivider('Documents'),
                          SizedBox(height: 16.h),

                          // Visiting Card Preview
                          _buildLabel('Visiting Card'),
                          SizedBox(height: 8.h),
                          _buildImagePreview(
                            label: 'Visiting Card',
                            imagePath: _user.visitingCardPath,
                            configModel: _configModel,
                          ),

                          SizedBox(height: 16.h),

                          // Shop Image Preview
                          _buildLabel('Shop Image'),
                          SizedBox(height: 8.h),
                          _buildImagePreview(
                            label: 'Shop Image',
                            imagePath: _user.shopImagePath,
                            configModel: _configModel,
                          ),
                        ],

                        // Address Section for regular users
                        if (!isDistributor) ...[
                          SizedBox(height: 24.h),
                          _buildSectionDivider('Address'),
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
                          _buildCscPicker(isDistributor: false),

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
                            onSaved: (value) => _user.pincode = value,
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
  }) {
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
        controller: controller,
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
        ),
        style: MyGoogleFontStyle(
          fontFamily: 'Urbanist',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E232C),
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
        countryDropdownLabel: _selectedCountry ?? "Select Country",
        stateDropdownLabel: _selectedState ?? "Select State",
        cityDropdownLabel: _selectedCity ?? "Select City",
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
            if (isDistributor) {
              _user.stateBusiness = value;
            }
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

  // Image preview only (no upload functionality)
  Widget _buildImagePreview({
    required String label,
    String? imagePath,
    required ConfigModel configModel,
  }) {
    String? imageUrl;
    if (imagePath != null && imagePath.isNotEmpty) {
      Map<String, dynamic> apiConfig = configModel.apiConfig;
      String baseUrl = apiConfig['baseURL'] ?? '';
      baseUrl = baseUrl.replaceAll('/api', '');
      imageUrl = '$baseUrl/storage/$imagePath';
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
      child: imageUrl != null
          ? GestureDetector(
              onTap: () => _showFullImage(context, imageUrl!),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(
                  imageUrl,
                  height: 150.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 150.h,
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
                    return _buildNoImagePlaceholder(label);
                  },
                ),
              ),
            )
          : _buildNoImagePlaceholder(label),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
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
                      child: Center(
                        child: CircularProgressIndicator(
                          color: const Color(0xFFEED056),
                        ),
                      ),
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
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoImagePlaceholder(String label) {
    return Container(
      height: 100.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: Color(0xFF8391A1),
            size: 28.sp,
          ),
          SizedBox(width: 10.w),
          Text(
            'No $label uploaded',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 14.sp,
              color: Color(0xFF8391A1),
            ),
          ),
        ],
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

            _user.referedById = configModel.user!.referedById ?? 0;

            // Update user profile data
            Map<String, dynamic> response = await userModel.updateUser(
              updateUserData: _user.toJson(),
            );

            // Image upload functionality is disabled
            // To enable, uncomment the code below and add image picker functionality
            // if (response['success'] == true && (_visitingCardImage != null || _shopImage != null)) {
            //   await userModel.uploadWholesalerDocuments(
            //     userId: _user.id.toString(),
            //     visitingCardImage: _visitingCardImage,
            //     shopImage: _shopImage,
            //   );
            // }

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

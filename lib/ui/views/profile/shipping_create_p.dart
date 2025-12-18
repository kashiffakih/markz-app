import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/user_address.dart';
import 'package:aadab/core/providers/user_address_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/profile/address_p.dart';

class ShippingCreatePage extends StatefulWidget {
  final arguments;
  const ShippingCreatePage({Key? key, this.arguments}) : super(key: key);

  @override
  State<ShippingCreatePage> createState() => _ShippingCreatePageState();
}

class _ShippingCreatePageState extends State<ShippingCreatePage> {
  UserAddress _userAddress = UserAddress(
    add1: '',
    add2: '',
    add3: "",
    city: null,
    state: null,
    nationality: 'INDIA',

    pincode: '',
    isDefault: 0,
  );
  String countryValue = "INDIA";
  String stateValue = "";
  String cityValue = "";
  String address = "";

  String selectedChip = '';
  bool isAltPhone = false;

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  // Build styled text field
  Widget _buildTextField({
    required String hintText,
    required String? initialValue,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Color(0xFFC7B456), size: 20)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Color(0xFFE8E8E8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Color(0xFFE8E8E8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Color(0xFFC7B456), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.red.shade300),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xFF9E9E9E),
            fontFamily: 'Urbanist',
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: MyGoogleFontStyle(
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color(0xff1A1A1A),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  // Build section header
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFC7B456).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFFC7B456), size: 18),
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserAddressModel _userAddressModel =
        Provider.of<UserAddressModel>(context, listen: false);

    var cartItems = [];
    var cartTotal = '';
    var couponValue = 0;
    if (widget.arguments != null) {
      cartItems = widget.arguments!['cartItems'];
      cartTotal = widget.arguments!['cartTotal'];
      couponValue = widget.arguments!['couponValue'];
    }

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Address',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Fill in your delivery details',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFD4C76A), Color(0xFFC7B456)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Address Details Section
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                                'Address Details', Icons.home_rounded),
                            SizedBox(height: 4),
                            _buildTextField(
                              hintText: 'House No, Building Name',
                              initialValue: _userAddress.add1,
                              prefixIcon: Icons.apartment_rounded,
                              onSaved: (value) => _userAddress.add1 = value,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "House No, Building name is required";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14),
                            _buildTextField(
                              hintText: 'Road, Colony, Area',
                              initialValue: _userAddress.add2,
                              prefixIcon: Icons.route_rounded,
                              onSaved: (value) => _userAddress.add2 = value,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Road, Colony, Area is required";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14),
                            _buildTextField(
                              hintText: 'District',
                              initialValue: _userAddress.add3,
                              prefixIcon: Icons.map_rounded,
                              onSaved: (value) {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "District is required";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14),
                            _buildTextField(
                              hintText: 'Landmark (Near...)',
                              initialValue: _userAddress.add3,
                              prefixIcon: Icons.place_rounded,
                              onSaved: (value) => _userAddress.add3 = value,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Landmark is required";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      // Location Section
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                                'Location', Icons.my_location_rounded),
                            SizedBox(height: 4),
                            CSCPicker(
                              layout: Layout.vertical,
                              showStates: true,
                              showCities: true,
                              flagState: CountryFlag.DISABLE,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                                border: Border.all(color: Color(0xFFE8E8E8)),
                              ),
                              disabledDropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Color(0xFFF5F5F5),
                                border: Border.all(color: Color(0xFFE8E8E8)),
                              ),
                              countrySearchPlaceholder: "Search Country",
                              stateSearchPlaceholder: "Search State",
                              citySearchPlaceholder: "Search City",
                              countryDropdownLabel: "Select Country",
                              stateDropdownLabel: "Select State",
                              cityDropdownLabel: "Select City",
                              defaultCountry: CscCountry.India,
                              disableCountry: true,
                              selectedItemStyle: TextStyle(
                                color: Color(0xFF1A1A1A),
                                fontSize: 14,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w500,
                              ),
                              dropdownHeadingStyle: TextStyle(
                                color: Color(0xFF1A1A1A),
                                fontSize: 17,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold,
                              ),
                              dropdownItemStyle: TextStyle(
                                color: Color(0xFF1A1A1A),
                                fontSize: 14,
                                fontFamily: 'Urbanist',
                              ),
                              dropdownDialogRadius: 16.0,
                              searchBarRadius: 14.0,
                              onCountryChanged: (value) {
                                setState(() {
                                  countryValue = value;
                                });
                              },
                              onStateChanged: (value) {
                                setState(() {
                                  stateValue = value.toString();
                                  _userAddress.state = stateValue;
                                });
                              },
                              onCityChanged: (value) {
                                setState(() {
                                  cityValue = value.toString();
                                  _userAddress.city = cityValue;
                                });
                              },
                            ),
                            SizedBox(height: 14),
                            _buildTextField(
                              hintText: 'Pincode',
                              initialValue: _userAddress.pincode,
                              prefixIcon: Icons.pin_drop_rounded,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              onSaved: (value) => _userAddress.pincode = value,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Pincode is required";
                                }
                                if (value.length != 6) {
                                  return "Pincode must be 6 digits";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      // Contact Details Section
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                                'Contact Details', Icons.contact_phone_rounded),
                            SizedBox(height: 4),
                            _buildTextField(
                              hintText: 'Full Name',
                              initialValue: _userAddress.fullName,
                              prefixIcon: Icons.person_rounded,
                              onSaved: (value) => _userAddress.fullName = value,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Full name is required";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14),
                            _buildTextField(
                              hintText: 'Phone Number',
                              initialValue: _userAddress.phone,
                              prefixIcon: Icons.phone_rounded,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              onSaved: (value) => _userAddress.phone = value,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Phone number is required";
                                }
                                if (value.length != 10) {
                                  return "Phone number must be 10 digits";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14),

                            // Alternate Phone Toggle
                            if (!isAltPhone)
                              InkWell(
                                onTap: () => setState(() => isAltPhone = true),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFC7B456).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Color(0xFFC7B456).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add_circle_outline_rounded,
                                          color: Color(0xFFC7B456), size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'Add Alternate Phone',
                                        style: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFC7B456),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            if (isAltPhone) ...[
                              _buildTextField(
                                hintText: 'Alternate Phone Number',
                                initialValue: _userAddress.altPhone,
                                prefixIcon: Icons.phone_android_rounded,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                onSaved: (value) =>
                                    _userAddress.altPhone = value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Alternate phone is required";
                                  }
                                  if (value.length != 10) {
                                    return "Phone number must be 10 digits";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isAltPhone = false;
                                    _userAddress.altPhone = '';
                                  });
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.red.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.remove_circle_outline_rounded,
                                          color: Colors.red, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'Remove Alternate Phone',
                                        style: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      // Address Type Section
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                                'Address Type', Icons.label_rounded),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedChip = 'Home';
                                        _userAddress.label = selectedChip;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 16),
                                      decoration: BoxDecoration(
                                        gradient: selectedChip == 'Home'
                                            ? LinearGradient(
                                                colors: [
                                                  Color(0xFF4CAF50),
                                                  Color(0xFF66BB6A)
                                                ],
                                              )
                                            : null,
                                        color: selectedChip != 'Home'
                                            ? Color(0xFFF5F5F5)
                                            : null,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: selectedChip == 'Home'
                                              ? Colors.transparent
                                              : Color(0xFFE8E8E8),
                                        ),
                                        boxShadow: selectedChip == 'Home'
                                            ? [
                                                BoxShadow(
                                                  color: Color(0xFF4CAF50)
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 4),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.home_rounded,
                                            color: selectedChip == 'Home'
                                                ? Colors.white
                                                : Color(0xFF666666),
                                            size: 22,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Home',
                                            style: TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: selectedChip == 'Home'
                                                  ? Colors.white
                                                  : Color(0xFF666666),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedChip = 'Work';
                                        _userAddress.label = selectedChip;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 16),
                                      decoration: BoxDecoration(
                                        gradient: selectedChip == 'Work'
                                            ? LinearGradient(
                                                colors: [
                                                  Color(0xFF2196F3),
                                                  Color(0xFF42A5F5)
                                                ],
                                              )
                                            : null,
                                        color: selectedChip != 'Work'
                                            ? Color(0xFFF5F5F5)
                                            : null,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: selectedChip == 'Work'
                                              ? Colors.transparent
                                              : Color(0xFFE8E8E8),
                                        ),
                                        boxShadow: selectedChip == 'Work'
                                            ? [
                                                BoxShadow(
                                                  color: Color(0xFF2196F3)
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 4),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.work_rounded,
                                            color: selectedChip == 'Work'
                                                ? Colors.white
                                                : Color(0xFF666666),
                                            size: 22,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Work',
                                            style: TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: selectedChip == 'Work'
                                                  ? Colors.white
                                                  : Color(0xFF666666),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),
                      
                      // Set as Default Checkbox
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                             BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CheckboxListTile(
                          value: _userAddress.isDefault == 1,
                          onChanged: (value) {
                            setState(() {
                              _userAddress.isDefault = value == true ? 1 : 0;
                            });
                          },
                          activeColor: Color(0xFFC7B456),
                          title: Text(
                            "Set as Default Address",
                             style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),


                      SizedBox(height: 24),

                      // Save Button
                      GestureDetector(
                        onTap: _loading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  if (_userAddress.label == null ||
                                      _userAddress.label == '') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        title: Row(
                                          children: [
                                            Icon(Icons.warning_amber_rounded,
                                                color: Colors.orange),
                                            SizedBox(width: 10),
                                            Text(
                                              'Address Type Required',
                                              style: TextStyle(
                                                fontFamily: 'Urbanist',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: Text(
                                          'Please select whether this is a Home or Work address.',
                                          style: TextStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 14,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFC7B456),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    setState(() => _loading = true);
                                    bool response =
                                        await _userAddressModel.saveUserAddress(
                                            userAddress: _userAddress);
                                    if (response == true) {
                                      await _userAddressModel
                                          .getUserAddresses();

                                      if (widget.arguments['isShipping'] ==
                                          true) {
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddressPage(
                                              arguments: {
                                                'cartItems': cartItems,
                                                'cartTotal': cartTotal,
                                                'couponValue': couponValue,
                                                'address': [],
                                                'isAddress': widget.arguments[
                                                        'isShipping'] ??
                                                    false
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                    setState(() => _loading = false);
                                  }
                                }
                              },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFD4C76A),
                                Color(0xFFC7B456),
                                Color(0xFFAA9A40)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFC7B456).withOpacity(0.4),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _loading
                                ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.save_rounded,
                                          color: Colors.white, size: 22),
                                      SizedBox(width: 10),
                                      Text(
                                        'Save Address',
                                        style: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

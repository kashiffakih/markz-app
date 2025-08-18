// import 'package:csc_picker/csc_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:aadab/core/models/user_address.dart';
// import 'package:aadab/core/providers/user_address_pr.dart';
// import 'package:aadab/ui/shared/font_sh.dart';
// import 'package:aadab/ui/views/profile/address_p.dart';

// class ShippingUpdatePage extends StatefulWidget {
//   final arguments;
// const ShippingUpdatePage({Key? key, required this.arguments})
//     : super(key: key);

//   @override
//   State<ShippingUpdatePage> createState() => _ShippingUpdatePageState();
// }

// class _ShippingUpdatePageState extends State<ShippingUpdatePage> {
//   UserAddress _userAddress = UserAddress();

//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _userAddress =
//         UserAddress.fromJson(widget.arguments['userAddress'].toJson());
//   }

//   String selectedChip = '';
//   bool isAltPhone = false;

//   String countryValue = "INDIA";
//   String stateValue = "";
//   String cityValue = "";
//   String address = "";

//   bool _loading = false;
//   @override
//   Widget build(BuildContext context) {
//     setState(() {
//       if (stateValue == "" && cityValue == "") {
//         stateValue = widget.arguments['userAddress'].state.toString();
//         cityValue = widget.arguments['userAddress'].city.toString();
//       }
//     });
//     UserAddressModel _userAddressModel =
//         Provider.of<UserAddressModel>(context, listen: false);

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             child: Column(
//               children: [
//                 // Title
//                 Container(
//                   margin: EdgeInsets.all(20),
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Row(
//                           children: [
//                             Container(
//                               child: Image.asset(
//                                 'assets/images/vector-GJ4.png',
//                                 height: 15,
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 'Update Shipping Address',
//                                 textAlign: TextAlign.center,
//                                 style: MyGoogleFontStyle(
//                                   fontFamily: 'Urbanist',
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xff1e232c),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Body
//                 Container(
//                   padding: EdgeInsets.all(15),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: Color(0xffe3e3e3)),
//                             color: Color(0xfffbfbfb),
//                           ),
//                           child: TextFormField(
//                             initialValue: _userAddress.add1,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                               enabledBorder: InputBorder.none,
//                               errorBorder: InputBorder.none,
//                               disabledBorder: InputBorder.none,
//                               contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
//                               hintText: 'House No, Building no',
//                               hintStyle: TextStyle(color: Color(0x3f000000)),
//                             ),
//                             style: MyGoogleFontStyle(
//                               fontFamily: 'Urbanist',
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff000000),
//                             ),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return "House No, Building no Cannot be empty.";
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               _userAddress.add1 = value;
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         // Address
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: Color(0xffe3e3e3)),
//                             color: Color(0xfffbfbfb),
//                           ),
//                           child: TextFormField(
//                             initialValue: _userAddress.add2,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                               enabledBorder: InputBorder.none,
//                               errorBorder: InputBorder.none,
//                               disabledBorder: InputBorder.none,
//                               contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
//                               hintText: 'Road, Colony, Area',
//                               hintStyle: TextStyle(color: Color(0x3f000000)),
//                             ),
//                             style: MyGoogleFontStyle(
//                               fontFamily: 'Urbanist',
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff000000),
//                             ),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return "Road, Colony, Area Cannot be empty.";
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               _userAddress.add2 = value;
//                             },
//                           ),
//                         ),

//                         SizedBox(
//                           height: 20,
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: Color(0xffe3e3e3)),
//                             color: Color(0xfffbfbfb),
//                           ),
//                           child: TextFormField(
//                             initialValue: _userAddress.add3,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                               enabledBorder: InputBorder.none,
//                               errorBorder: InputBorder.none,
//                               disabledBorder: InputBorder.none,
//                               contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
//                               hintText: 'Landmark',
//                               hintStyle: TextStyle(color: Color(0x3f000000)),
//                             ),
//                             style: MyGoogleFontStyle(
//                               fontFamily: 'Urbanist',
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff000000),
//                             ),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return "Landmark Cannot be empty.";
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               _userAddress.add3 = value;
//                             },
//                           ),
//                         ),

//                         SizedBox(
//                           height: 20,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: Text('Country: India'),
//                             ),
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: Text('State: ' +
//                                   widget.arguments['userAddress'].state),
//                             ),
//                             Text('City: ' +
//                                 widget.arguments['userAddress'].city),
//                           ],
//                         ),

//                         SizedBox(
//                           height: 20,
//                         ),

//                         Container(
//                             // padding: EdgeInsets.symmetric(horizontal: 20),
//                             // height: 600,
//                             child: Column(
//                           children: [
//                             CSCPicker(
//                               layout: Layout.vertical,
//                               showStates: true,
//                               showCities: true,
//                               flagState: CountryFlag.DISABLE,
//                               dropdownDecoration: BoxDecoration(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10)),
//                                   color: Colors.white,
//                                   border: Border.all(
//                                       color: Colors.grey.shade300, width: 1)),
//                               disabledDropdownDecoration: BoxDecoration(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10)),
//                                   color: Colors.grey.shade300,
//                                   border: Border.all(
//                                       color: Colors.grey.shade300, width: 1)),
//                               countrySearchPlaceholder: "Country",
//                               stateSearchPlaceholder: "State",
//                               citySearchPlaceholder: "City",
//                               countryDropdownLabel: "Country",
//                               stateDropdownLabel: "State",
//                               cityDropdownLabel: "City",
//                               defaultCountry: CscCountry.India,
//                               disableCountry: true,
//                               selectedItemStyle: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 14,
//                               ),
//                               dropdownHeadingStyle: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.bold),
//                               dropdownItemStyle: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 14,
//                               ),
//                               dropdownDialogRadius: 10.0,
//                               searchBarRadius: 10.0,
//                               onCountryChanged: (value) {
//                                 setState(() {
//                                   countryValue = value;
//                                 });
//                               },
//                               onStateChanged: (value) {
//                                 setState(() {
//                                   stateValue = value.toString();
//                                   _userAddress.state = stateValue;
//                                 });
//                               },
//                               onCityChanged: (value) {
//                                 setState(() {
//                                   cityValue = value.toString();
//                                   _userAddress.city = cityValue;
//                                 });
//                               },
//                             ),
//                           ],
//                         )),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: Color(0xffe3e3e3)),
//                             color: Color(0xfffbfbfb),
//                           ),
//                           child: TextFormField(
//                             initialValue: _userAddress.pincode,
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                               enabledBorder: InputBorder.none,
//                               errorBorder: InputBorder.none,
//                               disabledBorder: InputBorder.none,
//                               contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
//                               hintText: 'Pincode',
//                               hintStyle: TextStyle(color: Color(0x3f000000)),
//                             ),
//                             style: MyGoogleFontStyle(
//                               fontFamily: 'Urbanist',
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff000000),
//                             ),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return "Pincode Cannot be empty.";
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               _userAddress.pincode = value;
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),

//                         // Full Name
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: Color(0xffe3e3e3)),
//                             color: Color(0xfffbfbfb),
//                           ),
//                           child: TextFormField(
//                             initialValue: _userAddress.fullName,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                               enabledBorder: InputBorder.none,
//                               errorBorder: InputBorder.none,
//                               disabledBorder: InputBorder.none,
//                               contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
//                               hintText: 'Full Name',
//                               hintStyle: TextStyle(color: Color(0x3f000000)),
//                             ),
//                             style: MyGoogleFontStyle(
//                               fontFamily: 'Urbanist',
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff000000),
//                             ),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return "Full Name Cannot be empty.";
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               _userAddress.fullName = value;
//                             },
//                           ),
//                         ),

//                         SizedBox(
//                           height: 20,
//                         ),
//                         // Phone
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: Color(0xffe3e3e3)),
//                             color: Color(0xfffbfbfb),
//                           ),
//                           child: TextFormField(
//                             initialValue: _userAddress.phone,
//                             keyboardType: TextInputType.number,
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly,
//                               LengthLimitingTextInputFormatter(10),
//                             ],
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                               enabledBorder: InputBorder.none,
//                               errorBorder: InputBorder.none,
//                               disabledBorder: InputBorder.none,
//                               contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
//                               hintText: 'Phone',
//                               hintStyle: TextStyle(color: Color(0x3f000000)),
//                             ),
//                             style: MyGoogleFontStyle(
//                               fontFamily: 'Urbanist',
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff000000),
//                             ),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return "Phone Cannot be empty.";
//                               }
//                               if (value.length != 10) {
//                                 return 'Number should be 10 digits';
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               _userAddress.phone = value;
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         if (isAltPhone == false)
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 isAltPhone = true;
//                               });
//                             },
//                             child: Row(
//                               children: [
//                                 Icon(Icons.add),
//                                 Text('Add Alternate Phone Number'),
//                               ],
//                             ),
//                           ),
//                         if (isAltPhone == true)
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(color: Color(0xffe3e3e3)),
//                               color: Color(0xfffbfbfb),
//                             ),
//                             child: TextFormField(
//                               initialValue: _userAddress.altPhone,
//                               keyboardType: TextInputType.number,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.digitsOnly,
//                                 LengthLimitingTextInputFormatter(10),
//                               ],
//                               decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 focusedBorder: InputBorder.none,
//                                 enabledBorder: InputBorder.none,
//                                 errorBorder: InputBorder.none,
//                                 disabledBorder: InputBorder.none,
//                                 contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
//                                 hintText: 'Alternate Phone Number',
//                                 hintStyle: TextStyle(color: Color(0x3f000000)),
//                               ),
//                               style: MyGoogleFontStyle(
//                                 fontFamily: 'Urbanist',
//                                 fontWeight: FontWeight.w500,
//                                 color: Color(0xff000000),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter a phone number';
//                                 }
//                                 if (value.length != 10) {
//                                   return 'Number should be 10 digits';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _userAddress.altPhone = value!;
//                               },
//                             ),
//                           ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         if (isAltPhone == true)
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 isAltPhone = false;
//                                 _userAddress.altPhone = '';
//                               });
//                             },
//                             child: Row(
//                               children: [
//                                 Icon(Icons.remove),
//                                 Text('Remove Alternate Phone Number'),
//                               ],
//                             ),
//                           ),
//                         if (isAltPhone == true)
//                           SizedBox(
//                             height: 20,
//                           ),

//                         Wrap(
//                           spacing: 8.0,
//                           children: [
//                             ChoiceChip(
//                               selected: _userAddress.label == 'Home',
//                               onSelected: (bool selected) {
//                                 setState(() {
//                                   selectedChip = selected ? 'Home' : '';
//                                   _userAddress.label = selectedChip;
//                                 });
//                               },
//                               selectedColor: Colors.green,
//                               label: SizedBox(
//                                 width: 80,
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.home),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Text('Home'),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             ChoiceChip(
//                               selected: _userAddress.label == 'Work',
//                               onSelected: (bool selected) {
//                                 setState(() {
//                                   selectedChip = selected ? 'Work' : '';
//                                   _userAddress.label = selectedChip;
//                                 });
//                               },
//                               selectedColor: Colors.blue,
//                               label: SizedBox(
//                                 width: 80,
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.work),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Text('Work'),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             // ChoiceChip(
//                             //   selected: selectedChip == 'Other',
//                             //   onSelected: (bool selected) {
//                             //     setState(() {
//                             //       selectedChip = selected ? 'Other' : '';
//                             //       _userAddress.label = selectedChip;
//                             //     });
//                             //   },
//                             //   selectedColor: Colors.orange,
//                             //   label: Text('Other'),
//                             // ),
//                             // Add more ChoiceChip widgets here as needed
//                           ],
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),

//                         // Save address
//                         Container(
//                           // primaryXwC (318:2628)
//                           margin: EdgeInsets.fromLTRB(5, 0, 6.34, 0),
//                           child: TextButton(
//                             onPressed: () async {
//                               if (_formKey.currentState!.validate()) {
//                                 _formKey.currentState!.save();

//                                 if (_userAddress.label == null ||
//                                     _userAddress.label == '') {
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) =>
//                                         AlertDialog(
//                                       title:
//                                           Text('Please select address type.'),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: Text('Ok'),
//                                         )
//                                       ],
//                                     ),
//                                   );
//                                 } else {
//                                   setState(() {
//                                     _loading = true;
//                                   });
//                                   print('city : ${_userAddress.city}');
//                                   print('state : ${_userAddress.state}');

//                                   _userAddress.city = _userAddress.city != null
//                                       ? _userAddress.city.toString()
//                                       : widget.arguments['userAddress'].city
//                                           .toString();
//                                   _userAddress.state = _userAddress.state !=
//                                           null
//                                       ? _userAddress.state.toString()
//                                       : widget.arguments['userAddress'].state
//                                           .toString();
//                                   print(_userAddress.city);
//                                   bool response =
//                                       await _userAddressModel.updateUserAddress(
//                                           userAddress: _userAddress);
//                                   if (response == true) {
//                                     // Navigator.of(context).pop();
//                                     Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 AddressPage(arguments: {
//                                                   'cartItems': [],
//                                                   'cartTotal': '',
//                                                   'couponValue': 0,
//                                                   'isAddress': false,
//                                                 })));
//                                   }
//                                   setState(() {
//                                     _loading = false;
//                                   });
//                                 }
//                               }
//                             },
//                             style: TextButton.styleFrom(
//                               padding: EdgeInsets.zero,
//                             ),
//                             child: Container(
//                               width: double.infinity,
//                               height: 53,
//                               decoration: BoxDecoration(
//                                 color: Color(0xff1e1e1e),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Center(
//                                 child: _loading
//                                     ? SizedBox(
//                                         child: CircularProgressIndicator(
//                                           backgroundColor: Colors.white,
//                                         ),
//                                         height: 20,
//                                         width: 20,
//                                       )
//                                     : Text(
//                                         'Update address',
//                                         textAlign: TextAlign.center,
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontSize: 15.1428556442,
//                                           fontWeight: FontWeight.w700,
//                                           height: 1.4999999685,
//                                           color: Color(0xffffffff),
//                                         ),
//                                       ),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       // bottomNavigationBar: BottomNavigationBar(
//       //   elevation: 10,
//       //   iconSize: 30,
//       //   type: BottomNavigationBarType.fixed,
//       //   backgroundColor: Colors.white,
//       //   selectedItemColor: Colors.black,
//       //   unselectedItemColor: Colors.black,
//       //   selectedFontSize: 14,
//       //   unselectedFontSize: 14,
//       //   onTap: (value) async {
//       //     if (value == 0) {
//       //       Navigator.pushNamed(context, '/homePage');
//       //     }
//       //     if (value == 1) {
//       //       Navigator.pushNamed(context, '/wishlistPage');
//       //     }

//       //     if (value == 2) {
//       //       Map<String, dynamic> _CartData = {
//       //         'kindOfFlower': '',
//       //         'flavour': '',
//       //         'writeOnCake': '',
//       //         'pack': ''
//       //       };
//       //       await _addToCartModel.getAddToCart('', '', _CartData);
//       //       Navigator.pushNamed(context, '/cartPage');
//       //     }
//       //     if (value == 3) {
//       //       Navigator.pushNamed(context, '/profilePage');
//       //     }
//       //   },
//       //   items: const [
//       //     BottomNavigationBarItem(
//       //       label: 'Home',
//       //       icon: Iconoir(Iconoir.home_simple),
//       //       // icon: Icon(DonIcons.wap_home, size: 23),
//       //     ),
//       //     BottomNavigationBarItem(label: 'Saved', icon: Iconoir(Iconoir.heart)),
//       //     BottomNavigationBarItem(
//       //       label: 'Cart',
//       //       icon: Iconoir(Iconoir.shopping_bag),
//       //     ),
//       //     BottomNavigationBarItem(
//       //       label: 'Profile',
//       //       icon: Icon(
//       //         DonIcons.user_o,
//       //         size: 23,
//       //       ),
//       //     ),
//       //   ],
//       // ),
//     );
//   }
// }
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/user_address.dart';
import 'package:aadab/core/providers/user_address_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/profile/address_p.dart';

class ShippingUpdatePage extends StatefulWidget {
  final arguments;

  const ShippingUpdatePage({Key? key, required this.arguments})
      : super(key: key);

  @override
  State<ShippingUpdatePage> createState() => _ShippingUpdatePageState();
}

class _ShippingUpdatePageState extends State<ShippingUpdatePage> {
  late UserAddress _userAddress;
  final _formKey = GlobalKey<FormState>();
  String selectedChip = '';
  bool isAltPhone = false;
  String countryValue = "India";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userAddress =
        UserAddress.fromJson(widget.arguments['userAddress'].toJson());
    selectedChip = _userAddress.label ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final userAddressModel =
        Provider.of<UserAddressModel>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (widget.arguments['isAddress'] == true) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddressPage(
                arguments: {
                  'cartItems': widget.arguments['cartItems'] ?? [],
                  'cartTotal': widget.arguments['cartTotal'] ?? '',
                  'couponValue': widget.arguments['couponValue'] ?? 0,
                  'isAddress': widget.arguments['isAddress'] ?? false,
                },
              ),
            ),
          );
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildForm(userAddressModel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: Image.asset(
            'assets/images/vector-GJ4.png',
            height: 15,
          ),
          onPressed: () {
            if (widget.arguments['isAddress'] == true) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressPage(
                    arguments: {
                      'cartItems': widget.arguments['cartItems'] ?? [],
                      'cartTotal': widget.arguments['cartTotal'] ?? '',
                      'couponValue': widget.arguments['couponValue'] ?? 0,
                      'isAddress': widget.arguments['isAddress'] ?? false,
                    },
                  ),
                ),
              );
            }
          },
        ),
        Expanded(
          child: Text(
            'Update Shipping Address',
            textAlign: TextAlign.center,
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E232C),
            ),
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildForm(UserAddressModel userAddressModel) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            initialValue: _userAddress.add1,
            hintText: 'House No, Building No',
            validator: (value) =>
                value!.isEmpty ? 'House No cannot be empty' : null,
            onSaved: (value) => _userAddress.add1 = value,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            initialValue: _userAddress.add2,
            hintText: 'Road, Colony, Area',
            validator: (value) =>
                value!.isEmpty ? 'Road, Colony, Area cannot be empty' : null,
            onSaved: (value) => _userAddress.add2 = value,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            initialValue: _userAddress.add3,
            hintText: 'Landmark',
            validator: (value) =>
                value!.isEmpty ? 'Landmark cannot be empty' : null,
            onSaved: (value) => _userAddress.add3 = value,
          ),
          const SizedBox(height: 16),
          _buildCSCPicker(),
          const SizedBox(height: 16),
          _buildTextField(
            initialValue: _userAddress.pincode,
            hintText: 'Pincode',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (value) {
              if (value!.isEmpty) return 'Pincode cannot be empty';
              if (value.length != 6) return 'Pincode must be 6 digits';
              return null;
            },
            onSaved: (value) => _userAddress.pincode = value,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            initialValue: _userAddress.fullName,
            hintText: 'Full Name',
            validator: (value) =>
                value!.isEmpty ? 'Full Name cannot be empty' : null,
            onSaved: (value) => _userAddress.fullName = value,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            initialValue: _userAddress.phone,
            hintText: 'Phone',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value!.isEmpty) return 'Phone cannot be empty';
              if (value.length != 10) return 'Phone must be 10 digits';
              return null;
            },
            onSaved: (value) => _userAddress.phone = value,
          ),
          const SizedBox(height: 16),
          _buildAlternatePhoneField(),
          const SizedBox(height: 16),
          _buildAddressTypeChips(),
          const SizedBox(height: 24),
          _buildSaveButton(userAddressModel),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String? initialValue,
    required String hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE3E3E3)),
        color: const Color(0xFFFBFBFB),
      ),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0x3F000000)),
        ),
        style: MyGoogleFontStyle(
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w500,
          color: const Color(0xFF000000),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildCSCPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Country: $countryValue',
          style: MyGoogleFontStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E232C),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'State: ${_userAddress.state?.isNotEmpty == true ? _userAddress.state : "Not selected"}',
          style: MyGoogleFontStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E232C),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'City: ${_userAddress.city?.isNotEmpty == true ? _userAddress.city : "Not selected"}',
          style: MyGoogleFontStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E232C),
          ),
        ),
        const SizedBox(height: 16),
        CSCPicker(
          layout: Layout.vertical,
          showStates: true,
          showCities: true,
          flagState: CountryFlag.DISABLE,
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          disabledDropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade300,
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          countrySearchPlaceholder: 'Country',
          stateSearchPlaceholder: 'State',
          citySearchPlaceholder: 'City',
          countryDropdownLabel: 'Country',
          stateDropdownLabel: 'State',
          cityDropdownLabel: 'City',
          defaultCountry: CscCountry.India,
          disableCountry: true,
          selectedItemStyle: const TextStyle(color: Colors.black, fontSize: 14),
          dropdownHeadingStyle: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          dropdownItemStyle: const TextStyle(color: Colors.black, fontSize: 14),
          dropdownDialogRadius: 10.0,
          searchBarRadius: 10.0,
          onCountryChanged: (value) {
            setState(() {
              countryValue = value;
            });
          },
          onStateChanged: (value) {
            setState(() {
              _userAddress.state =
                  value?.isNotEmpty == true ? value : _userAddress.state;
            });
          },
          onCityChanged: (value) {
            setState(() {
              _userAddress.city =
                  value?.isNotEmpty == true ? value : _userAddress.city;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAlternatePhoneField() {
    return Column(
      children: [
        if (!isAltPhone)
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Alternate Phone Number'),
            onTap: () {
              setState(() {
                isAltPhone = true;
              });
            },
          ),
        if (isAltPhone) ...[
          _buildTextField(
            initialValue: _userAddress.altPhone,
            hintText: 'Alternate Phone Number',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value != null && value.isNotEmpty && value.length != 10) {
                return 'Alternate Phone must be 10 digits';
              }
              return null;
            },
            onSaved: (value) => _userAddress.altPhone = value,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.remove),
            title: const Text('Remove Alternate Phone Number'),
            onTap: () {
              setState(() {
                isAltPhone = false;
                _userAddress.altPhone = null;
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _buildAddressTypeChips() {
    return Wrap(
      spacing: 8.0,
      children: [
        ChoiceChip(
          selected: selectedChip == 'Home',
          onSelected: (selected) {
            setState(() {
              selectedChip = selected ? 'Home' : '';
              _userAddress.label =
                  selectedChip.isNotEmpty ? selectedChip : null;
            });
          },
          selectedColor: Colors.green,
          label: const SizedBox(
            width: 80,
            child: Row(
              children: [
                Icon(Icons.home),
                SizedBox(width: 10),
                Text('Home'),
              ],
            ),
          ),
        ),
        ChoiceChip(
          selected: selectedChip == 'Work',
          onSelected: (selected) {
            setState(() {
              selectedChip = selected ? 'Work' : '';
              _userAddress.label =
                  selectedChip.isNotEmpty ? selectedChip : null;
            });
          },
          selectedColor: Colors.blue,
          label: const SizedBox(
            width: 80,
            child: Row(
              children: [
                Icon(Icons.work),
                SizedBox(width: 10),
                Text('Work'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(UserAddressModel userAddressModel) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: _isLoading
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (selectedChip.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please select address type')),
                    );
                    return;
                  }
                  setState(() => _isLoading = true);
                  try {
                    final success = await userAddressModel.updateUserAddress(
                        userAddress: _userAddress);
                    if (success && mounted) {
                      // Refresh the addresses list
                      await userAddressModel.getUserAddresses();
                      
                      // Navigate back based on where we came from
                      if (widget.arguments['isAddress'] == true) {
                        // If coming from checkout flow, go back to address selection
                        Navigator.pop(context);
                      } else {
                        // If coming from profile, replace with AddressPage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddressPage(
                              arguments: {
                                'cartItems': widget.arguments['cartItems'] ?? [],
                                'cartTotal': widget.arguments['cartTotal'] ?? '',
                                'couponValue': widget.arguments['couponValue'] ?? 0,
                                'isAddress': widget.arguments['isAddress'] ?? false,
                              },
                            ),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to update address')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                }
              },
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFF1E1E1E),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Update Address',
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

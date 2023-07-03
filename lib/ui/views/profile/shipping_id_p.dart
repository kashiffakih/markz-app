import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/user_address.dart';
import 'package:sales_app/core/providers/user_address_pr.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class ShippingUpdatePage extends StatefulWidget {
  final arguments;
  const ShippingUpdatePage({Key? key, required this.arguments})
      : super(key: key);

  @override
  State<ShippingUpdatePage> createState() => _ShippingUpdatePageState();
}

class _ShippingUpdatePageState extends State<ShippingUpdatePage> {
  UserAddress _userAddress = UserAddress();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userAddress = widget.arguments['userAddress'];
  }

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    UserAddressModel _userAddressModel =
        Provider.of<UserAddressModel>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                // Title
                Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                'assets/images/vector-GJ4.png',
                                height: 15,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Add Shipping Address',
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
                      ),
                    ],
                  ),
                ),
                // Body
                Container(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Full Name
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xffe3e3e3)),
                            color: Color(0xfffbfbfb),
                          ),
                          child: TextFormField(
                            initialValue: _userAddress.add1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
                              hintText: 'Address 1',
                              hintStyle: TextStyle(color: Color(0x3f000000)),
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Address 1 Cannot be empty.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userAddress.add1 = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Address
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xffe3e3e3)),
                            color: Color(0xfffbfbfb),
                          ),
                          child: TextFormField(
                            initialValue: _userAddress.add2,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
                              hintText: 'Address 2',
                              hintStyle: TextStyle(color: Color(0x3f000000)),
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Address 2 Cannot be empty.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userAddress.add2 = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xffe3e3e3)),
                            color: Color(0xfffbfbfb),
                          ),
                          child: TextFormField(
                            initialValue: _userAddress.add3,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
                              hintText: 'Address 3',
                              hintStyle: TextStyle(color: Color(0x3f000000)),
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Address 3 Cannot be empty.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userAddress.add3 = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xffe3e3e3)),
                            color: Color(0xfffbfbfb),
                          ),
                          child: TextFormField(
                            initialValue: _userAddress.city,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
                              hintText: 'City',
                              hintStyle: TextStyle(color: Color(0x3f000000)),
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "City Cannot be empty.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userAddress.city = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xffe3e3e3)),
                            color: Color(0xfffbfbfb),
                          ),
                          child: TextFormField(
                            initialValue: _userAddress.state,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
                              hintText: 'State',
                              hintStyle: TextStyle(color: Color(0x3f000000)),
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "State Cannot be empty.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userAddress.state = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xffe3e3e3)),
                            color: Color(0xfffbfbfb),
                          ),
                          child: TextFormField(
                            initialValue: _userAddress.pincode,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
                              hintText: 'Pincode',
                              hintStyle: TextStyle(color: Color(0x3f000000)),
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Pincode Cannot be empty.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userAddress.pincode = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Save address
                        Container(
                          // primaryXwC (318:2628)
                          margin: EdgeInsets.fromLTRB(5, 0, 6.34, 0),
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                setState(() {
                                  _loading = true;
                                });
                                bool response =
                                    await _userAddressModel.updateUserAddress(
                                        userAddress: _userAddress);
                                if (response == true) {
                                  Navigator.pushNamed(context, '/addressPage');
                                }
                                setState(() {
                                  _loading = false;
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 53,
                              decoration: BoxDecoration(
                                color: Color(0xff1e1e1e),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: _loading
                                    ? SizedBox(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                        ),
                                        height: 20,
                                        width: 20,
                                      )
                                    : Text(
                                        'Update address',
                                        textAlign: TextAlign.center,
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 15.1428556442,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4999999685,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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

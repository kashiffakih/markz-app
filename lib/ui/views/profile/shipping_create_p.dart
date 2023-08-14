import 'package:flutter/material.dart';
import 'package:icon_forest/don_icons.dart';
import 'package:icon_forest/iconoir.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/user_address.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/user_address_pr.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/profile/address_p.dart';

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
    nationality: 'Dubai',
    pincode: '',
  );
  // String selectedCountry = 'Dubai';
  // String selectedState = '';
  // String selectedCity = '';

  String selectedChip = '';

  List<String> countries = ['USA', 'Canada', 'India', 'Dubai'];
  Map<String, List<String>> states = {
    'USA': ['New York', 'California', 'Texas'],
    'Canada': ['Ontario', 'Quebec', 'Alberta'],
    'India': ['Delhi', 'Maharashtra', 'Karnataka'],
    'Dubai': [
      'Abo Dhabi',
      'Ajman',
      'Dubai',
      'Fujairah',
      'Ras Al Khaimah',
      'Sharjah',
      'Umm Al Quwain'
    ]
  };
  Map<String, List<String>> cities = {
    'New York': ['New York City', 'Buffalo'],
    'California': ['Los Angeles', 'San Francisco'],
    'Texas': ['Houston', 'Dallas'],
    'Ontario': ['Toronto', 'Ottawa'],
    'Quebec': ['Montreal', 'Quebec City'],
    'Alberta': ['Calgary', 'Edmonton'],
    'Delhi': ['New Delhi', 'Noida'],
    'Maharashtra': ['Mumbai', 'Pune'],
    'Karnataka': ['Bangalore', 'Mysore'],
  };

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final UserAddressModel _userAddressModel =
        Provider.of<UserAddressModel>(context);
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);

    var cartItems = [];
    var cartTotal = '';
    // print(widget.arguments!['cartItems']);
    // print(widget.arguments!['cartTotal']);
    if (widget.arguments != null) {
      cartItems = widget.arguments!['cartItems'];
      cartTotal = widget.arguments!['cartTotal'];
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20),
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
                            border: Border.all(color: Color(0xffdadada)),
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonFormField(
                              value: _userAddress.nationality,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  labelText: 'Select Country',
                                  contentPadding: EdgeInsets.all(10)),
                              items: countries
                                  .map(
                                    (_country) => DropdownMenuItem(
                                      child: Text(
                                        _country,
                                      ),
                                      value: _country,
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  // selectedCountry = value.toString();
                                  _userAddress.state = null;
                                  _userAddress.city = null;
                                  _userAddress.nationality = value.toString();
                                });
                                print(_userAddress.state);
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffdadada)),
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonFormField<String>(
                            // value: _userAddress.state,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              labelText: _userAddress.nationality == 'Dubai'
                                  ? 'Selecte Emirate'
                                  : 'Select State',
                              contentPadding: EdgeInsets.all(10),
                            ),
                            value: _userAddress.state,
                            items:
                                states[_userAddress.nationality]?.map((state) {
                                      return DropdownMenuItem<String>(
                                        value: state,
                                        child: Text(state),
                                      );
                                    }).toList() ??
                                    [],
                            onChanged: (value) {
                              setState(() {
                                _userAddress.city = null;
                                _userAddress.state = value.toString();
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (_userAddress.nationality != 'Dubai')
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffdadada)),
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButtonFormField<String>(
                                // value: _userAddress.city,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    labelText: 'Select City',
                                    contentPadding: EdgeInsets.all(10)),
                                items: cities[_userAddress.state]?.map((city) {
                                      return DropdownMenuItem<String>(
                                        value: city,
                                        child: Text(city),
                                      );
                                    }).toList() ??
                                    [],
                                onChanged: (value) {
                                  setState(() {
                                    _userAddress.city = value.toString();
                                  });
                                }),
                          ),
                        if (_userAddress.nationality != 'Dubai')
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
                        Wrap(
                          spacing: 8.0,
                          children: [
                            ChoiceChip(
                              selected: selectedChip == 'Home',
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedChip = selected ? 'Home' : '';
                                  _userAddress.label = selectedChip;
                                });
                              },
                              selectedColor: Colors.green,
                              label: Text('Home'),
                            ),
                            ChoiceChip(
                              selected: selectedChip == 'Work',
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedChip = selected ? 'Work' : '';
                                  _userAddress.label = selectedChip;
                                });
                              },
                              selectedColor: Colors.blue,
                              label: Text('Work'),
                            ),
                            ChoiceChip(
                              selected: selectedChip == 'Other',
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedChip = selected ? 'Other' : '';
                                  _userAddress.label = selectedChip;
                                });
                              },
                              selectedColor: Colors.orange,
                              label: Text('Other'),
                            ),
                            // Add more ChoiceChip widgets here as needed
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Save address
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 6.34, 0),
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                setState(() {
                                  _loading = true;
                                });
                                bool response = await _userAddressModel
                                    .saveUserAddress(userAddress: _userAddress);
                                if (response == true) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AddressPage(
                                              arguments: {
                                                'cartItems': cartItems,
                                                'cartTotal': cartTotal,
                                                'address': []
                                              })));
                                  // Navigator.pushNamed(context, '/addressPage');
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
                                        'Save address',
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) async {
          if (value == 0) {
            Navigator.pushNamed(context, '/homePage');
          }
          if (value == 1) {
            Navigator.pushNamed(context, '/wishlistPage');
          }

          if (value == 2) {
            Map<String, dynamic> _CartData = {
              'kindOfFlower': '',
              'flavour': '',
              'writeOnCake': '',
              'pack': ''
            };
            await _addToCartModel.getAddToCart('', '', _CartData);
            Navigator.pushNamed(context, '/cartPage');
          }
          if (value == 3) {
            Navigator.pushNamed(context, '/profilePage');
          }
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Iconoir(Iconoir.home_simple),
            // icon: Icon(DonIcons.wap_home, size: 23),
          ),
          BottomNavigationBarItem(label: 'Saved', icon: Iconoir(Iconoir.heart)),
          BottomNavigationBarItem(
            label: 'Cart',
            icon: Iconoir(Iconoir.shopping_bag),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              DonIcons.user_o,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }
}

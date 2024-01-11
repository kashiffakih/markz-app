import 'package:flutter/material.dart';
import 'package:icon_forest/don_icons.dart';
import 'package:icon_forest/iconoir.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/user_address_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/checkout/checkout_p.dart';
import 'package:sales_app/ui/views/profile/shipping_create_p.dart';
import 'package:sales_app/ui/views/profile/shipping_id_p.dart';

class AddressPage extends StatefulWidget {
  final arguments;
  const AddressPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  bool _isShipping = false;

  @override
  void initState() {
    super.initState();
    Provider.of<UserAddressModel>(context, listen: false).getUserAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final UserAddressModel _userAddressModel =
        Provider.of<UserAddressModel>(context);
    final ConfigModel _configModel = locator<ConfigModel>();
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);

    var cartItems = [];
    var cartTotal = '';
    int couponValue = 0;
    // print(widget.arguments!['cartItems']);
    // print(widget.arguments!['cartTotal']);
    setState(() {
      if (widget.arguments != null) {
        cartItems = widget.arguments!['cartItems'];
        cartTotal = widget.arguments!['cartTotal'];
        couponValue = int.parse(widget.arguments!['couponValue'].toString());
      }
    });

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
                        child: Center(
                          child: Text(
                            'Addresses',
                            textAlign: TextAlign.center,
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e232c),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 15,
                              height: 15,
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                                color: Color(0xffEED056),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Container(
                            width: 258,
                            height: 38,
                            padding: const EdgeInsets.only(
                              left: 21,
                              right: 20.70,
                            ),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.50, color: Color(0xFFC7B456)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Center vertically
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Search',
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 18,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w600,
                                        // letterSpacing: -0.36,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    'assets/images/Search-1.png',
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(width: 10),
                          // Container(
                          //   width: 20,
                          //   height: 20,
                          //   child: Column(
                          //     mainAxisSize: MainAxisSize.min,
                          //     mainAxisAlignment:
                          //         MainAxisAlignment.center, // Center vertically
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Image.asset(
                          //         'assets/images/filter.png',
                          //         height: 20,
                          //         fit: BoxFit.cover,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
                // Body
                Container(
                  height: MediaQuery.of(context).size.height - 150,
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: _userAddressModel.userAddresses?.length == 0
                      ? SizedBox(
                          height: 60,
                          child: Center(child: Text('No address found.')),
                        )
                      : ListView.builder(
                          itemCount: _userAddressModel.userAddresses?.length,
                          itemBuilder: (BuildContext context, index) => Column(
                            children: [
                              Row(
                                children: [
                                  if (widget.arguments['isAddress'] == true)
                                    Checkbox(
                                      value: _isShipping,
                                      activeColor: Colors.black,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isShipping = value ?? false;
                                          if (_isShipping == true) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CheckoutPage(
                                                            arguments: {
                                                              'cartItems':
                                                                  cartItems,
                                                              'cartTotal':
                                                                  cartTotal,
                                                              'couponValue':
                                                                  couponValue,
                                                              'address':
                                                                  _userAddressModel
                                                                      .userAddresses![
                                                                          index]
                                                                      .toJson(),
                                                            })));
                                          }
                                        });
                                      },
                                    ),
                                  if (widget.arguments['isAddress'] == true)
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Use as the shipping address',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff232323),
                                        ),
                                      ),
                                    ),
                                  // Expanded(
                                  //     child: InkWell(
                                  //         onTap: () {
                                  //           Navigator.of(context).push(
                                  //               MaterialPageRoute(
                                  //                   builder: (context) =>
                                  //                       ShippingUpdatePage(
                                  //                           arguments: {
                                  //                             'userAddress':
                                  //                                 _userAddressModel
                                  //                                         .userAddresses![
                                  //                                     index]
                                  //                           })));
                                  //         },
                                  //         child: Align(
                                  //             alignment: Alignment.centerRight,
                                  //             child: Icon(Icons.edit)))),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ShippingUpdatePage(
                                              arguments: {
                                                'userAddress': _userAddressModel
                                                    .userAddresses![index]
                                              })));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffc7b456)),
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x338a959e),
                                        offset: Offset(0, 7.6690645218),
                                        blurRadius: 19.1726608276,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _userAddressModel.userAddresses![index]
                                                    .label !=
                                                null
                                            ? _userAddressModel
                                                .userAddresses![index].label
                                                .toString()
                                            : '',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff232323),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        _userAddressModel
                                                .userAddresses![index].add1
                                                .toString() +
                                            ', ' +
                                            _userAddressModel
                                                .userAddresses![index].add2
                                                .toString() +
                                            ', ' +
                                            _userAddressModel
                                                .userAddresses![index]
                                                .nationality
                                                .toString() +
                                            ', ' +
                                            _userAddressModel
                                                .userAddresses![index].state
                                                .toString() +
                                            ', ' +
                                            (_userAddressModel
                                                        .userAddresses![index]
                                                        .city !=
                                                    null
                                                ? _userAddressModel
                                                        .userAddresses![index]
                                                        .city
                                                        .toString() +
                                                    ', '
                                                : '') +
                                            _userAddressModel
                                                .userAddresses![index].pincode
                                                .toString() +
                                            '.',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff909090),
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShippingCreatePage(arguments: {
                    'cartItems': cartItems,
                    'cartTotal': cartTotal,
                    'couponValue': couponValue,
                    'address': []
                  })));
          // Navigator.pushNamed(context, '/shippingCreatePage');
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Color(0xffffffff),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   elevation: 10,
      //   iconSize: 30,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.black,
      //   selectedFontSize: 14,
      //   unselectedFontSize: 14,
      //   onTap: (value) async {
      //     if (value == 0) {
      //       Navigator.pushNamed(context, '/homePage');
      //     }
      //     if (value == 1) {
      //       Navigator.pushNamed(context, '/wishlistPage');
      //     }

      //     if (value == 2) {
      //       Map<String, dynamic> _CartData = {
      //         'kindOfFlower': '',
      //         'flavour': '',
      //         'writeOnCake': '',
      //         'pack': ''
      //       };
      //       await _addToCartModel.getAddToCart('', '', _CartData);
      //       Navigator.pushNamed(context, '/cartPage');
      //     }
      //     if (value == 3) {
      //       Navigator.pushNamed(context, '/profilePage');
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: Iconoir(Iconoir.home_simple),
      //       // icon: Icon(DonIcons.wap_home, size: 23),
      //     ),
      //     BottomNavigationBarItem(label: 'Saved', icon: Iconoir(Iconoir.heart)),
      //     BottomNavigationBarItem(
      //       label: 'Cart',
      //       icon: Iconoir(Iconoir.shopping_bag),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Profile',
      //       icon: Icon(
      //         DonIcons.user_o,
      //         size: 23,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

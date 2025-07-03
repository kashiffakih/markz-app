import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/user_address.dart';
import 'package:aadab/core/providers/user_address_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/checkout/cart_p.dart';
import 'package:aadab/ui/views/profile/shipping_create_p.dart';
import 'package:aadab/ui/views/profile/shipping_id_p.dart';

class AddressPage extends StatefulWidget {
  final arguments;
  const AddressPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  int? _selectedAddressIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<UserAddressModel>(context, listen: false)
          .getUserAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserAddressModel _userAddressModel =
        Provider.of<UserAddressModel>(context, listen: false);

    var cartItems = [];
    var cartTotal = '';
    int couponValue = 0;

    if (widget.arguments != null) {
      cartItems = widget.arguments!['cartItems'];
      cartTotal = widget.arguments!['cartTotal'];
      couponValue = int.parse(widget.arguments!['couponValue'].toString());
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          // Navigator.pushReplacementNamed(context, '/homePage');
          return false;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Title
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 18,
                          color: Color(0xffEED056),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Addresses',
                          textAlign: TextAlign.center,
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff1e232c),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                // Body
                Container(
                  height: MediaQuery.of(context).size.height - 150,
                  padding: const EdgeInsets.all(15),
                  child: _userAddressModel.userAddresses?.isEmpty ?? true
                      ? const Center(child: Text('No address found.'))
                      : ListView.builder(
                          itemCount: _userAddressModel.userAddresses!.length,
                          itemBuilder: (BuildContext context, index) => Column(
                            children: [
                              Row(
                                children: [
                                  if (widget.arguments['isAddress'] == true)
                                    Checkbox(
                                      value: _selectedAddressIndex == index,
                                      activeColor: Colors.black,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedAddressIndex = index;

                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                title:
                                                    const Text("Are you sure?"),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _selectedAddressIndex =
                                                                null;
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        child: const Text(
                                                          'No',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CartPage(
                                                                      arguments: {
                                                                    'address': _userAddressModel
                                                                        .userAddresses![
                                                                            index]
                                                                        .toJson(),
                                                                  }),
                                                            ),
                                                          );
                                                        },
                                                        child:
                                                            const Text('Yes'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  if (widget.arguments['isAddress'] == true)
                                    const SizedBox(width: 10),
                                  if (widget.arguments['isAddress'] == true)
                                    const Text(
                                      'Use as the shipping address',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff232323),
                                      ),
                                    ),
                                  Spacer(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            title: const Text(
                                              "Are you sure?",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            content: const Text(
                                              "Do you really want to delete this address? This action cannot be undone.",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            actionsPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10),
                                            actionsAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _selectedAddressIndex =
                                                        null;
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                ),
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  UserAddress userAddress =
                                                      _userAddressModel
                                                              .userAddresses![
                                                          index];
                                                  userAddress.isDeleted = 1;

                                                  _userAddressModel
                                                      .updateUserAddress(
                                                          userAddress:
                                                              userAddress)
                                                      .then((_) {
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) async {
                                                      await Provider.of<
                                                                  UserAddressModel>(
                                                              context,
                                                              listen: false)
                                                          .getUserAddresses();
                                                    });
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                ),
                                                child: const Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                              // Address container
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ShippingUpdatePage(arguments: {
                                        'userAddress': _userAddressModel
                                            .userAddresses![index],
                                      }),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffc7b456),
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x338a959e),
                                        offset: Offset(0, 8),
                                        blurRadius: 19,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _userAddressModel
                                                .userAddresses![index].label ??
                                            '',
                                        style: const TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff232323),
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        (_userAddressModel.userAddresses![index].fullName != null
                                                ? _userAddressModel
                                                    .userAddresses![index]
                                                    .fullName
                                                    .toString()
                                                : '') +
                                            ', ' +
                                            (_userAddressModel.userAddresses![index].phone != null
                                                ? _userAddressModel
                                                    .userAddresses![index].phone
                                                    .toString()
                                                : '') +
                                            ', ' +
                                            (_userAddressModel.userAddresses![index].altPhone != null
                                                ? _userAddressModel
                                                    .userAddresses![index]
                                                    .altPhone
                                                    .toString()
                                                : '') +
                                            ', ' +
                                            (_userAddressModel.userAddresses![index].add1 != null
                                                ? _userAddressModel
                                                    .userAddresses![index].add1
                                                    .toString()
                                                : '') +
                                            ', ' +
                                            (_userAddressModel.userAddresses![index].add2 != null
                                                ? _userAddressModel
                                                    .userAddresses![index].add2
                                                    .toString()
                                                : '') +
                                            ', ' +
                                            (_userAddressModel.userAddresses![index].add3 != null
                                                ? _userAddressModel
                                                    .userAddresses![index].add3
                                                    .toString()
                                                : '') +
                                            ',' +
                                            (_userAddressModel.userAddresses![index].state != null
                                                ? _userAddressModel.userAddresses![index].state.toString()
                                                : '') +
                                            ', ' +
                                            ', ' +
                                            (_userAddressModel.userAddresses![index].city != null ? _userAddressModel.userAddresses![index].city.toString() : '') +
                                            ', ' +
                                            (_userAddressModel.userAddresses![index].pincode != null ? _userAddressModel.userAddresses![index].pincode.toString() : '') +
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ShippingCreatePage(arguments: {
                'cartItems': cartItems,
                'cartTotal': cartTotal,
                'couponValue': couponValue,
                'address': [],
                'isShipping': widget.arguments['isAddress']
              }),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


// class _AddressPageState extends State<AddressPage> {
//   bool _isShipping = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await Provider.of<UserAddressModel>(context, listen: false)
//           .getUserAddresses();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final UserAddressModel _userAddressModel =
//         Provider.of<UserAddressModel>(context);

//     var cartItems = [];
//     var cartTotal = '';
//     int couponValue = 0;
//     setState(() {
//       if (widget.arguments != null) {
//         cartItems = widget.arguments!['cartItems'];
//         cartTotal = widget.arguments!['cartTotal'];
//         couponValue = int.parse(widget.arguments!['couponValue'].toString());
//       }
//     });

//     return Scaffold(
//       body: WillPopScope(
//         onWillPop: () async {
//           Navigator.pushReplacementNamed(context, '/homePage');
//           return false;
//         },
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Container(
//               child: Column(
//                 children: [
//                   // Title
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                     width: double.infinity,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             width: 15,
//                             height: 15,
//                             child: Icon(
//                               Icons.arrow_back_ios,
//                               size: 18,
//                               color: Color(0xffEED056),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 100,
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Center(
//                             child: Text(
//                               'Addresses',
//                               textAlign: TextAlign.center,
//                               style: MyGoogleFontStyle(
//                                 fontFamily: 'Urbanist',
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xff1e232c),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Body
//                   Container(
//                     height: MediaQuery.of(context).size.height - 150,
//                     padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
//                     child: _userAddressModel.userAddresses?.length == 0
//                         ? SizedBox(
//                             height: 60,
//                             child: Center(child: Text('No address found.')),
//                           )
//                         : ListView.builder(
//                             itemCount: _userAddressModel.userAddresses?.length,
//                             itemBuilder: (BuildContext context, index) =>
//                                 Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     if (widget.arguments['isAddress'] == true)
//                                       Checkbox(
//                                         value: _isShipping,
//                                         activeColor: Colors.black,
//                                         onChanged: (bool? value) {
//                                           setState(() {
//                                             _isShipping = value ?? false;

//                                             showDialog(
//                                               context: context,
//                                               barrierDismissible: false,
//                                               builder: (BuildContext context) =>
//                                                   AlertDialog(
//                                                 shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20)),
//                                                 title: Text("Are you sure ?"),
//                                                 actions: <Widget>[
//                                                   Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceAround,
//                                                     children: [
//                                                       TextButton(
//                                                         onPressed: () {
//                                                           setState(() {
//                                                             _isShipping = false;
//                                                             Navigator.pop(
//                                                                 context);
//                                                           });
//                                                         },
//                                                         child: Text(
//                                                           'No',
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.red),
//                                                         ),
//                                                       ),
//                                                       TextButton(
//                                                         onPressed: () {
//                                                           if (_isShipping ==
//                                                               true) {
//                                                             Navigator.of(context).push(
//                                                                 MaterialPageRoute(
//                                                                     builder: (context) =>
//                                                                         CartPage(
//                                                                             arguments: {
//                                                                               // 'cartItems':
//                                                                               //     cartItems,
//                                                                               // 'cartTotal':
//                                                                               //     cartTotal,
//                                                                               // 'couponValue':
//                                                                               //     couponValue,
//                                                                               'address': _userAddressModel.userAddresses![index].toJson(),
//                                                                             })));
//                                                           }
//                                                         },
//                                                         child: Text('Yes'),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             );
//                                           });
//                                         },
//                                       ),
//                                     if (widget.arguments['isAddress'] == true)
//                                       Expanded(
//                                         flex: 4,
//                                         child: Text(
//                                           'Use as the shipping address',
//                                           style: MyGoogleFontStyle(
//                                             fontFamily: 'Poppins',
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w400,
//                                             color: Color(0xff232323),
//                                           ),
//                                         ),
//                                       ),
//                                     // Expanded(
//                                     //     child: InkWell(
//                                     //         onTap: () {
//                                     //           Navigator.of(context).push(
//                                     //               MaterialPageRoute(
//                                     //                   builder: (context) =>
//                                     //                       ShippingUpdatePage(
//                                     //                           arguments: {
//                                     //                             'userAddress':
//                                     //                                 _userAddressModel
//                                     //                                         .userAddresses![
//                                     //                                     index]
//                                     //                           })));
//                                     //         },
//                                     //         child: Align(
//                                     //             alignment: Alignment.centerRight,
//                                     //             child: Icon(Icons.edit)))),
//                                   ],
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 ShippingUpdatePage(arguments: {
//                                                   'userAddress':
//                                                       _userAddressModel
//                                                           .userAddresses![index]
//                                                 })));
//                                   },
//                                   child: Container(
//                                     margin: EdgeInsets.only(bottom: 10),
//                                     padding: EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       border:
//                                           Border.all(color: Color(0xffc7b456)),
//                                       color: Color(0xffffffff),
//                                       borderRadius: BorderRadius.all(
//                                         Radius.circular(5),
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Color(0x338a959e),
//                                           offset: Offset(0, 7.6690645218),
//                                           blurRadius: 19.1726608276,
//                                         ),
//                                       ],
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           _userAddressModel
//                                                       .userAddresses?[index]
//                                                       .label !=
//                                                   null
//                                               ? _userAddressModel
//                                                   .userAddresses![index].label
//                                                   .toString()
//                                               : '',
//                                           style: MyGoogleFontStyle(
//                                             fontFamily: 'Urbanist',
//                                             fontWeight: FontWeight.w700,
//                                             color: Color(0xff232323),
//                                           ),
//                                         ),
//                                         Divider(
//                                           thickness: 1,
//                                           color: Colors.grey,
//                                         ),
                                        // Text(
                                        //   (_userAddressModel.userAddresses![index].fullName != null
                                        //           ? _userAddressModel
                                        //               .userAddresses![index]
                                        //               .fullName
                                        //               .toString()
                                        //           : '') +
                                        //       ', ' +
                                        //       (_userAddressModel.userAddresses![index].phone != null
                                        //           ? _userAddressModel
                                        //               .userAddresses![index]
                                        //               .phone
                                        //               .toString()
                                        //           : '') +
                                        //       ', ' +
                                        //       (_userAddressModel.userAddresses![index].altPhone != null
                                        //           ? _userAddressModel
                                        //               .userAddresses![index]
                                        //               .altPhone
                                        //               .toString()
                                        //           : '') +
                                        //       ', ' +
                                        //       (_userAddressModel.userAddresses![index].add1 != null
                                        //           ? _userAddressModel.userAddresses![index].add1
                                        //               .toString()
                                        //           : '') +
                                        //       ', ' +
                                        //       (_userAddressModel.userAddresses![index].add2 != null
                                        //           ? _userAddressModel
                                        //               .userAddresses![index]
                                        //               .add2
                                        //               .toString()
                                        //           : '') +
                                        //       ', ' +
                                        //       (_userAddressModel.userAddresses![index].add3 != null
                                        //           ? _userAddressModel
                                        //               .userAddresses![index]
                                        //               .add3
                                        //               .toString()
                                        //           : '') +
                                        //       ',' +
                                        //       (_userAddressModel.userAddresses![index].state != null
                                        //           ? _userAddressModel.userAddresses![index].state.toString()
                                        //           : '') +
                                        //       ', ' +
                                        //       ', ' +
                                        //       (_userAddressModel.userAddresses![index].city != null ? _userAddressModel.userAddresses![index].city.toString() : '') +
                                        //       ', ' +
                                        //       (_userAddressModel.userAddresses![index].pincode != null ? _userAddressModel.userAddresses![index].pincode.toString() : '') +
                                        //       '.',
                                        //   style: MyGoogleFontStyle(
                                        //     fontFamily: 'Urbanist',
                                        //     fontWeight: FontWeight.w400,
                                        //     color: Color(0xff909090),
                                        //   ),
                                        // ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => ShippingCreatePage(arguments: {
//                     'cartItems': cartItems,
//                     'cartTotal': cartTotal,
//                     'couponValue': couponValue,
//                     'address': []
//                   })));
//           // Navigator.pushNamed(context, '/shippingCreatePage');
//         },
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//         backgroundColor: Colors.black,
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

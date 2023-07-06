import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    var cartItems = [];
    var cartTotal = '';
    // print(widget.arguments!['cartItems']);
    // print(widget.arguments!['cartTotal']);
    setState(() {
      if (widget.arguments != null) {
        cartItems = widget.arguments!['cartItems'];
        cartTotal = widget.arguments!['cartTotal'];
      }
    });

    print(cartItems);
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Container(
                  height: 600,
                  padding: EdgeInsets.all(15),
                  child: _userAddressModel.userAddresses!.isEmpty
                      ? SizedBox(
                          height: 60,
                          child: Center(child: Text('No address found.')),
                        )
                      : ListView.builder(
                          itemCount: _userAddressModel.userAddresses!.length,
                          itemBuilder: (BuildContext context, index) => Column(
                            children: [
                              Row(
                                children: [
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
                                                      CheckoutPage(arguments: {
                                                        'cartItems': cartItems,
                                                        'cartTotal': cartTotal,
                                                        'address':
                                                            _userAddressModel
                                                                .userAddresses![
                                                                    index]
                                                                .toJson()
                                                      })));
                                        }
                                      });
                                    },
                                  ),
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
                                  Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShippingUpdatePage(
                                                            arguments: {
                                                              'userAddress':
                                                                  _userAddressModel
                                                                          .userAddresses![
                                                                      index]
                                                            })));
                                          },
                                          child: Icon(Icons.edit))),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffc7b456)),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _configModel.user.firstName.toString(),
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
                                              .userAddresses![index].add3
                                              .toString() +
                                          ', ' +
                                          _userAddressModel
                                              .userAddresses![index].city
                                              .toString() +
                                          ', ' +
                                          _userAddressModel
                                              .userAddresses![index].state
                                              .toString() +
                                          '. ' +
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
    );
  }
}

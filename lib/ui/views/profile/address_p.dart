import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/user_address.dart';
import 'package:aadab/core/providers/user_address_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAddresses());
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<UserAddressModel>(context, listen: false)
          .getUserAddresses();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load addresses: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAddressModel =
        Provider.of<UserAddressModel>(context, listen: false);
    final double fem = MediaQuery.of(context).size.width / 360;
    final double ffem = fem * 0.97;
    final isAddressSelectionMode = widget.arguments?['isAddress'] == true;
    final cartItems = widget.arguments?['cartItems'] as List<dynamic>? ?? [];
    final cartTotal = widget.arguments?['cartTotal']?.toString() ?? '';
    final couponValue =
        int.tryParse(widget.arguments?['couponValue']?.toString() ?? '0') ?? 0;
    print('from ${widget.arguments}');
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (widget.arguments['isAddress'] == true) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacementNamed(context, '/profilePage');
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(context, fem, ffem),
                      _buildBody(context, userAddressModel,
                          isAddressSelectionMode, fem, ffem),
                    ],
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShippingCreatePage(arguments: {
                  'cartItems': cartItems,
                  'cartTotal': cartTotal,
                  'couponValue': couponValue,
                  'address': [],
                  'isShipping': isAddressSelectionMode,
                }),
              ),
            );
          },
          backgroundColor: Colors.black,
          child: Icon(Icons.add, size: 24 * fem, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double fem, double ffem) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30 * fem, vertical: 10 * fem),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18 * fem,
              color: const Color(0xffEED056),
            ),
            onPressed: () {
              if (widget.arguments['isAddress'] == true) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/profilePage');
              }
            },
          ),
          Expanded(
            child: Text(
              'Addresses',
              textAlign: TextAlign.center,
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 18 * ffem,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
          SizedBox(width: 48 * fem),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    UserAddressModel userAddressModel,
    bool isAddressSelectionMode,
    double fem,
    double ffem,
  ) {
    return Container(
      padding: EdgeInsets.all(15 * fem),
      child: userAddressModel.userAddresses?.isEmpty ?? true
          ? Center(
              child: Text(
                'No address found.',
                style: MyGoogleFontStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14 * ffem,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff909090),
                ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userAddressModel.userAddresses!.length,
              itemBuilder: (context, index) => _buildAddressItem(
                context: context,
                address: userAddressModel.userAddresses![index],
                index: index,
                isAddressSelectionMode: isAddressSelectionMode,
                userAddressModel: userAddressModel,
                fem: fem,
                ffem: ffem,
              ),
            ),
    );
  }

  Widget _buildAddressItem({
    required BuildContext context,
    required UserAddress address,
    required int index,
    required bool isAddressSelectionMode,
    required UserAddressModel userAddressModel,
    required double fem,
    required double ffem,
  }) {
    return Column(
      children: [
        if (isAddressSelectionMode)
          Row(
            children: [
              Checkbox(
                value: _selectedAddressIndex == index,
                activeColor: Colors.black,
                onChanged: (bool? value) {
                  if (value == true) {
                    setState(() => _selectedAddressIndex = index);
                    _showConfirmDialog(
                      context,
                      userAddressModel,
                      address,
                      fem,
                      ffem,
                    );
                  }
                },
              ),
              SizedBox(width: 10 * fem),
              Text(
                'Use as the shipping address',
                style: MyGoogleFontStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15 * ffem,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff232323),
                ),
              ),
              const Spacer(),
            ],
          ),
        InkWell(
          onTap: () {
            // if (widget.arguments['isAddress'] != true)
            widget.arguments['userAddress'] = address;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ShippingUpdatePage(arguments: widget.arguments),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10 * fem),
            padding: EdgeInsets.all(10 * fem),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffc7b456)),
              color: Colors.white,
              borderRadius: BorderRadius.circular(5 * fem),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x338a959e),
                  offset: Offset(0, 8 * fem),
                  blurRadius: 19 * fem,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.label?.toString() ?? 'No Label',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16 * ffem,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff232323),
                        ),
                      ),
                      Divider(
                        thickness: 1 * fem,
                        color: Colors.grey,
                      ),
                      Text(
                        _formatAddress(address),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff909090),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showDeleteDialog(
                      context, userAddressModel, address, fem, ffem),
                  icon: Icon(Icons.delete, size: 20 * fem, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatAddress(UserAddress address) {
    final parts = [
      address.fullName?.toString(),
      address.phone?.toString(),
      address.altPhone?.toString(),
      address.add1?.toString(),
      address.add2?.toString(),
      address.add3?.toString(),
      address.city?.toString(),
      address.state?.toString(),
      address.pincode?.toString(),
    ].where((part) => part != null && part.isNotEmpty).join(', ');
    return parts.isEmpty ? 'No address details' : '$parts.';
  }

  void _showConfirmDialog(
    BuildContext context,
    UserAddressModel userAddressModel,
    UserAddress address,
    double fem,
    double ffem,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20 * fem)),
        title: Text(
          'Confirm Address',
          style: MyGoogleFontStyle(
            fontFamily: 'Urbanist',
            fontSize: 16 * ffem,
            fontWeight: FontWeight.w600,
            color: const Color(0xff1e232c),
          ),
        ),
        content: Text(
          'Use this address for shipping?',
          style: MyGoogleFontStyle(
            fontFamily: 'Poppins',
            fontSize: 14 * ffem,
            fontWeight: FontWeight.w400,
            color: const Color(0xff909090),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _selectedAddressIndex = null);
              Navigator.pop(context);
            },
            child: Text(
              'No',
              style: MyGoogleFontStyle(
                fontFamily: 'Poppins',
                fontSize: 14 * ffem,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              print('Selected address ID: ${address.id}');
              print('Selected address data: ${address.toJson()}');
              Navigator.pop(context); // Close the dialog first
              Navigator.pop(context, {
                'address': address.toJson(),
              }); // Then return to cart with the selected address
            },
            child: Text(
              'Yes',
              style: MyGoogleFontStyle(
                fontFamily: 'Poppins',
                fontSize: 14 * ffem,
                fontWeight: FontWeight.w500,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    UserAddressModel userAddressModel,
    UserAddress address,
    double fem,
    double ffem,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20 * fem)),
        title: Text(
          'Delete Address',
          style: MyGoogleFontStyle(
            fontFamily: 'Urbanist',
            fontSize: 16 * ffem,
            fontWeight: FontWeight.w600,
            color: const Color(0xff1e232c),
          ),
        ),
        content: Text(
          'Do you really want to delete this address? This action cannot be undone.',
          style: MyGoogleFontStyle(
            fontFamily: 'Poppins',
            fontSize: 14 * ffem,
            fontWeight: FontWeight.w400,
            color: const Color(0xff909090),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _selectedAddressIndex = null);
              Navigator.pop(context);
            },
            child: Text(
              'No',
              style: MyGoogleFontStyle(
                fontFamily: 'Poppins',
                fontSize: 14 * ffem,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                final updatedAddress = address..isDeleted = 1;
                await userAddressModel.updateUserAddress(
                    userAddress: updatedAddress);
                await userAddressModel.getUserAddresses();
                if (mounted) {
                  setState(() => _selectedAddressIndex = null);
                  Navigator.pop(context);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete address: $e')),
                  );
                  Navigator.pop(context);
                }
              }
            },
            child: Text(
              'Yes',
              style: MyGoogleFontStyle(
                fontFamily: 'Poppins',
                fontSize: 14 * ffem,
                fontWeight: FontWeight.w500,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

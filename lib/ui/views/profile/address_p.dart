import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/user_address.dart';
import 'package:aadab/core/providers/user_address_pr.dart';
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
      // Handle error silently
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateBack() {
    if (widget.arguments?['isAddress'] == true) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/profilePage');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAddressModel = Provider.of<UserAddressModel>(context);
    final isAddressSelectionMode = widget.arguments?['isAddress'] == true;
    final cartItems = widget.arguments?['cartItems'] as List<dynamic>? ?? [];
    final cartTotal = widget.arguments?['cartTotal']?.toString() ?? '';
    final couponValue =
        int.tryParse(widget.arguments?['couponValue']?.toString() ?? '0') ?? 0;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _navigateBack();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, isAddressSelectionMode),

              // Body
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : _buildBody(
                        context,
                        userAddressModel,
                        isAddressSelectionMode,
                        cartItems,
                        cartTotal,
                        couponValue,
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildFAB(
          cartItems,
          cartTotal,
          couponValue,
          isAddressSelectionMode,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isSelectionMode) {
    return Container(
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
            onTap: _navigateBack,
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
                  isSelectionMode ? 'Select Address' : 'My Addresses',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  isSelectionMode
                      ? 'Choose a delivery address'
                      : 'Manage your saved addresses',
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
              isSelectionMode ? Icons.local_shipping_rounded : Icons.home_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFC7B456).withOpacity(0.15),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC7B456)),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Loading addresses...',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF888888),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    UserAddressModel userAddressModel,
    bool isAddressSelectionMode,
    List<dynamic> cartItems,
    String cartTotal,
    int couponValue,
  ) {
    if (userAddressModel.userAddresses?.isEmpty ?? true) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadAddresses,
      color: Color(0xFFC7B456),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: userAddressModel.userAddresses!.length,
        itemBuilder: (context, index) => _buildAddressCard(
          context: context,
          address: userAddressModel.userAddresses![index],
          index: index,
          isAddressSelectionMode: isAddressSelectionMode,
          userAddressModel: userAddressModel,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Color(0xFFC7B456).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_off_rounded,
              size: 64,
              color: Color(0xFFC7B456),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Addresses Found',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Add your first address to get started with deliveries',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF888888),
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Tap + to add address',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFFC7B456),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required BuildContext context,
    required UserAddress address,
    required int index,
    required bool isAddressSelectionMode,
    required UserAddressModel userAddressModel,
  }) {
    final isSelected = _selectedAddressIndex == index;
    final isHome = address.label?.toLowerCase() == 'home';

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Color(0xFFC7B456) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Selection header (only in selection mode)
          if (isAddressSelectionMode)
            InkWell(
              onTap: () {
                setState(() => _selectedAddressIndex = index);
                _showConfirmDialog(context, userAddressModel, address);
              },
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(0xFFC7B456).withOpacity(0.1)
                      : Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Color(0xFFC7B456)
                              : Color(0xFFD0D0D0),
                          width: 2,
                        ),
                        color: isSelected ? Color(0xFFC7B456) : Colors.white,
                      ),
                      child: isSelected
                          ? Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Use as shipping address',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Color(0xFFC7B456)
                            : Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Address content
          InkWell(
            onTap: () {
              widget.arguments?['userAddress'] = address;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ShippingUpdatePage(arguments: widget.arguments),
                ),
              );
            },
            borderRadius: BorderRadius.vertical(
              top: isAddressSelectionMode ? Radius.zero : Radius.circular(16),
              bottom: Radius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label and actions row
                  Row(
                    children: [
                      // Label badge
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isHome
                                ? [Color(0xFF4CAF50), Color(0xFF66BB6A)]
                                : [Color(0xFF2196F3), Color(0xFF42A5F5)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isHome ? Icons.home_rounded : Icons.work_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              address.label?.toUpperCase() ?? 'ADDRESS',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      // Edit button
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                      SizedBox(width: 8),
                      // Delete button
                      GestureDetector(
                        onTap: () => _showDeleteDialog(
                          context,
                          userAddressModel,
                          address,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Name and phone
                  Row(
                    children: [
                      Icon(Icons.person_rounded,
                          size: 16, color: Color(0xFFC7B456)),
                      SizedBox(width: 8),
                      Text(
                        address.fullName ?? 'No Name',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Phone
                  Row(
                    children: [
                      Icon(Icons.phone_rounded,
                          size: 16, color: Color(0xFFC7B456)),
                      SizedBox(width: 8),
                      Text(
                        address.phone ?? 'No Phone',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF666666),
                        ),
                      ),
                      if (address.altPhone?.isNotEmpty == true) ...[
                        Text(
                          ' / ${address.altPhone}',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ],
                  ),

                  SizedBox(height: 12),

                  // Address
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: 18, color: Color(0xFFC7B456)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _formatAddress(address),
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF666666),
                              height: 1.5,
                            ),
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
    );
  }

  Widget _buildFAB(
    List<dynamic> cartItems,
    String cartTotal,
    int couponValue,
    bool isAddressSelectionMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
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
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.add_location_alt_rounded,
              size: 26,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  String _formatAddress(UserAddress address) {
    final parts = [
      address.add1,
      address.add2,
      address.add3,
      address.city,
      address.state,
      address.pincode,
    ].where((part) => part != null && part.isNotEmpty).toList();

    if (parts.isEmpty) return 'No address details';

    return parts.join(', ');
  }

  void _showConfirmDialog(
    BuildContext context,
    UserAddressModel userAddressModel,
    UserAddress address,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFC7B456).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.local_shipping_rounded,
                color: Color(0xFFC7B456),
                size: 22,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Confirm Address',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Use this address for shipping?',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on_rounded,
                      size: 18, color: Color(0xFFC7B456)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${address.add1}, ${address.city}',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _selectedAddressIndex = null);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF888888),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD4C76A), Color(0xFFC7B456)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context, {
                    'address': address.toJson(),
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
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
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 22,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Delete Address',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this address? This action cannot be undone.',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF666666),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _selectedAddressIndex = null);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF888888),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
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
                        SnackBar(
                          content: Text('Failed to delete address'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

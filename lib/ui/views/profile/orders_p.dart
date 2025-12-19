import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/order.dart';
import 'package:aadab/core/providers/order_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/views/profile/order-details-processing.dart';

class OrdersPage extends StatefulWidget {
  final isProfile;

  OrdersPage({Key? key, this.isProfile}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final DateFormat _dateFormat = DateFormat('MMM d, yyyy');
  bool _isPageLoading = false;

  final ConfigModel _configModel = locator<ConfigModel>();

  // Filter State
  List<String> _selectedStatuses = [];
  DateTimeRange? _selectedDateRange;
  final List<String> _allStatuses = [
    'Order Placed',
    'Processing',
    'Delivered',
    'Cancelled'
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isPageLoading = true);
    try {
      await Provider.of<OrderModel>(context, listen: false).getOrder();
    } catch (e) {
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to load orders: $e')),
        // );
      }
    } finally {
      if (mounted) setState(() => _isPageLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderModel = Provider.of<OrderModel>(context, listen: true);
    // print('Building OrdersPage with ${orderModel.orders.length} orders');
    return Scaffold(
      body: Container(
        width: 1.0.sw,
        height: 1.0.sh,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFEF9),
              Color(0xFFFFFDF7),
              Colors.white,
            ],
          ),
        ),
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (!didPop) {
              final isProfile = widget.isProfile?['isProfile'] ?? false;
              Navigator.pushReplacementNamed(
                context,
                isProfile ? '/profilePage' : '/homePage',
              );
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.0.w),
                  child: _buildHeader(context),
                ),
                Expanded(
                  child: _isPageLoading
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFFEED056)))
                      : _buildOrderList(context, orderModel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              final isProfile = widget.isProfile?['isProfile'] ?? false;
              Navigator.pushReplacementNamed(
                context,
                isProfile ? '/profilePage' : '/homePage',
              );
            },
            child: Container(
              padding: EdgeInsets.all(8.0.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFEED056).withOpacity(0.15),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16.0.sp,
                color: const Color(0xffEED056),
              ),
            ),
          ),
          Text(
            'My Orders',
            textAlign: TextAlign.center,
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 20.0.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff1e232c),
            ),
          ),
          InkWell(
            onTap: _showFilterBottomSheet,
            child: Container(
              padding: EdgeInsets.all(8.0.w),
              decoration: BoxDecoration(
                color:
                    (_selectedStatuses.isNotEmpty || _selectedDateRange != null)
                        ? Color(0xFFEED056)
                        : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFEED056).withOpacity(0.15),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.filter_list_rounded,
                size: 20.0.sp,
                color:
                    (_selectedStatuses.isNotEmpty || _selectedDateRange != null)
                        ? Colors.white
                        : const Color(0xff1e232c),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Orders',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1e232c),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedStatuses.clear();
                            _selectedDateRange = null;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Reset',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.w),
                  Text(
                    'Status',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1e232c),
                    ),
                  ),
                  SizedBox(height: 10.w),
                  Wrap(
                    spacing: 8.w,
                    children: _allStatuses.map((status) {
                      final isSelected = _selectedStatuses.contains(status);
                      return FilterChip(
                        label: Text(status),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            if (selected) {
                              _selectedStatuses.add(status);
                            } else {
                              _selectedStatuses.remove(status);
                            }
                          });
                        },
                        selectedColor: Color(0xFFEED056).withOpacity(0.2),
                        checkmarkColor: Color(0xFFEED056),
                        labelStyle: TextStyle(
                          color: isSelected ? Color(0xFFEED056) : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(), // Explicit toList
                  ),
                  SizedBox(height: 20.w),
                  Text(
                    'Date Range',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1e232c),
                    ),
                  ),
                  SizedBox(height: 10.w),
                  InkWell(
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDateRange: _selectedDateRange,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFFEED056),
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setModalState(() {
                          _selectedDateRange = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 18.sp, color: Colors.grey),
                          SizedBox(width: 10.w),
                          Text(
                            _selectedDateRange == null
                                ? 'Select Date Range'
                                : '${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.w),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {}); // Trigger rebuild of page
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEED056),
                        padding: EdgeInsets.symmetric(vertical: 15.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOrderList(BuildContext context, OrderModel orderModel) {
    var filteredOrders = orderModel.orders;

    // Apply Status Filter
    if (_selectedStatuses.isNotEmpty) {
      filteredOrders = filteredOrders.where((order) {
        final status = _getOrderStatus(order);
        // Map internal status to filter labels if needed, currently 1:1 match
        if (_selectedStatuses.contains('Processing') &&
            status == 'Order Processing') return true;
        return _selectedStatuses.contains(status);
      }).toList();
    }

    // Apply Date Filter
    if (_selectedDateRange != null) {
      filteredOrders = filteredOrders.where((order) {
        if (order.createdAt == null) return false;
        final orderDate = DateTime.parse(order.createdAt.toString());
        return orderDate.isAfter(
                _selectedDateRange!.start.subtract(Duration(days: 1))) &&
            orderDate.isBefore(_selectedDateRange!.end.add(Duration(days: 1)));
      }).toList();
    }

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined,
                size: 60.sp, color: Colors.grey.shade300),
            SizedBox(height: 10.w),
            Text(
              'No orders found',
              style: TextStyle(color: Colors.grey, fontSize: 16.sp),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 20.w),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        final status = _getOrderStatus(order);
        return _buildOrderCard(order, status);
      },
    );
  }

  Widget _buildOrderCard(Order order, String status) {
    // Get the first product image if available
    String? imageUrl;
    if (order.orderDetails != null && order.orderDetails!.isNotEmpty) {
      final firstDetail = order.orderDetails!.first;
      // Try direct image path on detail first
      if (firstDetail.productImagePath != null &&
          firstDetail.productImagePath!.isNotEmpty) {
        imageUrl = firstDetail.productImagePath!;
      }
      // Fallback to product images
      else if (firstDetail.product != null &&
          firstDetail.product!.productImages != null &&
          firstDetail.product!.productImages!.isNotEmpty) {
        imageUrl = firstDetail.product!.productImages!.first.imagepath;
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.w),
      padding: EdgeInsets.all(12.0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16.0.r)),
        border: Border.all(
          color: const Color(0xffEED056).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEED056).withOpacity(0.12),
            offset: Offset(0, 6),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          _configModel.apiConfig['mediaURL'] + imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(Icons.broken_image_rounded,
                                color: Colors.grey.shade400, size: 24.sp),
                          ),
                        )
                      : Center(
                          child: Icon(Icons.image_not_supported_rounded,
                              color: Colors.grey.shade400, size: 24.sp),
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              // Order Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order #${order.id?.toString() ?? 'N/A'}',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff232323),
                          ),
                        ),
                        Text(
                          order.createdAt != null
                              ? _dateFormat.format(
                                  DateTime.parse(order.createdAt.toString()))
                              : 'N/A',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff909090),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.w),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Qty: ',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff909090),
                            ),
                          ),
                          TextSpan(
                            text: () {
                              int totalQty = 0;
                              if (order.orderDetails != null) {
                                for (var detail in order.orderDetails!) {
                                  totalQty += detail.quantity ?? 0;
                                }
                              }
                              return totalQty.toString();
                            }(),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff232323),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.w),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Amount: ',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff909090),
                            ),
                          ),
                          TextSpan(
                            text: order.totalAmount?.toString() ?? '0',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff232323),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.w),
          Divider(height: 1, color: Colors.grey.shade200),
          SizedBox(height: 12.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status,
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: status == 'Delivered'
                      ? Colors.green
                      : status == 'Order Processing'
                          ? Colors.orange
                          : status == 'Cancelled'
                              ? Colors.red
                              : Colors.black,
                ),
              ),
              InkWell(
                onTap: () {
                  final filteredImages = order.orderDetails?.isNotEmpty == true
                      ? order.orderDetails?.first.product?.productImages ?? []
                      : [];
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OrderDetailsPage(
                        arguments: {
                          'order': order.toJson(),
                          'product_images': filteredImages,
                          'status': status,
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                  decoration: BoxDecoration(
                    color: Color(0xFFEED056).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Color(0xFFEED056), width: 1),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Details',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff232323),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.arrow_forward_rounded,
                          size: 14.sp, color: Color(0xff232323)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Removed _getFilteredOrders as logic is moved to _buildOrderList

  String _getOrderStatus(Order order) {
    // If orderStatuses is empty or null, it's "Order Placed"
    if (order.orderStatuses == null || order.orderStatuses!.isEmpty) {
      return 'Order Placed';
    }

    // Get the latest status (last item in the array)
    var latestStatus = order.orderStatuses!.last;
    String? statusName = latestStatus.status?.name;

    // Return the status name if it matches our expected statuses
    if (statusName == 'Cancelled') return 'Cancelled';
    if (statusName == 'Delivered') return 'Delivered';
    if (statusName == 'Order Processing') return 'Order Processing';

    // Default to Order Placed if no specific status found
    return 'Order Placed';
  }
}

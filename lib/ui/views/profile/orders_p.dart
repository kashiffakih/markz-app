import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  final DateFormat _dateFormat = DateFormat('MMMM d, yyyy');
  bool _isPageLoading = false;

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
    final orderModel = Provider.of<OrderModel>(context, listen: false);
    print('Building OrdersPage with ${orderModel.orders.first.id} orders');
    return Scaffold(
      body: PopScope(
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
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 20.0.w),
              child: Column(
                children: [
                  _buildHeader(context),
                  _buildTabBar(context, orderModel),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 10.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.0.w,
              color: const Color(0xffEED056),
            ),
            onPressed: () {
              final isProfile = widget.isProfile?['isProfile'] ?? false;
              Navigator.pushReplacementNamed(
                context,
                isProfile ? '/profilePage' : '/homePage',
              );
            },
          ),
          Expanded(
            child: Text(
              'Orders',
              textAlign: TextAlign.center,
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 18.0.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
          SizedBox(width: 48.0.w),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, OrderModel orderModel) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            labelPadding: EdgeInsets.all(8.0.w),
            indicatorColor: Colors.black,
            isScrollable: true,
            tabs: [
              _buildTab('Order Placed'),
              _buildTab('Processing'),
              _buildTab('Delivered'),
              _buildTab('Cancelled'),
            ],
          ),
          Container(
            height: 0.8.sh,
            child: _isPageLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: [
                      _buildOrderTab(orderModel, 'Order Placed'),
                      _buildOrderTab(orderModel, 'Processing'),
                      _buildOrderTab(orderModel, 'Delivered'),
                      _buildOrderTab(orderModel, 'Cancelled'),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label) {
    return Padding(
      padding: EdgeInsets.all(2.0.w),
      child: Text(
        label,
        style: MyGoogleFontStyle(
          fontFamily: 'Urbanist',
          fontSize: 14.0.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildOrderTab(OrderModel orderModel, String status) {
    final filteredOrders = _getFilteredOrders(orderModel.orders, status);

    if (filteredOrders.isEmpty) {
      return const SizedBox(
        height: 60,
        child: Center(child: Text('No Orders Found')),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: filteredOrders
            .map((order) => _buildOrderCard(order, status))
            .toList(),
      ),
    );
  }

  Widget _buildOrderCard(dynamic order, String status) {
    return Container(
      margin: EdgeInsets.all(10.0.w),
      padding: EdgeInsets.all(10.0.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffc7b456)),
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0.w)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x338a959e),
            offset: Offset(0, 7.6690645218.w),
            blurRadius: 19.1726608276.w,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Order No: ${order.id?.toString() ?? 'N/A'}',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff232323),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  order.createdAt != null
                      ? _dateFormat
                          .format(DateTime.parse(order.createdAt.toString()))
                      : 'N/A',
                  textAlign: TextAlign.right,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff909090),
                  ),
                ),
              ),
            ],
          ),
          Divider(thickness: 1.0.w, color: Colors.grey),
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Quantity: ',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffaaaaaa),
                        ),
                      ),
                      TextSpan(
                        text: () {
                          int totalQty = 0;
                          if (order.orderDetails != null) {
                            for (var detail in order.orderDetails!) {
                              totalQty += (detail.quantity ?? 0) as int;
                            }
                          }
                          return totalQty.toString();
                        }(),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Total Amount: ',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffaaaaaa),
                        ),
                      ),
                      TextSpan(
                        text: order.orderCost?.toString() ?? '0',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0.w),
          Row(
            children: [
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
                          'status': _getOrderStatus(order),
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 74.5.w,
                  height: 30.0.w,
                  decoration: BoxDecoration(
                    color: const Color(0xff232323),
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                  child: Center(
                    child: Text(
                      'Detail',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  _getOrderStatus(order),
                  textAlign: TextAlign.right,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w400,
                    color: _getOrderStatus(order) == 'Delivered'
                        ? Colors.green
                        : _getOrderStatus(order) == 'Order Processing'
                            ? Colors.orange
                            : _getOrderStatus(order) == 'Cancelled'
                                ? Colors.red
                                : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<dynamic> _getFilteredOrders(List<dynamic> orders, String status) {
    return orders.where((order) {
      // Get the current order status based on orderStatuses array
      String orderStatus = _getOrderStatus(order);

      // Match the status with the tab
      if (status == 'Order Placed' && orderStatus == 'Order Placed')
        return true;
      if (status == 'Processing' && orderStatus == 'Order Processing')
        return true;
      if (status == 'Delivered' && orderStatus == 'Delivered') return true;
      if (status == 'Cancelled' && orderStatus == 'Cancelled') return true;

      return false;
    }).toList();
  }

  String _getOrderStatus(dynamic order) {
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

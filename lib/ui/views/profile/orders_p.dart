import 'package:flutter/material.dart';
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
    final double fem = MediaQuery.of(context).size.width / 360;
    final double ffem = fem * 0.97;

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
              padding: EdgeInsets.only(top: 20 * fem),
              child: Column(
                children: [
                  _buildHeader(context, fem, ffem),
                  _buildTabBar(context, orderModel, fem, ffem),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double fem, double ffem) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30 * fem, vertical: 10 * fem),
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

  Widget _buildTabBar(
      BuildContext context, OrderModel orderModel, double fem, double ffem) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            labelPadding: EdgeInsets.all(8 * fem),
            indicatorColor: Colors.black,
            isScrollable: true,
            tabs: [
              _buildTab('Order Placed', fem, ffem),
              _buildTab('Processing', fem, ffem),
              _buildTab('Delivered', fem, ffem),
              _buildTab('Cancelled', fem, ffem),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: _isPageLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: [
                      _buildOrderTab(orderModel, 'Order Placed', fem, ffem),
                      _buildOrderTab(orderModel, 'Processing', fem, ffem),
                      _buildOrderTab(orderModel, 'Delivered', fem, ffem),
                      _buildOrderTab(orderModel, 'Cancelled', fem, ffem),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, double fem, double ffem) {
    return Padding(
      padding: EdgeInsets.all(2 * fem),
      child: Text(
        label,
        style: MyGoogleFontStyle(
          fontFamily: 'Urbanist',
          fontSize: 14 * ffem,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildOrderTab(
      OrderModel orderModel, String status, double fem, double ffem) {
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
            .map((order) => _buildOrderCard(order, status, fem, ffem))
            .toList(),
      ),
    );
  }

  Widget _buildOrderCard(
      dynamic order, String status, double fem, double ffem) {
    return Container(
      height: 120 * fem,
      margin: EdgeInsets.all(10 * fem),
      padding: EdgeInsets.all(10 * fem),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffc7b456)),
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5 * fem)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x338a959e),
            offset: Offset(0, 7.6690645218 * fem),
            blurRadius: 19.1726608276 * fem,
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
                    fontSize: 14 * ffem,
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
                    fontSize: 12 * ffem,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff909090),
                  ),
                ),
              ),
            ],
          ),
          Divider(thickness: 1 * fem, color: Colors.grey),
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
                          fontSize: 12 * ffem,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffaaaaaa),
                        ),
                      ),
                      TextSpan(
                        text: order.orderDetails?.length.toString() ?? '0',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12 * ffem,
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
                          fontSize: 12 * ffem,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffaaaaaa),
                        ),
                      ),
                      TextSpan(
                        text: order.orderCost?.toString() ?? '0',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12 * ffem,
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
          SizedBox(height: 15 * fem),
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
                  width: 74.5 * fem,
                  height: 30 * fem,
                  decoration: BoxDecoration(
                    color: const Color(0xff232323),
                    borderRadius: BorderRadius.circular(8 * fem),
                  ),
                  child: Center(
                    child: Text(
                      'Detail',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12 * ffem,
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
                    fontSize: 14 * ffem,
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

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:aadab/core/models/add_to_cart.dart';
import 'package:aadab/core/models/order.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final ConfigModel _configModel = locator<ConfigModel>();

  Future<bool> placedOrder(
    List<AddToCart> cartItems,
    String cartTotal,
    addressId,
    isGift,
    userWalletUsed,
    couponId,
    paymentOption,
    deliveryMethod,
    couponValue,
  ) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    if (_configModel.user == null) {
      return false;
    }

    if (couponId.toString() == 'null' || couponId == null || couponId == '') {
      couponId = '';
    }
    var orderDetails = [];
    cartItems.forEach((item) {
      debugPrint("Item pack order s :${userWalletUsed}");

      // Get the product image path based on selected flavour
      String? productImagePath;
      if (item.product != null &&
          item.product!.productImages != null &&
          item.flavour != null) {
        try {
          var matchingImage = item.product!.productImages!
              .where((image) => image.unit?.name == item.flavour)
              .toList();
          if (matchingImage.isNotEmpty) {
            productImagePath = matchingImage.first.imagepath;
          }
        } catch (e) {
          debugPrint("Error getting product image: $e");
        }
      }

      // Fallback to primary image if flavour-specific image not found
      if (productImagePath == null && item.product != null) {
        productImagePath = item.product!.imagepath1 ??
            (item.product!.productImages != null &&
                    item.product!.productImages!.isNotEmpty
                ? item.product!.productImages!.first.imagepath
                : null);
      }

      orderDetails.add({
        'cashback': (item.points ?? 0) * (item.qty ?? 0),
        'order_detail_cost': item.productPrice ?? 0.0,
        'product_id': item.productId,
        'quantity': item.qty ?? 0,
        'product_pack': item.pack,
        'kind_of_flower': item.kindOfFlower,
        'flavour': item.flavour,
        'write_on_cake': item.writeOnCake,
        'product_image_path': productImagePath ?? '',
      });
    });

    // Safe parsing of all numeric values
    final parsedCouponValue = int.tryParse(couponValue?.toString() ?? '0') ?? 0;
    final parsedCartTotal =
        double.tryParse(cartTotal?.toString() ?? '0') ?? 0.0;
    final parsedUserWalletUsed =
        double.tryParse(userWalletUsed?.toString() ?? '0') ?? 0.0;
    final parsedAddressId = int.tryParse(addressId?.toString() ?? '0') ?? 0;
    final parsedTaxPercent = double.tryParse(
            _configModel.user?.companies?[0].taxPercent?.toString() ?? '0') ??
        0.0;
    final parsedDeliveryAmount = double.tryParse(
            _configModel.user?.companies?[0].deliveryCharges?.toString() ??
                '0') ??
        0.0;

    // Calculate tax amount
    final taxAmount = (parsedCartTotal / 100) * parsedTaxPercent;

    // Calculate total amount (cart + tax)
    final totalAmount = parsedCartTotal + taxAmount;

    // Calculate order cost (total - wallet - coupon)
    final orderCost =
        (parsedCartTotal - parsedUserWalletUsed.toInt() - parsedCouponValue)
            .toInt();

    Order order = Order(
        couponAmount: parsedCouponValue,
        couponId: couponId,
        deliveryAmount: parsedDeliveryAmount,
        details: '-',
        isApprovedByHotelier: 0,
        orderCost: orderCost,
        packagingAmount: _configModel.user?.companies?[0].packagingCharges ?? 0,
        taxAmount: taxAmount,
        taxPercent: parsedTaxPercent.toString(),
        tipAmount: 0,
        totalAmount: totalAmount,
        totalCashback: 0,
        walletAmountUsed: parsedUserWalletUsed.toInt(),
        userId: _configModel.user?.id ?? 0,
        isDelivered: 0,
        isDeliveryBoyAccepted: 0,
        isDinein: 0,
        storePayableAmount: 0,
        comissionAmount: 0,
        paymentmode: paymentOption.toString(),
        isGift: isGift,
        deliveryMethod: deliveryMethod.toString(),
        addressId: parsedAddressId);

    var _orderJson = order.toJson();
    _orderJson['order_details'] = orderDetails;

    print('Order $_orderJson');
    try {
      http.Response _response = await http.post(
        Uri.parse('${_apiConfig['baseURL']}/orders'),
        body: json.encode(_orderJson),
        headers: _apiConfig['headers'],
      );

      print('Response status: ${_response.statusCode}');
      print('Response body: ${_response.body}');

      if (_response.statusCode == 200 || _response.statusCode == 201) {
        Map<String, dynamic> _responseData = json.decode(_response.body);
        print('Place order: $_responseData');

        // Check if success field exists and return it, otherwise check status code
        if (_responseData.containsKey('success')) {
          return _responseData['success'] == true;
        } else if (_responseData.containsKey('status')) {
          return _responseData['status'] == 'success' ||
              _responseData['status'] == true;
        } else if (_responseData.containsKey('data')) {
          // Sometimes the API returns data object on success
          return _responseData['data'] != null;
        }

        // If response is 200/201 but no explicit success field, assume success
        return true;
      } else {
        print('Order placement failed with status: ${_response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error placing order: $e');
      return false;
    }
  }

  // Future<bool> placedOrder(
  //   List<AddToCart> cartItems,
  //   String cartTotal,
  //   addressId,
  //   isGift,
  //   userWalletUsed,
  //   couponId,
  //   paymentOption,
  //   deliveryMethod,
  //   couponValue,
  // ) async {
  //   Map<String, dynamic> _apiConfig = _configModel.apiConfig;

  //   // Ensure `couponId` is not null or 'null'
  //   if (couponId == null ||
  //       couponId.toString().trim().isEmpty ||
  //       couponId.toString() == 'null') {
  //     couponId = '';
  //   }

  //   var orderDetails = cartItems.map((item) {
  //     debugPrint("Item pack order s :${item.pack}");
  //     return {
  //       'cashback': item.points,
  //       'order_detail_cost': item.productPrice,
  //       'product_id': item.productId,
  //       'quantity': item.qty,
  //       'product_pack': item.pack,
  //       'kind_of_flower': item.kindOfFlower,
  //       'flavour': item.flavour,
  //       'write_on_cake': item.writeOnCake,
  //     };
  //   }).toList();

  //   // Safe Parsing to avoid exceptions
  //   int parsedCouponAmount = int.tryParse(couponValue.toString()) ?? 0;
  //   int parsedCartTotal = int.tryParse(cartTotal.toString()) ?? 0;
  //   int parsedAddressId = int.tryParse(addressId.toString()) ?? 0;
  //   int parsedGst = 5 * parsedCartTotal ~/ 100;
  // double parsedDeliveryAmount = double.tryParse(
  //         _configModel.user?.companies?[0].deliveryCharges?.toString() ??
  //             '0') ??
  //     0.0;
  //   double parsedTaxPercent = double.tryParse(
  //           _configModel.user?.companies?[0].taxPercent?.toString() ?? '0') ??
  //       0.0;
  //   double parsedTaxAmount = (parsedCartTotal / 100) * parsedTaxPercent;
  //   int parsedWalletAmountUsed =
  //       double.tryParse(userWalletUsed.toString())?.toInt() ?? 0;

  //   double parsedTotalAmount = (parsedCartTotal + parsedTaxAmount + parsedGst);

  //   Order order = Order(
  //     couponAmount: parsedCouponAmount,
  //     couponId: couponId,
  //     deliveryAmount: parsedDeliveryAmount,
  //     details: '-',
  //     isApprovedByHotelier: 0,
  //     orderCost: parsedCartTotal,
  //     packagingAmount: _configModel.user?.companies?[0].packagingCharges ?? 0,
  //     taxAmount: parsedTaxAmount,
  //     taxPercent: parsedTaxPercent.toString(),
  //     tipAmount: 0,
  //     totalAmount: parsedTotalAmount,
  //     totalCashback: 0,
  //     walletAmountUsed: parsedWalletAmountUsed,
  //     userId: _configModel.user?.id ?? 0,
  //     isDelivered: 0,
  //     isDeliveryBoyAccepted: 0,
  //     isDinein: 0,
  //     storePayableAmount: 0,
  //     comissionAmount: 0,
  //     paymentmode: paymentOption.toString(),
  //     isGift: isGift,
  //     deliveryMethod: deliveryMethod.toString(),
  //     addressId: parsedAddressId,
  //   );

  //   var _orderJson = order.toJson();
  //   _orderJson['order_details'] = orderDetails;

  //   http.Response _response = await http.post(
  //     Uri.parse('${_apiConfig['baseURL']}/orders'),
  //     body: json.encode(_orderJson),
  //     headers: _apiConfig['headers'],
  //   );

  //   Map<String, dynamic> _responseData = json.decode(_response.body);
  //   print('Place order: $_responseData');

  //   return _responseData['success'] ?? false;
  // }

  List<Order> _orders = [];

  getOrders() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    if (_configModel.user == null) {
      debugPrint('getOrders: User is null');
      return <Order>[];
    }

    try {
      var userId = _configModel.user!.id;
      debugPrint('getOrders: Fetching orders for userId=$userId');
      debugPrint(
          'getOrders: API URL = ${_apiConfig['baseURL']}/orders?userId=$userId');

      http.Response _response = await http.get(
        Uri.parse('${_apiConfig['baseURL']}/orders?userId=$userId'),
        headers: _apiConfig['headers'],
      );

      debugPrint('getOrders: Response status code = ${_response.statusCode}');
      debugPrint('getOrders: Response body = ${_response.body}');

      if (_response.statusCode == 200) {
        Map<String, dynamic> _responseData = json.decode(_response.body);

        // Handle different API response formats
        bool hasSuccess = _responseData.containsKey('success') &&
            _responseData['success'] == true;
        bool hasData = _responseData.containsKey('data');

        debugPrint('getOrders: hasSuccess=$hasSuccess, hasData=$hasData');

        if (hasSuccess && hasData) {
          _orders = [];
          var dataList = _responseData['data'];

          if (dataList is List) {
            debugPrint(
                'getOrders: Found ${dataList.length} orders in API response');
            int successCount = 0;
            int failCount = 0;

            for (int i = 0; i < dataList.length; i++) {
              try {
                final data = dataList[i];
                _orders.add(Order.fromJson(data));
                successCount++;
                debugPrint(
                    'getOrders: Successfully added order #${i + 1} - ID: ${data['id']}');
              } catch (e, stackTrace) {
                failCount++;
                debugPrint('getOrders: ERROR parsing order #${i + 1}');
                debugPrint('getOrders: Error details: $e');
                debugPrint('getOrders: Order data: ${dataList[i]}');
                debugPrint('getOrders: Stack trace: $stackTrace');
              }
            }

            debugPrint(
                'getOrders: Summary - Success: $successCount, Failed: $failCount');
          } else {
            debugPrint('getOrders: Data is not a list');
          }
        } else if (hasData && !hasSuccess) {
          // Try to parse data even if success field is missing
          _orders = [];
          var dataList = _responseData['data'];

          if (dataList is List) {
            debugPrint(
                'getOrders: Found ${dataList.length} orders (no success field)');
            int successCount = 0;
            int failCount = 0;

            for (int i = 0; i < dataList.length; i++) {
              try {
                final data = dataList[i];
                _orders.add(Order.fromJson(data));
                successCount++;
                debugPrint(
                    'getOrders: Successfully added order #${i + 1} - ID: ${data['id']}');
              } catch (e, stackTrace) {
                failCount++;
                debugPrint('getOrders: ERROR parsing order #${i + 1}');
                debugPrint('getOrders: Error details: $e');
                debugPrint('getOrders: Order data: ${dataList[i]}');
                debugPrint('getOrders: Stack trace: $stackTrace');
              }
            }

            debugPrint(
                'getOrders: Summary - Success: $successCount, Failed: $failCount');
          }
        } else {
          debugPrint('getOrders: No valid data found in response');
        }
      } else {
        debugPrint(
            'getOrders: Failed with status code ${_response.statusCode}');
      }

      if (_orders.isNotEmpty) {
        debugPrint('getOrders: Successfully loaded ${_orders.length} orders');
        if (_orders.first.orderDetails != null &&
            _orders.first.orderDetails!.isNotEmpty) {
          final firstOrderDetail = _orders.first.orderDetails!.first;
          if (firstOrderDetail.product?.productImages != null &&
              firstOrderDetail.product!.productImages!.isNotEmpty) {
            debugPrint(
                "getOrders: First order image path = ${firstOrderDetail.product!.productImages!.first.imagepath}");
          }
        }
      } else {
        debugPrint('getOrders: No orders found');
      }
    } catch (e) {
      debugPrint('getOrders: Exception occurred - $e');
    }

    return _orders;
  }

  // Check coupon usage count for current user
  Future<int> getCouponUsageCount(String couponId) async {
    try {
      Map<String, dynamic> _apiConfig = _configModel.apiConfig;

      if (_configModel.user == null || couponId.isEmpty) {
        return 0;
      }

      var userId = _configModel.user!.id;
      http.Response _response = await http.get(
        Uri.parse(
            '${_apiConfig['baseURL']}/orders/coupon-usage?userId=$userId&couponId=$couponId'),
        headers: _apiConfig['headers'],
      );

      if (_response.statusCode == 200) {
        Map<String, dynamic> _responseData = json.decode(_response.body);
        return _responseData['count'] ?? 0;
      }

      // If API endpoint doesn't exist, count from local orders
      await getOrders();
      int count = 0;
      for (var order in _orders) {
        if (order.couponId == couponId) {
          count++;
        }
      }
      return count;
    } catch (e) {
      debugPrint('Error getting coupon usage count: $e');
      return 0;
    }
  }

  // Cancel order
  Future<bool> cancelOrder(int orderId) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    if (_configModel.user == null) {
      debugPrint('cancelOrder: User is null');
      return false;
    }

    try {
      debugPrint('cancelOrder: Cancelling order $orderId');

      final response = await http.post(
        Uri.parse('${_apiConfig['baseURL']}/orders/$orderId/order_statuses'),
        headers: _apiConfig['headers'],
        body: jsonEncode({
          'status_id': '8', // Cancelled status ID
          'date': DateTime.now().toIso8601String(),
        }),
      );

      debugPrint('cancelOrder: Response status code = ${response.statusCode}');
      debugPrint('cancelOrder: Response body = ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Try to parse response and check for success
        try {
          Map<String, dynamic> responseData = json.decode(response.body);

          // Check various success indicators
          if (responseData.containsKey('success')) {
            return responseData['success'] == true;
          } else if (responseData.containsKey('status')) {
            return responseData['status'] == 'success' ||
                responseData['status'] == true;
          }

          // If no explicit success field but status is 200/201, assume success
          return true;
        } catch (e) {
          debugPrint(
              'cancelOrder: Could not parse response, assuming success based on status code');
          return true;
        }
      } else {
        debugPrint(
            'cancelOrder: Failed with status code ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('cancelOrder: Exception occurred - $e');
      return false;
    }
  }
}

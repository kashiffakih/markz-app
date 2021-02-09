import 'package:flutter/material.dart';
import 'package:sales_app/core/models/my_order.dart';
import 'package:sales_app/core/models/order.dart' as or;
import 'package:sales_app/core/models/sku.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/services/my_order_s.dart';
import 'package:sales_app/locator.dart';

class MyOrderModel with ChangeNotifier {
  final ConfigModel _configModel = locator<ConfigModel>();
  final MyOrderService _myOrderService = locator<MyOrderService>();

  // Order
  MyOrder order;

  // Update Order
  updateOrder({@required int retailerId}) {
    User user = _configModel.user;

    order = MyOrder(
      userId: user.id,
      distributorId: user.distributor?.id,
      retailerId: retailerId,
      total: 0,
      status: 0,
      isOrderTaken: 1,
      reasonForNoOrder: '',
      orderDetails: [],
    );
    notifyListeners();
  }

  addNoOrderReason({@required reason}) {
    order.isOrderTaken = 0;
    order.reasonForNoOrder = reason;
  }

  addOrUpdateOrderDetail({
    @required Sku sku,
    @required int qty,
  }) {
    int value = 0;
    if (sku.offerPrice != null)
      value = qty * sku.offerPrice;
    else
      value = qty * sku.price;

    // Check if orderDetail is already there or not
    OrderDetails _orderDetail = order.orderDetails.length > 0
        ? order.orderDetails.firstWhere((_detail) => _detail.skuId == sku.id,
            orElse: () => null)
        : null;

    // Add or update orderDetail
    if (_orderDetail != null) {
      _orderDetail.qty = qty;
      _orderDetail.value = value;
    } else {
      _orderDetail = OrderDetails(
        sku: sku,
        skuId: sku.id,
        qty: qty,
        value: value,
      );
      order.orderDetails.add(_orderDetail);
    }

    // Remove sku with 0 qty
    if (_orderDetail.value == 0) {
      order.orderDetails = order.orderDetails
          .where((_detail) => _detail.skuId != _orderDetail.skuId)
          .toList();
    }

    // Calculate total
    order.total = 0;
    order.orderDetails.forEach((_detail) {
      order.total += _detail.value;
    });
    if (order.orderDetails.length == 0) order.total = 0;
    notifyListeners();
  }

  saveOrder() {
    _myOrderService.saveOrder(
      order: order,
    );
  }

  updatePreviousOrder({@required or.Order order}) {
    _myOrderService.updatePreviousOrder(order: order);
  }

  emptyOrder() {
    order = null;
    notifyListeners();
  }
}

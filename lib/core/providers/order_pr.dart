import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_app/core/models/order.dart';
import 'package:sales_app/core/models/reason.dart';
import 'package:sales_app/core/services/order_s.dart';
import 'package:sales_app/locator.dart';

class OrderModel with ChangeNotifier {
  final OrderService _orderService = locator<OrderService>();

  // List of reasons
  late List<Reason> _reasons;

  set reasons(List<Reason> newReasons) {
    _reasons = newReasons;
    notifyListeners();
  }

  List<Reason> get reasons => _reasons;

  Future<void> getReasons() async {
    _reasons = await _orderService.getReasons();
  }

  // List of orders of a user of today
  bool ordersLoader = true;

  late List<Order> _orders = [];

  set orders(List<Order> newOrders) {
    _orders = newOrders;
    ordersLoader = false;
    notifyListeners();
  }

  List<Order> get orders => _orders;

  fetchOrdersOfToday() async {
    DateFormat format = DateFormat('yyyy-MM-dd');
    String date = format.format(DateTime.now());

    orders = await _orderService.fetchOrdersOfToday(
      date: date,
    );
  }

  fetchOrdersOfMonth(
      {@required monthId, @required year, @required dataType}) async {
    ordersLoader = true;
    notifyListeners();
    orders = await _orderService.fetchOrdersOfMonth(
      monthId: monthId,
      year: year,
      orderType: dataType,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sales_app/core/models/sku.dart';
import 'package:sales_app/core/services/sku_s.dart';
import 'package:sales_app/locator.dart';

class SkuModel with ChangeNotifier {
  final _referencePlanService = locator<SkuService>();

  // Get reference plans
  List<Sku>? _sku;

  set skus(List<Sku>? newSku) {
    _sku = newSku;
    notifyListeners();
  }

  List<Sku>? get skus => _sku;

  Future<void> getSkus() async {
    skus = await _referencePlanService.getSkus();
  }
}

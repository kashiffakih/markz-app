import 'package:flutter/material.dart';
import 'package:sales_app/core/models/sku_availability.dart';
import 'package:sales_app/core/services/sku_availability_s.dart';
import 'package:sales_app/locator.dart';

class SkuAvailabilityModel with ChangeNotifier {
  final SkuAvailabilityService _skuAvailabilityService =
      locator<SkuAvailabilityService>();

  // Update Sku Availability
  updateSkuAvailability({@required Map<String, dynamic>? skuAvailability}) {
    _skuAvailabilityService.updateSkuAvailability(
      skuAvailability: skuAvailability,
    );
  }

  // List of SKU Availabilities
  late List<SkuAvailability> _skuAvailabilities;

  set skuAvailabilities(List<SkuAvailability> neSkuAvailabilities) {
    _skuAvailabilities = neSkuAvailabilities;
    notifyListeners();
  }

  List<SkuAvailability> get skuAvailabilities => _skuAvailabilities;

  getSkuAvailabilities({@required retailerId}) async {
    skuAvailabilities = await _skuAvailabilityService.getSkuAvailabilities(
      retailerId: retailerId,
    );
  }
}

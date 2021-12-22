import 'package:flutter/material.dart';
import 'package:sales_app/core/models/asset.dart';
import 'package:sales_app/core/services/manufacturer_s.dart';
import 'package:sales_app/locator.dart';

class ManufacturerModel with ChangeNotifier {
  final ManufacturerService _manufacturerService =
      locator<ManufacturerService>();

  // Manufacturers
  late List<Manufacturer> _manufacturers;

  set manufacturers(List<Manufacturer> newNotices) {
    _manufacturers = newNotices;
    notifyListeners();
  }

  List<Manufacturer> get manufacturers => _manufacturers;

  getManufacturers() async {
    manufacturers = await _manufacturerService.getManufacturers();
  }
}

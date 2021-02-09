import 'package:flutter/material.dart';
import 'package:sales_app/core/services/device_info_s.dart';
import 'package:sales_app/locator.dart';

class DeviceInfoModel with ChangeNotifier {
  final _deviceInfoService = locator<DeviceInfoService>();

  // Battery Level
  int _batteryLevel;

  set batteryLevel(int newBatteryLevel) {
    _batteryLevel = newBatteryLevel;
    notifyListeners();
  }

  int get batteryLevel => _batteryLevel;

  Future<void> getBatteryLevel() async {
    batteryLevel = await _deviceInfoService.getBatteryLevel();
  }
}

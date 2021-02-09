import 'package:battery/battery.dart';

class DeviceInfoService {
  Future<int> getBatteryLevel() async {
    var _battery = Battery();

    return await _battery.batteryLevel;
  }
}

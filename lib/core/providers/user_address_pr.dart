import 'package:flutter/material.dart';
import 'package:sales_app/core/models/user_address.dart';
import 'package:sales_app/core/services/user_address_s.dart';
import 'package:sales_app/locator.dart';

class UserAddressModel with ChangeNotifier {
  final UserAddressService _userAddressService = locator<UserAddressService>();

  bool userAddressesLoader = true;

  List<UserAddress>? _userAddresses;

  set userAddresses(List<UserAddress>? newUserAddresses) {
    _userAddresses = newUserAddresses;
    userAddressesLoader = false;
    notifyListeners();
  }

  List<UserAddress>? get userAddresses => _userAddresses;

  getUserAddresses() async {
    userAddresses = await _userAddressService.getUserAddresses();
  }

  Future<bool> saveUserAddress({@required UserAddress? userAddress}) async {
    return await _userAddressService.saveUserAddress(userAddress: userAddress);
  }

  Future<bool> updateUserAddress({@required UserAddress? userAddress}) async {
    return await _userAddressService.updateUserAddress(
        userAddress: userAddress);
  }
}

import 'package:flutter/material.dart';
import 'package:aadab/core/models/user_wallet.dart';
import 'package:aadab/core/services/user_wallet_s.dart';
import 'package:aadab/locator.dart';

class UserWalletModel with ChangeNotifier {
  final UserWalletService _userWalletService = locator<UserWalletService>();

  bool userWalletLoader = true;

  List<UserWallet>? _userWallets;

  set userWallets(List<UserWallet>? newUserWallet) {
    _userWallets = newUserWallet;
    userWalletLoader = false;
    notifyListeners();
  }

  List<UserWallet>? get userWallets => _userWallets;
  var totalPoint = 0;
  var totalEarnPoint = 0;
  var totalUsedPoint = 0;
  var totaRemainingPoint = 0;

  getMyUserWallets() async {
    userWalletLoader = true;
    notifyListeners();

    Map<String, dynamic> _response =
        await _userWalletService.getMyUserWallets();
    // print(_response['data']);
    _userWallets = _response['data'];
    totalPoint = _response['total_points'];
    totalEarnPoint = _response['total_earn_points'];
    totalUsedPoint = _response['total_used_points'];
    totaRemainingPoint = _response['remaining_points'];

    userWalletLoader = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> mapRedeemReferralCode(
      String referralCode) async {
    return await _userWalletService.mapRedeemReferralCode(referralCode);
  }
}

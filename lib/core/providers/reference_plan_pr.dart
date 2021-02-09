import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/reference_plan.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/location_pr.dart';
import 'package:sales_app/core/services/reference_plan_s.dart';
import 'package:sales_app/locator.dart';

class ReferencePlanModel with ChangeNotifier {
  final _referencePlanService = locator<ReferencePlanService>();
  final _locationModel = LocationModel();
  final ConfigModel _configModel = locator<ConfigModel>();

  // Get reference plans
  List<ReferencePlan> _referencePlans;

  set referencePlans(List<ReferencePlan> newReferencePlans) {
    _referencePlans = newReferencePlans;
    notifyListeners();
  }

  List<ReferencePlan> get referencePlans => _referencePlans;

  Future<void> getReferencePlans() async {
    referencePlans = await _referencePlanService.getReferencePlans();
  }

  // Add retailer image
  addRetailerImage({@required Retailers retailer}) async {
    await _locationModel.getCurrentLocation();
    print(_locationModel.currentLocation);

    await _referencePlanService.addRetailerImage(
      retailer: retailer,
      lat: _locationModel.currentLocation.lat,
      lng: _locationModel.currentLocation.lng,
    );
    await this.getReferencePlans();
    _configModel.file = null;
    notifyListeners();
  }
}

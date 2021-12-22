import 'package:flutter/material.dart';
import 'package:sales_app/core/models/asset.dart';
import 'package:sales_app/core/models/asset_status.dart';
import 'package:sales_app/core/services/asset_s.dart';
import 'package:sales_app/locator.dart';

class AssetModel with ChangeNotifier {
  final AssetService _assetService = locator<AssetService>();

  // List of assets
  late List<Asset> _assets;

  set assets(List<Asset> newAssets) {
    _assets = newAssets;
    notifyListeners();
  }

  List<Asset> get assets => _assets;

  getAssets() async {
    assets = await _assetService.getAssets();
  }

  // Create a new asset
  Future<void> assetCreate({required Asset asset}) async {
    await _assetService.assetCreate(asset: asset);
  }

  // Update a new asset
  Future<void> assetUpdate({required Asset asset}) async {
    await _assetService.assetUpdate(asset: asset);
  }

  // Create a new asset status
  assetStatusCreate(
      {required Asset asset, required AssetStatus assetStatus}) async {
    await _assetService.assetStatusCreate(
      asset: asset,
      assetStatus: assetStatus,
    );
  }
}

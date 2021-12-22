import 'package:flutter/material.dart';
import 'package:sales_app/core/models/daily_photo.dart';
import 'package:sales_app/core/services/daily_photo_s.dart';
import 'package:sales_app/locator.dart';

class DailyPhotoModel with ChangeNotifier {
  final DailyPhotoService _dailyPhotoService = locator<DailyPhotoService>();

  // List of Daily Photos
  bool dailyPhotosLoader = true;

  List<DailyPhoto> _dailyPhotos = [];
  set dailyPhotos(List<DailyPhoto> newDailyPhotos) {
    _dailyPhotos = newDailyPhotos;
    dailyPhotosLoader = false;
    notifyListeners();
  }

  List<DailyPhoto> get dailyPhotos => _dailyPhotos;

  getDailyPhotos({@required date}) async {
    dailyPhotos = await _dailyPhotoService.getDailyPhotos(date: date);
  }

  Future<void> dailyPhotoCreate({@required DailyPhoto? dailyPhoto}) async {
    await _dailyPhotoService.dailyPhotoCreate(dailyPhoto: dailyPhoto);
  }
}

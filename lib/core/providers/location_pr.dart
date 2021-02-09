import 'package:flutter/material.dart';
import 'package:sales_app/core/models/location.dart';
import 'package:sales_app/core/services/location_s.dart';

class LocationModel with ChangeNotifier {
  final LocationService _locationService = LocationService();

  // Current Location
  Location _currentLocation;

  set currentLocation(Location newLocation) {
    _currentLocation = newLocation;
    notifyListeners();
  }

  Location get currentLocation => _currentLocation;

  Future<void> getCurrentLocation() async {
    currentLocation = await _locationService.getCurrentLocation();
  }

  // Current Address
  String _address;

  set address(String newAddress) {
    _address = newAddress;
    notifyListeners();
  }

  String get address => _address;

  getLocationAddress({@required latitude, @required longitude}) async {
    String _strAddress = await _locationService.getLocationAddress(
      latitude: latitude,
      longitude: longitude,
    );

    if (_strAddress == 'Geolocation not found') {
      address = 'Latitude: $latitude, Longitude: $longitude';
    } else {
      address = _strAddress;
    }
  }
}

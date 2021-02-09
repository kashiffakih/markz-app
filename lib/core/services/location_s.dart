import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:sales_app/core/models/location.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationService {
  final ConfigModel _configModel = locator<ConfigModel>();

  Location _currentLocation;

  Future<Location> getCurrentLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _currentLocation = Location(
      lat: position.latitude.toString(),
      lng: position.longitude.toString(),
    );
    return _currentLocation;
  }

  Future<String> getLocationAddress(
      {@required latitude, @required longitude}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    http.Response _response = await http.get(
      'https://test.easyhrworld.com/api/v2/attendance/getGeoLocation?lat=$latitude&log=$longitude',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-API-KEY': '356a192b7913b04c54574d18c28d46e6395428ab',
      },
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);

    return _responseData['address'];
  }
}

import 'dart:convert';

import 'package:sales_app/core/models/review.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  final ConfigModel _configModel = locator<ConfigModel>();
  List<Review> _reviews = [];

  Future<List<Review>> getMyReviews([productId, description]) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var userId = _configModel.user.id;

    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/review?userId=$userId&productId=$productId&description=$description'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);
    if (_responseData['success']) {
      _reviews = [];
      _responseData['data'].forEach((data) {
        _reviews.add(Review.fromJson(data));
      });
    }
    return _reviews;
  }
}

import 'dart:convert';
import 'dart:io' as io;

import 'package:aadab/core/models/review.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  final ConfigModel _configModel = locator<ConfigModel>();
  List<Review> _reviews = [];

  Future<List<Review>> getMyReviews(
      [productId,
      productPackId,
      description,
      rating,
      List<String>? images,
      onlyFetch]) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    print(
        'ReviewService - productId: $productId, description: $description, rating: $rating, images: ${images?.length}, onlyFetch: $onlyFetch');

    // Only require user for posting/updating reviews, not for fetching
    var userId = _configModel.user?.id;

    // Handle review submission (with or without images)
    if (onlyFetch != true) {
      // Can't submit reviews without being logged in
      if (userId == null) {
        print('User must be logged in to submit reviews');
        return <Review>[];
      }

      print('chutiaa');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${_apiConfig['baseURL']}/review'),
      );

      // Add form fields
      request.fields['userId'] = userId.toString();
      request.fields['productId'] = productId.toString();
      request.fields['product_pack_id'] = productPackId.toString();
      request.fields['description'] = description.toString();
      request.fields['rating'] = rating.toString();

      // Add multiple images if provided
      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          io.File file = io.File(images[i]);
          if (await file.exists()) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'attachments[]', // Use array notation for multiple files
                images[i],
                filename:
                    'review_image_${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
              ),
            );
          }
        }
      }

      // Don't override Content-Type for multipart requests
      Map<String, String> headers =
          Map<String, String>.from(_apiConfig['headers']);
      headers.remove(
          'Content-Type'); // Let the multipart request set its own content type
      request.headers.addAll(headers);

      print('Sending review with fields: ${request.fields}');
      print('Files count: ${request.files.length}');

      http.StreamedResponse response = await request.send();
      http.Response responseData = await http.Response.fromStream(response);

      print('Review submission status: ${responseData.statusCode}');
      print('Review submission response: ${responseData.body}');

      // Parse the response to check for success
      // try {
      Map<String, dynamic> submitResponse = json.decode(responseData.body);
      if (submitResponse['success']) {
        _reviews = [];
        submitResponse['data'].forEach((data) {
          _reviews.add(Review.fromJson(data));
        });
        print('Review submitted successfully');
      } else {
        print(
            'Review submission failed: ${submitResponse['message'] ?? 'Unknown error'}');
      }
      // } catch (e) {
      //   print('Error parsing review submission response: $e');
      // }
    } else {
      print('Ayaya ayaha pe');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${_apiConfig['baseURL']}/review'),
      );

      // Add form fields
      // For fetching reviews, userId is optional (guests can view reviews)
      if (userId != null) {
        request.fields['userId'] = userId.toString();
      }
      request.fields['product_pack_id'] = productPackId.toString();
      request.fields['productId'] = productId.toString();
      request.fields['isOnlyFetch'] = '1';

      Map<String, String> headers =
          Map<String, String>.from(_apiConfig['headers']);
      headers.remove(
          'Content-Type'); // Let the multipart request set its own content type
      request.headers.addAll(headers);

      print('Sending review with fields: ${request.fields}');
      print('Files count: ${request.files.length}');

      http.StreamedResponse response = await request.send();
      http.Response responseData = await http.Response.fromStream(response);

      print('Review submission status: ${responseData.statusCode}');
      print('Review submission response: ${responseData.body}');

      // Parse the response to check for success
      // try {
      Map<String, dynamic> submitResponse = json.decode(responseData.body);
      print('Ha bhahhhhh ${submitResponse}');
      if (submitResponse['success']) {
        _reviews = [];
        submitResponse['data'].forEach((data) {
          _reviews.add(Review.fromJson(data));
        });
        print('Review submitted successfully');
      } else {
        print(
            'Review submission failed: ${submitResponse['message'] ?? 'Unknown error'}');
      }
      // } catch (e) {
      //   print('Error parsing review submission response: $e');
      // }
    }

    return _reviews;
  }

  // Method specifically for fetching reviews (guests allowed)
  Future<List<Review>> fetchProductReviews(productId, [productPackId]) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    print('Fetching reviews for product: $productId, pack: $productPackId');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${_apiConfig['baseURL']}/review'),
      );

      // Add form fields
      request.fields['productId'] = productId.toString();
      if (productPackId != null && productPackId != '') {
        request.fields['product_pack_id'] = productPackId.toString();
      }
      request.fields['isOnlyFetch'] = '1';

      // Add userId if user is logged in
      if (_configModel.user != null) {
        request.fields['userId'] = _configModel.user!.id.toString();
      }

      Map<String, String> headers =
          Map<String, String>.from(_apiConfig['headers']);
      headers.remove('Content-Type');
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      http.Response responseData = await http.Response.fromStream(response);

      print('Fetch reviews status: ${responseData.statusCode}');
      print('Fetch reviews response: ${responseData.body}');

      Map<String, dynamic> submitResponse = json.decode(responseData.body);
      if (submitResponse['success'] == true) {
        _reviews = [];
        if (submitResponse['data'] != null) {
          submitResponse['data'].forEach((data) {
            _reviews.add(Review.fromJson(data));
          });
        }
        print('Reviews fetched successfully: ${_reviews.length} reviews');
      } else {
        print(
            'Failed to fetch reviews: ${submitResponse['message'] ?? 'Unknown error'}');
        _reviews = [];
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      _reviews = [];
    }

    return _reviews;
  }
}

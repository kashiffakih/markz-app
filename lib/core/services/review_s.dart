import 'dart:convert';
import 'dart:io';

import 'package:sales_app/core/models/review.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  final ConfigModel _configModel = locator<ConfigModel>();
  List<Review> _reviews = [];

  Future<List<Review>> getMyReviews([productId, description, rating]) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    var userId = _configModel.user.id;
    print('rating $rating');
    // _configModel.files.forEach((imageFile) async {
    // if (imageFile.file != null) {
// Add each image file to the request
    // for (String filePath in _configModel.files) {
    //   File file = File(filePath);
    //   if (await file.exists()) {
    //     // Add the image file to the request
    //     request.files.add(
    //       await http.MultipartFile.fromPath(
    //         'attachments[]', // Use [] to indicate array in multipart request
    //         filePath,
    //       ),
    //     );
    //   }
    // }

    _configModel.files.forEach((element) async {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${_apiConfig['baseURL']}/review'),
      )
        ..fields['userId'] = userId.toString()
        ..fields['productId'] = productId.toString()
        ..fields['description'] = description.toString()
        ..fields['rating'] = rating.toString()
        ..fields['filename'] = element.fileName ?? ''
        ..files.add(
          await http.MultipartFile.fromPath(
            'attachment',
            element.file.toString(),
          ),
        )
        ..headers.addAll(_apiConfig['headers']);
      http.StreamedResponse _res = await request.send();
      http.Response _responseImage = await http.Response.fromStream(_res);
      // Clear the file reference after uploading
      element.file = null;
      print('Image');
      print(_responseImage.body);
    });
    // }
    // });

    http.Response _response = await http.post(
      Uri.parse('${_apiConfig['baseURL']}/review?userId=$userId'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);

    print("Review ${_responseData['data'][0]['review_images']}");
    if (_responseData['success']) {
      _reviews = [];
      _responseData['data'].forEach((data) {
        _reviews.add(Review.fromJson(data));
      });
    }

    return _reviews;
  }
}

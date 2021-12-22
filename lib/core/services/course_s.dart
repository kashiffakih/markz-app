import 'dart:convert';

import 'package:sales_app/core/models/course.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;

class CourseService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Courses
  late List<Course> _courses;

  Future<List<Course>> getCourses() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/courses'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);
    if (_responseData['success']) {
      _courses = [];
      _responseData['data'].forEach((_course) {
        _courses.add(Course.fromJson(_course));
      });
    }

    return _courses;
  }
}

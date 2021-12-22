import 'package:flutter/material.dart';
import 'package:sales_app/core/models/course.dart';
import 'package:sales_app/core/services/course_s.dart';
import 'package:sales_app/locator.dart';

class CourseModel with ChangeNotifier {
  final CourseService _courseService = locator<CourseService>();

  // Courses
  List<Course>? _courses;

  set courses(List<Course>? newCourses) {
    _courses = newCourses;
    notifyListeners();
  }

  List<Course>? get courses => _courses;

  getCourses() async {
    courses = await _courseService.getCourses();
  }
}

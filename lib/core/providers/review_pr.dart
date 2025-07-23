import 'package:flutter/material.dart';
import 'package:aadab/core/models/review.dart';
import 'package:aadab/core/services/review_s.dart';
import 'package:aadab/locator.dart';

class ReviewModel with ChangeNotifier {
  final ReviewService _reviewService = locator<ReviewService>();

  bool reviewLoader = true;

  List<Review>? _reviews;

  set reviews(List<Review>? newReview) {
    _reviews = newReview;
    reviewLoader = false;
    notifyListeners();
  }

  List<Review>? get reviews => _reviews;
  getMyReviews(productId, description, rating) async {
    reviews = await _reviewService.getMyReviews(productId, description, rating);
  }

  getReviews(productId) async {
    print('ha bhai');
    bool onlyFetch = true;
    reviews = await _reviewService.getMyReviews(productId, '', '', onlyFetch);
  }
}

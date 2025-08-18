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
  getMyReviews(productId, productPackId, description, rating,
      [List<String>? images]) async {
    reviews = await _reviewService.getMyReviews(
        productId, productPackId, description, rating, images ?? [], false);
  }

  getReviews(productId) async {
    print('ha bhai');
    bool onlyFetch = true;
    reviews = await _reviewService.getMyReviews(
        productId, '', '', '', null, onlyFetch);
  }

  getReviewsByProductPack(productId, productPackId) async {
    print('Fetching reviews for product pack: $productPackId');
    bool onlyFetch = true;
    reviews = await _reviewService.getMyReviews(
        productId, productPackId, '', '', null, onlyFetch);
  }

  // Method for fetching reviews that works for both logged in and guest users
  fetchReviewsForGuests(productId, [productPackId]) async {
    print('Fetching reviews for guests - productId: $productId, packId: $productPackId');
    reviews = await _reviewService.fetchProductReviews(productId, productPackId);
  }
}

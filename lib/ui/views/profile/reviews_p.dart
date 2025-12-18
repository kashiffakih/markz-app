import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aadab/core/models/review.dart';
import 'package:aadab/ui/views/products/product_id_p.dart';
import 'package:aadab/ui/views/profile/review_id_p.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/review_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/widgets/image_zoom_w.dart';

class ReviewsPage extends StatefulWidget {
  final arguments;

  const ReviewsPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final DateFormat _dateFormat = DateFormat('MMMM d, yyyy');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final reviewModel = Provider.of<ReviewModel>(context, listen: false);
    final productId = widget.arguments?['productId']?.toString() ?? '';
    final productPackId = widget.arguments?['productPackId']?.toString() ?? '';
    setState(() => _isLoading = true);
    try {
      if (widget.arguments?['is_edit'] == false) {
        await reviewModel.fetchReviewsForGuests(productId, productPackId);
      } else {
        await reviewModel.getMyReviews('', productId, '', '', []);
      }
    } catch (e) {
      // Handle error silently
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewModel = Provider.of<ReviewModel>(context, listen: false);
    final configModel = locator<ConfigModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFEF9),
              Color(0xFFFFFDF7),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar with gradient
              _buildAppBar(context, reviewModel),

              // Content
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : reviewModel.reviews == null ||
                            reviewModel.reviews!.isEmpty
                        ? _buildEmptyState()
                        : _buildReviewsList(reviewModel, configModel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ReviewModel reviewModel) {
    final totalReviews = reviewModel.reviews?.length ?? 0;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEED056),
            Color(0xFFF6E27F),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEED056).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                ),
              ),

              // Title
              Column(
                children: [
                  Text(
                    'Customer Reviews',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.w),
                  if (!_isLoading && totalReviews > 0)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '$totalReviews ${totalReviews == 1 ? 'Review' : 'Reviews'}',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),

              // Placeholder for symmetry
              SizedBox(width: 38.w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFEED056).withOpacity(0.15),
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEED056)),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 24.w),
          Text(
            'Loading reviews...',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xff232323),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(30.w),
            decoration: BoxDecoration(
              color: Color(0xFFEED056).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rate_review_outlined,
              size: 60.sp,
              color: Color(0xFFEED056),
            ),
          ),
          SizedBox(height: 24.w),
          Text(
            'No Reviews Yet',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xff232323),
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            'Be the first to share your experience!',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff909090),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList(ReviewModel reviewModel, ConfigModel configModel) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: reviewModel.reviews!.length,
      itemBuilder: (context, index) {
        final review = reviewModel.reviews![index];
        return _buildReviewCard(
          review: review,
          configModel: configModel,
          dateFormat: _dateFormat,
          onTap: () {
            final createdAt = DateTime.tryParse(review.createdAt.toString());
            final daysDifference = createdAt != null
                ? DateTime.now().difference(createdAt).inDays
                : 31;
            if (daysDifference <= 30 && widget.arguments['is_edit'] == true) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReviewUpdatePage(
                    arguments: {'review': review},
                  ),
                ),
              );
            } else if (widget.arguments['is_popup'] != false) {
              _showReviewUpdatePopup(context);
            }
          },
        );
      },
    );
  }

  Widget _buildReviewCard({
    required Review review,
    required ConfigModel configModel,
    required DateFormat dateFormat,
    required VoidCallback onTap,
  }) {
    final firstImage = review.product?.imagepath1;
    final rating = double.tryParse(review.rating?.toString() ?? '') ?? 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFEED056).withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Product Info Header
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFFEF9),
                    Colors.white,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  GestureDetector(
                    onTap: () {
                      if (review.product != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductIdPage(arguments: {
                              'product': review.product?.toJson(),
                              'product_images': review.product?.productImages
                            }),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Color(0xFFEED056).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: firstImage != null
                            ? Image.network(
                                configModel.apiConfig['mediaURL'] + firstImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.image_not_supported,
                                        color: Colors.grey[400], size: 30.sp),
                              )
                            : Icon(Icons.image_not_supported,
                                color: Colors.grey[400], size: 30.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.product?.name?.toString() ?? 'Unknown Product',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff232323),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.w),

                        // Rating Stars
                        Row(
                          children: [
                            RatingBarIndicator(
                              itemSize: 18.w,
                              rating: rating,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, _) => Icon(
                                Icons.star_rounded,
                                color: Color(0xFFEED056),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 2.w),
                              decoration: BoxDecoration(
                                color: Color(0xFFEED056).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                rating.toStringAsFixed(1),
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFD4A840),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Edit indicator for editable reviews
                  if (widget.arguments?['is_edit'] == true)
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Color(0xFFEED056).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 18.sp,
                        color: Color(0xFFEED056),
                      ),
                    ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: Color(0xFFEED056).withOpacity(0.1),
            ),

            // Review Content
            Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info and date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFEED056), Color(0xFFF6E27F)],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                (review.user?.firstName?.toString() ?? 'A')[0]
                                    .toUpperCase(),
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            review.user?.firstName?.toString() ?? 'Anonymous',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff232323),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          review.createdAt != null
                              ? dateFormat.format(
                                  DateTime.parse(review.createdAt.toString()))
                              : 'N/A',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff909090),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Review description
                  if (review.description?.isNotEmpty ?? false) ...[
                    SizedBox(height: 14.w),
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.format_quote,
                            size: 20.sp,
                            color: Color(0xFFEED056).withOpacity(0.5),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              review.description!,
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff505050),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Review Images
                  if (review.reviewImages?.isNotEmpty ?? false) ...[
                    SizedBox(height: 14.w),
                    SizedBox(
                      height: 80.w,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: review.reviewImages!.length,
                        itemBuilder: (context, index) {
                          final image = review.reviewImages![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageScreen(
                                    image: configModel.apiConfig['mediaURL'] +
                                        image.imagePath,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10.w),
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Color(0xFFEED056).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11.r),
                                child: Image.network(
                                  configModel.apiConfig['mediaURL'] +
                                      image.imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.error,
                                          color: Colors.grey[400]),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewUpdatePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.timer_off_outlined,
                  size: 40.sp,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 20.w),
              Text(
                'Update Not Allowed',
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff232323),
                ),
              ),
              SizedBox(height: 10.w),
              Text(
                "Reviews can only be updated within 30 days of posting.",
                textAlign: TextAlign.center,
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff909090),
                ),
              ),
              SizedBox(height: 24.w),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEED056),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Got It',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

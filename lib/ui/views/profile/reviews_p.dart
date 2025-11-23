// import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:aadab/core/providers/config_pr.dart';
// import 'package:aadab/core/providers/review_pr.dart';
// import 'package:aadab/locator.dart';
// import 'package:aadab/ui/shared/font_sh.dart';
// import 'package:aadab/ui/views/products/product_id_p.dart';
// import 'package:aadab/ui/views/profile/review_id_p.dart';
// import 'package:aadab/ui/widgets/image_zoom_w.dart';

// class ReviewsPage extends StatefulWidget {
//   final arguments;
//   const ReviewsPage({Key? key, this.arguments}) : super(key: key);

//   @override
//   State<ReviewsPage> createState() => _ReviewsPageState();
// }

// class _ReviewsPageState extends State<ReviewsPage> {
//   late final DateFormat _dateFormat;

//   @override
//   void initState() {
//     super.initState();
//     _dateFormat = DateFormat('yyyy-MM-dd');
//     String productId = '';
//     if (widget.arguments?['productId'] != null) {
//       setState(() {
//         productId = widget.arguments['productId'].toString();
//       });
//     }
//     print('is edit ${widget.arguments['is_edit']}');
//     if (widget.arguments['is_edit'] == false) {
//       print('yes');
//       Provider.of<ReviewModel>(context, listen: false).getReviews(productId);
//     } else {
//       print('no');
//       Provider.of<ReviewModel>(context, listen: false)
//           .getMyReviews(productId, '', '');
//     }
//     // Fetch reviews during initialization
//   }

//   @override
//   Widget build(BuildContext context) {
//     final reviewModel = Provider.of<ReviewModel>(context, listen: false);
//     final configModel = locator<ConfigModel>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           'Reviews',
//           style: MyGoogleFontStyle(
//             fontFamily: 'Urbanist',
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: const Color(0xff1e232c),
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Color(0xffEED056)),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: reviewModel.reviews == null
//           ? const Center(child: Text('No reviews available'))
//           : Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: ListView.builder(
//                 itemCount: reviewModel.reviews!.length,
//                 itemBuilder: (context, index) {
//                   final review = reviewModel.reviews![index];

//                   // Parse created_at date
//                   DateTime createdAt =
//                       DateTime.parse(review.createdAt.toString());

//                   // Calculate difference in days
//                   int daysDifference =
//                       DateTime.now().difference(createdAt).inDays;

//                   return ReviewCard(
//                     review: review,
//                     configModel: configModel,
//                     dateFormat: _dateFormat,
//                     onTap: () {
//                       if (daysDifference <= 30) {
//                         // Navigate to update page if within 30 days
// Navigator.of(context).push(
//   MaterialPageRoute(
//     builder: (context) => ReviewUpdatePage(
//       arguments: {'review': review},
//     ),
//   ),
// );
//                       } else {
//                         // Show popup if more than 30 days
//                         _showReviewUpdatePopup(context);
//                       }
//                     },
//                   );
//                 },
//               ),
//             ),
//     );
//   }
// }

// void _showReviewUpdatePopup(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text("Update Not Allowed"),
//       content: Text("You can't update your review after 30 days."),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text("OK"),
//         ),
//       ],
//     ),
//   );
// }

// class ReviewCard extends StatelessWidget {
//   final dynamic review;
//   final ConfigModel configModel;
//   final DateFormat dateFormat;
//   final VoidCallback onTap;

//   const ReviewCard({
//     required this.review,
//     required this.configModel,
//     required this.dateFormat,
//     required this.onTap,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           border: Border.all(color: const Color(0xffc7b456)),
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(5),
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0x338a959e),
//               offset: Offset(0, 7.6),
//               blurRadius: 19.1,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 // Product Image
//                 InkWell(
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => ProductIdPage(arguments: {
//                           'product': review.product.toJson(),
//                           'product_images': review.product.productImages
//                         }),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     margin: const EdgeInsets.only(right: 15),
//                     child: Image.network(
//                       configModel.apiConfig['mediaURL'] +
//                           (review.product?.imagepath1 ?? ''),
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) =>
//                           const Icon(Icons.error),
//                     ),
//                   ),
//                 ),
//                 // Product Info
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       review.product?.name ?? 'Unknown Product',
//                       style: MyGoogleFontStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                         color: const Color(0xff232323),
//                       ),
//                     ),
//                     // Text(
//                     //   '₹ ${review.product?.productPrices?[0]?.price ?? '0.0'}',
//                     //   style: MyGoogleFontStyle(
//                     //     fontFamily: 'Poppins',
//                     //     fontSize: 16,
//                     //     fontWeight: FontWeight.w600,
//                     //     color: const Color(0xff232323),
//                     //   ),
//                     // ),
//                     Center(
//                       child: double.tryParse(review.rating) == null
//                           ? Text("No Rating")
//                           : RatingBar.builder(
//                               itemSize: 15,
//                               initialRating:
//                                   double.tryParse(review.rating) ?? 0.0,
//                               direction: Axis.horizontal,
//                               itemCount: 5,
//                               allowHalfRating: true,
//                               ignoreGestures: true,
//                               itemBuilder: (context, _) => const Icon(
//                                 Icons.star,
//                                 color: Colors.amber,
//                               ),
//                               onRatingUpdate: (double value) {},
//                             ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // Reviewer Info
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   review.user!.firstName.toString(),
//                   style: MyGoogleFontStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                     color: const Color(0xff909090),
//                   ),
//                 ),
//                 Text(
//                   dateFormat.format(DateTime.parse(review.createdAt)),
//                   style: MyGoogleFontStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                     color: const Color(0xff909090),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // Review Description
//             if (review.description != null && review.description!.isNotEmpty)
//               Text(
//                 review.description!,
//                 style: MyGoogleFontStyle(
//                   fontFamily: 'Poppins',
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: const Color(0xff909090),
//                 ),
//               ),
//             const SizedBox(height: 15),
//             // Review Images
//             if (review.reviewImages != null && review.reviewImages.isNotEmpty)
//               SizedBox(
//                 height: 100,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: review.reviewImages.length,
//                   itemBuilder: (context, index) {
//                     final image = review.reviewImages[index];
//                     return InkWell(
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => ImageScreen(
//                                 image: configModel.apiConfig['mediaURL'] +
//                                     image.imagePath),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(right: 10),
//                         width: 66.71,
//                         height: 66.71,
//                         child: Image.network(
//                           configModel.apiConfig['mediaURL'] + image.imagePath,
//                           fit: BoxFit.contain,
//                           errorBuilder: (context, error, stackTrace) =>
//                               const Icon(Icons.error),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               )
//             else
//               const Text('No review images available'),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
    print('arguments: ${widget.arguments}');
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final reviewModel = Provider.of<ReviewModel>(context, listen: false);
    final productId = widget.arguments?['productId']?.toString() ?? '';
    final productPackId = widget.arguments?['productPackId']?.toString() ?? '';
    setState(() => _isLoading = true);
    try {
      if (widget.arguments?['is_edit'] == false) {
        // Use guest-friendly method for viewing reviews
        await reviewModel.fetchReviewsForGuests(productId, productPackId);
      } else {
        await reviewModel.getMyReviews('', productId, '', '', []);
      }
    } catch (e) {
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to load reviews: $e')),
        // );
      }
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Reviews',
          style: MyGoogleFontStyle(
            fontFamily: 'Urbanist',
            fontSize: 20.0.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff1e232c),
          ),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8.0.w),
            padding: EdgeInsets.all(8.0.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFEED056).withOpacity(0.15),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 16.0.sp,
              color: const Color(0xffEED056),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFEF9), Color(0xFFFFFDF7), Colors.white],
          ),
        ),
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFEED056).withOpacity(0.15),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEED056)),
                        strokeWidth: 3,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Loading...', style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff232323),
                    )),
                  ],
                ),
              )
            : reviewModel.reviews == null || reviewModel.reviews!.isEmpty
                ? const Center(child: Text('No reviews available'))
                : Padding(
                    padding: EdgeInsets.all(20.0.w),
                    child: ListView.builder(
                      itemCount: reviewModel.reviews!.length,
                      itemBuilder: (context, index) {
                      final review = reviewModel.reviews![index];
                      // print(
                      //     'check review product image ${review.product!.imagepath1}');
                      return _buildReviewCard(
                        review: review,
                        configModel: configModel,
                        dateFormat: _dateFormat,
                        // 1.0.w: 1.0.w,
                        // 1.0.sp: 1.0.sp,
                        onTap: () {
                          final createdAt =
                              DateTime.tryParse(review.createdAt.toString());
                          final daysDifference = createdAt != null
                              ? DateTime.now().difference(createdAt).inDays
                              : 31;
                          if (daysDifference <= 30 &&
                              widget.arguments['is_edit'] == true) {
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
                    ),
                  ),
      ),
    );
  }

  Widget _buildReviewCard({
    required Review review,
    required ConfigModel configModel,
    required DateFormat dateFormat,
    required VoidCallback onTap,
  }) {
    // final productImages = review.product?.productImages ?? [];
    final firstImage = review.product?.imagepath1;
    // print('imaage $productImages');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0.w),
        padding: EdgeInsets.all(10.0.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffc7b456)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x338a959e),
              offset: Offset(0, 7.6.w),
              blurRadius: 19.1.w,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (firstImage != null && review.product != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductIdPage(arguments: {
                            'product': review.product?.toJson(),
                            'product_images': review.product?.productImages
                          }),
                        ),
                      );
                      // Navigator.pushNamed(
                      //   context,
                      //   '/productPage',
                      //   arguments: {'productId': review.product?.id},
                      // );
                    },
                    child: Container(
                      width: 80.0.w,
                      height: 80.0.w,
                      margin: EdgeInsets.only(right: 15.0.w),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              configModel.apiConfig['mediaURL'] + firstImage),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 80.0.w,
                    height: 80.0.w,
                    margin: EdgeInsets.only(right: 15.0.w),
                    child: const Icon(Icons.image_not_supported),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.product?.name?.toString() ?? 'Unknown Product',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff232323),
                        ),
                      ),
                      SizedBox(height: 5.0.w),
                      // Text(review.toJson().toString()),
                      double.tryParse(review.rating?.toString() ?? '') == null
                          ? Text(
                              'No Rating',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.0.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff909090),
                              ),
                            )
                          : RatingBarIndicator(
                              itemSize: 15.0.w,
                              rating:
                                  double.tryParse(review.rating.toString()) ??
                                      0.0,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.user?.firstName?.toString() ?? 'Anonymous',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff909090),
                  ),
                ),
                Text(
                  review.createdAt != null
                      ? dateFormat
                          .format(DateTime.parse(review.createdAt.toString()))
                      : 'N/A',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff909090),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0.w),
            if (review.description?.isNotEmpty ?? false)
              Text(
                review.description!,
                style: MyGoogleFontStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff909090),
                ),
              ),
            SizedBox(height: 15.0.w),
            if (review.reviewImages?.isNotEmpty ?? false)
              SizedBox(
                height: 100.0.w,
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
                        margin: EdgeInsets.only(right: 10.0.w),
                        width: 66.71.w,
                        height: 66.71.w,
                        child: Image.network(
                          configModel.apiConfig['mediaURL'] + image.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Text(
                'No review images available',
                style: MyGoogleFontStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff909090),
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0.r)),
        title: Text(
          'Update Not Allowed',
          style: MyGoogleFontStyle(
            fontFamily: 'Urbanist',
            fontSize: 16.0.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff1e232c),
          ),
        ),
        content: Text(
          "You can't update your review after 30 days.",
          style: MyGoogleFontStyle(
            fontFamily: 'Poppins',
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff909090),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: MyGoogleFontStyle(
                fontFamily: 'Poppins',
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

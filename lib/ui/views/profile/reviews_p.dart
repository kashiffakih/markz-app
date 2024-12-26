import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/review_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/products/product_id_p.dart';
import 'package:sales_app/ui/views/profile/review_id_p.dart';
import 'package:sales_app/ui/widgets/image_zoom_w.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({Key? key}) : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  late final DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _dateFormat = DateFormat('yyyy-MM-dd');
    // Fetch reviews during initialization
    Provider.of<ReviewModel>(context, listen: false).getMyReviews('', '', '');
  }

  @override
  Widget build(BuildContext context) {
    final reviewModel = Provider.of<ReviewModel>(context);
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xff1e232c),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xffEED056)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: reviewModel.reviews == null
          ? const Center(child: Text('No reviews available'))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: reviewModel.reviews!.length,
                itemBuilder: (context, index) {
                  final review = reviewModel.reviews![index];
                  return ReviewCard(
                    review: review,
                    configModel: configModel,
                    dateFormat: _dateFormat,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReviewUpdatePage(
                            arguments: {'review': review},
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final dynamic review;
  final ConfigModel configModel;
  final DateFormat dateFormat;
  final VoidCallback onTap;

  const ReviewCard({
    required this.review,
    required this.configModel,
    required this.dateFormat,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffc7b456)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x338a959e),
              offset: Offset(0, 7.6),
              blurRadius: 19.1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Product Image
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductIdPage(arguments: {
                          'product': review.product.toJson(),
                          'product_images': review.product.productImages
                        }),
                      ),
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 15),
                    child: Image.network(
                      configModel.apiConfig['mediaURL'] +
                          (review.product?.imagepath1 ?? ''),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                // Product Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.product?.name ?? 'Unknown Product',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff232323),
                      ),
                    ),
                    Text(
                      '₹ ${review.product?.productPrices?[0]?.price ?? '0.0'}',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff232323),
                      ),
                    ),
                    review.rating == null
                        ? SizedBox.shrink()
                        : Center(
                            child: RatingBar.builder(
                              itemSize: 15,
                              initialRating:
                                  double.parse(review.rating.toString()),
                              direction: Axis.horizontal,
                              itemCount: 5,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (double value) {},
                            ),
                          )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Reviewer Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  configModel.user.firstName.toString(),
                  style: MyGoogleFontStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff909090),
                  ),
                ),
                Text(
                  dateFormat.format(DateTime.parse(review.createdAt)),
                  style: MyGoogleFontStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff909090),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Review Description
            if (review.description != null && review.description!.isNotEmpty)
              Text(
                review.description!,
                style: MyGoogleFontStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff909090),
                ),
              ),
            const SizedBox(height: 15),
            // Review Images
            if (review.reviewImages != null && review.reviewImages.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.reviewImages.length,
                  itemBuilder: (context, index) {
                    final image = review.reviewImages[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ImageScreen(
                                image: configModel.apiConfig['mediaURL'] +
                                    image.imagePath),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 66.71,
                        height: 66.71,
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
              const Text('No review images available'),
          ],
        ),
      ),
    );
  }
}

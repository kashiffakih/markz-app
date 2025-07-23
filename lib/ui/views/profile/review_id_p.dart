// import 'package:aadab/ui/widgets/multi_image_w.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:provider/provider.dart';
// import 'package:aadab/core/models/review.dart';
// import 'package:aadab/core/providers/add_to_cart_pr.dart';
// import 'package:aadab/core/providers/review_pr.dart';
// import 'package:aadab/ui/shared/font_sh.dart';

// class ReviewUpdatePage extends StatefulWidget {
//   final arguments;
//   const ReviewUpdatePage({Key? key, required this.arguments}) : super(key: key);

//   @override
//   State<ReviewUpdatePage> createState() => _ReviewUpdatePageState();
// }

// class _ReviewUpdatePageState extends State<ReviewUpdatePage> {
//   Review _review = Review();

//   final _formKey = GlobalKey<FormState>();
//   @override
//   void initState() {
//     super.initState();
//     _review = widget.arguments['review'];
//   }

//   String _reviewDescription = _review.description.toString();
//   bool _isLoading = false;
//   double _currentRating = double.parse(_review.rating.toString());
//   bool _loading = false;
//   @override
//   Widget build(BuildContext context) {
//     final ReviewModel _reviewModel =
//         Provider.of<ReviewModel>(context, listen: false);
//     final AddToCartModel _addToCartModel =
//         Provider.of<AddToCartModel>(context, listen: false);
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.only(top: 20),
//             child: Column(
//               children: [
//                 // Title
//                 Container(
//                   margin: EdgeInsets.all(20),
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Row(
//                           children: [
//                             Container(
//                               child: Image.asset(
//                                 'assets/images/vector-GJ4.png',
//                                 height: 15,
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 'Update Review',
//                                 textAlign: TextAlign.center,
//                                 style: MyGoogleFontStyle(
//                                   fontFamily: 'Urbanist',
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xff1e232c),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Body
//                 Container(
//                   padding: EdgeInsets.all(15),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         RatingBar.builder(
//                           itemSize: 30,
//                           initialRating: _currentRating,
//                           minRating: 0.5,
//                           direction: Axis.horizontal,
//                           allowHalfRating: true,
//                           itemCount: 5,
//                           itemPadding:
//                               const EdgeInsets.symmetric(horizontal: 4),
//                           itemBuilder: (context, _) =>
//                               const Icon(Icons.star, color: Colors.amber),
//                           onRatingUpdate: (rating) =>
//                               setState(() => _currentRating = rating),
//                         ),
//                         SizedBox(height: 10),
//                         Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(color: const Color(0xffdadada)),
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: TextFormField(
//                             maxLines: 5,
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.all(10),
//                               hintText: 'Write your review here.',
//                               hintStyle: TextStyle(color: Color(0xff8390a1)),
//                             ),
//                             initialValue: _reviewDescription,
//                             onSaved: (value) =>
//                                 _reviewDescription = value ?? '',
//                             validator: (value) => value?.isEmpty ?? true
//                                 ? 'Please write some review.'
//                                 : null,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         SizedBox(height: 120, child: MultipleImageUploadPage()),
//                         Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 5),
//                           child: TextButton(
//                             onPressed: _isLoading
//                                 ? null
//                                 : () async {
//                                     if (_formKey.currentState!.validate()) {
//                                       _formKey.currentState!.save();
//                                       setState(() => _isLoading = true);
//                                       try {
//                                         await _reviewModel.getMyReviews(
//                                             _review.productId,
//                                             _reviewDescription,
//                                             _currentRating);
//                                         if (mounted) Navigator.pop(context);
//                                       } catch (e) {
//                                         if (mounted) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(
//                                             SnackBar(
//                                                 content: Text(
//                                                     'Failed to submit review: $e')),
//                                           );
//                                         }
//                                       } finally {
//                                         if (mounted)
//                                           setState(() => _isLoading = false);
//                                       }
//                                     }
//                                   },
//                             style:
//                                 TextButton.styleFrom(padding: EdgeInsets.zero),
//                             child: Container(
//                               width: double.infinity,
//                               height: 53,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xff1e1e1e),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Center(
//                                 child: _isLoading
//                                     ? const SizedBox(
//                                         width: 20,
//                                         height: 20,
//                                         child: CircularProgressIndicator(
//                                             color: Colors.white),
//                                       )
//                                     : Text(
//                                         'Post Review',
//                                         style: MyGoogleFontStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w700,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/review.dart';
// import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/review_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/widgets/multi_image_w.dart';

class ReviewUpdatePage extends StatefulWidget {
  final arguments;

  const ReviewUpdatePage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<ReviewUpdatePage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late Review _review;
  String _reviewDescription = '';
  double _currentRating = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _review = widget.arguments?['review'] ?? Review();
    _reviewDescription = _review.description?.toString() ?? '';
    _currentRating =
        double.tryParse(_review.rating?.toString() ?? '0.0') ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final reviewModel = Provider.of<ReviewModel>(context, listen: false);
    final configModel = locator<ConfigModel>();
    final double fem = MediaQuery.of(context).size.width / 360;
    final double ffem = fem * 0.97;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20 * fem),
            child: Column(
              children: [
                _buildHeader(context, fem, ffem),
                _buildBody(context, reviewModel, configModel, fem, ffem),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double fem, double ffem) {
    return Container(
      margin: EdgeInsets.all(20 * fem),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18 * fem,
              color: const Color(0xffEED056),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Update Review',
              textAlign: TextAlign.center,
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 18 * ffem,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
          SizedBox(width: 48 * fem),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ReviewModel reviewModel,
    ConfigModel configModel,
    double fem,
    double ffem,
  ) {
    final productImages = _review.product?.productImages ?? [];
    final firstImage =
        productImages.isNotEmpty ? productImages.first.imagepath : null;

    return Container(
      padding: EdgeInsets.all(15 * fem),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (firstImage != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/productPage',
                        arguments: {'productId': _review.product?.id},
                      );
                    },
                    child: Container(
                      width: 80 * fem,
                      height: 80 * fem,
                      margin: EdgeInsets.only(right: 15 * fem),
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
                    width: 80 * fem,
                    height: 80 * fem,
                    margin: EdgeInsets.only(right: 15 * fem),
                    child: const Icon(Icons.image_not_supported),
                  ),
                Expanded(
                  child: Text(
                    _review.product?.name?.toString() ?? 'Unknown Product',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16 * ffem,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff232323),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10 * fem),
            RatingBar.builder(
              itemSize: 30 * fem,
              initialRating: _currentRating,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4 * fem),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) =>
                  setState(() => _currentRating = rating),
            ),
            SizedBox(height: 10 * fem),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffdadada)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20 * fem),
              ),
              child: TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10 * fem),
                  hintText: 'Write your review here.',
                  hintStyle: MyGoogleFontStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12 * ffem,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff8390a1),
                  ),
                ),
                initialValue: _reviewDescription,
                onSaved: (value) => _reviewDescription = value ?? '',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please write some review.' : null,
              ),
            ),
            SizedBox(height: 10 * fem),
            SizedBox(
              height: 120 * fem,
              child: MultipleImageUploadPage(),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5 * fem),
              child: TextButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() => _isLoading = true);
                          try {
                            await reviewModel.getMyReviews(
                              _review.product?.id?.toString() ?? '',
                              _reviewDescription,
                              _currentRating,
                            );
                            if (mounted) Navigator.pop(context);
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Failed to update review: $e')),
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        }
                      },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Container(
                  width: double.infinity,
                  height: 53 * fem,
                  decoration: BoxDecoration(
                    color: const Color(0xff1e1e1e),
                    borderRadius: BorderRadius.circular(10 * fem),
                  ),
                  child: Center(
                    child: _isLoading
                        ? SizedBox(
                            width: 20 * fem,
                            height: 20 * fem,
                            child: const CircularProgressIndicator(
                                color: Colors.white),
                          )
                        : Text(
                            'Update Review',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 15 * ffem,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

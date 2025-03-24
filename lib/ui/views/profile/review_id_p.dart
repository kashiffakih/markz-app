import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/review.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/review_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class ReviewUpdatePage extends StatefulWidget {
  final arguments;
  const ReviewUpdatePage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<ReviewUpdatePage> createState() => _ReviewUpdatePageState();
}

class _ReviewUpdatePageState extends State<ReviewUpdatePage> {
  Review _review = Review();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _review = widget.arguments['review'];
  }

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final ReviewModel _reviewModel =
        Provider.of<ReviewModel>(context, listen: false);
    final AddToCartModel _addToCartModel =
        Provider.of<AddToCartModel>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                // Title
                Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                'assets/images/vector-GJ4.png',
                                height: 15,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Update Review',
                                textAlign: TextAlign.center,
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1e232c),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Container(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Full Name
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xffe3e3e3)),
                            color: Color(0xfffbfbfb),
                          ),
                          child: TextFormField(
                            initialValue: _review.description,
                            maxLines: 5,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(
                                  10), // Added padding for better text alignment
                              hintText:
                                  'Enter your review here', // Added hint text for better UX
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000),
                            ),
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return "Address 1 Cannot be empty.";
                            //   }
                            //   return null;
                            // },
                            onSaved: (value) {
                              _review.description = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        // Save address
                        Container(
                          // primaryXwC (318:2628)
                          margin: EdgeInsets.fromLTRB(5, 0, 6.34, 0),
                          child: TextButton(
                            onPressed: () async {
                              // if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              setState(() {
                                _loading = true;
                              });

                              await _reviewModel.getMyReviews(
                                _review.productId,
                                _review.description,
                                '',
                              );
                              // if (review.length != 0) {
                              //   print('object');
                              // }
                              Navigator.pop(context);
                              setState(() {
                                _loading = false;
                              });
                            },
                            // },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 53,
                              decoration: BoxDecoration(
                                color: Color(0xff1e1e1e),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: _loading
                                    ? SizedBox(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                        ),
                                        height: 20,
                                        width: 20,
                                      )
                                    : Text(
                                        'Update review',
                                        textAlign: TextAlign.center,
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 15.1428556442,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4999999685,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

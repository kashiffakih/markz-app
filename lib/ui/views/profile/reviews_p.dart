import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/review_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({Key? key}) : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  DateFormat? _format;
  @override
  void initState() {
    _format = DateFormat('yyyy-MM-dd');
    var productId = '';
    Provider.of<ReviewModel>(context, listen: false).getMyReviews(productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ReviewModel _reviewModel = Provider.of<ReviewModel>(context);
    final ConfigModel _configModel = locator<ConfigModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
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
                                'Reviews',
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
                  height: 650,
                  margin: EdgeInsets.all(20),
                  child: _reviewModel.reviewLoader
                      ? Center(child: Text('No reviews'))
                      : ListView.builder(
                          itemCount: _reviewModel.reviews!.length,
                          itemBuilder: (BuildContext context, index) =>
                              SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffc7b456)),
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x338a959e),
                                        offset: Offset(0, 7.6690645218),
                                        blurRadius: 19.1726608276,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      // Photo and Title
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      // mediaF3t (I318:2555;0:1388)
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 15, 0),
                                                      width: 66.71,
                                                      height: 66.71,
                                                      child: Image.network(
                                                        _configModel.apiConfig[
                                                                'mediaURL'] +
                                                            _reviewModel
                                                                .reviews![index]
                                                                .product!
                                                                .imagepath1
                                                                .toString(),
                                                        // 'assets/images/media.png',
                                                        width: 66.71,
                                                        height: 66.71,
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _reviewModel
                                                              .reviews![index]
                                                              .product!
                                                              .name
                                                              .toString(),
                                                          style:
                                                              MyGoogleFontStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Color(
                                                                0xff232323),
                                                          ),
                                                        ),
                                                        Text(
                                                          // BLr (I318:2555;0:1392)
                                                          '₹ ' +
                                                              _reviewModel
                                                                  .reviews![
                                                                      index]
                                                                  .product!
                                                                  .productPrices![
                                                                      0]
                                                                  .price
                                                                  .toString(),
                                                          style:
                                                              MyGoogleFontStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xff232323),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      // Stars
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(_configModel
                                                .user.firstName
                                                .toString()),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _format!.format(DateTime.parse(
                                                  _reviewModel
                                                      .reviews![index].createdAt
                                                      .toString())),
                                              textAlign: TextAlign.right,
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff909090),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      // Description
                                      Text(
                                        _reviewModel.reviews![index].description
                                            .toString(),
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff909090),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

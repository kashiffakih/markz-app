import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:aadab/core/providers/review_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:aadab/ui/widgets/multi_image_w.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';

class OrderDetailsPage extends StatefulWidget {
  final arguments;

  const OrderDetailsPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final _reviewFormKey = GlobalKey<FormState>();
  String _reviewDescription = '';
  bool _isLoading = false;
  double _currentRating = 0;

  @override
  Widget build(BuildContext context) {
    final configModel = locator<ConfigModel>();
    final reviewModel = Provider.of<ReviewModel>(context, listen: false);

    final double baseWidth = 360;
    final double fem = MediaQuery.of(context).size.width / baseWidth;
    final double ffem = fem * 0.97;

    // Calculate GST
    String calculateReverseGst() {
      double price = double.tryParse(
              widget.arguments?['order']['order_cost'].toString() ?? '0') ??
          0;
      double gstAmount = (price / 105) * 5; // 5% GST
      return (price - gstAmount).round().toString();
    }

    final String reverseGstCalculation = calculateReverseGst();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding:
                EdgeInsets.symmetric(horizontal: 20 * fem, vertical: 10 * fem),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, fem, ffem),
                _buildOrderStatus(fem, ffem),
                _buildOrderItems(context, fem, ffem, configModel, reviewModel),
                _buildCostBreakdown(fem, ffem, reverseGstCalculation),
                _buildPaymentInfo(fem, ffem),
                _buildDateInfo(fem, ffem),
                _buildPhoneInfo(fem, ffem),
                _buildAddressInfo(fem, ffem),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double fem, double ffem) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
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
              'Order Details',
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

  Widget _buildOrderStatus(double fem, double ffem) {
    final status = widget.arguments?['status']?.toString() ?? 'Unknown';
    return Container(
      width: 320 * fem,
      padding: EdgeInsets.only(bottom: 5 * fem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            status,
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 18 * ffem,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.9 * fem,
              color: status == 'Delivered'
                  ? Colors.green
                  : status == 'Order in processing'
                      ? Colors.orange
                      : status == 'Cancelled'
                          ? Colors.red
                          : Colors.black,
            ),
          ),
          Divider(color: Colors.black),
          Text(
            'Order #${widget.arguments?['order']['id']?.toString() ?? 'N/A'}',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 12 * ffem,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.6 * fem,
              color: const Color(0xff1e1e1e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(BuildContext context, double fem, double ffem,
      ConfigModel configModel, ReviewModel reviewModel) {
    final orderDetails =
        widget.arguments?['order']['order_details'] as List<dynamic>? ?? [];
    return Container(
      width: 322 * fem,
      height: MediaQuery.of(context).size.height *
          0.23 *
          (orderDetails.length < 2 ? orderDetails.length : 2),
      child: ListView.builder(
        itemCount: orderDetails.length,
        itemBuilder: (context, index) {
          final detail = orderDetails[index];
          final productImages =
              widget.arguments?['product_images'] as List<dynamic>? ?? [];
          final newImageDisplay = productImages
                  .where((element) =>
                      element.id.toString() ==
                      detail['product_pack'].toString())
                  .toList()
                  .isNotEmpty
              ? productImages
                  .where((element) =>
                      element.id.toString() ==
                      detail['product_pack'].toString())
                  .toList()[0]
                  .imagepath
              : null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 11 * fem),
                    child: Text(
                      detail['product']['name']?.toString() ??
                          'Unknown Product',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 15 * ffem,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3 * fem,
                        color: const Color(0xff1e1e1e),
                      ),
                    ),
                  ),
                  SizedBox(width: 50 * fem),
                  Container(
                    width: 60 * fem,
                    height: 80 * fem,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: newImageDisplay != null
                            ? NetworkImage(configModel.apiConfig['mediaURL'] +
                                newImageDisplay)
                            : const AssetImage(
                                    'assets/images/aadab-logo-mini.png')
                                as ImageProvider,
                      ),
                    ),
                  ),
                  if (widget.arguments?['status'] == 'Delivered') ...[
                    const Spacer(),
                    _buildReviewButton(context, fem, ffem, reviewModel, detail),
                  ],
                ],
              ),
              _buildProductDetails(detail, fem, ffem),
              Divider(color: Colors.black),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReviewButton(BuildContext context, double fem, double ffem,
      ReviewModel reviewModel, dynamic detail) {
    return InkWell(
      onTap: () =>
          _showReviewDialog(context, reviewModel, detail['product']['id']),
      child: Container(
        width: 74.5 * fem,
        height: 30 * fem,
        decoration: BoxDecoration(
          color: const Color(0xff232323),
          borderRadius: BorderRadius.circular(8 * fem),
        ),
        child: Center(
          child: Text(
            '+ Review',
            style: MyGoogleFontStyle(
              fontFamily: 'Poppins',
              fontSize: 12 * ffem,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showReviewDialog(
      BuildContext context, ReviewModel reviewModel, int productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add your review'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: 400,
          child: SingleChildScrollView(
            child: Form(
              key: _reviewFormKey,
              child: Column(
                children: [
                  RatingBar.builder(
                    itemSize: 30,
                    initialRating: _currentRating,
                    minRating: 0.5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) =>
                        setState(() => _currentRating = rating),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffdadada)),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Write your review here.',
                        hintStyle: TextStyle(color: Color(0xff8390a1)),
                      ),
                      initialValue: _reviewDescription,
                      onSaved: (value) => _reviewDescription = value ?? '',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please write some review.'
                          : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 120, child: MultipleImageUploadPage()),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_reviewFormKey.currentState!.validate()) {
                                _reviewFormKey.currentState!.save();
                                setState(() => _isLoading = true);
                                try {
                                  await reviewModel.getMyReviews(productId,
                                      _reviewDescription, _currentRating);
                                  if (mounted) Navigator.pop(context);
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to submit review: $e')),
                                    );
                                  }
                                } finally {
                                  if (mounted)
                                    setState(() => _isLoading = false);
                                }
                              }
                            },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Container(
                        width: double.infinity,
                        height: 53,
                        decoration: BoxDecoration(
                          color: const Color(0xff1e1e1e),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                )
                              : Text(
                                  'Post Review',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 15,
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
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(dynamic detail, double fem, double ffem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (detail['flavour'] != null)
          Container(
            margin: EdgeInsets.only(bottom: 7 * fem),
            constraints: BoxConstraints(maxWidth: 205 * fem),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Colour: ',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.24 * fem,
                      color: const Color(0xff1e1e1e),
                    ),
                  ),
                  TextSpan(
                    text: detail['flavour'].toString(),
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.24 * fem,
                      color: const Color(0xff1e1e1e),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Size: ',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.24 * fem,
                      color: const Color(0xff1e1e1e),
                    ),
                  ),
                  TextSpan(
                    text: detail['kind_of_flower']?.toString() ?? 'N/A',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.24 * fem,
                      color: const Color(0xff1e1e1e),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 34 * fem),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Quantity: ',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.24 * fem,
                      color: const Color(0xff1e1e1e),
                    ),
                  ),
                  TextSpan(
                    text: detail['quantity']?.toString() ?? '0',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.24 * fem,
                      color: const Color(0xff1e1e1e),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              'RS ${detail['order_detail_cost']?.toString() ?? '0'}',
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 12 * ffem,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.24 * fem,
                color: const Color(0xff1e1e1e),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCostBreakdown(
      double fem, double ffem, String reverseGstCalculation) {
    final order = widget.arguments?['order'] ?? {};
    final isMaharashtra =
        order['address']?['state']?.toString() == 'Maharashtra';
    String abc = (order['order_cost'] -
            int.parse((order['order_cost'] / 105 * 100).round().toString()))
        .toString();
    return Column(
      children: [
        _buildCostRow('Item total',
            (order['order_cost'] / 105 * 100).round().toString(), fem, ffem),
        if (isMaharashtra) ...[
          _buildCostRow(
              'CGST 2.5%', (int.parse(abc) ~/ 2).toString(), fem, ffem),
          _buildCostRow(
              'SGST 2.5%', (int.parse(abc) ~/ 2).toString(), fem, ffem),
        ] else
          _buildCostRow('IGST 5%', abc, fem, ffem),
        _buildCostRow('Delivery charge',
            order['delivery_amount']?.toString() ?? '0', fem, ffem),
        _buildCostRow('Packing charge',
            order['packaging_amount']?.toString() ?? '0', fem, ffem),
        _buildCostRow('Reward', order['wallet_amount_used']?.toString() ?? '0',
            fem, ffem),
        Divider(color: Colors.black, indent: 20 * fem, endIndent: 20 * fem),
        _buildCostRow(
            'Grand Total', order['order_cost']?.toString() ?? '0', fem, ffem,
            isBold: true),
        Divider(color: Colors.black, indent: 20 * fem, endIndent: 20 * fem),
      ],
    );
  }

  Widget _buildCostRow(String label, String value, double fem, double ffem,
      {bool isBold = false}) {
    return Container(
      width: 320 * fem,
      padding: EdgeInsets.symmetric(vertical: 2 * fem),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: isBold ? 14 * ffem : 12 * ffem,
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
              color: const Color(0xff1e1e1e),
            ),
          ),
          Text(
            'RS $value',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: isBold ? 15 * ffem : 12 * ffem,
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
              letterSpacing: -0.24 * fem,
              color: const Color(0xff1e1e1e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(double fem, double ffem) {
    return Padding(
      padding: EdgeInsets.only(left: 20 * fem, top: 20 * fem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 12 * ffem,
              fontWeight: FontWeight.w400,
              color: const Color(0xff1e1e1e),
            ),
          ),
          Text(
            'Paid: ${widget.arguments?['order']['paymentmode']?.toString()}',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 13 * ffem,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1e1e1e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(double fem, double ffem) {
    final String? rawDate =
        widget.arguments?['order']['created_at']?.toString();
    final String formattedDate = rawDate != null
        ? DateFormat('MMMM d, yyyy, h:mm a').format(DateTime.parse(rawDate))
        : 'N/A';

    return Padding(
      padding: EdgeInsets.only(left: 20 * fem, top: 20 * fem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 12 * ffem,
              fontWeight: FontWeight.w400,
              color: const Color(0xff1e1e1e),
            ),
          ),
          Text(
            formattedDate,
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 13 * ffem,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1e1e1e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInfo(double fem, double ffem) {
    return Padding(
      padding: EdgeInsets.only(left: 20 * fem, top: 20 * fem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phone number',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 12 * ffem,
              fontWeight: FontWeight.w400,
              color: const Color(0xff1e1e1e),
            ),
          ),
          Text(
            widget.arguments?['order']['address']['phone'].toString() ?? 'N/A',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 13 * ffem,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1e1e1e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressInfo(double fem, double ffem) {
    final address = widget.arguments?['order']['address'] ?? {};
    return Padding(
      padding: EdgeInsets.only(left: 20 * fem, top: 20 * fem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deliver to:',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 12 * ffem,
              fontWeight: FontWeight.w400,
              color: const Color(0xff1e1e1e),
            ),
          ),
          Text(
            [
              address['add_1'],
              address['add_2'],
              address['add_3'],
              address['city'],
              address['state'],
              address['pincode']
            ].where((e) => e != null && e.isNotEmpty).join(', '),
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 13 * ffem,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1e1e1e),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:aadab/ui/views/profile/orders_p.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:aadab/core/providers/review_pr.dart';
import 'package:aadab/core/providers/order_pr.dart';
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
  List<String> _selectedImages = [];
  Set<int> _reviewedProducts = {};
  bool _isLoadingReviews = true;

  @override
  void initState() {
    super.initState();
    _loadExistingReviews();
  }

  Future<void> _loadExistingReviews() async {
    final configModel = locator<ConfigModel>();
    final reviewModel = Provider.of<ReviewModel>(context, listen: false);

    if (configModel.user != null) {
      final orderDetails =
          widget.arguments?['order']['order_details'] as List<dynamic>? ?? [];
      for (var detail in orderDetails) {
        // final productId = detail['product_id'];
        final productPackId = detail['product_pack'];
        // Convert to int if it's a string
        final productPackIdInt = productPackId is String
            ? int.tryParse(productPackId) ?? productPackId
            : productPackId;
        // print('Checking reviews for product pack: $productPackIdInt');
        // Check if this product has been reviewed by the user
        // Use getReviewsByProductPack to check existing reviews for this pack
        await reviewModel.getReviewsByProductPack(
            detail['product_id'], productPackIdInt);
        print('Reviews found: ${reviewModel.reviews?.length ?? 0}');
        if (reviewModel.reviews != null) {
          for (var review in reviewModel.reviews!) {
            print(
                'Review - UserId: ${review.userId}, ProductPackId: ${review.productPackId}, CurrentUserId: ${configModel.user!.id}, CheckingPackId: $productPackIdInt');
            // Check if user has reviewed this product pack
            if (review.userId == configModel.user!.id &&
                review.productPackId == productPackIdInt) {
              setState(() {
                _reviewedProducts.add(productPackIdInt);
              });
              print(
                  'User has already reviewed product pack: $productPackIdInt');
              break;
            }
          }
        }
      }
    }
    setState(() {
      _isLoadingReviews = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final configModel = locator<ConfigModel>();
    final reviewModel = Provider.of<ReviewModel>(context, listen: false);
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
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  _buildOrderStatus(),
                  _buildOrderItems(context, configModel, reviewModel),
                  _buildCostBreakdown(reverseGstCalculation),
                  _buildPaymentInfo(),
                  _buildDateInfo(),
                  _buildPhoneInfo(),
                  _buildAddressInfo(),
                  _buildCancelButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.w),
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
                size: 16.sp,
                color: const Color(0xffEED056),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Order Details',
              textAlign: TextAlign.center,
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
          SizedBox(width: 48.w),
        ],
      ),
    );
  }

  Widget _buildOrderStatus() {
    final status = widget.arguments?['status']?.toString() ?? 'Unknown';
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Color(0xFFEED056).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEED056).withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
                decoration: BoxDecoration(
                  color: status == 'Delivered'
                      ? Colors.green.withOpacity(0.15)
                      : status == 'Order Processing'
                          ? Colors.orange.withOpacity(0.15)
                          : status == 'Cancelled'
                              ? Colors.red.withOpacity(0.15)
                              : Color(0xFFEED056).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  status,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: status == 'Delivered'
                        ? Colors.green
                        : status == 'Order Processing'
                            ? Colors.orange
                            : status == 'Cancelled'
                                ? Colors.red
                                : Color(0xFFEED056),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.w),
          Text(
            'Order #${widget.arguments?['order']['id']?.toString() ?? 'N/A'}',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1e1e1e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(
      BuildContext context, ConfigModel configModel, ReviewModel reviewModel) {
    final orderDetails =
        widget.arguments?['order']['order_details'] as List<dynamic>? ?? [];
    return Container(
      width: 322.w,
      height: MediaQuery.of(context).size.height *
          0.23 *
          (orderDetails.length < 2 ? orderDetails.length : 2),
      child: ListView.builder(
        itemCount: orderDetails.length,
        itemBuilder: (context, index) {
          final detail = orderDetails[index];
          // final productImages =
          //     widget.arguments?['product_images'] as List<dynamic>? ?? [];
          final newImageDisplay = detail['product_image_path'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 11.w),
                    child: Text(
                      detail['product']?['name']?.toString() ??
                          'Unknown Product',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3.w,
                        color: const Color(0xff1e1e1e),
                      ),
                    ),
                  ),
                  SizedBox(width: 50.w),
                  Container(
                    width: 60.w,
                    height: 80.w,
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
                    if (_isLoadingReviews)
                      SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xffEED056)),
                        ),
                      )
                    else if (!_reviewedProducts.contains(
                        detail['product_pack'] is String
                            ? int.tryParse(detail['product_pack']) ??
                                detail['product_pack']
                            : detail['product_pack']))
                      _buildReviewButton(context, reviewModel, detail),
                  ],
                ],
              ),
              _buildProductDetails(detail),
              Divider(color: Colors.black),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReviewButton(
      BuildContext context, ReviewModel reviewModel, dynamic detail) {
    final productId = detail['product_id'];
    final productPackId = detail['product_pack'];
    final productPackIdInt = productPackId is String
        ? int.tryParse(productPackId) ?? productPackId
        : productPackId;

    return InkWell(
      onTap: () =>
          _showReviewDialog(context, reviewModel, productPackIdInt, productId),
      child: Container(
        width: 74.5.w,
        height: 30.w,
        decoration: BoxDecoration(
          color: const Color(0xff232323),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Center(
          child: Text(
            '+ Review',
            style: MyGoogleFontStyle(
              fontFamily: 'Poppins',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, ReviewModel reviewModel,
      int productPackId, int productId) {
    _selectedImages = [];
    _currentRating = 0;
    _reviewDescription = '';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      onRatingUpdate: (rating) {
                        setDialogState(() => _currentRating = rating);
                      },
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
                    SizedBox(
                      height: 120,
                      child: MultipleImageUploadPage(
                        onImagesSelected: (images) {
                          setDialogState(() {
                            _selectedImages = images;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_reviewFormKey.currentState!.validate()) {
                                  if (_currentRating == 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Please select a rating')),
                                    );
                                    return;
                                  }
                                  _reviewFormKey.currentState!.save();
                                  print(
                                      'Submitting review - ProductId: $productId, Description: $_reviewDescription, Rating: $_currentRating, Images: ${_selectedImages.length}');
                                  setDialogState(() => _isLoading = true);
                                  try {
                                    await reviewModel.getMyReviews(
                                        productId,
                                        productPackId,
                                        _reviewDescription,
                                        _currentRating,
                                        _selectedImages);
                                    if (mounted) {
                                      Navigator.pop(context);
                                      // Update the parent widget's state after dialog is closed
                                      setState(() {
                                        _reviewedProducts.add(productPackId);
                                      });
                                      print(
                                          'Review submitted for product: $productId');
                                      print(
                                          'Reviewed products: $_reviewedProducts');
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to submit review: $e')),
                                      );
                                    }
                                  } finally {
                                    if (mounted)
                                      setDialogState(() => _isLoading = false);
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
      ),
    );
  }

  Widget _buildProductDetails(dynamic detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (detail['flavour'] != null)
          Container(
            margin: EdgeInsets.only(bottom: 7.w),
            constraints: BoxConstraints(maxWidth: 205.w),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Colour: ',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.24.w,
                      color: const Color(0xff1e1e1e),
                    ),
                  ),
                  TextSpan(
                    text: detail['flavour'].toString(),
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.24.w,
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
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.24.w,
                      color: const Color(0xff1e1e1e),
                    ),
                  ),
                  TextSpan(
                    text: detail['kind_of_flower']?.toString() ?? 'N/A',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.24.w,
                      color: const Color(0xff1e1e1e),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 34.w),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Quantity: ',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.24.w,
                      color: const Color(0xff1e1e1e),
                    ),
                  ),
                  TextSpan(
                    text: '${detail['quantity']?.toString()} X ' ?? '0',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.24.w,
                      color: const Color(0xff1e1e1e),
                    ),
                  ),
                  TextSpan(
                    text: detail['order_detail_cost'].toString() ?? '0',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.24.w,
                      color: const Color(0xff1e1e1e),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              'RS ${(int.parse(detail['quantity'].toString()) * int.parse(detail['order_detail_cost'].toString())).toString() ?? '0'}',
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.24.w,
                color: const Color(0xff1e1e1e),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCostBreakdown(String reverseGstCalculation) {
    final order = widget.arguments?['order'] ?? {};
    final address = order['address'];
    final isMaharashtra =
        address != null && address['state']?.toString() == 'Maharashtra';
    // Parse order_cost to double (handles both String and num from API)
    final orderCost =
        double.tryParse(order['order_cost']?.toString() ?? '0') ?? 0.0;
    final itemTotal = double.parse((orderCost / 105 * 100).toStringAsFixed(2));
    String abc = (orderCost - itemTotal).toStringAsFixed(2);
    return Column(
      children: [
        _buildCostRow('Item total', itemTotal.toStringAsFixed(2)),
        if (isMaharashtra) ...[
          _buildCostRow(
              'CGST 2.5%', (double.parse(abc) / 2).toStringAsFixed(2)),
          _buildCostRow(
              'SGST 2.5%', (double.parse(abc) / 2).toStringAsFixed(2)),
        ] else
          _buildCostRow('IGST 5%', abc),
        _buildCostRow(
            'Delivery charge', order['delivery_amount']?.toString() ?? '0'),
        _buildCostRow(
            'Packing charge', order['packaging_amount']?.toString() ?? '0'),
        _buildCostRow('Coupon Value', order['coupon_amount']?.toString() ?? '0',
            isNegative: true),
        _buildCostRow('Reward', order['wallet_amount_used']?.toString() ?? '0',
            isNegative: true),
        Divider(color: Colors.black, indent: 20.w, endIndent: 20.w),
        _buildCostRow('Grand Total', order['total_amount']?.toString() ?? '0',
            isBold: true),
        Divider(color: Colors.black, indent: 20.w, endIndent: 20.w),
      ],
    );
  }

  Widget _buildCostRow(String label, String value,
      {bool isBold = false, bool isNegative = false}) {
    return Container(
      width: 320.w,
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: isBold ? 14.sp : 12.sp,
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
              color: const Color(0xff1e1e1e),
            ),
          ),
          Text(
            isNegative ? '- RS $value' : 'RS $value',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: isBold ? 15.sp : 12.sp,
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
              letterSpacing: -0.24.w,
              color: const Color(0xff1e1e1e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, top: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff1e1e1e),
            ),
          ),
          Text(
            'Paid: ${widget.arguments?['order']['paymentmode']?.toString()}',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1e1e1e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo() {
    final String? rawDate =
        widget.arguments?['order']['created_at']?.toString();
    final String formattedDate = rawDate != null
        ? DateFormat('MMMM d, yyyy, h:mm a').format(DateTime.parse(rawDate))
        : 'N/A';

    return Padding(
      padding: EdgeInsets.only(left: 20.w, top: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff1e1e1e),
            ),
          ),
          Text(
            formattedDate,
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1e1e1e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInfo() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, top: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phone number',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff1e1e1e),
            ),
          ),
          Text(
            widget.arguments?['order']['address']?['phone'].toString() ?? 'N/A',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1e1e1e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressInfo() {
    final address = widget.arguments?['order']['address'] ?? {};
    return Padding(
      padding: EdgeInsets.only(left: 20.w, top: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deliver to:',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 12.sp,
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
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1e1e1e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    final status = widget.arguments?['status']?.toString().toLowerCase() ?? '';
    final orderId = widget.arguments?['order']['id'];

    // Only show cancel button for "Order placed" and "Order in processing" statuses
    // Handle various status name variations
    final canCancel = status.contains('place') ||
        status.contains('placed') ||
        status.contains('processing');

    if (!canCancel) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
      child: InkWell(
        onTap:
            _isLoading ? null : () => _showCancelConfirmation(context, orderId),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.w),
          decoration: BoxDecoration(
            color: _isLoading ? Colors.grey : Colors.red,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: _isLoading
                ? []
                : [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: _isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Cancelling Order...',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    'Cancel Order',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, int? orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Cancel Order',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xff1e1e1e),
            ),
          ),
          content: Text(
            'Are you sure you want to cancel this order? This action cannot be undone.',
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xff666666),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'No',
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff666666),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelOrder(context, orderId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OrdersPage(isProfile: {'isProfile': true}),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Yes, Cancel',
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelOrder(BuildContext context, int? orderId) async {
    if (orderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid order ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final orderModel = Provider.of<OrderModel>(context, listen: false);
      bool success = await orderModel.cancelOrder(orderId);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back to refresh the previous screen
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel order. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cancelling order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/product_pr.dart';
import 'package:sales_app/core/providers/review_pr.dart';
import 'package:sales_app/core/providers/wish_list_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/products/shops_p.dart';

import '../../../core/models/product.dart';

class ProductIdPage extends StatefulWidget {
  final arguments;
  const ProductIdPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<ProductIdPage> createState() => _ProductIdPageState();
}

class _ProductIdPageState extends State<ProductIdPage> {
  void initState() {
    super.initState();
    var productId = '';
    Provider.of<AddToCartModel>(context, listen: false)
        .getAddToCart(productId, '', _CartData);
    Provider.of<ProductModel>(context, listen: false)
        .getCategoryWiseProduct(widget.arguments!['product']['category_id']);
    Provider.of<WishListModel>(context, listen: false).getWishLists(productId);
    _format = DateFormat('yyyy-MM-dd');
  }

  int activeIndex = -1;

  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final _reviewFormKey = GlobalKey<FormState>();
  var _reviewDescription = '';
  DateFormat? _format;
  // ignore: non_constant_identifier_names
  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': ''
  };

  bool? check1 = false;
  List<Map<String, dynamic>> flavors = [
    {
      'id': 1,
      'name': 'Brown',
    },
    {
      'id': 2,
      'name': 'Red',
    },
  ];
  // List<Map<String, dynamic>> flowers = [
  //   {
  //     'id': 1,
  //     'name': 'Lily',
  //   },
  //   {
  //     'id': 2,
  //     'name': 'Rose',
  //   },
  // ];

  double discountPrice = 0.0;
  @override
  Widget build(BuildContext context) {
    Product product = Product.fromJson(widget.arguments['product']);
    // print(widget.arguments['product']['review']);
    List<Map<String, dynamic>> _sizes =
        widget.arguments['product']['product_packs'];
    final ConfigModel _configModel = locator<ConfigModel>();
    final ProductModel _productModel = Provider.of<ProductModel>(context);
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final WishListModel _wishListModel = Provider.of<WishListModel>(context);
    final ReviewModel _reviewModel = Provider.of<ReviewModel>(context);
    discountPrice = (int.parse(widget.arguments['product']['product_prices']![0]
                    ['price']
                .toString()) -
            int.parse(widget.arguments['product']['product_prices']![0]
                    ['offer_price']
                .toString())) /
        int.parse(widget.arguments['product']['product_prices']![0]['price']
            .toString()) *
        100;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30, left: 20, bottom: 10),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            'Product Details',
                            textAlign: TextAlign.center,
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e232c),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 30,
                              height: 15,
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                                color: Color(0xffEED056),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Container(
                            width: 238,
                            height: 38,
                            padding: const EdgeInsets.only(
                              left: 21,
                              right: 20.70,
                            ),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.50, color: Color(0xFFC7B456)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Center vertically
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 17.0),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        // if (value.length % 3 == 0) {
                                        // Call your API here
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ShopsPage(
                                                initialText: value
                                                    .toString()), // Pass initialText if needed
                                          ),
                                        );
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Search',
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 18,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w600,
                                        // letterSpacing: -0.36,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    'assets/images/Search-1.png',
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/cartPage');
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center vertically
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/shopping_cart.png',
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                widget.arguments['product'] != null
                    ? SingleChildScrollView(
                        child: Container(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Featured Image
                                Stack(children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 350,
                                    child: Image.network(
                                      _configModel.apiConfig['mediaURL'] +
                                          widget.arguments['product']
                                                  ['imagepath1']
                                              .toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Rounded Section
                                  Positioned(
                                    top: 325,
                                    child: Align(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 41,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xffffffff),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),

                                Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          // color: Colors.red,
                                          color: Color(0xffffffff),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            // Name
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        widget.arguments![
                                                                'product']
                                                                ['name']
                                                            .toString(),
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontSize: 19,
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    // Reviews
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Row(
                                                            children:
                                                                List.generate(5,
                                                                    (index) {
                                                              return Icon(
                                                                index < 5
                                                                    ? Icons.star
                                                                    : Icons
                                                                        .star_border,
                                                                color: Colors
                                                                    .amber,
                                                                size: 16,
                                                              );
                                                            }),
                                                          ),
                                                          Text(
                                                            '( ' +
                                                                (product.reviews ==
                                                                            null
                                                                        ? 0
                                                                        : product
                                                                            .reviews
                                                                            ?.length)
                                                                    .toString() +
                                                                ' Review)',
                                                            style:
                                                                MyGoogleFontStyle(
                                                              fontFamily:
                                                                  'Urbanist',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  10,
                                            ),
                                            // Qty
                                            Column(
                                              children: [
                                                if (_addToCartModel.addToCarts
                                                        ?.where((cart) =>
                                                            cart.productId ==
                                                            widget.arguments[
                                                                    'product']
                                                                ['id'])
                                                        ?.toList()
                                                        ?.isEmpty ??
                                                    true)
                                                  TextButton(
                                                    onPressed: () async {
                                                      // if (_formKey.currentState!
                                                      //     .validate()) {
                                                      _formKey.currentState!
                                                          .save();
                                                      bool type = true;
                                                      print(_CartData[
                                                          'kindOfFlower']);
                                                      print(
                                                          _CartData['flavour']);
                                                      if (_CartData[
                                                                  'kindOfFlower'] ==
                                                              '' ||
                                                          _CartData[
                                                                  'flavour'] ==
                                                              '') {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            title: Text(
                                                                "kindly choose colour and size."),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'Ok',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        await _addToCartModel
                                                            .getAddToCart(
                                                                widget.arguments![
                                                                        'product']
                                                                    ['id'],
                                                                type,
                                                                _CartData);
                                                      }
                                                    },
                                                    style: TextButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    child: Container(
                                                      width: 82,
                                                      height: 27.33,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffeaeaea)),
                                                        color:
                                                            Color(0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x3f000000),
                                                            offset: Offset(0,
                                                                2.1298701763),
                                                            blurRadius:
                                                                2.1298701763,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'ADD',
                                                          style:
                                                              MyGoogleFontStyle(
                                                            fontFamily:
                                                                'DM Sans',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            height: 1,
                                                            color: Color(
                                                                0xffc7b456),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if (_addToCartModel.addToCarts
                                                        ?.where((cart) =>
                                                            cart.productId ==
                                                            widget.arguments[
                                                                    'product']
                                                                ['id'])
                                                        ?.toList()
                                                        ?.isNotEmpty ==
                                                    true)
                                                  Center(
                                                    child: Row(
                                                      children: [
                                                        TextButton(
                                                          onPressed: () async {
                                                            bool minus = false;
                                                            await _addToCartModel
                                                                .getAddToCart(
                                                                    widget.arguments[
                                                                            'product']
                                                                        ['id'],
                                                                    minus,
                                                                    _CartData);
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            padding:
                                                                EdgeInsets.zero,
                                                          ),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    5),
                                                              ),
                                                            ),
                                                            child: Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Text(
                                                          // '1',
                                                          _addToCartModel
                                                                  .addToCarts!
                                                                  .where((_aTC) =>
                                                                      _aTC.productId ==
                                                                      widget.arguments[
                                                                              'product']
                                                                          [
                                                                          'id'])
                                                                  .toList()
                                                                  .isNotEmpty
                                                              ? _addToCartModel
                                                                  .addToCarts!
                                                                  .where((_aTC) =>
                                                                      _aTC.productId ==
                                                                      widget.arguments[
                                                                              'product']
                                                                          [
                                                                          'id'])
                                                                  .toList()[0]
                                                                  .qty
                                                                  .toString()
                                                              : '0',
                                                          style:
                                                              MyGoogleFontStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff1e1e1e),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            bool type = true;

                                                            await _addToCartModel
                                                                .getAddToCart(
                                                                    widget.arguments[
                                                                            'product']
                                                                        ['id'],
                                                                    type,
                                                                    _CartData);
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            padding:
                                                                EdgeInsets.zero,
                                                          ),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    5),
                                                              ),
                                                            ),
                                                            child: Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                Text(
                                                  'Avaliable in stock',
                                                  style: MyGoogleFontStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Price
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      widget.arguments['product']
                                                      ['product_prices']![0]
                                                  ['offer_price'] !=
                                              0
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                    text: 'Total Price',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[500]),
                                                    children: [
                                                      WidgetSpan(
                                                        child: SizedBox(
                                                            width:
                                                                20), // Adjust the width as needed
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'RS. ${widget.arguments['product']['product_prices']![0]['price'].toString()}',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFC7B456),
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      WidgetSpan(
                                                        child: SizedBox(
                                                            width:
                                                                20), // Adjust the width as needed
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              'RS.${widget.arguments['product']['product_prices']![0]['offer_price'].toString()}',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Text(
                                              'RS ${widget.arguments['product']['product_prices']![0]['price'].toString()}',
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                height: 1.5,
                                                letterSpacing: -0.2190869331,
                                                color: Color(0x99000000),
                                              ),
                                            ),
                                      if (discountPrice != 0.0)
                                        Center(
                                          child: Text(
                                            '( ${discountPrice.round()}% Off)',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              // height: 1.5 * ffem / fem,
                                              // letterSpacing:
                                              //     -0.2190869331 * fem,
                                              color: Color(0x99000000),
                                            ),
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, top: 10),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Customer Ratings',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              // height: 1.5 * ffem / fem,
                                              // letterSpacing:
                                              //     -0.2190869331 * fem,
                                              color: Color(0x99000000),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '4.7',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  // height: 1.5 * ffem / fem,
                                                  // letterSpacing:
                                                  //     -0.2190869331 * fem,
                                                  color: Color(0x99000000),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, left: 3),
                                            child: Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                ' ( ${(product.reviews == null ? 0 : product.reviews?.length)} ratings )',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20.0, top: 10),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'View Ratings',
                                                style: MyGoogleFontStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  // height: 1.5 * ffem / fem,
                                                  // letterSpacing:
                                                  //     -0.2190869331 * fem,
                                                  color: Color(0x99000000),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),

                                // Description and Reviews
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 310,
                                  child: DefaultTabController(
                                    length: 3,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          child: TabBar(
                                            indicatorColor: Colors.black,
                                            tabs: [
                                              Text(
                                                'Description',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                'Reviews',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                'Write a review',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          height: 250,
                                          child: TabBarView(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(widget
                                                    .arguments!['product']
                                                        ['description']
                                                    .toString()),
                                              ),
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      // height:
                                                      //     MediaQuery.of(context)
                                                      //             .size
                                                      //             .height -
                                                      //         50,
                                                      child: product.reviews ==
                                                              null
                                                          ? Center(
                                                              child: Text(
                                                                  'No reviews'))
                                                          : SingleChildScrollView(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0),
                                                                child: SizedBox(
                                                                  height: 240,
                                                                  child: ListView
                                                                      .builder(
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    itemCount: widget
                                                                        .arguments![
                                                                            'product']
                                                                            [
                                                                            'reviews']!
                                                                        .length,
                                                                    itemBuilder:
                                                                        (BuildContext context,
                                                                                index) =>
                                                                            Container(
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              10),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                Color(0xffc7b456)),
                                                                        color: Color(
                                                                            0xffffffff),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(5)),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Color(0x338a959e),
                                                                            offset:
                                                                                Offset(0, 7.6690645218),
                                                                            blurRadius:
                                                                                19.1726608276,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(_configModel.user.firstName.toString()),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  _format!.format(DateTime.parse(widget.arguments!['product']['reviews']![index]['created_at'].toString())),
                                                                                  textAlign: TextAlign.right,
                                                                                  style: MyGoogleFontStyle(
                                                                                    fontFamily: 'Poppins',
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: Color(0xff909090),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                              height: 10),
                                                                          Text(
                                                                            widget.arguments!['product']['reviews']![index]['description'].toString(),
                                                                            style:
                                                                                MyGoogleFontStyle(
                                                                              fontFamily: 'Poppins',
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Color(0xff909090),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Form(
                                                  key: _reviewFormKey,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xffdadada)),
                                                          color:
                                                              Color(0xffffffff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: TextFormField(
                                                          maxLines: 6,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            errorBorder:
                                                                InputBorder
                                                                    .none,
                                                            disabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            hintText:
                                                                'Write your review here.',
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            hintStyle: TextStyle(
                                                                color: Color(
                                                                    0xff8390a1)),
                                                          ),
                                                          initialValue:
                                                              _reviewDescription,
                                                          onSaved: (value) {
                                                            _reviewDescription =
                                                                value
                                                                    .toString();
                                                          },
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Please write some review.';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                5, 0, 6.34, 0),
                                                        child: TextButton(
                                                          onPressed: _loading
                                                              ? null
                                                              : () async {
                                                                  if (_reviewFormKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    _reviewFormKey
                                                                        .currentState!
                                                                        .save();

                                                                    setState(
                                                                        () {
                                                                      _loading =
                                                                          true;
                                                                    });

                                                                    await _reviewModel
                                                                        .getMyReviews(
                                                                      widget.arguments[
                                                                              'product']
                                                                          [
                                                                          'id'],
                                                                      _reviewDescription,
                                                                    );

                                                                    setState(
                                                                        () {
                                                                      _loading =
                                                                          false;
                                                                    });

                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                            MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              ProductIdPage(
                                                                        arguments: {
                                                                          'product':
                                                                              widget.arguments!['product']
                                                                        },
                                                                      ),
                                                                    ));
                                                                  }
                                                                },
                                                          style: TextButton
                                                              .styleFrom(
                                                            padding:
                                                                EdgeInsets.zero,
                                                          ),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            height: 53,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xff1e1e1e),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Center(
                                                              child: _loading
                                                                  ? SizedBox(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                      ),
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                    )
                                                                  : Text(
                                                                      'Post Review',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          MyGoogleFontStyle(
                                                                        fontFamily:
                                                                            'Urbanist',
                                                                        fontSize:
                                                                            15.1428556442,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        height:
                                                                            1.4999999685,
                                                                        color: Color(
                                                                            0xffffffff),
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
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Size
                                Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Size',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 9,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 8),
                                                width: 381,
                                                height: 60,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 295,
                                                      child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            _sizes.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                index) {
                                                          final isActive =
                                                              index ==
                                                                  activeIndex;
                                                          return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 52,
                                                                height: 52,
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      activeIndex =
                                                                          index;
                                                                      print(
                                                                          'tab');
                                                                      print(_sizes[
                                                                              index]
                                                                          [
                                                                          'value']);

                                                                      _CartData[
                                                                          'kindOfFlower'] = _sizes[index]
                                                                              [
                                                                              'value']
                                                                          .toString();
                                                                    });
                                                                  },
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    backgroundColor:
                                                                        isActive
                                                                            ? Colors.black // Set the active color here
                                                                            : null,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0), // Adjust the border radius
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    width: 50,
                                                                    height: 50,
                                                                    decoration:
                                                                        ShapeDecoration(
                                                                      shape:
                                                                          OvalBorder(
                                                                        side: BorderSide(
                                                                            width:
                                                                                0.95,
                                                                            color:
                                                                                Color(0xFFDDDDDD)),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        _sizes[index]['value']
                                                                            .toString(),
                                                                        style:
                                                                            MyGoogleFontStyle(
                                                                          fontFamily:
                                                                              'Urbanist',
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          height:
                                                                              1.2,
                                                                          letterSpacing:
                                                                              -0.36,
                                                                          color: isActive
                                                                              ? Colors.white
                                                                              : Color(0x99000000),
                                                                          // Set the text color based on active state
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 10),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Image.asset(
                                                      'assets/images/size-chart-icon.png',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Size Chart',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        width: 318.36,
                                        height: 70,
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 0.95,
                                                color: Color(0xFFDADADA)),
                                            borderRadius:
                                                BorderRadius.circular(19.01),
                                          ),
                                        ),
                                        child: DropdownButtonFormField(
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                labelText: 'Select Color',
                                                contentPadding:
                                                    EdgeInsets.all(10)),
                                            items: flavors
                                                .map(
                                                  (_flavor) => DropdownMenuItem(
                                                    child: Text(
                                                      _flavor['name'],
                                                    ),
                                                    value: _flavor['name'],
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {
                                              _CartData['flavour'] =
                                                  value.toString();
                                            }),
                                      ),
                                    ],
                                  ),
                                ),

                                // Add More Items
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Add More Items',
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 220,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: _productModel
                                                        .categoryWiseproductsLoader
                                                    ? Center(
                                                        child:
                                                            LinearProgressIndicator())
                                                    : ListView.builder(
                                                        itemCount: _productModel
                                                            .categoryWiseproducts!
                                                            .length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (BuildContext
                                                                        context,
                                                                    index) =>
                                                                InkWell(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ProductIdPage(
                                                                            arguments: {
                                                                              'product': _productModel.categoryWiseproducts![index].toJson()
                                                                            })));
                                                          },
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                // margin: EdgeInsets.fromLTRB(
                                                                //     0, 0, 0, 0),
                                                                width: 170,
                                                                height: 320,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          140,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Positioned(
                                                                            // frame9SvA (318:2815)
                                                                            left:
                                                                                0,
                                                                            top:
                                                                                0,
                                                                            child:
                                                                                Container(
                                                                              padding: EdgeInsets.fromLTRB(106, 13, 14, 13),
                                                                              width: 145,
                                                                              height: 133,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15),
                                                                                color: Color(0x0c000000),
                                                                                image: DecorationImage(
                                                                                  fit: BoxFit.cover,
                                                                                  image: NetworkImage(_configModel.apiConfig['mediaURL'] + _productModel.categoryWiseproducts![index].imagepath1.toString()
                                                                                      // 'assets/images/shades-chocolate-cake-3-1-2-1-bg.png',
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                              child: InkWell(
                                                                                onTap: () async {
                                                                                  await _wishListModel.getWishLists(_productModel.categoryWiseproducts![index].id);
                                                                                },
                                                                                child: _wishListModel.wishLists!.where((wishList) => wishList.productId == _productModel.categoryWiseproducts![index].id && wishList.userId == _configModel.user.id).toList().length == 0
                                                                                    ? Align(
                                                                                        // vectorRZx (318:2001)
                                                                                        alignment: Alignment.topRight,
                                                                                        child: SizedBox(
                                                                                          width: 25,
                                                                                          height: 22.4,
                                                                                          child: Image.asset(
                                                                                            'assets/images/vector-yse.png',
                                                                                            width: 25,
                                                                                            height: 22.4,
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    : Align(
                                                                                        // vectorRZx (318:2001)
                                                                                        alignment: Alignment.topRight,
                                                                                        child: SizedBox(
                                                                                          width: 25,
                                                                                          height: 22.4,
                                                                                          child: Image.asset(
                                                                                            'assets/images/vector-wXc.png',
                                                                                            width: 25,
                                                                                            height: 22.4,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        _productModel
                                                                            .categoryWiseproducts![index]
                                                                            .name
                                                                            .toString(),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            MyGoogleFontStyle(
                                                                          fontFamily:
                                                                              'Urbanist',
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          height:
                                                                              1.2,
                                                                          letterSpacing:
                                                                              -0.3,
                                                                          color:
                                                                              Color(0xff000000),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context).push(MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ProductIdPage(arguments: {
                                                                                  'product': _productModel.categoryWiseproducts![index].toJson()
                                                                                })));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        child: _productModel.categoryWiseproducts![index].productPrices![0].offerPrice !=
                                                                                0
                                                                            ? Text.rich(TextSpan(children: [
                                                                                new TextSpan(
                                                                                  text: 'RS. ${_productModel.categoryWiseproducts![index].productPrices![0].price.toString()}',
                                                                                  style: new TextStyle(
                                                                                    color: Colors.grey,
                                                                                    decoration: TextDecoration.lineThrough,
                                                                                  ),
                                                                                ),
                                                                                new TextSpan(
                                                                                  text: ' RS.${_productModel.categoryWiseproducts![index].productPrices![0].offerPrice.toString()}',
                                                                                ),
                                                                              ]))
                                                                            : Text(
                                                                                _productModel.categoryWiseproducts![index].productPrices![0].price.toString() + " " + 'RS',
                                                                                style: MyGoogleFontStyle(
                                                                                  fontFamily: 'Poppins',
                                                                                  fontSize: 13,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  height: 1.5,
                                                                                  letterSpacing: -0.2190869331,
                                                                                  color: Color(0x99000000),
                                                                                ),
                                                                              ),
                                                                      ),
                                                                    ),
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
                                      ],
                                    ),
                                  ),
                                ),

                                // Earn Points Text
                                Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Earn 20 points for this product',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 2,
                                        color: Colors.black,
                                      ),
                                      // SizedBox(
                                      //   height: 20,
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Expanded(
                                          //   child: RichText(
                                          //     text: TextSpan(
                                          //       style: MyGoogleFontStyle(
                                          //         fontFamily: 'Poppins',
                                          //         fontWeight: FontWeight.w700,
                                          //         color: Color(0xff000000),
                                          //       ),
                                          //       children: [
                                          //         TextSpan(
                                          //           text: 'Total Price\n',
                                          //           style: MyGoogleFontStyle(
                                          //             fontFamily: 'Urbanist',
                                          //             fontWeight:
                                          //                 FontWeight.w400,
                                          //             color:
                                          //                 Color(0xffaaaaaa),
                                          //           ),
                                          //         ),
                                          //         TextSpan(
                                          //           text: 'RS' +
                                          //               ' ' +
                                          //               widget.arguments![
                                          //                       'product'][
                                          //                       'product_prices']
                                          //                       [0]['price']
                                          //                   .toString(),
                                          //           style: MyGoogleFontStyle(
                                          //             fontFamily: 'Poppins',
                                          //             fontWeight:
                                          //                 FontWeight.w700,
                                          //             fontSize: 20,
                                          //             color:
                                          //                 Color(0xff000000),
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          SizedBox(
                                            width: 150,
                                            height: 41,
                                            child: TextButton(
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _formKey.currentState!.save();
                                                  bool type = true;

                                                  // await _addToCartModel
                                                  //     .getAddToCart(
                                                  //         widget.arguments![
                                                  //             'product']['id'],
                                                  //         type,
                                                  //         _CartData);
                                                  Navigator.pushNamed(
                                                      context, '/cartPage');
                                                }
                                              },
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 10, 10, 10),
                                                decoration: BoxDecoration(
                                                  color: Color(0xff1e1e1e),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Image.asset(
                                                        'assets/images/shopping-bag-03.png',
                                                        width: 18,
                                                        height: 17,
                                                      ),
                                                    ),
                                                    Text(
                                                      // addtocartB9Y (318:2187)
                                                      'Go To Cart',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xffffffff),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            width: 150,
                                            height: 41,
                                            child: TextButton(
                                              onPressed: () async {},
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    30, 10, 10, 10),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFC7B456),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Image.asset(
                                                        'assets/images/shopping-bag-03.png',
                                                        width: 18,
                                                        height: 17,
                                                      ),
                                                    ),
                                                    Text(
                                                      // addtocartB9Y (318:2187)
                                                      'Buy Now',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xffffffff),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 650,
                        child: Center(child: CircularProgressIndicator()),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
      'name': 'Chocolate Cake With Venilla',
    },
    {
      'id': 2,
      'name': 'Chocolate Cake With Strawberry',
    },
  ];
  List<Map<String, dynamic>> flowers = [
    {
      'id': 1,
      'name': 'Lily',
    },
    {
      'id': 2,
      'name': 'Rose',
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _sizes =
        widget.arguments['product']['product_packs'];
    final ConfigModel _configModel = locator<ConfigModel>();
    final ProductModel _productModel = Provider.of<ProductModel>(context);
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final WishListModel _wishListModel = Provider.of<WishListModel>(context);
    final ReviewModel _reviewModel = Provider.of<ReviewModel>(context);

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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                widget.arguments['product'] != null
                    ? SingleChildScrollView(
                        child: Container(
                          height: widget.arguments['product']['category']
                                      ['name'] ==
                                  'Flower'
                              ? 1330
                              : 1480,
                          child: Form(
                            key: _formKey,
                            child: Stack(
                              children: [
                                // Featured Image
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 435,
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
                                  left: 0,
                                  top: 364,
                                  child: Align(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 412,
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
                                Positioned(
                                  left: 25,
                                  top: 370,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              // Name
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        widget.arguments![
                                                                'product']
                                                                ['name']
                                                            .toString(),
                                                        style:
                                                            MyGoogleFontStyle(
                                                          fontSize: 17,
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                      // Reviews
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/vector-TXk.png',
                                                              width: 20,
                                                              height: 15,
                                                            ),
                                                            Image.asset(
                                                              'assets/images/vector-TXk.png',
                                                              width: 20,
                                                              height: 15,
                                                            ),
                                                            Image.asset(
                                                              'assets/images/vector-TXk.png',
                                                              width: 20,
                                                              height: 15,
                                                            ),
                                                            Image.asset(
                                                              'assets/images/vector-TXk.png',
                                                              width: 20,
                                                              height: 15,
                                                            ),
                                                            Image.asset(
                                                              'assets/images/vector-TXk.png',
                                                              width: 20,
                                                              height: 15,
                                                            ),
                                                            Text(
                                                              '( ' +
                                                                  widget
                                                                      .arguments[
                                                                          'product']
                                                                          [
                                                                          'reviews']
                                                                      .length
                                                                      .toString() +
                                                                  ' )',
                                                              style:
                                                                  MyGoogleFontStyle(
                                                                fontFamily:
                                                                    'Urbanist',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                    0xff000000),
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
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          _formKey.currentState!
                                                              .save();
                                                          bool type = true;
                                                          await _addToCartModel
                                                              .getAddToCart(
                                                                  widget.arguments![
                                                                          'product']
                                                                      ['id'],
                                                                  type,
                                                                  _CartData);
                                                        }
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                      child: Container(
                                                        width: 82,
                                                        height: 27.33,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xffeaeaea)),
                                                          color:
                                                              Color(0xffffffff),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  7.0163693428),
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
                                                                  FontWeight
                                                                      .w700,
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
                                                            onPressed:
                                                                () async {
                                                              bool minus =
                                                                  false;
                                                              await _addToCartModel
                                                                  .getAddToCart(
                                                                      widget.arguments[
                                                                              'product']
                                                                          [
                                                                          'id'],
                                                                      minus,
                                                                      _CartData);
                                                            },
                                                            style: TextButton
                                                                .styleFrom(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            ),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border
                                                                    .all(),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                  Icons.remove),
                                                            ),
                                                          ),
                                                          Text(
                                                            // '1',
                                                            _addToCartModel
                                                                    .addToCarts!
                                                                    .where((_aTC) =>
                                                                        _aTC.productId ==
                                                                        widget.arguments['product']
                                                                            [
                                                                            'id'])
                                                                    .toList()
                                                                    .isNotEmpty
                                                                ? _addToCartModel
                                                                    .addToCarts!
                                                                    .where((_aTC) =>
                                                                        _aTC.productId ==
                                                                        widget.arguments['product']
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
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xff1e1e1e),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              bool type = true;

                                                              await _addToCartModel
                                                                  .getAddToCart(
                                                                      widget.arguments[
                                                                              'product']
                                                                          [
                                                                          'id'],
                                                                      type,
                                                                      _CartData);
                                                            },
                                                            style: TextButton
                                                                .styleFrom(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            ),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border
                                                                    .all(),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                  Icons.add),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  Text(
                                                    'Avaliable in stock',
                                                    style: MyGoogleFontStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                ),
                                // Size
                                Positioned(
                                  left: 25,
                                  top: 450,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
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
                                        Container(
                                          width: 340,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xffdadada)),
                                            color: Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: DropdownButtonFormField(
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  labelText: 'Select Size',
                                                  contentPadding:
                                                      EdgeInsets.all(10)),
                                              items: _sizes
                                                  .map(
                                                    (_size) => DropdownMenuItem(
                                                      child: Text(
                                                        _size['value']
                                                                .toString() +
                                                            ' ' +
                                                            _size['unit']
                                                                    ['name']
                                                                .toString(),
                                                      ),
                                                      value: _size['value']
                                                              .toString() +
                                                          ' ' +
                                                          _size['unit']['name']
                                                              .toString(),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (value) {
                                                _CartData['pack'] =
                                                    value.toString();
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Flavour
                                if (widget.arguments['product']['category']
                                            ['name'] ==
                                        'Cake' ||
                                    widget.arguments['product']['category']
                                            ['name'] ==
                                        'Cakes & Flowers')
                                  Positioned(
                                    left: 25,
                                    top: 550,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Flavour',
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
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xffdadada)),
                                              color: Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: DropdownButtonFormField(
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    labelText: 'Select Flavor',
                                                    contentPadding:
                                                        EdgeInsets.all(10)),
                                                items: flavors
                                                    .map(
                                                      (_flavor) =>
                                                          DropdownMenuItem(
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
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                if (widget.arguments['product']['category']
                                        ['name'] ==
                                    'Flower')
                                  Positioned(
                                    left: 25,
                                    top: 560,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Flower',
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
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xffdadada)),
                                              color: Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: DropdownButtonFormField(
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    labelText: 'Select Flower',
                                                    contentPadding:
                                                        EdgeInsets.all(10)),
                                                items: flowers
                                                    .map(
                                                      (_flower) =>
                                                          DropdownMenuItem(
                                                        child: Text(
                                                          _flower['name'],
                                                        ),
                                                        value: _flower['name'],
                                                      ),
                                                    )
                                                    .toList(),
                                                onChanged: (value) {
                                                  _CartData['kindOfFlower'] =
                                                      value.toString();
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                if (widget.arguments['product']['category']
                                        ['name'] !=
                                    'Flower')
                                  // Writing on the cake
                                  Positioned(
                                    left: 25,
                                    top: widget.arguments['product']['category']
                                                ['name'] !=
                                            'Flower'
                                        ? 660
                                        : widget.arguments['product']
                                                    ['category']['name'] ==
                                                'Cakes & Flowers'
                                            ? 800
                                            : 660,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Writing on the Cake',
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
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xffdadada)),
                                              color: Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                hintText: 'Add your text here',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                hintStyle: TextStyle(
                                                    color: Color(0xff8390a1)),
                                              ),
                                              initialValue:
                                                  _CartData['writeOnCake'],
                                              onSaved: (value) {
                                                _CartData['writeOnCake'] =
                                                    value.toString();
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please write someting.';
                                                }
                                                return null;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                // Add More Items
                                Stack(
                                  children: [
                                    Positioned(
                                      left: 25,
                                      top: widget.arguments['product']
                                                  ['category']['name'] ==
                                              'Flower'
                                          ? 670
                                          : widget.arguments['product']
                                                      ['category']['name'] ==
                                                  'Cake'
                                              ? 770
                                              : 760,
                                      child: Container(
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
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
                                                                            ProductIdPage(arguments: {
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
                                                                          BorderRadius.circular(
                                                                              15),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              160,
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              Positioned(
                                                                                // frame9SvA (318:2815)
                                                                                left: 0,
                                                                                top: 0,
                                                                                child: Container(
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
                                                                              if (_addToCartModel.addToCarts!.where((cart) => cart.productId == _productModel.categoryWiseproducts![index].id && cart.userId == _configModel.user.id).toList().isEmpty)
                                                                                Positioned(
                                                                                  // frame494xX8 (318:2821)
                                                                                  left: 31,
                                                                                  top: 165,
                                                                                  child: TextButton(
                                                                                    onPressed: () async {
                                                                                      _formKey.currentState!.save();
                                                                                      print(_CartData.toString());
                                                                                      bool type = true;
                                                                                      // await _addToCartModel.getAddToCart(_productModel.categoryWiseproducts![index].id, type, _CartData);
                                                                                    },
                                                                                    style: TextButton.styleFrom(
                                                                                      padding: EdgeInsets.zero,
                                                                                    ),
                                                                                    child: Container(
                                                                                      width: 82,
                                                                                      height: 27.33,
                                                                                      decoration: BoxDecoration(
                                                                                        border: Border.all(color: Color(0xffeaeaea)),
                                                                                        color: Color(0xffffffff),
                                                                                        borderRadius: BorderRadius.circular(7.0163693428),
                                                                                        boxShadow: [
                                                                                          BoxShadow(
                                                                                            color: Color(0x3f000000),
                                                                                            offset: Offset(0, 2.1298701763),
                                                                                            blurRadius: 2.1298701763,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          'ADD',
                                                                                          style: MyGoogleFontStyle(
                                                                                            fontFamily: 'DM Sans',
                                                                                            fontSize: 12,
                                                                                            fontWeight: FontWeight.w700,
                                                                                            height: 1,
                                                                                            color: Color(0xffc7b456),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              if (_addToCartModel.addToCarts!.where((cart) => cart.productId == _productModel.categoryWiseproducts![index].id && cart.userId == _configModel.user.id).toList().isNotEmpty)
                                                                                Positioned(
                                                                                  left: 17,
                                                                                  top: 115,
                                                                                  child: Container(
                                                                                    width: 115,
                                                                                    height: 30.33,
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(color: Color(0xffeaeaea)),
                                                                                      color: Color(0xffffffff),
                                                                                      borderRadius: BorderRadius.circular(7.0163693428),
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          color: Color(0x3f000000),
                                                                                          offset: Offset(0, 2.1298701763),
                                                                                          blurRadius: 2.1298701763,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    child: Center(
                                                                                      child: Row(
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            width: 50,
                                                                                            child: TextButton(
                                                                                              onPressed: () async {
                                                                                                bool minus = false;
                                                                                                await _addToCartModel.getAddToCart(_productModel.categoryWiseproducts![index].id, minus, _CartData);
                                                                                              },
                                                                                              style: TextButton.styleFrom(
                                                                                                padding: EdgeInsets.zero,
                                                                                              ),
                                                                                              child: Container(
                                                                                                decoration: BoxDecoration(
                                                                                                  border: Border.all(),
                                                                                                  borderRadius: BorderRadius.all(
                                                                                                    Radius.circular(5),
                                                                                                  ),
                                                                                                ),
                                                                                                child: Icon(Icons.remove),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            // '1',
                                                                                            _addToCartModel.addToCarts!.where((_aTC) => _aTC.productId == _productModel.categoryWiseproducts![index].id).toList()[0].qty.toString(),
                                                                                            style: MyGoogleFontStyle(
                                                                                              fontFamily: 'Poppins',
                                                                                              fontWeight: FontWeight.w500,
                                                                                              color: Color(0xff1e1e1e),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 50,
                                                                                            child: TextButton(
                                                                                              onPressed: () async {
                                                                                                bool type = true;

                                                                                                await _addToCartModel.getAddToCart(_productModel.categoryWiseproducts![index].id, type, _CartData);
                                                                                              },
                                                                                              style: TextButton.styleFrom(
                                                                                                padding: EdgeInsets.zero,
                                                                                              ),
                                                                                              child: Container(
                                                                                                decoration: BoxDecoration(
                                                                                                  border: Border.all(),
                                                                                                  borderRadius: BorderRadius.all(
                                                                                                    Radius.circular(5),
                                                                                                  ),
                                                                                                ),
                                                                                                child: Icon(Icons.add),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              else
                                                                                Positioned(
                                                                                  // frame494xX8 (318:2821)
                                                                                  left: 31,
                                                                                  top: 110,
                                                                                  child: TextButton(
                                                                                    onPressed: () async {
                                                                                      bool type = true;
                                                                                      await _addToCartModel.getAddToCart(_productModel.categoryWiseproducts![index].id, type, _CartData);
                                                                                      // Navigator.pushNamed(context, '/cartPage');
                                                                                    },
                                                                                    style: TextButton.styleFrom(
                                                                                      padding: EdgeInsets.zero,
                                                                                    ),
                                                                                    child: Container(
                                                                                      width: 82,
                                                                                      height: 27.33,
                                                                                      decoration: BoxDecoration(
                                                                                        border: Border.all(color: Color(0xffeaeaea)),
                                                                                        color: Color(0xffffffff),
                                                                                        borderRadius: BorderRadius.circular(7.0163693428),
                                                                                        boxShadow: [
                                                                                          BoxShadow(
                                                                                            color: Color(0x3f000000),
                                                                                            offset: Offset(0, 2.1298701763),
                                                                                            blurRadius: 2.1298701763,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          'ADD',
                                                                                          style: MyGoogleFontStyle(
                                                                                            fontFamily: 'DM Sans',
                                                                                            fontSize: 12,
                                                                                            fontWeight: FontWeight.w700,
                                                                                            height: 1,
                                                                                            color: Color(0xffc7b456),
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
                                                                            _productModel.categoryWiseproducts![index].name.toString(),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                MyGoogleFontStyle(
                                                                              fontFamily: 'Urbanist',
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w700,
                                                                              height: 1.2,
                                                                              letterSpacing: -0.3,
                                                                              color: Color(0xff000000),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.of(context).push(MaterialPageRoute(
                                                                                builder: (context) => ProductIdPage(arguments: {
                                                                                      'product': _productModel.categoryWiseproducts![index].toJson()
                                                                                    })));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Text(
                                                                              _productModel.categoryWiseproducts![index].productPrices![0].price.toString(),
                                                                              style: MyGoogleFontStyle(
                                                                                fontFamily: 'Poppins',
                                                                                fontSize: 10.9543466568,
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
                                  ],
                                ),
                                // Description and Reviews
                                Positioned(
                                  left: 25,
                                  top: widget.arguments['product']['category']
                                              ['name'] ==
                                          'Flower'
                                      ? 910
                                      : widget.arguments['product']['category']
                                                  ['name'] ==
                                              'Cake'
                                          ? 1010
                                          : 1020,
                                  child: Container(
                                    child: DefaultTabController(
                                      length: 2,
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
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    'Description',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    'Reviews',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                50,
                                            height: widget
                                                        .arguments!['product']
                                                            ['reviews']
                                                        .length ==
                                                    1
                                                ? 160
                                                : 250,
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
                                                SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
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
                                                                  color: Color(
                                                                      0xffffffff),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                child:
                                                                    TextFormField(
                                                                  maxLines: 3,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
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
                                                                    hintStyle:
                                                                        TextStyle(
                                                                            color:
                                                                                Color(0xff8390a1)),
                                                                  ),
                                                                  initialValue:
                                                                      _reviewDescription,
                                                                  onSaved:
                                                                      (value) {
                                                                    _reviewDescription =
                                                                        value
                                                                            .toString();
                                                                  },
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                        .isEmpty) {
                                                                      return 'Please write some review.';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        5,
                                                                        0,
                                                                        6.34,
                                                                        0),
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () async {
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

                                                                      await _reviewModel.getMyReviews(
                                                                          widget.arguments['product']
                                                                              [
                                                                              'id'],
                                                                          _reviewDescription);
                                                                      setState(
                                                                          () {
                                                                        _loading =
                                                                            false;
                                                                      });

                                                                      Navigator.of(context).push(MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ProductIdPage(arguments: {
                                                                                'product': widget.arguments!['product']
                                                                              })));
                                                                    }
                                                                  },
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height: 53,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xff1e1e1e),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child: _loading
                                                                          ? SizedBox(
                                                                              child: CircularProgressIndicator(
                                                                                backgroundColor: Colors.white,
                                                                              ),
                                                                              height: 20,
                                                                              width: 20,
                                                                            )
                                                                          : Text(
                                                                              'Post Review',
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
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .height,
                                                        // margin:
                                                        //     EdgeInsets.all(5),
                                                        child: widget
                                                                    .arguments![
                                                                        'product']
                                                                        [
                                                                        'reviews']
                                                                    .length ==
                                                                0
                                                            ? Center(
                                                                child: Text(
                                                                    'No reviews'))
                                                            : ListView.builder(
                                                                itemCount: widget
                                                                    .arguments![
                                                                        'product']
                                                                        [
                                                                        'reviews']!
                                                                    .length,
                                                                itemBuilder: (BuildContext
                                                                            context,
                                                                        index) =>
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Color(
                                                                            0xffc7b456)),
                                                                    color: Color(
                                                                        0xffffffff),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius
                                                                          .circular(
                                                                              5),
                                                                    ),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Color(
                                                                            0x338a959e),
                                                                        offset: Offset(
                                                                            0,
                                                                            7.6690645218),
                                                                        blurRadius:
                                                                            19.1726608276,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      // Photo and Title
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      // mediaF3t (I318:2555;0:1388)
                                                                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                                                                      width: 66.71,
                                                                                      height: 66.71,
                                                                                      child: Image.network(
                                                                                        _configModel.apiConfig['mediaURL'] + widget.arguments!['product']['imagepath1'].toString(),
                                                                                        // 'assets/images/media.png',
                                                                                        width: 66.71,
                                                                                        height: 66.71,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 190,
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            widget.arguments!['product']['name'].toString(),
                                                                                            style: MyGoogleFontStyle(
                                                                                              fontFamily: 'Poppins',
                                                                                              fontSize: 16,
                                                                                              fontWeight: FontWeight.w400,
                                                                                              color: Color(0xff232323),
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            // BLr (I318:2555;0:1392)
                                                                                            '₹ ' + widget.arguments!['product']['product_prices']![0]['price'].toString(),
                                                                                            style: MyGoogleFontStyle(
                                                                                              fontFamily: 'Poppins',
                                                                                              fontSize: 16,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              color: Color(0xff232323),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      // Stars
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(_configModel.user.firstName.toString()),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              _format!.format(DateTime.parse(widget.arguments!['product']['reviews']![index]['created_at'].toString())),
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
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      // Description
                                                                      Text(
                                                                        widget
                                                                            .arguments!['product']['reviews']![index]['description']
                                                                            .toString(),
                                                                        style:
                                                                            MyGoogleFontStyle(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Color(0xff909090),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Earn Points Text
                                Positioned(
                                  left: 25,
                                  top: widget.arguments['product']['category']
                                              ['name'] ==
                                          'Flower'
                                      ? 1200
                                      : 1350,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
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
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xff000000),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'Total Price\n',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xffaaaaaa),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '₹ ' +
                                                          widget.arguments![
                                                                  'product'][
                                                                  'product_prices']
                                                                  [0]['price']
                                                              .toString(),
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 20,
                                                        color:
                                                            Color(0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _formKey.currentState!.save();
                                                  bool type = true;
                                                  await _addToCartModel
                                                      .getAddToCart(
                                                          widget.arguments![
                                                              'product']['id'],
                                                          type,
                                                          _CartData);
                                                  Navigator.pushNamed(
                                                      context, '/cartPage');
                                                }
                                              },
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    40, 20, 40, 20),
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
                                                        width: 20,
                                                        height: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      // addtocartB9Y (318:2187)
                                                      'Add To Cart',
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
                                          ],
                                        )
                                      ],
                                    ),
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

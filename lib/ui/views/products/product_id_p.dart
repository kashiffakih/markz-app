import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/product_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class ProductIdPage extends StatefulWidget {
  final arguments;
  const ProductIdPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<ProductIdPage> createState() => _ProductIdPageState();
}

class _ProductIdPageState extends State<ProductIdPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductModel>(context, listen: false)
        .getCategoryWiseProduct(widget.arguments!['product']['category_id']);
  }

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

  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
  };

  @override
  Widget build(BuildContext context) {
    final ConfigModel _configModel = locator<ConfigModel>();
    final ProductModel _productModel = Provider.of<ProductModel>(context);
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                  margin: EdgeInsets.only(top: 20, left: 20),
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
                    ? Container(
                        height: widget.arguments['product']['category']
                                    ['name'] ==
                                'Flower'
                            ? 1280
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
                                      widget.arguments['product']['imagepath1']
                                          .toString(),
                                  // 'assets/images/shades-chocolate-cake-3-1-2-1-YTY.png',
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
                                top: 405,
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            // Name
                                            Expanded(
                                              child: Text(
                                                widget.arguments!['product']
                                                        ['name']
                                                    .toString(),
                                                style: MyGoogleFontStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'Urbanist',
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                            // Qty
                                            Column(
                                              children: [
                                                // Container(
                                                //   padding: EdgeInsets.only(
                                                //       left: 10, right: 10),
                                                //   margin: EdgeInsets.only(bottom: 10),
                                                //   decoration: BoxDecoration(
                                                //     color: Color(0xfffbfbfb),
                                                //     borderRadius:
                                                //         BorderRadius.circular(30),
                                                //     boxShadow: [
                                                //       BoxShadow(
                                                //         color: Color(0x3f000000),
                                                //         offset: Offset(0, 2),
                                                //         blurRadius: 2,
                                                //       ),
                                                //     ],
                                                //   ),
                                                //   child: Center(
                                                //     child: Text(
                                                //       '-   1   +',
                                                //       style: MyGoogleFontStyle(
                                                //         fontFamily: 'Poppins',
                                                //         fontWeight: FontWeight.w400,
                                                //         color: Color(0xffc7b456),
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),
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
                                              // reviewgN2 (318:2121)
                                              '(320 Review)',
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // Size
                              Positioned(
                                left: 25,
                                top: 502,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Size',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.only(top: 5, right: 5),
                                          padding: EdgeInsets.only(
                                              left: 15, top: 15),
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xffdddddd)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintText: '3‘',
                                              hintStyle: TextStyle(
                                                  color: Color(0xff888888)),
                                            ),
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.only(top: 5, right: 5),
                                          padding: EdgeInsets.only(
                                              left: 15, top: 15),
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xff000000)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintText: '6‘',
                                              hintStyle: TextStyle(
                                                  color: Color(0xff888888)),
                                            ),
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
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
                                  top: 590,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
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
                                                  errorBorder: InputBorder.none,
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
                                      'Flower' ||
                                  widget.arguments['product']['category']
                                          ['name'] ==
                                      'Cakes & Flowers')
                                Positioned(
                                  left: 25,
                                  top: widget.arguments['product']['category']
                                              ['name'] ==
                                          'Flower'
                                      ? 590
                                      : widget.arguments['product']['category']
                                                  ['name'] ==
                                              'Cakes & Flowers'
                                          ? 800
                                          : 590,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
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
                                                  errorBorder: InputBorder.none,
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
                                      ? 700
                                      : widget.arguments['product']['category']
                                                  ['name'] ==
                                              'Cakes & Flowers'
                                          ? 800
                                          : 700,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
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
                                              disabledBorder: InputBorder.none,
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
                                            validator: (value) {},
                                          ),
                                          // TextFormField(
                                          //   decoration: InputDecoration(
                                          //       border: InputBorder.none,
                                          //       focusedBorder: InputBorder.none,
                                          //       enabledBorder: InputBorder.none,
                                          //       errorBorder: InputBorder.none,
                                          //       disabledBorder:
                                          //           InputBorder.none,
                                          //       labelText: 'Add your text here',
                                          //       contentPadding:
                                          //           EdgeInsets.all(10)),
                                          //   onSaved: (newValue) {
                                          //     WriteOnCake = newValue.toString();
                                          //   },
                                          // ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              // Add More Items
                              Positioned(
                                left: 25,
                                top: widget.arguments['product']['category']
                                            ['name'] ==
                                        'Flower'
                                    ? 700
                                    : widget.arguments['product']['category']
                                                ['name'] ==
                                            'Cake'
                                        ? 800
                                        : 900,
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
                                                          (BuildContext context,
                                                                  index) =>
                                                              InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ProductIdPage(
                                                                          arguments: {
                                                                            'product':
                                                                                _productModel.categoryWiseproducts![index].toJson()
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
                                                                    height: 160,
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
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                106,
                                                                                13,
                                                                                14,
                                                                                13),
                                                                            width:
                                                                                145,
                                                                            height:
                                                                                133,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              color: Color(0x0c000000),
                                                                              image: DecorationImage(
                                                                                fit: BoxFit.cover,
                                                                                image: NetworkImage(_configModel.apiConfig['mediaURL'] + _productModel.categoryWiseproducts![index].imagepath1.toString()
                                                                                    // 'assets/images/shades-chocolate-cake-3-1-2-1-bg.png',
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Align(
                                                                              // vector3f4 (318:2818)
                                                                              alignment: Alignment.topRight,
                                                                              child: SizedBox(
                                                                                width: 25,
                                                                                height: 22.4,
                                                                                child: TextButton(
                                                                                  onPressed: () {},
                                                                                  style: TextButton.styleFrom(
                                                                                    padding: EdgeInsets.zero,
                                                                                  ),
                                                                                  child: Image.asset(
                                                                                    'assets/images/vector-yse.png',
                                                                                    width: 25,
                                                                                    height: 22.4,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          // frame494xX8 (318:2821)
                                                                          left:
                                                                              31,
                                                                          top:
                                                                              110,
                                                                          child:
                                                                              TextButton(
                                                                            onPressed:
                                                                                () async {
                                                                              bool type = true;
                                                                              await _addToCartModel.getAddToCart(_productModel.categoryWiseproducts![index].id, type, '');
                                                                              Navigator.pushNamed(context, '/cartPage');
                                                                            },
                                                                            style:
                                                                                TextButton.styleFrom(
                                                                              padding: EdgeInsets.zero,
                                                                            ),
                                                                            child:
                                                                                Container(
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
                                                                    child: Text(
                                                                      _productModel
                                                                          .categoryWiseproducts![
                                                                              index]
                                                                          .name
                                                                          .toString(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                                                        color: Color(
                                                                            0xff000000),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                      _productModel
                                                                          .categoryWiseproducts![
                                                                              index]
                                                                          .productPrices![
                                                                              0]
                                                                          .price
                                                                          .toString(),
                                                                      style:
                                                                          MyGoogleFontStyle(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            10.9543466568,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        height:
                                                                            1.5,
                                                                        letterSpacing:
                                                                            -0.2190869331,
                                                                        color: Color(
                                                                            0x99000000),
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
                              // Description and Reviews
                              Positioned(
                                left: 25,
                                top: widget.arguments['product']['category']
                                            ['name'] ==
                                        'Flower'
                                    ? 950
                                    : widget.arguments['product']['category']
                                                ['name'] ==
                                            'Cake'
                                        ? 1050
                                        : 1150,
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
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  'Description',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
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
                                          height: 200,
                                          child: TabBarView(
                                            children: [
                                              Text(widget.arguments!['product']
                                                      ['description']
                                                  .toString()),
                                              Text('Reviews'),
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
                                    ? 1150
                                    : 1350,
                                child: Container(
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
                                                      color: Color(0xffaaaaaa),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: widget
                                                        .arguments!['product']
                                                            ['product_prices']
                                                            [0]['price']
                                                        .toString(),
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color(0xff000000),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              bool type = true;
                                              // print(_CartData.toString());
                                              await _addToCartModel
                                                  .getAddToCart(
                                                      widget.arguments![
                                                          'product']['id'],
                                                      type,
                                                      _CartData);
                                              Navigator.pushNamed(
                                                  context, '/cartPage');
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
                                                    'Add to Cart',
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Urbanist',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color(0xffffffff),
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

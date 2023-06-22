import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class ProductIdPage extends StatefulWidget {
  const ProductIdPage({Key? key}) : super(key: key);

  @override
  State<ProductIdPage> createState() => _ProductIdPageState();
}

class _ProductIdPageState extends State<ProductIdPage> {
  List<Map<String, dynamic>> flavors = [
    {
      'id': 1,
      'name': 'Chocolate Cake With',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                  height: 3000,
                  child: Stack(
                    children: [
                      // Featured Image
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Align(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 435,
                            child: Image.asset(
                              'assets/images/shades-chocolate-cake-3-1-2-1-YTY.png',
                            ),
                          ),
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
                                        '3 Shade Chocolate Cake',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                    // Qty
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          margin: EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            color: Color(0xfffbfbfb),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x3f000000),
                                                offset: Offset(0, 2),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              '-   1   +',
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xffc7b456),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          // avaliableinstockuAv (318:2110)
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
                                  margin: EdgeInsets.only(top: 5, right: 5),
                                  padding: EdgeInsets.only(left: 15, top: 15),
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffdddddd)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: '3‘',
                                      hintStyle:
                                          TextStyle(color: Color(0xff888888)),
                                    ),
                                    style: MyGoogleFontStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5, right: 5),
                                  padding: EdgeInsets.only(left: 15, top: 15),
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xff000000)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: '6‘',
                                      hintStyle:
                                          TextStyle(color: Color(0xff888888)),
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
                      Positioned(
                        left: 25,
                        top: 590,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  border: Border.all(color: Color(0xffdadada)),
                                  color: Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        labelText: 'Select Flavor',
                                        contentPadding: EdgeInsets.all(10)),
                                    items: flavors
                                        .map(
                                          (_flavor) => DropdownMenuItem(
                                            child: Text(
                                              _flavor['name'],
                                            ),
                                            value: _flavor['id'],
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {}),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Writing on the cake
                      Positioned(
                        left: 25,
                        top: 700,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  border: Border.all(color: Color(0xffdadada)),
                                  color: Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      labelText: 'Add your text here',
                                      contentPadding: EdgeInsets.all(10)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Add More Items
                      Positioned(
                        left: 25,
                        top: 800,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                width: MediaQuery.of(context).size.width,
                                height: 220,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, index) =>
                                                Text('Hi'),
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
                        top: 1100,
                        child: Container(
                          child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: TabBar(
                                    indicatorColor: Colors.black,
                                    tabs: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Description',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Reviews',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  height: 200,
                                  child: TabBarView(
                                    children: [
                                      Text('Description'),
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
                        top: 1300,
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
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                          TextSpan(
                                            text: '\$198.00',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 20, 40, 20),
                                      decoration: BoxDecoration(
                                        color: Color(0xff1e1e1e),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(right: 10),
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
                                              fontWeight: FontWeight.w700,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

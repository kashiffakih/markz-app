import 'package:flutter/material.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                                'Wishlist',
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
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 25,
                        top: 0,
                        child: SingleChildScrollView(
                          child: Container(
                            width: MediaQuery.of(context).size.width - 50,
                            height: MediaQuery.of(context).size.height - 200,
                            child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (BuildContext context, index) =>
                                  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 18, 0),
                                        child: Image.asset(
                                          'assets/images/mask-group-HvE.png',
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            Text(
                                              'Chocolate Cake',
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff909090),
                                              ),
                                            ),
                                            Text(
                                              '₹ 65.00',
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff1e1e1e),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  13, 4, 14, 6),
                                              width: 100,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: Color(0xff000000),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 5, 0),
                                                    child: Text(
                                                      'Add  to Cart',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xffffffff),
                                                      ),
                                                    ),
                                                  ),
                                                  Image.asset(
                                                    'assets/images/shopping-bag-03-YoY.png',
                                                    width: 9.5,
                                                    height: 9.2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () {},
                                                  style: TextButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                    ),
                                                    child: Icon(Icons.remove),
                                                  ),
                                                ),
                                                Text(
                                                  '1',
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff1e1e1e),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {},
                                                  style: TextButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                    ),
                                                    child: Icon(Icons.add),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Image.asset(
                                          'assets/images/shape-z7p.png',
                                          width: 18,
                                          height: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: Divider(
                                      thickness: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 25,
                        bottom: 100,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0.89, 0, 0, 0),
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Container(
                                    width: 321,
                                    height: 53,
                                    decoration: BoxDecoration(
                                      color: Color(0xff1e1e1e),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Add all to my cart',
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
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
                    ],
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

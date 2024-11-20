import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/product.dart';
import 'package:sales_app/core/providers/add_to_cart_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/product_pr.dart';
import 'package:sales_app/core/providers/wish_list_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/views/products/product_id_p.dart';
import 'package:badges/badges.dart' as badges;

class ShopsPage extends StatefulWidget {
  final initialText;
  const ShopsPage({Key? key, this.initialText}) : super(key: key);

  @override
  State<ShopsPage> createState() => ShopsPageState();
}

class ShopsPageState extends State<ShopsPage> {
  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': ''
  };
  bool _isInitialLoad = false;
  List<Product>? filteredProducts = [];
  int activeIndex = -1;

  // TextEditingController _controller = TextEditingController();
  var search = '';
  @override
  void initState() {
    super.initState();

    Provider.of<ProductModel>(context, listen: false).getCategories();
    Provider.of<ProductModel>(context, listen: false).getAllProducts(search);
    var productId = '';
    Provider.of<AddToCartModel>(context, listen: false)
        .getAddToCart(productId, '', _CartData);
    Provider.of<WishListModel>(context, listen: false).getWishLists(productId);
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    final ConfigModel _configModel = locator<ConfigModel>();
    final ProductModel _productModel = Provider.of<ProductModel>(context);
    final AddToCartModel _addToCartModel = Provider.of<AddToCartModel>(context);
    final WishListModel _wishListModel = Provider.of<WishListModel>(context);

    setState(() {
      if (!_isInitialLoad && _productModel.allProducts!.length > 0) {
        filteredProducts = _productModel.allProducts?.toList();
        _isInitialLoad = true;
      } else {
        _isInitialLoad = false;
      }
    });
    var cartCount = 0;
    setState(() {
      cartCount = _addToCartModel.addToCarts == null
          ? 0
          : _addToCartModel.addToCarts!.length;
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(9 * fem, 16 * fem, 0 * fem, 22 * fem),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    EdgeInsets.only(left: 20, top: 30, bottom: 20, right: 20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/homePage');
                      },
                      child: Center(
                        child: Text(
                          'Shops',
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 15,
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
                          width: 248,
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
                            crossAxisAlignment:
                                CrossAxisAlignment.center, // Center vertically
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: TextFormField(
                                    initialValue: widget.initialText.toString(),
                                    // controller: _controller,
                                    onChanged: (value) {
                                      if (value.length % 3 == 0) {
                                        setState(() {
                                          filteredProducts =
                                              Provider.of<ProductModel>(context,
                                                      listen: false)
                                                  .getAllProducts(value);
                                        });
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        filteredProducts =
                                            Provider.of<ProductModel>(context,
                                                    listen: false)
                                                .getAllProducts(value);
                                      });
                                    },
                                    autofocus: true,
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
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/cartPage');
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            child: badges.Badge(
                              badgeContent: Text(
                                cartCount.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              child: Image.asset(
                                'assets/images/cart-icon.png',
                                width: 23,
                                height: 23,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                  width: 391 * fem,
                  height: 35 * fem,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            activeIndex =
                                -1; // Set activeIndex to -1 for "All" button
                            filteredProducts =
                                _productModel.allProducts!.toList();
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: activeIndex == -1
                              ? Colors.black // Set the active color here
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        child: Container(
                          width: 50 * fem,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            border: activeIndex == -1
                                ? null
                                : Border.all(color: Color(0xffc7b456)),
                            borderRadius: BorderRadius.circular(5 * fem),
                          ),
                          child: Center(
                            child: Text(
                              'All',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.2 * ffem / fem,
                                letterSpacing: -0.36 * fem,
                                color: activeIndex == -1
                                    ? Colors.white // Set the active color here
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2 * fem,
                      ),
                      SizedBox(
                        width: 295,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _productModel.categories!.length,
                            itemBuilder: (BuildContext context, index) {
                              final isActive = index == activeIndex;
                              return Row(
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        activeIndex = index;
                                        filteredProducts = _productModel
                                            .allProducts!
                                            .where((element) =>
                                                element.categoryId ==
                                                _productModel.categories![index]
                                                    ['id'])
                                            .toList();

                                        print(filteredProducts);
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: isActive
                                            ? Colors
                                                .black // Set the active color here
                                            : null,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        )),
                                    child: Container(
                                      width: 79 * fem,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xffc7b456)),
                                        borderRadius:
                                            BorderRadius.circular(5 * fem),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _productModel.categories![index]
                                                  ['name']
                                              .toString(),
                                          style: MyGoogleFontStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 15 * ffem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2 * ffem / fem,
                                            letterSpacing: -0.36 * fem,
                                            color: isActive
                                                ? Colors.white
                                                : Color(0x99000000),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6 * fem,
                                  ),
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(12 * fem, 0 * fem, 22 * fem, 0 * fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    filteredProducts != null
                        ? Container(
                            width: double.infinity,
                            // height: double.infinity,
                            height: 582 * fem,
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 179,
                                  childAspectRatio: 1 / 2,
                                  crossAxisSpacing: 10,
                                  // mainAxisSpacing: 10
                                ),
                                itemCount: filteredProducts!.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  double discountPrice = (int.parse(
                                              filteredProducts![index]
                                                  .productPrices![0]
                                                  .price
                                                  .toString()) -
                                          int.parse(_productModel
                                              .allProducts![index]
                                              .productPrices![0]
                                              .offerPrice
                                              .toString())) /
                                      int.parse(_productModel
                                          .allProducts![index]
                                          .productPrices![0]
                                          .price
                                          .toString()) *
                                      100;
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 145 * fem,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15 * fem),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 210.33 * fem,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    // frame9SvA (318:2815)
                                                    left: 0 * fem,
                                                    top: 0 * fem,
                                                    child: InkWell(
                                                      onTap: () {
                                                        print(filteredProducts![
                                                                index]
                                                            .productImages);
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ProductIdPage(
                                                                        arguments: {
                                                                          'product':
                                                                              filteredProducts![index].toJson(),
                                                                          'product_images':
                                                                              filteredProducts![index].productImages
                                                                        })));
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                106 * fem,
                                                                13 * fem,
                                                                14 * fem,
                                                                13 * fem),
                                                        width: 145 * fem,
                                                        height: 193 * fem,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15 * fem),
                                                          color:
                                                              Color(0x0c000000),
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                              _configModel.apiConfig[
                                                                      'mediaURL'] +
                                                                  filteredProducts![
                                                                          index]
                                                                      .imagepath1
                                                                      .toString(),
                                                            ),
                                                            // 'assets/images/shades-chocolate-cake-3-1-2-1-bg.png',
                                                          ),
                                                        ),
                                                        child: InkWell(
                                                          onTap: () async {
                                                            await _wishListModel
                                                                .getWishLists(
                                                                    filteredProducts![
                                                                            index]
                                                                        .id);
                                                          },
                                                          child: _wishListModel
                                                                      .wishLists!
                                                                      .where((wishList) =>
                                                                          wishList.productId ==
                                                                              filteredProducts![index]
                                                                                  .id &&
                                                                          wishList.userId ==
                                                                              _configModel.user.id)
                                                                      .toList()
                                                                      .length ==
                                                                  0
                                                              ? Align(
                                                                  // vectorRZx (318:2001)
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      SizedBox(
                                                                    width: 25 *
                                                                        fem,
                                                                    height:
                                                                        22.4 *
                                                                            fem,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/vector-yse.png',
                                                                      width: 25 *
                                                                          fem,
                                                                      height:
                                                                          22.4 *
                                                                              fem,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Align(
                                                                  // vectorRZx (318:2001)
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      SizedBox(
                                                                    width: 25 *
                                                                        fem,
                                                                    height:
                                                                        22.4 *
                                                                            fem,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/vector-wXc.png',
                                                                      width: 25 *
                                                                          fem,
                                                                      height:
                                                                          22.4 *
                                                                              fem,
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
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                ProductIdPage(
                                                                    arguments: {
                                                                      'product':
                                                                          filteredProducts![index]
                                                                              .toJson(),
                                                                      'product_images':
                                                                          filteredProducts![index]
                                                                              .productImages
                                                                    })));
                                              },
                                              child: Container(
                                                // shadechocolatecake3mjU (318:2819)
                                                margin: EdgeInsets.fromLTRB(
                                                    10 * fem,
                                                    0 * fem,
                                                    0 * fem,
                                                    4 * fem),
                                                constraints: BoxConstraints(
                                                  maxWidth: 123 * fem,
                                                ),
                                                child: Text(
                                                  filteredProducts![index]
                                                      .name
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 15 * ffem,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.2 * ffem / fem,
                                                    letterSpacing: -0.3 * fem,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              // TMQ (318:2820)
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem,
                                                  0 * fem,
                                                  1 * fem,
                                                  0 * fem),
                                              child: filteredProducts![index]
                                                          .productPrices![0]
                                                          .offerPrice !=
                                                      0
                                                  ? Text.rich(
                                                      TextSpan(children: [
                                                      new TextSpan(
                                                        text:
                                                            'RS. ${filteredProducts![index].productPrices![0].price.toString()}',
                                                        style: new TextStyle(
                                                          color: Colors.grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      ),
                                                      new TextSpan(
                                                        text:
                                                            ' RS.${filteredProducts![index].productPrices![0].offerPrice.toString()}',
                                                      ),
                                                    ]))
                                                  : Text(
                                                      'RS. ${filteredProducts![index].productPrices![0].price.toString()}',
                                                      style: MyGoogleFontStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.5,
                                                        letterSpacing:
                                                            -0.2190869331,
                                                        color:
                                                            Color(0x99000000),
                                                      ),
                                                    ),
                                            ),
                                            if (discountPrice != 0.0)
                                              Center(
                                                child: Text(
                                                  '( ${discountPrice.round()}% Off)',
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 13 * ffem,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.5 * ffem / fem,
                                                    letterSpacing:
                                                        -0.2190869331 * fem,
                                                    color: Color(0x99000000),
                                                  ),
                                                ),
                                              ),
                                            SizedBox(
                                              child: Row(
                                                children: [
                                                  Row(
                                                    children: List.generate(5,
                                                        (index) {
                                                      return Icon(
                                                        index < 5
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color: Colors.amber,
                                                        size: 16,
                                                      );
                                                    }),
                                                  ),
                                                  Text(
                                                    ' ( ${filteredProducts?[index].reviews == null ? 0 : filteredProducts?[index].reviews?.length} Review )',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          )
                        : SizedBox(
                            height: 550,
                            child: Center(child: Text('No product found.'))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   elevation: 10,
      //   iconSize: 30,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.black,
      //   selectedFontSize: 14,
      //   unselectedFontSize: 14,
      //   onTap: (value) async {
      //     if (value == 0) {
      //       Navigator.pushNamed(context, '/homePage');
      //     }
      //     if (value == 1) {
      //       Navigator.pushNamed(context, '/wishlistPage');
      //     }

      //     if (value == 2) {
      //       Map<String, dynamic> _CartData = {
      //         'kindOfFlower': '',
      //         'flavour': '',
      //         'writeOnCake': '',
      //         'pack': ''
      //       };
      //       await _addToCartModel.getAddToCart('', '', _CartData);
      //       Navigator.pushNamed(context, '/cartPage');
      //     }
      //     if (value == 3) {
      //       Navigator.pushNamed(context, '/profilePage');
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: Iconoir(Iconoir.home_simple),
      //       // icon: Icon(DonIcons.wap_home, size: 23),
      //     ),
      //     BottomNavigationBarItem(label: 'Saved', icon: Iconoir(Iconoir.heart)),
      //     BottomNavigationBarItem(
      //       label: 'Cart',
      //       icon: Iconoir(Iconoir.shopping_bag),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Profile',
      //       icon: Icon(
      //         DonIcons.user_o,
      //         size: 23,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

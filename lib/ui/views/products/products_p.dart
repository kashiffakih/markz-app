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
import 'package:sales_app/ui/views/products/shops_p.dart';
import 'package:badges/badges.dart' as badges;

class ProductsPage extends StatefulWidget {
  final arguments;

  const ProductsPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Map<String, dynamic> _CartData = {
    'kindOfFlower': '',
    'flavour': '',
    'writeOnCake': '',
    'pack': ''
  };
  bool _isInitialLoad = false;
  List<Product>? filteredProducts = [];
  TextEditingController _controller = TextEditingController();

  int activeIndex = -1;
  @override
  void initState() {
    super.initState();
    var productId = '';
    print(widget.arguments['categoryId']);
    Provider.of<AddToCartModel>(context, listen: false)
        .getAddToCart(productId, '', _CartData);
    Provider.of<ProductModel>(context, listen: false)
        .getCategoryWiseProduct(widget.arguments['categoryId']);
    Provider.of<ProductModel>(context, listen: false).getCategories();
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
      if (!_isInitialLoad &&
          _productModel.categoryWiseproducts?.isNotEmpty == true) {
        filteredProducts = _productModel.categoryWiseproducts;
        _isInitialLoad = true;
      } else {
        // _isInitialLoad = false;
      }
    });
    var cartCount = 0;
    setState(() {
      cartCount = _addToCartModel.addToCarts == null
          ? 0
          : _addToCartModel.addToCarts!.length;
    });
    // print(filteredProducts);
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
              // Top Section
              Container(
                margin:
                    EdgeInsets.only(left: 20, top: 30, bottom: 20, right: 30),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          'Shop ${widget.arguments['category'].toString()}\'s',
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
                    // End Header
                    const SizedBox(height: 15),
                    // Categories
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
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
                                      _controller.clear();
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
                    // End Categories
                  ],
                ),
              ),
              // End Top Section
              SizedBox(
                height: 2 * fem,
              ),

              // Categories
              Container(
                // margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 5 * fem),
                height: 35 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          activeIndex =
                              -1; // Set activeIndex to -1 for "All" button
                          filteredProducts = _productModel.categoryWiseproducts!
                              .where((element) =>
                                  element.categoryId ==
                                  widget.arguments['categoryId'])
                              .toList();
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: activeIndex == -1
                            ? Colors.black // Set the active color here
                            : Colors.white,
                      ),
                      child: Container(
                        width: 55 * fem,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          border: activeIndex == -1
                              ? null
                              : Border.all(color: Color(0xffc7b456)),
                          borderRadius: BorderRadius.circular(15 * fem),
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
                      width: 5 * fem,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.arguments['subCategory'].length,
                        itemBuilder: (BuildContext context, index) {
                          final isActive = index == activeIndex;
                          return Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    activeIndex = index;
                                    print(activeIndex);
                                    print(index);
                                    print(widget.arguments['subCategory']);
                                    print(_productModel.categoryWiseproducts!);
                                    filteredProducts = [];
                                    filteredProducts = _productModel
                                        .categoryWiseproducts!
                                        .where((cat) =>
                                            cat.subCategoryId ==
                                            widget.arguments['subCategory']
                                                [index]['id'])
                                        .toList();
                                    print(filteredProducts![0].toJson());
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  backgroundColor:
                                      isActive ? Colors.black : null,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffc7b456)),
                                    borderRadius:
                                        BorderRadius.circular(15 * fem),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.arguments['subCategory'][index]
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
                                        // Set the text color based on active state
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 6 * fem),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // End Categories

              // Text(filteredProducts![0].toJson().toString()),

              // Product List
              Container(
                margin:
                    EdgeInsets.fromLTRB(12 * fem, 0 * fem, 22 * fem, 0 * fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    filteredProducts!.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height - 200,
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  childAspectRatio: 1 / 2,
                                  maxCrossAxisExtent: 200,
                                ),
                                itemCount: filteredProducts!.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  double discountPrice = (int.parse(
                                              filteredProducts![index]
                                                  .productPrices![0]
                                                  .price
                                                  .toString()) -
                                          int.parse(filteredProducts![index]
                                              .productPrices![0]
                                              .offerPrice
                                              .toString())) /
                                      int.parse(filteredProducts![index]
                                          .productPrices![0]
                                          .price
                                          .toString()) *
                                      100;
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Single Product
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
                                                    left: 0 * fem,
                                                    top: 0 * fem,
                                                    child: InkWell(
                                                      onTap: () {
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
                                                                      .productImages!
                                                                      .first
                                                                      .imagepath
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
                                                                          wishList.productId == filteredProducts![index].id &&
                                                                          wishList.userId ==
                                                                              _configModel
                                                                                  .user.id)
                                                                      .toList()
                                                                      .length ==
                                                                  0
                                                              ? Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child: Icon(Icons
                                                                      .favorite_border_outlined))
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child: Icon(
                                                                    Icons
                                                                        .favorite_outlined,
                                                                    color: Colors
                                                                        .red,
                                                                  )),
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
                                                              '₹${filteredProducts![index].productPrices![0].price.toString()}',
                                                          style: new TextStyle(
                                                            color: Colors.grey,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                          ),
                                                        ),
                                                        new TextSpan(
                                                          text:
                                                              ' ₹${filteredProducts![index].productPrices![0].offerPrice.toString()}',
                                                        ),
                                                      ]))
                                                    : Text(
                                                        '₹${filteredProducts![index].productPrices![0].price.toString()}',
                                                        style:
                                                            MyGoogleFontStyle(
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
                                                      )),
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
                                                    ' ( ${filteredProducts![index].reviews!.length} Review )',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // End Single Product
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
              // End Product List
            ],
          ),
        ),
      ),
    );
  }
}

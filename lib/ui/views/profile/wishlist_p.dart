import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/models/product.dart';
import 'package:aadab/core/providers/add_to_cart_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/core/providers/wish_list_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:badges/badges.dart' as badges;

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  bool _isPageLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isPageLoading = true);
    try {
      await Future.wait<void>([
        Provider.of<WishListModel>(context, listen: false).getWishLists(''),
        Provider.of<ProductModel>(context, listen: false).getAllProducts(''),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading wishlist: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPageLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WishListModel, AddToCartModel>(
      builder: (context, wishListModel, addToCartModel, _) {
        final configModel = locator<ConfigModel>();
        final cartCount = addToCartModel.addToCarts?.length ?? 0;

        return Scaffold(
          body: Container(
            width: 1.0.sw,
            height: 1.0.sh,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFFEF9), Color(0xFFFFFDF7), Colors.white],
              ),
            ),
            child: SafeArea(
              child: _isPageLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFEED056).withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEED056)),
                              strokeWidth: 3,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text('Loading...', style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff232323),
                          )),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        _buildHeader(context, cartCount),
                        Expanded(
                          child: _buildWishlistContent(context, wishListModel,
                              addToCartModel, configModel),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, int cartCount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.0.w),
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
                size: 16.0.sp,
                color: const Color(0xffEED056),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Wishlist',
              textAlign: TextAlign.center,
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 20.0.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/cartPage'),
            child: badges.Badge(
              badgeContent: Text(
                cartCount.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: Image.asset(
                'assets/images/shopping_cart.png',
                height: 20.0.sp,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistContent(
    BuildContext context,
    WishListModel wishListModel,
    AddToCartModel addToCartModel,
    ConfigModel configModel,
  ) {
    if (wishListModel.wishLists?.isEmpty ?? true) {
      return const Center(child: Text('Wishlist is empty'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0.w),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: wishListModel.wishLists!.length,
          separatorBuilder: (_, __) =>
              const Divider(thickness: 2, color: Colors.black),
          itemBuilder: (context, index) => _buildWishlistItem(
            context,
            wishListModel,
            addToCartModel,
            configModel,
            index,
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistItem(
    BuildContext context,
    WishListModel wishListModel,
    AddToCartModel addToCartModel,
    ConfigModel configModel,
    int index,
  ) {
    final product = wishListModel.wishLists![index].product!;
    final price = int.parse(product.productPrices![0].price.toString());
    final offerPrice =
        int.parse(product.productPrices![0].offerPrice.toString());
    final discountPrice = ((price - offerPrice) / price * 100).round();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(configModel, product),
            const SizedBox(width: 12),
            Expanded(
              child: _buildProductDetails(context, wishListModel,
                  addToCartModel, product, discountPrice, index),
            ),
            IconButton(
              onPressed: () async {
                await wishListModel.getWishLists(product.id);
              },
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildProductImage(ConfigModel configModel, Product product) {
    return SizedBox(
      height: 90.0.w,
      width: 80.0.w,
      child: Image.network(
        '${configModel.apiConfig['mediaURL']}${product.productImages!.first.imagepath}',
        width: 80.0.w,
        height: 100.0.w,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildProductDetails(
    BuildContext context,
    WishListModel wishListModel,
    AddToCartModel addToCartModel,
    Product product,
    int discountPrice,
    int index,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name.toString(),
          style: MyGoogleFontStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500,
            color: const Color(0xff909090),
          ),
        ),
        Text.rich(
          TextSpan(
            text: 'Total Price',
            style: TextStyle(color: Colors.grey[500]),
            children: [
              const WidgetSpan(child: SizedBox(width: 10)),
              TextSpan(
                text: 'RS. ${product.productPrices![0].price}',
                style: const TextStyle(
                  color: Color(0xFFC7B456),
                  decoration: TextDecoration.lineThrough,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 10)),
              TextSpan(
                text: 'RS.${product.productPrices![0].offerPrice}',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              if (discountPrice != 0)
                const WidgetSpan(child: SizedBox(width: 10)),
              if (discountPrice != 0)
                TextSpan(
                  text: '($discountPrice% Off)',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _buildAddToCartButton(context, wishListModel, addToCartModel, index),
      ],
    );
  }

  Widget _buildAddToCartButton(
    BuildContext context,
    WishListModel wishListModel,
    AddToCartModel addToCartModel,
    int index,
  ) {
    return InkWell(
      onTap: () => _showAddToCartBottomSheet(
          context, wishListModel, addToCartModel, index),
      child: Container(
        padding: EdgeInsets.fromLTRB(13.0.w, 4.0.w, 14.0.w, 6.0.w),
        width: 100.0.w,
        height: 30.0.w,
        decoration: BoxDecoration(
          color: const Color(0xff000000),
          borderRadius: BorderRadius.circular(5.0.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Add to Cart',
              style: MyGoogleFontStyle(
                fontFamily: 'Poppins',
                fontSize: 9.0.w,
                fontWeight: FontWeight.w600,
                color: const Color(0xffffffff),
              ),
            ),
            const SizedBox(width: 5),
            Image.asset(
              'assets/images/shopping-bag-03-YoY.png',
              width: 9.5.w,
              height: 9.2.w,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddToCartBottomSheet(
    BuildContext context,
    WishListModel wishListModel,
    AddToCartModel addToCartModel,
    int index,
  ) {
    int activeIndex = -1;
    int sizeActiveIndex = -1;
    final product = wishListModel.wishLists![index].product!;
    final Map<String, dynamic> cartData = {
      'kindOfFlower': '',
      'flavour': '',
      'writeOnCake': '',
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            final filteredProductPacks = activeIndex != -1
                ? product.productPacks!
                    .where((element) =>
                        element.unitId ==
                        product.productImages![activeIndex].unit!.id)
                    .toList()
                : product.productPacks!;

            return Container(
              height: MediaQuery.sizeOf(context).height * 0.4,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Select Variant:',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15.0.w,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      letterSpacing: -0.36,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildVariantSelector(product, activeIndex, (index) {
                    modalSetState(() {
                      activeIndex = index;
                      sizeActiveIndex = -1;
                      cartData['flavour'] =
                          product.productImages![index].unit!.name.toString();
                      cartData['pack'] = product.productImages![index].id;
                    });
                  }),
                  const SizedBox(height: 20),
                  Text(
                    'Select Size:',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15.0.w,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      letterSpacing: -0.36,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSizeSelector(filteredProductPacks, sizeActiveIndex,
                      (index) {
                    modalSetState(() {
                      sizeActiveIndex = index;
                      cartData['pack'] = filteredProductPacks[index].id;
                      cartData['kindOfFlower'] =
                          filteredProductPacks[index].value.toString();
                    });
                  }),
                  const SizedBox(height: 20),
                  _buildBottomSheetAddToCartButton(
                    context,
                    addToCartModel,
                    wishListModel,
                    product,
                    cartData,
                    activeIndex,
                    sizeActiveIndex,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVariantSelector(
    Product product,
    int activeIndex,
    Function(int) onSelect,
  ) {
    return SizedBox(
      height: 50.0.w,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: product.productImages!.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final isActive = index == activeIndex;
          return TextButton(
            onPressed: () => onSelect(index),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: isActive ? Colors.black : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0.r),
              ),
            ),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.3,
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0.r),
                  side: const BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              child: Center(
                child: Text(
                  product.productImages![index].unit!.name.toString(),
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12.0.w,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: -0.36,
                    color: isActive ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSizeSelector(
    List<ProductPack> filteredProductPacks,
    int sizeActiveIndex,
    Function(int) onSelect,
  ) {
    return SizedBox(
      height: 50.0.w,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filteredProductPacks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final isSizeActive = index == sizeActiveIndex;
          return TextButton(
            onPressed: () => onSelect(index),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: isSizeActive ? Colors.black : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0.r),
              ),
            ),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.3,
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0.r),
                  side: const BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              child: Center(
                child: Text(
                  filteredProductPacks[index].value.toString(),
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12.0.w,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: -0.36,
                    color: isSizeActive ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomSheetAddToCartButton(
    BuildContext context,
    AddToCartModel addToCartModel,
    WishListModel wishListModel,
    Product product,
    Map<String, dynamic> cartData,
    int activeIndex,
    int sizeActiveIndex,
  ) {
    bool isLoading = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return InkWell(
          onTap: () async {
            if (activeIndex == -1) {
              _showErrorDialog(
                  context, 'Please select a variant before adding to cart.');
              return;
            }
            if (sizeActiveIndex == -1) {
              _showErrorDialog(
                  context, 'Please select a size before adding to cart.');
              return;
            }

            setState(() => isLoading = true);
            try {
              final price = product.productPrices!
                  .firstWhere((p) => p.productPackId == cartData['pack'])
                  .offerPrice
                  .toString();
              final points = product.productPacks!
                  .firstWhere((p) => p.id == cartData['pack'])
                  .points
                  .toString();

              cartData
                ..['points'] = points
                ..['product_price'] = price
                ..['is_add_to_cart'] = true;

              await addToCartModel.getAddToCart(product.id, true, cartData);
              await wishListModel.getWishLists('');
              if (mounted) {
                Navigator.pop(context);
              }
            } catch (e) {
              if (mounted) {
                _showErrorDialog(context, 'Error adding to cart: $e');
              }
            } finally {
              if (mounted) {
                setState(() => isLoading = false);
              }
            }
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(13.0.w, 4.0.w, 14.0.w, 6.0.w),
            width: 160.0.w,
            height: 50.0.w,
            decoration: BoxDecoration(
              color: const Color(0xff000000),
              borderRadius: BorderRadius.circular(5.0.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Add to Cart',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.0.w,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xffffffff),
                        ),
                      ),
                const SizedBox(width: 5),
                Image.asset(
                  'assets/images/shopping-bag-03-YoY.png',
                  width: 18.0.w,
                  height: 15.0.w,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Oops...!',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

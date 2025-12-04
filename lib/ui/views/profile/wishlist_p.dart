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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFEED056)),
                              strokeWidth: 3,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text('Loading...',
                              style: MyGoogleFontStyle(
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFFFFF8E1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_outline_rounded,
                size: 60,
                color: Color(0xFFC7B456),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Your Wishlist is Empty',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Save items you love to your wishlist',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                color: Color(0xFF888888),
              ),
            ),
            SizedBox(height: 24),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFD4C76A), Color(0xFFC7B456)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Start Shopping',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                '${wishListModel.wishLists!.length} items saved',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  color: Color(0xFF888888),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: wishListModel.wishLists!.length,
              itemBuilder: (context, index) => _buildWishlistItem(
                context,
                wishListModel,
                addToCartModel,
                configModel,
                index,
              ),
            ),
            SizedBox(height: 20),
          ],
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

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFFFDF7)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEED056).withOpacity(0.12),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(configModel, product),
          SizedBox(width: 14),
          Expanded(
            child: _buildProductDetails(context, wishListModel, addToCartModel,
                product, discountPrice, index),
          ),
          InkWell(
            onTap: () async {
              await wishListModel.getWishLists(product.id);
            },
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.favorite_rounded,
                color: Colors.red,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(ConfigModel configModel, Product product) {
    return Container(
      width: 85.0.w,
      height: 85.0.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFF5F5F5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          '${configModel.apiConfig['mediaURL']}${product.productImages!.first.imagepath}',
          width: 85.0.w,
          height: 85.0.w,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.image_rounded,
            color: Colors.grey[400],
            size: 30,
          ),
        ),
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
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 6),
        Row(
          children: [
            Text(
              'RS.${product.productPrices![0].offerPrice}',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFC7B456),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'RS.${product.productPrices![0].price}',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 12,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
        if (discountPrice != 0)
          Container(
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$discountPrice% OFF',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4CAF50),
              ),
            ),
          ),
        SizedBox(height: 10),
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
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 14),
            SizedBox(width: 6),
            Text(
              'Add to Cart',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
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
    final configModel = locator<ConfigModel>();
    final Map<String, dynamic> cartData = {
      'kindOfFlower': '',
      'flavour': '',
      'writeOnCake': '',
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Product header
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFF5F5F5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            '${configModel.apiConfig['mediaURL']}${product.productImages!.first.imagepath}',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(Icons.image),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'RS.${product.productPrices![0].offerPrice}',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFC7B456),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(color: Color(0xFFEEEEEE)),
                  SizedBox(height: 16),
                  // Variant selector
                  Text(
                    'Select Variant',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildVariantSelector(product, activeIndex, (index) {
                    modalSetState(() {
                      activeIndex = index;
                      sizeActiveIndex = -1;
                      cartData['flavour'] =
                          product.productImages![index].unit!.name.toString();
                      cartData['pack'] = product.productImages![index].id;
                    });
                  }),
                  SizedBox(height: 20),
                  // Size selector
                  Text(
                    'Select Size',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildSizeSelector(filteredProductPacks, sizeActiveIndex,
                      (index) {
                    modalSetState(() {
                      sizeActiveIndex = index;
                      cartData['pack'] = filteredProductPacks[index].id;
                      cartData['kindOfFlower'] =
                          filteredProductPacks[index].value.toString();
                    });
                  }),
                  SizedBox(height: 24),
                  _buildBottomSheetAddToCartButton(
                    context,
                    addToCartModel,
                    wishListModel,
                    product,
                    cartData,
                    activeIndex,
                    sizeActiveIndex,
                    filteredProductPacks,
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
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: product.productImages!.length,
        separatorBuilder: (_, __) => SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isActive = index == activeIndex;
          return GestureDetector(
            onTap: () => onSelect(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? Color(0xFFC7B456) : Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isActive ? Color(0xFFC7B456) : Color(0xFFE0E0E0),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  product.productImages![index].unit!.name.toString(),
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : Color(0xFF666666),
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
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filteredProductPacks.length,
        separatorBuilder: (_, __) => SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSizeActive = index == sizeActiveIndex;
          final isOutOfStock = (filteredProductPacks[index].qty ?? 0) <= 0;

          return GestureDetector(
            onTap: () => onSelect(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isOutOfStock
                    ? Color(0xFFEEEEEE)
                    : (isSizeActive ? Color(0xFFC7B456) : Color(0xFFF5F5F5)),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isOutOfStock
                      ? Color(0xFFDDDDDD)
                      : (isSizeActive ? Color(0xFFC7B456) : Color(0xFFE0E0E0)),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filteredProductPacks[index].value.toString(),
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isOutOfStock
                          ? Color(0xFFAAAAAA)
                          : (isSizeActive ? Colors.white : Color(0xFF666666)),
                    ),
                  ),
                  if (isOutOfStock) ...[
                    SizedBox(width: 6),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        'OUT',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ],
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
    List<ProductPack> filteredProductPacks,
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

            // Check if selected pack is out of stock
            final selectedPack = filteredProductPacks[sizeActiveIndex];
            final availableQty = selectedPack.qty ?? 0;

            if (availableQty <= 0) {
              _showOutOfStockDialog(context, product.name ?? 'This item');
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Added to cart successfully!'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFD4C76A),
                  Color(0xFFC7B456),
                  Color(0xFFAA9A40)
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFC7B456).withOpacity(0.4),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                else ...[
                  Icon(Icons.shopping_bag_rounded,
                      color: Colors.white, size: 18),
                  SizedBox(width: 10),
                  Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOutOfStockDialog(BuildContext context, String productName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Icon(Icons.inventory_2_outlined, color: Colors.red, size: 24),
            ),
            SizedBox(width: 12),
            Text(
              'Out of Stock',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sorry! This variant is currently unavailable.',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please select a different variant or check back later.',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 13,
                color: Color(0xFF888888),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFFF5F5F5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'OK',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
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

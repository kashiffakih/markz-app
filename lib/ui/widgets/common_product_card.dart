import 'package:aadab/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:aadab/core/models/product.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/core/providers/wish_list_pr.dart';

import 'package:aadab/ui/views/products/product_id_p.dart';
import 'package:aadab/ui/widgets/login_required_popup.dart';

class CommonProductCard extends StatelessWidget {
  final Product product;
  final double discountPrice;
  final double? width;
  final double? height;

  /// Default width matching home_p.dart styling
  static const double defaultWidth = 145.0;

  /// Default height ratio (35% of screen height) matching home_p.dart styling
  static const double defaultHeightRatio = 0.35;

  const CommonProductCard({
    Key? key,
    required this.product,
    required this.discountPrice,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel = locator<ConfigModel>();
    final wishListModel = context.watch<WishListModel>();

    final isWishListed = configModel.user != null &&
        wishListModel.wishLists?.any((wishList) =>
                wishList.productId == product.id &&
                wishList.userId == configModel.user!.id) ==
            true;

    final cardWidth = width ?? defaultWidth.w;
    final cardHeight = height ?? defaultHeightRatio.sh;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductIdPage(
              arguments: {
                'product': product.toJson(),
                'product_images': product.productImages,
              },
            ),
          ),
        );
      },
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFFFFDF7)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFEED056).withOpacity(0.12),
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                flex: 12,
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Color(0xFFF8F8F8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        (() {
                          // print('chel');
                          // print("product: ${product.productImages!.length}");
                          final mediaUrl = configModel.apiConfig['mediaURL'];
                          String? imagePath;

                          // Try getting image from productImages list
                          if (product.productImages?.isNotEmpty ?? false) {
                            imagePath = product.productImages!.first.imagepath;
                          }

                          // If not found or empty, fallback to imagepath1
                          if ((imagePath == null || imagePath.isEmpty) &&
                              product.imagepath1 != null &&
                              product.imagepath1!.isNotEmpty) {
                            imagePath = product.imagepath1;
                          }

                          // If logic fails to find any path, return placeholder
                          if (imagePath == null || imagePath.isEmpty) {
                            return Center(
                              child: Icon(Icons.image_rounded,
                                  color: Colors.grey[300], size: 40),
                            );
                          }

                          // If path is absolute URL, use it directly
                          if (imagePath.startsWith('http') ||
                              imagePath.startsWith('https')) {
                            return Image.network(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(Icons.image_rounded,
                                    color: Colors.grey[300], size: 40),
                              ),
                            );
                          }

                          // Otherwise require mediaURL
                          if (mediaUrl == null) {
                            return Center(
                              child: Icon(Icons.image_rounded,
                                  color: Colors.grey[300], size: 40),
                            );
                          }

                          // Construct URL with slash handling
                          String imageUrl;
                          if (mediaUrl.endsWith('/') &&
                              imagePath.startsWith('/')) {
                            imageUrl = '$mediaUrl${imagePath.substring(1)}';
                          } else if (!mediaUrl.endsWith('/') &&
                              !imagePath.startsWith('/')) {
                            imageUrl = '$mediaUrl/$imagePath';
                          } else {
                            imageUrl = '$mediaUrl$imagePath';
                          }

                          return Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(Icons.image_rounded,
                                  color: Colors.grey[300], size: 40),
                            ),
                          );
                        })(),
                        // Wishlist
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(8.0.w),
                            child: InkWell(
                              onTap: () async {
                                if (configModel.user == null) {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          LoginRequiredPopupWidget());
                                } else {
                                  await wishListModel.getWishLists(product.id);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(6.0.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isWishListed
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isWishListed
                                      ? Colors.red
                                      : Color(0xFF909090),
                                  size: 16.0.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Rating Badge
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 10),
                                SizedBox(width: 4),
                                Text(
                                  '${product.rating != null && product.rating != '0' ? product.rating : '0'}/5',
                                  style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Discount badge
                        if (discountPrice > 0)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF4CAF50),
                                    Color(0xFF388E3C)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${discountPrice.round()}% OFF',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Product Details
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 4, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product.name ?? 'Unnamed Product',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                          height: 1.3,
                        ),
                      ),
                      // Price Row
                      if (product.productPrices?.isNotEmpty ?? false)
                        Row(
                          children: [
                            Text(
                              '₹${product.productPrices![0].offerPrice ?? product.productPrices![0].price}',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFC7B456),
                              ),
                            ),
                            if (product.productPrices![0].offerPrice != null &&
                                product.productPrices![0].offerPrice != 0 &&
                                product.productPrices![0].price !=
                                    product.productPrices![0].offerPrice) ...[
                              SizedBox(width: 6),
                              Text(
                                '₹${product.productPrices![0].price}',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 12,
                                  color: Color(0xFF999999),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        )
                      else
                        Text(
                          '₹0',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

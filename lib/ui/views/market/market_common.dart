import 'package:aadab/core/models/product.dart';
import 'package:aadab/core/services/marketplace_s.dart';
import 'package:aadab/core/services/product_s.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/views/products/product_id_p.dart';
import 'package:flutter/material.dart';

// ---------------------------------------------------------------- brand tokens
const Color kMkGreen = Color(0xFF0B5D3B);
const Color kMkGreenDark = Color(0xFF08472D);
const Color kMkGreenSoft = Color(0xFFE8F3EE);
const Color kMkGold = Color(0xFFC99A2E);
const Color kMkBg = Color(0xFFF5F7F6);
const Color kMkInk = Color(0xFF14201A);
const Color kMkMuted = Color(0xFF66736C);
const Color kMkLine = Color(0xFFE3E9E6);
const Color kMkSale = Color(0xFFD9363E);

MarketplaceService get marketApi => locator<MarketplaceService>();

String _groupIndian(String digits) {
  if (digits.length <= 3) return digits;
  final last3 = digits.substring(digits.length - 3);
  var rest = digits.substring(0, digits.length - 3);
  final groups = <String>[];
  while (rest.length > 2) {
    groups.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) groups.insert(0, rest);
  return '${groups.join(',')},$last3';
}

String money(dynamic n) {
  if (n == null) return '';
  final v = n is num ? n : num.tryParse('$n');
  if (v == null) return '';
  final isWhole = v == v.roundToDouble();
  final s = (isWhole ? v.toStringAsFixed(0) : v.toStringAsFixed(2)).replaceFirst('-', '');
  final parts = s.split('.');
  final sign = v < 0 ? '-' : '';
  return '\u20B9$sign${_groupIndian(parts[0])}${parts.length > 1 ? '.${parts[1]}' : ''}';
}

void mkSnack(BuildContext context, String text, {bool error = false}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: error ? kMkSale : kMkGreen,
    behavior: SnackBarBehavior.floating,
  ));
}

/// Opens the existing product detail page for a marketplace product id.
Future<void> openMarketProduct(BuildContext context, int productId) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator(color: kMkGreen)),
  );
  Product? product;
  try {
    product = await locator<ProductService>().getProductById(productId);
  } catch (_) {
    product = null;
  }
  if (!context.mounted) return;
  Navigator.of(context, rootNavigator: true).pop(); // loader
  if (product == null) {
    mkSnack(context, 'Product load nahi ho paya', error: true);
    return;
  }
  final found = product;
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => ProductIdPage(
      arguments: {
        'product': found.toJson(),
        'product_images': found.productImages,
      },
    ),
  ));
}

// ---------------------------------------------------------------- widgets

class MkNetImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  const MkNetImage(this.url, {Key? key, this.fit = BoxFit.cover, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: const Color(0xFFEEF2F0),
        child: const Icon(Icons.image_outlined, color: Color(0xFFB7C2BC), size: 36),
      );
    }
    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (c, e, s) => Container(
        width: width,
        height: height,
        color: const Color(0xFFEEF2F0),
        child: const Icon(Icons.broken_image_outlined, color: Color(0xFFB7C2BC), size: 36),
      ),
      loadingBuilder: (c, child, progress) {
        if (progress == null) return child;
        return Container(width: width, height: height, color: const Color(0xFFEEF2F0));
      },
    );
  }
}

class MarketProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const MarketProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final discount = (product['discount_percent'] is num) ? (product['discount_percent'] as num).toInt() : 0;
    final seller = product['seller'];
    final sellerName = seller is Map ? '${seller['name'] ?? ''}' : '';
    final inStock = product['in_stock'] != false;
    final id = (product['id'] as num).toInt();

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => openMarketProduct(context, id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kMkLine),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MkNetImage(marketApi.mediaUrl(product['image'])),
                  if (discount > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: kMkSale, borderRadius: BorderRadius.circular(99)),
                        child: Text('$discount% OFF',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  if (!inStock)
                    Container(
                      color: Colors.white.withOpacity(0.65),
                      alignment: Alignment.center,
                      child: const Text('Out of stock',
                          style: TextStyle(fontWeight: FontWeight.w800, color: kMkMuted, fontSize: 12)),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sellerName.isNotEmpty)
                    Text('by $sellerName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10.5, color: kMkMuted, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('${product['name'] ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kMkInk, height: 1.25)),
                  const SizedBox(height: 6),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 6,
                    children: [
                      Text(money(product['price']),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kMkInk)),
                      if (product['mrp'] != null)
                        Text(money(product['mrp']),
                            style: const TextStyle(
                                fontSize: 11.5, color: kMkMuted, decoration: TextDecoration.lineThrough)),
                      if (discount > 0)
                        Text('$discount% off',
                            style: const TextStyle(fontSize: 11.5, color: kMkGreen, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Responsive 2/3/4-column product grid that works inside a CustomScrollView.
class MarketProductSliverGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const MarketProductSliverGrid({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w >= 900 ? 4 : (w >= 600 ? 3 : 2);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.56,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => MarketProductCard(product: items[i]),
          childCount: items.length,
        ),
      ),
    );
  }
}

class MarketSellerTile extends StatelessWidget {
  final Map<String, dynamic> seller;
  final VoidCallback onTap;
  const MarketSellerTile({Key? key, required this.seller, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = '${seller['name'] ?? ''}';
    final logo = marketApi.mediaUrl(seller['logo_path']);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kMkLine),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: kMkGreenSoft,
              backgroundImage: logo.isNotEmpty ? NetworkImage(logo) : null,
              onBackgroundImageError: logo.isNotEmpty ? (e, s) {} : null,
              child: logo.isEmpty
                  ? Text(name.isEmpty ? '?' : name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: kMkGreen, fontWeight: FontWeight.w800, fontSize: 20))
                  : null,
            ),
            const SizedBox(height: 8),
            Text(name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: kMkInk)),
            if ('${seller['city'] ?? ''}'.isNotEmpty)
              Text('${seller['city']}', style: const TextStyle(fontSize: 11, color: kMkMuted)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(color: kMkGreenSoft, borderRadius: BorderRadius.circular(99)),
              child: Text('${seller['product_count'] ?? 0} products',
                  style: const TextStyle(fontSize: 10.5, color: kMkGreenDark, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }
}

class MkSectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const MkSectionTitle(this.title, {Key? key, this.action, this.onAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kMkInk)),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(action!, style: const TextStyle(color: kMkGreen, fontWeight: FontWeight.w800, fontSize: 13)),
            ),
        ],
      ),
    );
  }
}

class MkEmpty extends StatelessWidget {
  final IconData icon;
  final String text;
  const MkEmpty({Key? key, required this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 52, color: kMkMuted.withOpacity(0.5)),
          const SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(color: kMkMuted)),
        ],
      ),
    );
  }
}

PreferredSizeWidget mkAppBar(String title, {List<Widget>? actions, PreferredSizeWidget? bottom}) {
  return AppBar(
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
    backgroundColor: kMkGreen,
    foregroundColor: Colors.white,
    elevation: 0,
    actions: actions,
    bottom: bottom,
  );
}

ButtonStyle mkButton({bool outlined = false}) {
  return ElevatedButton.styleFrom(
    backgroundColor: outlined ? Colors.white : kMkGreen,
    foregroundColor: outlined ? kMkGreen : Colors.white,
    elevation: 0,
    minimumSize: const Size(0, 46),
    padding: const EdgeInsets.symmetric(horizontal: 22),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(99),
      side: BorderSide(color: outlined ? kMkGreen : Colors.transparent, width: 1.5),
    ),
    textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
  );
}

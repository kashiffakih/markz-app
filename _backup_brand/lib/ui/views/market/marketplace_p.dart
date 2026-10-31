import 'package:aadab/ui/views/market/chat_p.dart';
import 'package:aadab/ui/views/market/market_common.dart';
import 'package:aadab/ui/views/market/market_sellers_p.dart';
import 'package:aadab/ui/views/market/market_shop_p.dart';
import 'package:aadab/ui/views/market/my_returns_p.dart';
import 'package:aadab/ui/views/market/reseller_p.dart';
import 'package:flutter/material.dart';

/// Marketplace landing screen: search, quick links, hot deals, new arrivals, top sellers.
class MarketplacePage extends StatefulWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final TextEditingController _search = TextEditingController();
  List<Map<String, dynamic>> _newArrivals = [];
  List<Map<String, dynamic>> _deals = [];
  List<Map<String, dynamic>> _sellers = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _list(dynamic v) {
    if (v is List) return v.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    return [];
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final r = await marketApi.home();
    if (!mounted) return;
    setState(() {
      if (marketApi.ok(r)) {
        _newArrivals = _list(r['new_arrivals']);
        _deals = _list(r['deals']);
        _sellers = _list(r['top_sellers']);
      } else {
        _error = marketApi.errorText(r);
      }
      _loading = false;
    });
  }

  void _go(Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  void _doSearch() {
    final q = _search.text.trim();
    if (q.isEmpty) return;
    _go(MarketShopPage(initialSearch: q, title: 'Results'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMkBg,
      appBar: mkAppBar('Aadab Marketplace'),
      body: RefreshIndicator(
        color: kMkGreen,
        onRefresh: _load,
        child: _loading
            ? ListView(children: const [SizedBox(height: 240), Center(child: CircularProgressIndicator(color: kMkGreen))])
            : _error != null
                ? ListView(children: [
                    const SizedBox(height: 120),
                    MkEmpty(icon: Icons.wifi_off_rounded, text: _error!),
                    Center(child: ElevatedButton(style: mkButton(), onPressed: _load, child: const Text('Retry'))),
                  ])
                : CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: _header()),
                      SliverToBoxAdapter(child: _quickLinks()),
                      if (_deals.isNotEmpty) ...[
                        SliverToBoxAdapter(child: MkSectionTitle('Hot Deals', action: 'View all', onAction: () => _go(const MarketShopPage()))),
                        MarketProductSliverGrid(items: _deals.take(4).toList()),
                      ],
                      SliverToBoxAdapter(child: MkSectionTitle('New Arrivals', action: 'View all', onAction: () => _go(const MarketShopPage()))),
                      if (_newArrivals.isEmpty)
                        const SliverToBoxAdapter(child: MkEmpty(icon: Icons.inventory_2_outlined, text: 'Abhi koi product nahi hai.'))
                      else
                        MarketProductSliverGrid(items: _newArrivals.take(8).toList()),
                      if (_sellers.isNotEmpty) ...[
                        SliverToBoxAdapter(child: MkSectionTitle('Top Sellers', action: 'All sellers', onAction: () => _go(const MarketSellersPage()))),
                        SliverToBoxAdapter(child: _sellerStrip()),
                      ],
                      SliverToBoxAdapter(child: _resellerBanner()),
                      const SliverToBoxAdapter(child: SizedBox(height: 28)),
                    ],
                  ),
      ),
    );
  }

  Widget _header() {
    return Container(
      color: kMkGreen,
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 18),
      child: TextField(
        controller: _search,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _doSearch(),
        decoration: InputDecoration(
          hintText: 'Products, categories search karo...',
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search, color: kMkMuted),
          suffixIcon: IconButton(icon: const Icon(Icons.arrow_forward_rounded, color: kMkGreen), onPressed: _doSearch),
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(99), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _quickLinks() {
    final items = <List<dynamic>>[
      [Icons.grid_view_rounded, 'Shop', () => _go(const MarketShopPage())],
      [Icons.storefront_outlined, 'Sellers', () => _go(const MarketSellersPage())],
      [Icons.chat_bubble_outline, 'Chats', () => _go(const ChatListPage())],
      [Icons.assignment_return_outlined, 'Returns', () => _go(const MyReturnsPage())],
      [Icons.account_balance_wallet_outlined, 'Reseller', () => _go(const ResellerPage())],
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items
            .map((it) => InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: it[2] as VoidCallback,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(color: kMkGreenSoft, borderRadius: BorderRadius.circular(16)),
                          child: Icon(it[0] as IconData, color: kMkGreen),
                        ),
                        const SizedBox(height: 6),
                        Text(it[1] as String, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: kMkInk)),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _sellerStrip() {
    return SizedBox(
      height: 168,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _sellers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final s = _sellers[i];
          return SizedBox(
            width: 140,
            child: MarketSellerTile(
              seller: s,
              onTap: () => _go(MarketShopPage(sellerId: (s['id'] as num).toInt())),
            ),
          );
        },
      ),
    );
  }

  Widget _resellerBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(colors: [kMkGreen, kMkGreenDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reseller bano, margin kamao',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Products apne customers ko apne margin par becho. Stock aur delivery hum sambhalte hain.',
                style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
            const SizedBox(height: 14),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kMkGold,
                foregroundColor: const Color(0xFF1D1405),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
              onPressed: () => _go(const ResellerPage()),
              child: const Text('Join as Reseller'),
            ),
          ],
        ),
      ),
    );
  }
}

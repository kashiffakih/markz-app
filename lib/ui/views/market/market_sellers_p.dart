import 'package:aadab/ui/views/market/market_common.dart';
import 'package:aadab/ui/views/market/market_shop_p.dart';
import 'package:flutter/material.dart';

class MarketSellersPage extends StatefulWidget {
  const MarketSellersPage({Key? key}) : super(key: key);

  @override
  State<MarketSellersPage> createState() => _MarketSellersPageState();
}

class _MarketSellersPageState extends State<MarketSellersPage> {
  final TextEditingController _search = TextEditingController();
  List<Map<String, dynamic>> _items = [];
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

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final r = await marketApi.sellers(search: _search.text.trim());
    if (!mounted) return;
    setState(() {
      if (marketApi.ok(r) && r['data'] is List) {
        _items = (r['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } else {
        _error = marketApi.errorText(r);
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w >= 900 ? 4 : (w >= 600 ? 3 : 2);
    return Scaffold(
      backgroundColor: kMkBg,
      appBar: mkAppBar('Our Sellers'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _load(),
              decoration: InputDecoration(
                hintText: 'Seller ka naam search karo...',
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: kMkMuted),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kMkLine)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kMkGreen, width: 1.5)),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: kMkGreen))
                : _error != null
                    ? Center(child: MkEmpty(icon: Icons.wifi_off_rounded, text: _error!))
                    : _items.isEmpty
                        ? const Center(child: MkEmpty(icon: Icons.storefront_outlined, text: 'Koi seller nahi mila.'))
                        : RefreshIndicator(
                            color: kMkGreen,
                            onRefresh: _load,
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.95,
                              ),
                              itemCount: _items.length,
                              itemBuilder: (context, i) {
                                final s = _items[i];
                                return MarketSellerTile(
                                  seller: s,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => MarketShopPage(sellerId: (s['id'] as num).toInt())),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

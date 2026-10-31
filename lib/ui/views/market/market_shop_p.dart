import 'package:aadab/ui/views/market/chat_p.dart';
import 'package:aadab/ui/views/market/market_common.dart';
import 'package:flutter/material.dart';

/// Product listing for the whole marketplace, or for one seller's store when [sellerId] is given.
class MarketShopPage extends StatefulWidget {
  final int? sellerId;
  final int? categoryId;
  final String? title;
  final String? initialSearch;
  const MarketShopPage({Key? key, this.sellerId, this.categoryId, this.title, this.initialSearch}) : super(key: key);

  @override
  State<MarketShopPage> createState() => _MarketShopPageState();
}

class _MarketShopPageState extends State<MarketShopPage> {
  final ScrollController _scroll = ScrollController();
  final TextEditingController _search = TextEditingController();
  final List<Map<String, dynamic>> _items = [];
  Map<String, dynamic>? _seller;
  List<Map<String, dynamic>> _categories = [];
  int? _category;
  String _sort = 'latest';
  int _page = 1;
  int _lastPage = 1;
  int _total = 0;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _category = widget.categoryId;
    _search.text = widget.initialSearch ?? '';
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 400) _loadMore();
    });
    _bootstrap();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    if (widget.sellerId != null) {
      final r = await marketApi.seller(widget.sellerId!);
      if (!mounted) return;
      if (marketApi.ok(r) && r['data'] is Map) {
        _seller = Map<String, dynamic>.from(r['data']);
        final cats = _seller!['categories'];
        if (cats is List) {
          _categories = cats.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
    } else {
      final r = await marketApi.categories();
      if (!mounted) return;
      final data = r['data'];
      if (data is List) {
        _categories = data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
    }
    await _load(reset: true);
  }

  Future<void> _load({bool reset = false}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _error = null;
        _page = 1;
      });
    }
    final r = await marketApi.products(
      search: _search.text.trim(),
      categoryId: _category,
      sellerId: widget.sellerId,
      sort: _sort,
      page: _page,
    );
    if (!mounted) return;
    setState(() {
      if (marketApi.ok(r)) {
        final data = r['data'];
        final list = data is List ? data.map((e) => Map<String, dynamic>.from(e as Map)).toList() : <Map<String, dynamic>>[];
        if (reset) _items.clear();
        _items.addAll(list);
        _lastPage = (r['last_page'] as num?)?.toInt() ?? 1;
        _total = (r['total'] as num?)?.toInt() ?? _items.length;
      } else {
        _error = marketApi.errorText(r);
      }
      _loading = false;
      _loadingMore = false;
    });
  }

  Future<void> _loadMore() async {
    if (_loading || _loadingMore || _page >= _lastPage) return;
    setState(() => _loadingMore = true);
    _page += 1;
    await _load();
  }

  void _setCategory(int? id) {
    _category = id;
    _load(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.sellerId != null ? (_seller != null ? '${_seller!['name']}' : 'Store') : (widget.title ?? 'Shop');
    return Scaffold(
      backgroundColor: kMkBg,
      appBar: mkAppBar(
        title,
        actions: [
          if (widget.sellerId != null && _seller != null)
            IconButton(
              tooltip: 'Chat with seller',
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: () => startChatWithSeller(context, widget.sellerId!),
            ),
        ],
      ),
      body: RefreshIndicator(
        color: kMkGreen,
        onRefresh: () => _load(reset: true),
        child: CustomScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (_seller != null) SliverToBoxAdapter(child: _sellerHeader()),
            SliverToBoxAdapter(child: _toolbar()),
            if (_categories.isNotEmpty) SliverToBoxAdapter(child: _chips()),
            if (_loading)
              const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator(color: kMkGreen)))
            else if (_error != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    MkEmpty(icon: Icons.wifi_off_rounded, text: _error!),
                    ElevatedButton(style: mkButton(), onPressed: () => _load(reset: true), child: const Text('Retry')),
                  ]),
                ),
              )
            else if (_items.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: MkEmpty(icon: Icons.search_off_rounded, text: 'Koi product nahi mila.')),
              )
            else ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                  child: Text('$_total products', style: const TextStyle(color: kMkMuted, fontSize: 12.5)),
                ),
              ),
              MarketProductSliverGrid(items: _items),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _loadingMore
                      ? const Center(child: CircularProgressIndicator(color: kMkGreen, strokeWidth: 2.5))
                      : const SizedBox(height: 8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sellerHeader() {
    final s = _seller!;
    final logo = marketApi.mediaUrl(s['logo_path']);
    final name = '${s['name'] ?? ''}';
    return Container(
      color: kMkGreen,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            backgroundImage: logo.isNotEmpty ? NetworkImage(logo) : null,
            onBackgroundImageError: logo.isNotEmpty ? (e, st) {} : null,
            child: logo.isEmpty
                ? Text(name.isEmpty ? '?' : name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: kMkGreen, fontWeight: FontWeight.w800, fontSize: 24))
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  [
                    if ('${s['city'] ?? ''}'.isNotEmpty) '${s['city']}',
                    '${s['product_count'] ?? 0} products',
                  ].join('  •  '),
                  style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolbar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _load(reset: true),
              decoration: InputDecoration(
                hintText: 'Search products...',
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
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            tooltip: 'Sort',
            icon: const Icon(Icons.sort_rounded, color: kMkGreen),
            onSelected: (v) {
              _sort = v;
              _load(reset: true);
            },
            itemBuilder: (_) => [
              CheckedPopupMenuItem(value: 'latest', checked: _sort == 'latest', child: const Text('Newest first')),
              CheckedPopupMenuItem(value: 'price_low', checked: _sort == 'price_low', child: const Text('Price: Low to High')),
              CheckedPopupMenuItem(value: 'price_high', checked: _sort == 'price_high', child: const Text('Price: High to Low')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chips() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _chip('All', _category == null, () => _setCategory(null)),
          ..._categories.map((c) {
            final id = (c['id'] as num).toInt();
            return _chip('${c['name']}', _category == id, () => _setCategory(id));
          }),
        ],
      ),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: active ? Colors.white : kMkInk)),
        selected: active,
        onSelected: (_) => onTap(),
        selectedColor: kMkGreen,
        backgroundColor: Colors.white,
        side: BorderSide(color: active ? kMkGreen : kMkLine),
        showCheckmark: false,
      ),
    );
  }
}

import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/views/market/market_common.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Seller: orders to ship. New orders -> pack -> "Ready to ship" (courier pickup + label are booked by the server).
class SellerShipPage extends StatefulWidget {
  const SellerShipPage({Key? key}) : super(key: key);

  @override
  State<SellerShipPage> createState() => _SellerShipPageState();
}

class _SellerShipPageState extends State<SellerShipPage> with SingleTickerProviderStateMixin {
  static const _tabs = ['to_ship', 'ready', 'shipped'];
  late final TabController _tab = TabController(length: 3, vsync: this);
  final Map<String, List<Map<String, dynamic>>> _orders = {'to_ship': [], 'ready': [], 'shipped': []};
  Map<String, dynamic> _counts = {};
  bool _loading = true;
  String? _error;
  int _busy = 0;

  bool get _loggedIn => locator<ConfigModel>().isLoggedIn;

  @override
  void initState() {
    super.initState();
    if (_loggedIn) {
      _loadAll();
      marketApi.fulfilmentSeen(); // seller opened the page: clear the "new order" alert
    } else {
      _loading = false;
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    for (final t in _tabs) {
      final r = await marketApi.fulfilmentOrders(t);
      if (!mounted) return;
      if (marketApi.ok(r)) {
        _orders[t] = ((r['data'] ?? []) as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        if (r['counts'] is Map) _counts = Map<String, dynamic>.from(r['counts'] as Map);
      } else {
        _error = r['_status'] == 403 ? 'Ye section sirf sellers ke liye hai.' : marketApi.errorText(r);
        break;
      }
    }
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _ready(Map<String, dynamic> o) async {
    final id = (o['order_id'] as num).toInt();
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ready to ship?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text('Order #$id pack ho gaya hai? Courier pickup book ho jayega.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Abhi nahi')),
          ElevatedButton(style: mkButton(), onPressed: () => Navigator.pop(ctx, true), child: const Text('Haan, ready hai')),
        ],
      ),
    );
    if (yes != true) return;
    setState(() => _busy = id);
    final r = await marketApi.fulfilmentReady(id);
    if (!mounted) return;
    setState(() => _busy = 0);
    if (marketApi.ok(r)) {
      mkSnack(context, '${r['message'] ?? 'Order ready ho gaya'}');
      _loadAll();
    } else {
      mkSnack(context, marketApi.errorText(r), error: true);
    }
  }

  String _count(String k) => (_counts[k] is num && (_counts[k] as num) > 0) ? ' (${_counts[k]})' : '';

  Widget _card(Map<String, dynamic> o, String tab) {
    final isLate = o['late'] == true;
    final items = (o['items'] is List) ? (o['items'] as List) : const [];
    final hours = (o['age_hours'] is num) ? (o['age_hours'] as num).floor() : 0;
    final id = (o['order_id'] as num).toInt();
    final cod = '${o['payment_mode']}' == 'COD';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isLate ? kMkSale : kMkLine, width: isLate ? 1.4 : 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Order #$id', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
          Text(money(o['amount']), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ]),
        const SizedBox(height: 4),
        Wrap(spacing: 6, runSpacing: 4, children: [
          _chip(cod ? 'COD - paisa delivery par' : 'Paid online', cod ? kMkGold : kMkGreen),
          if (isLate) _chip('$hours ghante se pending', kMkSale),
          if ('${o['customer_city'] ?? ''}'.isNotEmpty) _chip('${o['customer_city']}', kMkMuted),
        ]),
        const Divider(height: 18),
        for (final it in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: '${(it as Map)['image'] ?? ''}'.isEmpty
                      ? Container(color: kMkBg, child: const Icon(Icons.image_outlined, color: kMkMuted))
                      : Image.network(marketApi.mediaUrl(it['image']), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: kMkBg)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text('${it['name']}', maxLines: 2, overflow: TextOverflow.ellipsis)),
              Text('x ${it['quantity']}', style: const TextStyle(color: kMkMuted)),
            ]),
          ),
        const SizedBox(height: 8),
        Text(
          'Parcel ~${o['weight_g']} g  •  shipping fee ${money(o['seller_ship_fee'])}${'${o['waybill'] ?? ''}'.isNotEmpty ? '  •  AWB ${o['waybill']}' : ''}',
          style: const TextStyle(color: kMkMuted, fontSize: 12.5),
        ),
        const SizedBox(height: 10),
        if (tab == 'to_ship')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: mkButton(),
              onPressed: _busy == id ? null : () => _ready(o),
              icon: _busy == id
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.inventory_2_outlined, size: 20),
              label: const Text('Ready to ship'),
            ),
          )
        else
          Row(children: [
            Expanded(child: Text(tab == 'ready' ? 'Courier ke pickup ka intezaar • $hours ghante' : 'Pickup ho gaya', style: TextStyle(color: tab == 'ready' ? kMkGold : kMkGreen, fontWeight: FontWeight.w700, fontSize: 12.5))),
            if ('${o['label_url'] ?? ''}'.isNotEmpty)
              OutlinedButton.icon(
                onPressed: () => launchUrl(Uri.parse('${o['label_url']}'), mode: LaunchMode.externalApplication),
                icon: const Icon(Icons.print_outlined, size: 18),
                label: const Text('Label'),
              ),
          ]),
      ]),
    );
  }

  Widget _chip(String t, Color c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(99)),
        child: Text(t, style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 11.5)),
      );

  Widget _list(String tab) {
    final list = _orders[tab] ?? [];
    if (list.isEmpty) {
      return ListView(children: [
        const SizedBox(height: 80),
        MkEmpty(icon: Icons.check_circle_outline, text: tab == 'to_ship' ? 'Abhi koi order ship karne ko nahi. Sab clear!' : 'Yahan abhi kuch nahi.'),
      ]);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _card(list[i], tab),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMkBg,
      appBar: mkAppBar(
        'Orders to ship',
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Ship karna${_count('to_ship')}'),
            Tab(text: 'Pickup baaki${_count('ready')}'),
            Tab(text: 'Nikal gaye${_count('shipped')}'),
          ],
        ),
      ),
      body: !_loggedIn
          ? const Center(child: MkEmpty(icon: Icons.lock_outline, text: 'Pehle login karo.'))
          : _loading
              ? const Center(child: CircularProgressIndicator(color: kMkGreen))
              : _error != null
                  ? Center(child: MkEmpty(icon: Icons.storefront_outlined, text: _error!))
                  : TabBarView(
                      controller: _tab,
                      children: [for (final t in _tabs) RefreshIndicator(color: kMkGreen, onRefresh: _loadAll, child: _list(t))],
                    ),
    );
  }
}

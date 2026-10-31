import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/views/market/market_common.dart';
import 'package:flutter/material.dart';

/// Reseller program: apply, browse catalog, place orders with your own margin, wallet + withdrawals.
class ResellerPage extends StatefulWidget {
  const ResellerPage({Key? key}) : super(key: key);

  @override
  State<ResellerPage> createState() => _ResellerPageState();
}

class _ResellerPageState extends State<ResellerPage> with SingleTickerProviderStateMixin {
  bool get _loggedIn => locator<ConfigModel>().isLoggedIn;

  bool _loading = true;
  Map<String, dynamic>? _me; // reseller row (null = not applied)
  Map<String, dynamic> _rules = {};
  String? _error;

  // approved state
  late final TabController _tabs = TabController(length: 3, vsync: this);
  List<Map<String, dynamic>> _catalog = [];
  bool _catalogLoading = false;
  final TextEditingController _catalogSearch = TextEditingController();
  List<Map<String, dynamic>> _orders = [];
  Map<String, dynamic> _summary = {};
  List<Map<String, dynamic>> _txns = [];
  List<Map<String, dynamic>> _withdrawals = [];

  // cart
  final List<Map<String, dynamic>> _cart = [];
  final Map<String, TextEditingController> _marginCtl = {};

  @override
  void initState() {
    super.initState();
    if (_loggedIn) {
      _loadMe();
    } else {
      _loading = false;
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    _catalogSearch.dispose();
    for (final c in _marginCtl.values) {
      c.dispose();
    }
    super.dispose();
  }

  List<Map<String, dynamic>> _list(dynamic v) {
    if (v is List) return v.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    return [];
  }

  Future<void> _loadMe() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final r = await marketApi.resellerMe();
    if (!mounted) return;
    if (!marketApi.ok(r)) {
      setState(() {
        _error = marketApi.errorText(r);
        _loading = false;
      });
      return;
    }
    _me = r['data'] is Map ? Map<String, dynamic>.from(r['data']) : null;
    _rules = r['rules'] is Map ? Map<String, dynamic>.from(r['rules']) : {};
    setState(() => _loading = false);
    if (_me != null && '${_me!['status']}' == 'approved') {
      _loadCatalog();
      _loadOrders();
      _loadWallet();
    }
  }

  Future<void> _loadCatalog() async {
    setState(() => _catalogLoading = true);
    final r = await marketApi.resellerCatalog(search: _catalogSearch.text.trim());
    if (!mounted) return;
    setState(() {
      if (marketApi.ok(r)) _catalog = _list(r['data']);
      _catalogLoading = false;
    });
  }

  Future<void> _loadOrders() async {
    final r = await marketApi.resellerOrders();
    if (!mounted) return;
    if (marketApi.ok(r)) setState(() => _orders = _list(r['data']));
  }

  Future<void> _loadWallet() async {
    final r = await marketApi.resellerWallet();
    final w = await marketApi.resellerWithdrawals();
    if (!mounted) return;
    setState(() {
      if (marketApi.ok(r)) {
        _summary = r['summary'] is Map ? Map<String, dynamic>.from(r['summary']) : {};
        final t = r['transactions'];
        _txns = t is Map ? _list(t['data']) : [];
      }
      if (marketApi.ok(w)) _withdrawals = _list(w['data']);
    });
  }

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    final approved = _me != null && '${_me!['status']}' == 'approved';
    return Scaffold(
      backgroundColor: kMkBg,
      appBar: mkAppBar(
        'Reseller Program',
        bottom: approved
            ? TabBar(
                controller: _tabs,
                indicatorColor: kMkGold,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(fontWeight: FontWeight.w800),
                tabs: const [Tab(text: 'Catalog'), Tab(text: 'Orders'), Tab(text: 'Wallet')],
              )
            : null,
      ),
      body: !_loggedIn
          ? const Center(child: MkEmpty(icon: Icons.lock_outline, text: 'Reseller ke liye pehle login karo.'))
          : _loading
              ? const Center(child: CircularProgressIndicator(color: kMkGreen))
              : _error != null
                  ? Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        MkEmpty(icon: Icons.wifi_off_rounded, text: _error!),
                        ElevatedButton(style: mkButton(), onPressed: _loadMe, child: const Text('Retry')),
                      ]),
                    )
                  : _me == null
                      ? _applyView()
                      : !approved
                          ? _statusView()
                          : TabBarView(controller: _tabs, children: [_catalogTab(), _ordersTab(), _walletTab()]),
      bottomNavigationBar: approved && _cart.isNotEmpty ? _cartBar() : null,
    );
  }

  // ------------------------------------------------------------------ apply / status

  Widget _applyView() {
    final name = TextEditingController();
    final phone = TextEditingController();
    bool busy = false;
    return StatefulBuilder(builder: (context, setLocal) {
      return ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Reseller bano, margin kamao', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kMkInk)),
          const SizedBox(height: 8),
          Text(
            'Products apne customers ko apne margin par becho. Delivery aur ${_rules['return_window_days'] ?? 7} din return window ke baad margin wallet mein aata hai.',
            style: const TextStyle(color: kMkMuted, height: 1.45),
          ),
          const SizedBox(height: 20),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Business / shop name', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
          const SizedBox(height: 18),
          ElevatedButton(
            style: mkButton(),
            onPressed: busy
                ? null
                : () async {
                    if (name.text.trim().isEmpty) {
                      mkSnack(context, 'Business name likho', error: true);
                      return;
                    }
                    setLocal(() => busy = true);
                    final r = await marketApi.resellerApply(name.text.trim(), phone.text.trim());
                    if (!mounted) return;
                    setLocal(() => busy = false);
                    if (marketApi.ok(r)) {
                      mkSnack(context, '${r['message'] ?? 'Application submit ho gayi'}');
                      _loadMe();
                    } else {
                      mkSnack(context, marketApi.errorText(r), error: true);
                    }
                  },
            child: Text(busy ? 'Please wait...' : 'Apply karo'),
          ),
        ],
      );
    });
  }

  Widget _statusView() {
    final status = '${_me!['status']}';
    final reason = '${_me!['rejection_reason'] ?? ''}';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(status == 'pending' ? Icons.hourglass_top_rounded : Icons.block_rounded, size: 56, color: status == 'pending' ? kMkGold : kMkSale),
            const SizedBox(height: 12),
            Text(
              status == 'pending' ? 'Application review mein hai' : 'Application $status',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              status == 'pending' ? 'Admin approve karega to catalog yahin khul jayega.' : (reason.isEmpty ? 'Admin se contact karein.' : reason),
              textAlign: TextAlign.center,
              style: const TextStyle(color: kMkMuted),
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: _loadMe, child: const Text('Refresh status')),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------ catalog + cart

  Widget _catalogTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _catalogSearch,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _loadCatalog(),
            decoration: InputDecoration(
              hintText: 'Catalog search...',
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search, color: kMkMuted),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kMkLine)),
            ),
          ),
        ),
        Expanded(
          child: _catalogLoading
              ? const Center(child: CircularProgressIndicator(color: kMkGreen))
              : _catalog.isEmpty
                  ? const Center(child: MkEmpty(icon: Icons.inventory_2_outlined, text: 'Catalog mein koi product nahi.'))
                  : RefreshIndicator(
                      color: kMkGreen,
                      onRefresh: _loadCatalog,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                        itemCount: _catalog.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) => _catalogCard(_catalog[i]),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _catalogCard(Map<String, dynamic> p) {
    final packs = _list(p['packs']);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: kMkLine)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(width: 80, height: 100, child: MkNetImage(marketApi.mediaUrl(p['image']))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${p['name']}', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                Text('by ${p['seller'] ?? ''}', style: const TextStyle(color: kMkMuted, fontSize: 11.5)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: packs.map((pk) {
                    final stock = (pk['stock'] as num?)?.toInt() ?? 0;
                    return ActionChip(
                      label: Text('${pk['value']} • ${money(pk['price'])} +', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                      backgroundColor: stock > 0 ? kMkGreenSoft : Colors.grey.shade200,
                      onPressed: stock > 0 ? () => _addToCart(p, pk) : null,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(Map<String, dynamic> p, Map<String, dynamic> pk) {
    final key = '${p['id']}-${pk['id']}';
    final idx = _cart.indexWhere((c) => c['key'] == key);
    setState(() {
      if (idx >= 0) {
        _cart[idx]['quantity'] = (_cart[idx]['quantity'] as int) + 1;
      } else {
        _cart.add({
          'key': key,
          'product_id': p['id'],
          'product_pack': pk['id'],
          'name': p['name'],
          'pack_value': pk['value'],
          'price': (pk['price'] as num).toDouble(),
          'quantity': 1,
        });
        _marginCtl[key] = TextEditingController(text: '0');
      }
    });
    mkSnack(context, '${p['name']} cart mein add hua');
  }

  double _marginOf(Map<String, dynamic> c) => double.tryParse(_marginCtl[c['key']]?.text.trim() ?? '0') ?? 0;

  double get _collectTotal => _cart.fold(0.0, (s, c) => s + ((c['price'] as double) + _marginOf(c)) * (c['quantity'] as int));
  double get _marginTotal => _cart.fold(0.0, (s, c) => s + _marginOf(c) * (c['quantity'] as int));

  Widget _cartBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: kMkLine))),
        child: Row(
          children: [
            Expanded(
              child: Text('${_cart.length} item(s) in order', style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
            ElevatedButton(style: mkButton(), onPressed: _openCheckout, child: const Text('Review & Place')),
          ],
        ),
      ),
    );
  }

  void _openCheckout() {
    final name = TextEditingController();
    final phone = TextEditingController();
    final addr = TextEditingController();
    final city = TextEditingController();
    final state = TextEditingController();
    final pin = TextEditingController();
    bool busy = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheet) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Customer order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  ..._cart.map((c) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(border: Border.all(color: kMkLine), borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text('${c['name']} (${c['pack_value']})', style: const TextStyle(fontWeight: FontWeight.w700))),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  setSheet(() => _cart.remove(c));
                                  setState(() {});
                                  if (_cart.isEmpty) Navigator.pop(ctx);
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  if ((c['quantity'] as int) > 1) setSheet(() => c['quantity'] = (c['quantity'] as int) - 1);
                                },
                              ),
                              Text('${c['quantity']}', style: const TextStyle(fontWeight: FontWeight.w800)),
                              IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setSheet(() => c['quantity'] = (c['quantity'] as int) + 1)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _marginCtl[c['key']],
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  onChanged: (_) => setSheet(() {}),
                                  decoration: const InputDecoration(labelText: 'Margin / unit ₹', isDense: true, border: OutlineInputBorder()),
                                ),
                              ),
                            ],
                          ),
                          Text('Base ${money(c['price'])} → customer price ${money((c['price'] as double) + _marginOf(c))}',
                              style: const TextStyle(color: kMkMuted, fontSize: 12)),
                        ],
                      ),
                    );
                  }),
                  const Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Customer se lena'),
                    Text(money(_collectTotal), style: const TextStyle(fontWeight: FontWeight.w800)),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Aapka margin', style: TextStyle(color: kMkGreen)),
                    Text(money(_marginTotal), style: const TextStyle(fontWeight: FontWeight.w800, color: kMkGreen)),
                  ]),
                  const SizedBox(height: 14),
                  const Text('Customer details', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  _field(name, 'Customer name'),
                  _field(phone, 'Phone (10 digits)', keyboard: TextInputType.phone),
                  _field(addr, 'Address'),
                  Row(children: [
                    Expanded(child: _field(city, 'City')),
                    const SizedBox(width: 8),
                    Expanded(child: _field(state, 'State')),
                  ]),
                  _field(pin, 'Pincode (6 digits)', keyboard: TextInputType.number),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: mkButton(),
                      onPressed: busy
                          ? null
                          : () async {
                              setSheet(() => busy = true);
                              final customer = {
                                'name': name.text.trim(),
                                'phone': phone.text.trim(),
                                'add_1': addr.text.trim(),
                                'city': city.text.trim(),
                                'state': state.text.trim(),
                                'pincode': pin.text.trim(),
                              };
                              final items = _cart
                                  .map((c) => <String, dynamic>{
                                        'product_id': c['product_id'],
                                        'product_pack': c['product_pack'],
                                        'quantity': c['quantity'],
                                        'margin': _marginOf(c),
                                      })
                                  .toList();
                              final r = await marketApi.resellerPlaceOrder(customer, items);
                              if (!mounted) return;
                              setSheet(() => busy = false);
                              if (marketApi.ok(r)) {
                                Navigator.pop(ctx);
                                setState(() {
                                  _cart.clear();
                                  _marginCtl.clear();
                                });
                                mkSnack(context, 'Order place ho gaya. Customer se ${money(r['collect_total'])} lena hai.');
                                _loadOrders();
                                _loadWallet();
                                _loadCatalog();
                              } else {
                                mkSnack(context, marketApi.errorText(r), error: true);
                              }
                            },
                      child: Text(busy ? 'Please wait...' : 'Place order'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _field(TextEditingController c, String label, {TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        decoration: InputDecoration(labelText: label, isDense: true, border: const OutlineInputBorder()),
      ),
    );
  }

  // ------------------------------------------------------------------ orders

  Widget _ordersTab() {
    if (_orders.isEmpty) {
      return RefreshIndicator(
        color: kMkGreen,
        onRefresh: _loadOrders,
        child: ListView(children: const [SizedBox(height: 120), MkEmpty(icon: Icons.receipt_long_outlined, text: 'Abhi koi order nahi.')]),
      );
    }
    return RefreshIndicator(
      color: kMkGreen,
      onRefresh: _loadOrders,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final o = _orders[i];
          final st = '${o['status']}';
          final color = st == 'credited' ? kMkGreen : (st == 'reversed' ? kMkSale : kMkGold);
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: kMkLine)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #${o['order_id']}', style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text('${o['customer_name']}  •  ${o['customer_phone'] ?? ''}', style: const TextStyle(color: kMkMuted, fontSize: 12.5)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(money(o['margin_amount']), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(99)),
                      child: Text(st, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------------ wallet

  Widget _walletTab() {
    Widget stat(String label, dynamic v, {Color? color}) => Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: kMkLine)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(color: kMkMuted, fontSize: 11.5)),
              const SizedBox(height: 4),
              Text(money(v ?? 0), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: color ?? kMkInk)),
            ]),
          ),
        );

    return RefreshIndicator(
      color: kMkGreen,
      onRefresh: _loadWallet,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(children: [stat('Wallet', _summary['wallet_balance'], color: kMkGreen), const SizedBox(width: 10), stat('Pending margin', _summary['pending_balance'])]),
          const SizedBox(height: 10),
          Row(children: [stat('Total earned', _summary['total_earned']), const SizedBox(width: 10), stat('Withdrawn', _summary['total_withdrawn'])]),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: ElevatedButton(style: mkButton(), onPressed: _withdrawDialog, child: const Text('Withdraw'))),
            const SizedBox(width: 10),
            Expanded(child: ElevatedButton(style: mkButton(outlined: true), onPressed: _payoutDialog, child: const Text('Payout details'))),
          ]),
          const MkSectionTitle('Withdrawals'),
          if (_withdrawals.isEmpty) const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Koi withdrawal nahi.', style: TextStyle(color: kMkMuted))),
          ..._withdrawals.map((w) => ListTile(
                dense: true,
                title: Text(money(w['amount']), style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text('${w['status']}${'${w['remarks'] ?? ''}'.isNotEmpty ? ' • ${w['remarks']}' : ''}'),
              )),
          const MkSectionTitle('Ledger'),
          if (_txns.isEmpty) const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Koi entry nahi.', style: TextStyle(color: kMkMuted))),
          ..._txns.map((t) => ListTile(
                dense: true,
                title: Text('${t['type']}'),
                subtitle: Text('${t['note'] ?? ''}'),
                trailing: Text('${t['amount']}', style: const TextStyle(fontWeight: FontWeight.w800)),
              )),
        ],
      ),
    );
  }

  Future<void> _withdrawDialog() async {
    final amt = TextEditingController();
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Withdraw (min ${money(_rules['min_withdrawal'] ?? 100)})', style: const TextStyle(fontWeight: FontWeight.w800)),
        content: TextField(controller: amt, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount ₹')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(style: mkButton(), onPressed: () => Navigator.pop(ctx, true), child: const Text('Request')),
        ],
      ),
    );
    if (go != true) return;
    final v = num.tryParse(amt.text.trim());
    if (v == null) {
      mkSnack(context, 'Sahi amount likho', error: true);
      return;
    }
    final r = await marketApi.resellerWithdraw(v);
    if (!mounted) return;
    if (marketApi.ok(r)) {
      mkSnack(context, '${r['message'] ?? 'Withdrawal request bhej di'}');
      _loadWallet();
    } else {
      mkSnack(context, marketApi.errorText(r), error: true);
    }
  }

  Future<void> _payoutDialog() async {
    final upi = TextEditingController(text: '${_me?['upi_id'] ?? ''}');
    final accName = TextEditingController(text: '${_me?['acc_name'] ?? ''}');
    final accNo = TextEditingController(text: '${_me?['acc_no'] ?? ''}');
    final ifsc = TextEditingController(text: '${_me?['ifsc_code'] ?? ''}');
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Payout details', style: TextStyle(fontWeight: FontWeight.w800)),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: upi, decoration: const InputDecoration(labelText: 'UPI ID')),
            TextField(controller: accName, decoration: const InputDecoration(labelText: 'Account holder')),
            TextField(controller: accNo, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Account number')),
            TextField(controller: ifsc, decoration: const InputDecoration(labelText: 'IFSC')),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(style: mkButton(), onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (go != true) return;
    final r = await marketApi.resellerSavePayout({
      'upi_id': upi.text.trim(),
      'acc_name': accName.text.trim(),
      'acc_no': accNo.text.trim(),
      'ifsc_code': ifsc.text.trim(),
    });
    if (!mounted) return;
    if (marketApi.ok(r)) {
      if (r['data'] is Map) _me = Map<String, dynamic>.from(r['data']);
      mkSnack(context, 'Payout details save ho gaye');
    } else {
      mkSnack(context, marketApi.errorText(r), error: true);
    }
  }
}

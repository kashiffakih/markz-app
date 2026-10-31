import 'dart:async';

import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/seller/seller_add_product_p.dart';
import 'package:aadab/seller/seller_payments_p.dart';
import 'package:aadab/ui/views/market/market_common.dart';
import 'package:aadab/ui/views/market/seller_ship_p.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({Key? key}) : super(key: key);

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  Map<String, dynamic> _a = {};
  bool _loading = true;
  String? _error;
  int _lastNew = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
    // new-order alert: check every 40 seconds while the app is open
    _timer = Timer.periodic(const Duration(seconds: 40), (_) => _load(silent: true));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);
    final r = await marketApi.fulfilmentAlerts();
    if (!mounted) return;
    setState(() {
      if (marketApi.ok(r) && r['data'] is Map) {
        _a = Map<String, dynamic>.from(r['data'] as Map);
        _error = null;
        final n = (_a['new_orders'] is num) ? (_a['new_orders'] as num).toInt() : 0;
        if (n > _lastNew && silent) {
          HapticFeedback.heavyImpact();
          mkSnack(context, 'Naya order aaya! Pack karke "Ready to ship" dabao.');
        }
        _lastNew = n;
      } else {
        _error = r['_status'] == 403 ? 'Ye account seller nahi hai. Seller login se aao.' : marketApi.errorText(r);
      }
      _loading = false;
    });
  }

  int _n(String k) => (_a[k] is num) ? (_a[k] as num).toInt() : 0;

  Future<void> _open(Widget page) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    _load(silent: true);
  }

  Future<void> _logout() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Nahi')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Haan')),
        ],
      ),
    );
    if (yes == true) await locator<ConfigModel>().removeLoginData();
  }

  Widget _stat(String label, int v, Color c) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: kMkLine)),
          child: Column(children: [
            Text('$v', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: c)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11.5, color: kMkMuted)),
          ]),
        ),
      );

  Widget _tile(IconData icon, String title, String sub, VoidCallback onTap, {int badge = 0}) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: kMkLine)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 20, backgroundColor: kMkGreenSoft, child: Icon(icon, color: kMkGreen)),
              const Spacer(),
              if (badge > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: kMkSale, borderRadius: BorderRadius.circular(99)),
                  child: Text('$badge', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                ),
            ]),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(color: kMkMuted, fontSize: 12)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final user = locator<ConfigModel>().user;
    final name = [user?.firstName, user?.lastName].where((e) => e != null && e.isNotEmpty).join(' ');
    return Scaffold(
      backgroundColor: kMkBg,
      appBar: mkAppBar('Markz Seller', actions: [
        IconButton(onPressed: () => _load(), icon: const Icon(Icons.refresh)),
        IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
      ]),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kMkGreen))
          : _error != null
              ? Center(child: MkEmpty(icon: Icons.storefront_outlined, text: _error!))
              : RefreshIndicator(
                  color: kMkGreen,
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(14),
                    children: [
                      Text('Namaste${name.isEmpty ? '' : ', $name'}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      if (_n('new_orders') > 0)
                        InkWell(
                          onTap: () => _open(const SellerShipPage()),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: kMkGreen, borderRadius: BorderRadius.circular(14)),
                            child: Row(children: [
                              const Icon(Icons.notifications_active, color: Colors.white),
                              const SizedBox(width: 10),
                              Expanded(child: Text('${_n('new_orders')} naye order aaye hain. Dekhne ke liye dabao.', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                              const Icon(Icons.chevron_right, color: Colors.white),
                            ]),
                          ),
                        ),
                      Row(children: [
                        _stat('Ship karna', _n('to_ship'), kMkGreen),
                        const SizedBox(width: 10),
                        _stat('Late', _n('late'), kMkSale),
                        const SizedBox(width: 10),
                        _stat('Pickup baaki', _n('awaiting_pickup'), kMkGold),
                      ]),
                      const SizedBox(height: 14),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.25,
                        children: [
                          _tile(Icons.local_shipping_outlined, 'Orders to ship', 'Pack karke Ready dabao', () => _open(const SellerShipPage()), badge: _n('to_ship')),
                          _tile(Icons.add_photo_alternate_outlined, 'Product add karo', 'Photo, price, stock', () => _open(const SellerAddProductPage())),
                          _tile(Icons.account_balance_wallet_outlined, 'Payments', 'Payout aur ledger', () => _open(const SellerPaymentsPage())),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}

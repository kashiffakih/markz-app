import 'package:aadab/ui/views/market/market_common.dart';
import 'package:flutter/material.dart';

class SellerPaymentsPage extends StatefulWidget {
  const SellerPaymentsPage({Key? key}) : super(key: key);

  @override
  State<SellerPaymentsPage> createState() => _SellerPaymentsPageState();
}

class _SellerPaymentsPageState extends State<SellerPaymentsPage> {
  Map<String, dynamic> _d = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final r = await marketApi.sellerPaymentsSummary();
    if (!mounted) return;
    setState(() {
      if (marketApi.ok(r) && r['data'] is Map) {
        _d = Map<String, dynamic>.from(r['data'] as Map);
      } else {
        _error = marketApi.errorText(r);
      }
      _loading = false;
    });
  }

  Widget _row(String label, dynamic v, {String? hint, Color color = kMkInk}) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: kMkLine)),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
              if (hint != null) Text(hint, style: const TextStyle(color: kMkMuted, fontSize: 12)),
            ]),
          ),
          Text(money(v ?? 0), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final last = _d['last_payout'] is Map ? Map<String, dynamic>.from(_d['last_payout'] as Map) : null;
    final adj = _d['pending_adjustments'];
    return Scaffold(
      backgroundColor: kMkBg,
      appBar: mkAppBar('Payments'),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kMkGreen))
          : _error != null
              ? Center(child: MkEmpty(icon: Icons.wifi_off_rounded, text: _error!))
              : RefreshIndicator(
                  color: kMkGreen,
                  onRefresh: _load,
                  child: ListView(padding: const EdgeInsets.all(14), children: [
                    _row('Payout ke liye ready', _d['ready_amount'], hint: '${_d['ready_orders'] ?? 0} orders, agle payout me aayega', color: kMkGreen),
                    _row('Payout process me', _d['in_payout_amount']),
                    _row('Mil chuka', _d['paid_amount'], color: kMkGreen),
                    _row('Delivery ke baad ka intezaar', _d['awaiting_amount'], hint: '${_d['awaiting_orders'] ?? 0} orders abhi deliver nahi hue'),
                    _row('Hold par', _d['hold_amount'], hint: '${_d['hold_orders'] ?? 0} orders (return / dispute)', color: kMkGold),
                    if (adj is num && adj > 0) _row('Agle payout se katega', adj, hint: 'Return / weight adjustment', color: kMkSale),
                    if (last != null)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: kMkGreenSoft, borderRadius: BorderRadius.circular(14)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Last payout', style: TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('${last['payout_number'] ?? ''}  •  ${money(last['amount'])}'),
                          if ('${last['paid_at'] ?? ''}'.isNotEmpty) Text('Date: ${last['paid_at']}', style: const TextStyle(color: kMkMuted, fontSize: 12)),
                          if ('${last['transaction_id'] ?? ''}'.isNotEmpty) Text('Txn: ${last['transaction_id']}', style: const TextStyle(color: kMkMuted, fontSize: 12)),
                        ]),
                      ),
                  ]),
                ),
    );
  }
}

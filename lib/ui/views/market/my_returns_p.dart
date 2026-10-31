import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/views/market/market_common.dart';
import 'package:flutter/material.dart';

class MyReturnsPage extends StatefulWidget {
  const MyReturnsPage({Key? key}) : super(key: key);

  @override
  State<MyReturnsPage> createState() => _MyReturnsPageState();
}

class _MyReturnsPageState extends State<MyReturnsPage> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  String? _error;

  bool get _loggedIn => locator<ConfigModel>().isLoggedIn;

  @override
  void initState() {
    super.initState();
    if (_loggedIn) {
      _load();
    } else {
      _loading = false;
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final r = await marketApi.myReturns();
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

  Color _statusColor(String s) {
    switch (s) {
      case 'refunded':
        return kMkGreen;
      case 'rejected':
        return kMkSale;
      case 'requested':
        return kMkGold;
      default:
        return const Color(0xFF2563EB);
    }
  }

  String _statusText(String s) {
    switch (s) {
      case 'requested':
        return 'Requested';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'pickup_scheduled':
        return 'Pickup scheduled';
      case 'picked_up':
        return 'Picked up';
      case 'received':
        return 'Received';
      case 'refunded':
        return 'Refunded';
      default:
        return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMkBg,
      appBar: mkAppBar('My Returns'),
      body: !_loggedIn
          ? const Center(child: MkEmpty(icon: Icons.lock_outline, text: 'Returns dekhne ke liye pehle login karo.'))
          : _loading
              ? const Center(child: CircularProgressIndicator(color: kMkGreen))
              : _error != null
                  ? Center(child: MkEmpty(icon: Icons.wifi_off_rounded, text: _error!))
                  : _items.isEmpty
                      ? const Center(child: MkEmpty(icon: Icons.assignment_return_outlined, text: 'Abhi koi return request nahi hai. Return ke liye My Orders me delivered order par "Return" dabao.'))
                      : RefreshIndicator(
                          color: kMkGreen,
                          onRefresh: _load,
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
                            itemCount: _items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final r = _items[i];
                              final status = '${r['status']}';
                              return Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: kMkLine)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: Text('${r['return_number'] ?? 'Return'}', style: const TextStyle(fontWeight: FontWeight.w800))),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(color: _statusColor(status).withOpacity(0.12), borderRadius: BorderRadius.circular(99)),
                                          child: Text(_statusText(status), style: TextStyle(color: _statusColor(status), fontWeight: FontWeight.w800, fontSize: 11.5)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text('Order #${r['order_id']}  •  ${r['reason'] ?? ''}', style: const TextStyle(color: kMkMuted, fontSize: 13)),
                                    if ((r['refund_amount'] is num ? r['refund_amount'] as num : num.tryParse('${r['refund_amount']}') ?? 0) > 0)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text('Refund: ${money(r['refund_amount'])}', style: const TextStyle(fontWeight: FontWeight.w700, color: kMkGreen)),
                                      ),
                                    if ('${r['rejection_reason'] ?? ''}'.isNotEmpty && status == 'rejected')
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text('Reason: ${r['rejection_reason']}', style: const TextStyle(color: kMkSale, fontSize: 12.5)),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
    );
  }
}

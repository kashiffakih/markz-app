import 'package:aadab/ui/views/market/market_common.dart';
import 'package:flutter/material.dart';

/// Customer "Return this order" bottom sheet.
/// Reasons, window and fees come from the Markz policy (GET /marketplace/policy);
/// the refund shown is an estimate, the server decides the final amount.
/// Returns true when a return request was submitted.
Future<bool?> showReturnSheet(
  BuildContext context, {
  required int orderId,
  required num paid,
  required num deliveryPaid,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _ReturnSheet(orderId: orderId, paid: paid, deliveryPaid: deliveryPaid),
    ),
  );
}

class _ReturnSheet extends StatefulWidget {
  final int orderId;
  final num paid;
  final num deliveryPaid;
  const _ReturnSheet({Key? key, required this.orderId, required this.paid, required this.deliveryPaid}) : super(key: key);

  @override
  State<_ReturnSheet> createState() => _ReturnSheetState();
}

class _ReturnSheetState extends State<_ReturnSheet> {
  List<Map<String, dynamic>> _reasons = [];
  num _returnFee = 50;
  int _windowDays = 7;
  String? _code;
  bool _loading = true;
  bool _sending = false;
  String? _error;
  final TextEditingController _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPolicy();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _loadPolicy() async {
    final r = await marketApi.policy();
    if (!mounted) return;
    setState(() {
      final d = r['data'];
      if (marketApi.ok(r) && d is Map) {
        _reasons = ((d['return_reasons'] ?? []) as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        _returnFee = (d['customer_return_fee'] is num) ? d['customer_return_fee'] as num : num.tryParse('${d['customer_return_fee']}') ?? 50;
        _windowDays = (d['return_window_days'] is num) ? (d['return_window_days'] as num).toInt() : 7;
      } else {
        _error = marketApi.errorText(r);
      }
      _loading = false;
    });
  }

  Map<String, dynamic>? get _picked {
    for (final r in _reasons) {
      if (r['code'] == _code) return r;
    }
    return null;
  }

  /// estimated refund for the chosen reason
  num get _refund {
    final fault = _picked == null ? '' : '${_picked!['fault']}';
    if (fault == 'customer') {
      final v = widget.paid - widget.deliveryPaid - _returnFee;
      return v < 0 ? 0 : v;
    }
    return widget.paid;
  }

  Future<void> _submit() async {
    if (_code == null) {
      mkSnack(context, 'Return ka reason chuno', error: true);
      return;
    }
    setState(() => _sending = true);
    final r = await marketApi.requestReturn(widget.orderId, _code!, description: _note.text.trim());
    if (!mounted) return;
    setState(() => _sending = false);
    if (marketApi.ok(r)) {
      Navigator.pop(context, true);
      mkSnack(context, '${r['message'] ?? 'Return request submit ho gayi'}');
    } else {
      mkSnack(context, marketApi.errorText(r), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fault = _picked == null ? '' : '${_picked!['fault']}';
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: Text('Return Order #${widget.orderId}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: kMkInk))),
              IconButton(onPressed: () => Navigator.pop(context, false), icon: const Icon(Icons.close)),
            ]),
            Text('Delivery ke $_windowDays din ke andar return kar sakte ho.', style: const TextStyle(color: kMkMuted, fontSize: 13)),
            const SizedBox(height: 12),
            if (_loading)
              const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator(color: kMkGreen)))
            else if (_error != null)
              Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text(_error!, style: const TextStyle(color: kMkSale)))
            else ...[
              const Text('Return kyun kar rahe ho?', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              for (final r in _reasons)
                InkWell(
                  onTap: () => setState(() => _code = '${r['code']}'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(children: [
                      Icon(_code == r['code'] ? Icons.radio_button_checked : Icons.radio_button_off, color: _code == r['code'] ? kMkGreen : kMkMuted, size: 22),
                      const SizedBox(width: 8),
                      Expanded(child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('${r['label']}'))),
                    ]),
                  ),
                ),
              const SizedBox(height: 6),
              TextField(
                controller: _note,
                maxLines: 2,
                maxLength: 500,
                decoration: const InputDecoration(labelText: 'Kuch aur batana hai? (optional)', border: OutlineInputBorder()),
              ),
              if (_picked != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 4, bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: kMkGreenSoft, borderRadius: BorderRadius.circular(12)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Aapko wapas milega: ${money(_refund)}', style: const TextStyle(fontWeight: FontWeight.w800, color: kMkGreen)),
                    const SizedBox(height: 3),
                    Text(
                      fault == 'customer'
                          ? 'Delivery fee (${money(widget.deliveryPaid)}) aur return pickup fee (${money(_returnFee)}) kat-ti hai, kyunki is reason me galti product ki nahi hai.'
                          : 'Poora paisa wapas, koi charge nahi.',
                      style: const TextStyle(fontSize: 12.5, color: kMkMuted),
                    ),
                  ]),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: mkButton(),
                  onPressed: _sending ? null : _submit,
                  child: _sending
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Return request bhejo'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

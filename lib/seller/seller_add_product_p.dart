import 'dart:io';

import 'package:aadab/ui/views/market/market_common.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Seller: add a product (photos, category, price, stock and parcel size/weight).
/// Weight and size are required: the courier bills by weight and parcel size.
class SellerAddProductPage extends StatefulWidget {
  const SellerAddProductPage({Key? key}) : super(key: key);

  @override
  State<SellerAddProductPage> createState() => _SellerAddProductPageState();
}

class _Pkg {
  final String name;
  final int l, b, h;
  const _Pkg(this.name, this.l, this.b, this.h);
}

class _SellerAddProductPageState extends State<SellerAddProductPage> {
  static const int _maxImages = 6;
  static const List<_Pkg> _pkgs = [
    _Pkg('Custom (khud likhunga)', 0, 0, 0),
    _Pkg('Poly bag chhota (25x20x3)', 25, 20, 3),
    _Pkg('Poly bag medium (35x28x5)', 35, 28, 5),
    _Pkg('Box chhota (20x15x10)', 20, 15, 10),
    _Pkg('Box medium (30x25x15)', 30, 25, 15),
    _Pkg('Box bada (45x35x25)', 45, 35, 25),
  ];

  final _picker = ImagePicker();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _offer = TextEditingController();
  final _qty = TextEditingController();
  final _weight = TextEditingController();
  final _len = TextEditingController();
  final _bre = TextEditingController();
  final _hei = TextEditingController();

  List<Map<String, dynamic>> _cats = [];
  List<Map<String, dynamic>> _subs = [];
  int? _catId;
  int? _subId;
  int _pkg = 0;
  final List<XFile> _images = [];
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadForm();
  }

  @override
  void dispose() {
    for (final c in [_name, _desc, _price, _offer, _qty, _weight, _len, _bre, _hei]) {
      c.dispose();
    }
    super.dispose();
  }

  List<Map<String, dynamic>> _list(dynamic v) =>
      (v is List) ? v.map((e) => Map<String, dynamic>.from(e as Map)).toList() : <Map<String, dynamic>>[];

  Future<void> _loadForm() async {
    final r = await marketApi.sellerFormData();
    if (!mounted) return;
    setState(() {
      if (marketApi.ok(r)) {
        _cats = _list(r['categories']);
        _subs = _list(r['sub_categories']);
      } else {
        _error = marketApi.errorText(r);
      }
      _loading = false;
    });
  }

  List<Map<String, dynamic>> get _subsOfCat => _subs.where((s) => '${s['category_id']}' == '$_catId').toList();

  Future<void> _pickGallery() async {
    final room = _maxImages - _images.length;
    if (room <= 0) return;
    final files = await _picker.pickMultiImage(imageQuality: 85, maxWidth: 1600);
    if (!mounted || files.isEmpty) return;
    setState(() => _images.addAll(files.take(room)));
  }

  Future<void> _pickCamera() async {
    if (_images.length >= _maxImages) return;
    final f = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85, maxWidth: 1600);
    if (!mounted || f == null) return;
    setState(() => _images.add(f));
  }

  void _applyPkg(int i) {
    setState(() {
      _pkg = i;
      final p = _pkgs[i];
      if (p.l > 0) {
        _len.text = '${p.l}';
        _bre.text = '${p.b}';
        _hei.text = '${p.h}';
      }
    });
  }

  num _n(TextEditingController c) => num.tryParse(c.text.trim()) ?? 0;

  /// courier "billable" weight: bigger of real and volumetric weight, in 500 g slabs
  int get _billable {
    final vol = (_n(_len) * _n(_bre) * _n(_hei)) / 5000 * 1000;
    final w = _n(_weight) > vol ? _n(_weight) : vol;
    return w <= 0 ? 0 : ((w / 500).ceil() * 500);
  }

  String? _validate() {
    if (_images.isEmpty) return 'Kam se kam 1 photo daalo.';
    if (_name.text.trim().isEmpty) return 'Product ka naam likho.';
    if (_catId == null) return 'Category chuno.';
    if (_n(_price) <= 0) return 'MRP / price daalo.';
    if (_offer.text.trim().isNotEmpty && !(_n(_offer) < _n(_price))) return 'Offer price MRP se kam hona chahiye.';
    if (_qty.text.trim().isEmpty) return 'Stock daalo (0 bhi chalega).';
    if (_n(_weight) < 10) return 'Weight (gram) daalo, kam se kam 10 g.';
    if (_n(_len) < 1 || _n(_bre) < 1 || _n(_hei) < 1) return 'Parcel ki length, breadth, height (cm) daalo.';
    return null;
  }

  Future<void> _submit() async {
    final err = _validate();
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    final fields = <String, String>{
      'name': _name.text.trim(),
      'category_id': '$_catId',
      'price': _price.text.trim(),
      'qty': _qty.text.trim(),
      'weight': _weight.text.trim(),
      'length': _len.text.trim(),
      'breadth': _bre.text.trim(),
      'height': _hei.text.trim(),
    };
    if (_subId != null) fields['sub_category_id'] = '$_subId';
    if (_offer.text.trim().isNotEmpty) fields['offer_price'] = _offer.text.trim();
    if (_desc.text.trim().isNotEmpty) fields['description'] = _desc.text.trim();

    final r = await marketApi.sellerAddProduct(fields, _images.map((e) => e.path).toList());
    if (!mounted) return;
    setState(() => _saving = false);
    if (marketApi.ok(r)) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Product bhej diya'),
          content: Text('${r['message'] ?? 'Review ke baad store par dikhega.'}'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Theek hai'))],
        ),
      );
      if (mounted) Navigator.pop(context);
    } else {
      setState(() => _error = marketApi.errorText(r));
    }
  }

  Widget _field(TextEditingController c, String label, {bool number = false, int lines = 1, int? max}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          maxLines: lines,
          maxLength: max,
          keyboardType: number ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), counterText: ''),
        ),
      );

  Widget _section(String t) => Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 10),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: kMkGreen)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMkBg,
      appBar: mkAppBar('Product add karo'),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kMkGreen))
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _section('1. Photos (${_images.length}/$_maxImages)'),
                SizedBox(
                  height: 96,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    for (var i = 0; i < _images.length; i++)
                      Stack(children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: kMkLine)),
                          child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(File(_images[i].path), fit: BoxFit.cover)),
                        ),
                        Positioned(
                          right: 12,
                          top: 4,
                          child: InkWell(
                            onTap: () => setState(() => _images.removeAt(i)),
                            child: const CircleAvatar(radius: 11, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 14, color: Colors.white)),
                          ),
                        ),
                        if (i == 0)
                          Positioned(
                            left: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: kMkGreen, borderRadius: BorderRadius.circular(99)),
                              child: const Text('Cover', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                            ),
                          ),
                      ]),
                    if (_images.length < _maxImages) ...[
                      InkWell(onTap: _pickGallery, child: _addBox(Icons.photo_library_outlined, 'Gallery')),
                      InkWell(onTap: _pickCamera, child: _addBox(Icons.photo_camera_outlined, 'Camera')),
                    ],
                  ]),
                ),
                _section('2. Product ki jaankari'),
                _field(_name, 'Product ka naam', max: 200),
                DropdownButtonFormField<int>(
                  value: _catId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                  items: [for (final c in _cats) DropdownMenuItem(value: (c['id'] as num).toInt(), child: Text('${c['name']}'))],
                  onChanged: (v) => setState(() {
                    _catId = v;
                    _subId = null;
                  }),
                ),
                const SizedBox(height: 12),
                if (_catId != null && _subsOfCat.isNotEmpty) ...[
                  DropdownButtonFormField<int>(
                    value: _subId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Sub category (optional)', border: OutlineInputBorder()),
                    items: [for (final c in _subsOfCat) DropdownMenuItem(value: (c['id'] as num).toInt(), child: Text('${c['name']}'))],
                    onChanged: (v) => setState(() => _subId = v),
                  ),
                  const SizedBox(height: 12),
                ],
                _field(_desc, 'Description (fabric, size, wash care...)', lines: 3, max: 5000),
                _section('3. Price aur stock'),
                Row(children: [
                  Expanded(child: _field(_price, 'MRP / Price (₹)', number: true)),
                  const SizedBox(width: 10),
                  Expanded(child: _field(_offer, 'Offer price (₹)', number: true)),
                ]),
                _field(_qty, 'Stock (quantity)', number: true),
                _section('4. Parcel ka weight aur size (zaroori)'),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('Courier parcel ke weight aur size se charge lagata hai. Packing ke saath ka weight likho.', style: TextStyle(color: kMkMuted, fontSize: 12.5)),
                ),
                DropdownButtonFormField<int>(
                  value: _pkg,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Packing type', border: OutlineInputBorder()),
                  items: [for (var i = 0; i < _pkgs.length; i++) DropdownMenuItem(value: i, child: Text(_pkgs[i].name))],
                  onChanged: (v) => _applyPkg(v ?? 0),
                ),
                const SizedBox(height: 12),
                _field(_weight, 'Weight (gram)', number: true),
                Row(children: [
                  Expanded(child: _field(_len, 'Length cm', number: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _field(_bre, 'Breadth cm', number: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _field(_hei, 'Height cm', number: true)),
                ]),
                if (_billable > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text('Courier ke hisaab se billable weight: $_billable g', style: const TextStyle(color: kMkMuted, fontSize: 12.5)),
                  ),
                if (_error != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: kMkSale.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                    child: Text(_error!, style: const TextStyle(color: kMkSale)),
                  ),
                ElevatedButton(
                  style: mkButton(),
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Review ke liye bhejo'),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _addBox(IconData icon, String t) => Container(
        margin: const EdgeInsets.only(right: 8),
        width: 96,
        height: 96,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: kMkGreen, width: 1.4)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: kMkGreen),
          const SizedBox(height: 4),
          Text(t, style: const TextStyle(color: kMkGreen, fontWeight: FontWeight.w700, fontSize: 12)),
        ]),
      );
}

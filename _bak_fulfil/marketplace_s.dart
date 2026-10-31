import 'dart:convert';

import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;

/// Marketplace / chat / reseller / returns API calls.
/// Every method returns the decoded JSON map. `_status` holds the HTTP status code.
class MarketplaceService {
  final ConfigModel _configModel = locator<ConfigModel>();

  Map<String, dynamic> get _cfg => _configModel.apiConfig;
  String get _base => '${_cfg['baseURL']}';

  Map<String, String> get _headers {
    final h = <String, String>{};
    final raw = _cfg['headers'];
    if (raw is Map) {
      raw.forEach((k, v) => h['$k'] = '$v');
    }
    return h;
  }

  /// Full image url for a path coming from the API.
  String mediaUrl(dynamic path) {
    if (path == null) return '';
    final p = '$path';
    if (p.isEmpty) return '';
    if (p.startsWith('http')) return p;
    return '${_cfg['mediaURL']}$p';
  }

  Map<String, dynamic> _decode(http.Response res) {
    Map<String, dynamic> out = {};
    try {
      if (res.body.isNotEmpty) {
        final body = json.decode(res.body);
        if (body is Map) {
          out = Map<String, dynamic>.from(body);
        } else {
          out = {'data': body};
        }
      }
    } catch (_) {
      out = {'message': 'Server se galat response aaya'};
    }
    out['_status'] = res.statusCode;
    return out;
  }

  Map<String, dynamic> _failed(Object e) =>
      {'message': 'Network error. Internet check karo.', '_status': 0, '_error': '$e'};

  Map<String, String> _clean(Map<String, dynamic>? q) {
    final out = <String, String>{};
    if (q == null) return out;
    q.forEach((k, v) {
      if (v != null && '$v'.isNotEmpty) out[k] = '$v';
    });
    return out;
  }

  Future<Map<String, dynamic>> _get(String path, [Map<String, dynamic>? query]) async {
    try {
      final uri = Uri.parse('$_base$path').replace(queryParameters: _clean(query));
      final res = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 25));
      return _decode(res);
    } catch (e) {
      return _failed(e);
    }
  }

  Future<Map<String, dynamic>> _send(String method, String path, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('$_base$path');
      final headers = _headers;
      final payload = json.encode(body);
      http.Response res;
      if (method == 'PUT') {
        res = await http.put(uri, headers: headers, body: payload).timeout(const Duration(seconds: 25));
      } else {
        res = await http.post(uri, headers: headers, body: payload).timeout(const Duration(seconds: 25));
      }
      return _decode(res);
    } catch (e) {
      return _failed(e);
    }
  }

  /// Human readable error from a response map (validation errors included).
  String errorText(Map<String, dynamic> r) {
    final errors = r['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return '${first.first}';
      return '$first';
    }
    return '${r['message'] ?? 'Kuch gadbad hui'}';
  }

  bool ok(Map<String, dynamic> r) {
    final s = r['_status'];
    return s is int && s >= 200 && s < 300;
  }

  // ------------------------------------------------------------ public marketplace

  Future<Map<String, dynamic>> home() => _get('/marketplace/home');

  Future<Map<String, dynamic>> products({
    String? search,
    int? categoryId,
    int? sellerId,
    String sort = 'latest',
    int page = 1,
    int perPage = 20,
  }) =>
      _get('/marketplace/products', {
        'search': search,
        'categoryId': categoryId,
        'sellerId': sellerId,
        'sort': sort == 'latest' ? null : sort,
        'page': page,
        'perPage': perPage,
      });

  Future<Map<String, dynamic>> sellers({String? search, int page = 1}) =>
      _get('/marketplace/sellers', {'search': search, 'page': page, 'perPage': 24});

  Future<Map<String, dynamic>> seller(int id) => _get('/marketplace/sellers/$id');

  Future<Map<String, dynamic>> categories() => _get('/categories', {'cityId': 1});

  // ------------------------------------------------------------ chat

  Future<Map<String, dynamic>> chatConversations() => _get('/chat/conversations', {'as': 'customer'});

  Future<Map<String, dynamic>> chatStart(int companyId, {int? productId}) =>
      _send('POST', '/chat/conversations', {'company_id': companyId, 'product_id': productId});

  Future<Map<String, dynamic>> chatMessages(int conversationId, {int? afterId}) =>
      _get('/chat/conversations/$conversationId/messages', {'after_id': afterId});

  Future<Map<String, dynamic>> chatSend(int conversationId, String body) =>
      _send('POST', '/chat/conversations/$conversationId/messages', {'body': body});

  // ------------------------------------------------------------ returns

  Future<Map<String, dynamic>> myReturns() => _get('/my_returns');

  Future<Map<String, dynamic>> requestReturn(int orderId, String reason, {String? description}) =>
      _send('POST', '/my_returns', {'order_id': orderId, 'reason': reason, 'description': description});

  // ------------------------------------------------------------ reseller

  Future<Map<String, dynamic>> resellerMe() => _get('/reseller/me');

  Future<Map<String, dynamic>> resellerApply(String businessName, String phone) =>
      _send('POST', '/reseller/apply', {'business_name': businessName, 'phone': phone});

  Future<Map<String, dynamic>> resellerSavePayout(Map<String, dynamic> body) => _send('PUT', '/reseller/payout', body);

  Future<Map<String, dynamic>> resellerCatalog({String? search, int page = 1}) =>
      _get('/reseller/catalog', {'search': search, 'page': page});

  Future<Map<String, dynamic>> resellerPlaceOrder(Map<String, dynamic> customer, List<Map<String, dynamic>> items) =>
      _send('POST', '/reseller/orders', {'customer': customer, 'items': items});

  Future<Map<String, dynamic>> resellerOrders() => _get('/reseller/orders');

  Future<Map<String, dynamic>> resellerWallet() => _get('/reseller/wallet');

  Future<Map<String, dynamic>> resellerWithdrawals() => _get('/reseller/withdrawals');

  Future<Map<String, dynamic>> resellerWithdraw(num amount) => _send('POST', '/reseller/withdrawals', {'amount': amount});
}

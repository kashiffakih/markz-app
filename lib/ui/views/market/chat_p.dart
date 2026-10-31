import 'dart:async';

import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/views/market/market_common.dart';
import 'package:flutter/material.dart';

bool _loggedIn() => locator<ConfigModel>().isLoggedIn;

String _fmtTime(dynamic raw) {
  if (raw == null) return '';
  final d = DateTime.tryParse('$raw'.replaceFirst(' ', 'T'));
  if (d == null) return '';
  final l = d.toLocal();
  const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final hh = l.hour.toString().padLeft(2, '0');
  final mm = l.minute.toString().padLeft(2, '0');
  return '${l.day} ${m[l.month - 1]}, $hh:$mm';
}

/// Starts (or reuses) a chat with a seller and opens the thread.
Future<void> startChatWithSeller(BuildContext context, int companyId, {int? productId}) async {
  if (!_loggedIn()) {
    mkSnack(context, 'Chat ke liye pehle login karo', error: true);
    return;
  }
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator(color: kMkGreen)),
  );
  final r = await marketApi.chatStart(companyId, productId: productId);
  if (!context.mounted) return;
  Navigator.of(context, rootNavigator: true).pop();
  if (!marketApi.ok(r) || r['data'] is! Map) {
    mkSnack(context, marketApi.errorText(r), error: true);
    return;
  }
  final conv = Map<String, dynamic>.from(r['data']);
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatThreadPage(conversation: conv)));
}

// ============================================================================ list

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (_loggedIn()) {
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
    final r = await marketApi.chatConversations();
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
    return Scaffold(
      backgroundColor: kMkBg,
      appBar: mkAppBar('My Chats'),
      body: !_loggedIn()
          ? const Center(child: MkEmpty(icon: Icons.lock_outline, text: 'Chat dekhne ke liye pehle login karo.'))
          : _loading
              ? const Center(child: CircularProgressIndicator(color: kMkGreen))
              : _error != null
                  ? Center(child: MkEmpty(icon: Icons.wifi_off_rounded, text: _error!))
                  : _items.isEmpty
                      ? const Center(child: MkEmpty(icon: Icons.chat_bubble_outline, text: 'Abhi koi chat nahi.\nProduct ya seller page se "Chat" dabao.'))
                      : RefreshIndicator(
                          color: kMkGreen,
                          onRefresh: _load,
                          child: ListView.separated(
                            itemCount: _items.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, color: kMkLine),
                            itemBuilder: (context, i) {
                              final c = _items[i];
                              final company = c['company'] is Map ? Map<String, dynamic>.from(c['company']) : <String, dynamic>{};
                              final product = c['product'] is Map ? Map<String, dynamic>.from(c['product']) : null;
                              final unread = (c['customer_unread'] as num?)?.toInt() ?? 0;
                              final logo = marketApi.mediaUrl(company['logo_path']);
                              final name = '${company['name'] ?? 'Seller'}';
                              return Container(
                                color: Colors.white,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: kMkGreenSoft,
                                    backgroundImage: logo.isNotEmpty ? NetworkImage(logo) : null,
                                    onBackgroundImageError: logo.isNotEmpty ? (e, s) {} : null,
                                    child: logo.isEmpty
                                        ? Text(name.substring(0, 1).toUpperCase(), style: const TextStyle(color: kMkGreen, fontWeight: FontWeight.w800))
                                        : null,
                                  ),
                                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                                  subtitle: Text(
                                    '${product != null ? '${product['name']} • ' : ''}${c['last_message_preview'] ?? 'Start the conversation'}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: unread > 0
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(color: kMkSale, borderRadius: BorderRadius.circular(99)),
                                          child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                                        )
                                      : null,
                                  onTap: () async {
                                    await Navigator.push(context, MaterialPageRoute(builder: (_) => ChatThreadPage(conversation: c)));
                                    if (mounted) _load();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
    );
  }
}

// ============================================================================ thread

class ChatThreadPage extends StatefulWidget {
  final Map<String, dynamic> conversation;
  const ChatThreadPage({Key? key, required this.conversation}) : super(key: key);

  @override
  State<ChatThreadPage> createState() => _ChatThreadPageState();
}

class _ChatThreadPageState extends State<ChatThreadPage> {
  final ScrollController _scroll = ScrollController();
  final TextEditingController _draft = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  Timer? _poll;
  bool _loading = true;
  bool _sending = false;
  bool _closed = false;
  int _lastId = 0;

  int get _convId => (widget.conversation['id'] as num).toInt();

  @override
  void initState() {
    super.initState();
    _closed = '${widget.conversation['status']}' == 'closed';
    _fetch(initial: true);
    _poll = Timer.periodic(const Duration(seconds: 6), (_) => _fetch());
  }

  @override
  void dispose() {
    _poll?.cancel();
    _scroll.dispose();
    _draft.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _fetch({bool initial = false}) async {
    final r = await marketApi.chatMessages(_convId, afterId: initial || _lastId == 0 ? null : _lastId);
    if (!mounted) return;
    if (!marketApi.ok(r) || r['messages'] is! List) {
      if (initial) setState(() => _loading = false);
      return;
    }
    final incoming = (r['messages'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    final conv = r['conversation'];
    setState(() {
      if (initial) _messages.clear();
      if (incoming.isNotEmpty) _messages.addAll(incoming);
      if (_messages.isNotEmpty) _lastId = (_messages.last['id'] as num).toInt();
      if (conv is Map) _closed = '${conv['status']}' == 'closed';
      _loading = false;
    });
    if (initial || incoming.isNotEmpty) _scrollDown();
  }

  Future<void> _send() async {
    final body = _draft.text.trim();
    if (body.isEmpty || _sending) return;
    setState(() => _sending = true);
    final r = await marketApi.chatSend(_convId, body);
    if (!mounted) return;
    setState(() => _sending = false);
    if (marketApi.ok(r)) {
      _draft.clear();
      await _fetch();
    } else {
      mkSnack(context, marketApi.errorText(r), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final company = widget.conversation['company'] is Map ? Map<String, dynamic>.from(widget.conversation['company']) : <String, dynamic>{};
    final product = widget.conversation['product'] is Map ? Map<String, dynamic>.from(widget.conversation['product']) : null;
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F2),
      appBar: AppBar(
        backgroundColor: kMkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${company['name'] ?? 'Seller'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            if (product != null) Text('${product['name']}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: kMkGreen))
                : _messages.isEmpty
                    ? const Center(child: MkEmpty(icon: Icons.waving_hand_outlined, text: 'Seller ko pehla message bhejo.'))
                    : ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.all(12),
                        itemCount: _messages.length,
                        itemBuilder: (context, i) {
                          final m = _messages[i];
                          final mine = '${m['sender_type']}' == 'customer';
                          return Align(
                            alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                              decoration: BoxDecoration(
                                color: mine ? kMkGreen : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(14),
                                  topRight: const Radius.circular(14),
                                  bottomLeft: Radius.circular(mine ? 14 : 3),
                                  bottomRight: Radius.circular(mine ? 3 : 14),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('${m['body']}', style: TextStyle(color: mine ? Colors.white : kMkInk, fontSize: 14, height: 1.35)),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(_fmtTime(m['created_at']), style: TextStyle(fontSize: 10, color: mine ? Colors.white70 : kMkMuted)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          SafeArea(
            top: false,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: _closed
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Ye chat close ho chuki hai.', textAlign: TextAlign.center, style: TextStyle(color: kMkMuted)),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _draft,
                            minLines: 1,
                            maxLines: 4,
                            maxLength: 2000,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Message likho...',
                              isDense: true,
                              filled: true,
                              fillColor: kMkBg,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(99), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: kMkGreen,
                          child: _sending
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : IconButton(icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20), onPressed: _send),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

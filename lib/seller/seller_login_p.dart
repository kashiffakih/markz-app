import 'package:aadab/core/providers/auth_pr.dart';
import 'package:aadab/ui/views/market/market_common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellerLoginPage extends StatefulWidget {
  const SellerLoginPage({Key? key}) : super(key: key);

  @override
  State<SellerLoginPage> createState() => _SellerLoginPageState();
}

class _SellerLoginPageState extends State<SellerLoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _hide = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      setState(() => _error = 'Email aur password dono likho.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final auth = Provider.of<AuthModel>(context, listen: false);
    final res = await auth.login(loginData: {
      'email': _email.text.trim(),
      'password': _password.text,
      'rememberme': 1,
      'role': 'User',
    });
    if (!mounted) return;
    setState(() => _busy = false);
    // on success the gate swaps this page for the seller home by itself
    if (res['success'] != true) {
      setState(() => _error = '${res['message'] ?? 'Login nahi hua'}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMkGreen,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('MARKZ', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 6)),
                const SizedBox(height: 4),
                const Text('Seller App', style: TextStyle(color: Colors.white70, fontSize: 15)),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email_outlined)),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _password,
                        obscureText: _hide,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(icon: Icon(_hide ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _hide = !_hide)),
                        ),
                        onSubmitted: (_) => _login(),
                      ),
                      if (_error != null)
                        Padding(padding: const EdgeInsets.only(top: 10), child: Text(_error!, style: const TextStyle(color: kMkSale))),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: mkButton(),
                        onPressed: _busy ? null : _login,
                        child: _busy
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Login'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Seller banne ke liye Markz website par "Become a Seller" se apply karein.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 12.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

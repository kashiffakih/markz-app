import 'package:aadab/core/providers/auth_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/seller/seller_home_p.dart';
import 'package:aadab/seller/seller_login_p.dart';
import 'package:aadab/ui/views/market/market_common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellerApp extends StatelessWidget {
  const SellerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthModel()),
        ChangeNotifierProvider.value(value: locator<ConfigModel>()),
      ],
      child: MaterialApp(
        title: 'Markz Seller',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kMkGreen,
          colorScheme: ColorScheme.fromSeed(seedColor: kMkGreen),
          scaffoldBackgroundColor: kMkBg,
        ),
        home: const SellerGate(),
      ),
    );
  }
}

/// Decides between the login page and the seller home (restores a saved login on start).
class SellerGate extends StatefulWidget {
  const SellerGate({Key? key}) : super(key: key);

  @override
  State<SellerGate> createState() => _SellerGateState();
}

class _SellerGateState extends State<SellerGate> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final cfg = locator<ConfigModel>();
    cfg.getApiConfig(domain: const String.fromEnvironment('API_URL', defaultValue: 'http://192.168.1.3:8000'));
    try {
      await cfg.fetchLoginData();
      if (cfg.loginData.isNotEmpty && mounted) {
        final auth = Provider.of<AuthModel>(context, listen: false);
        await auth.login(loginData: Map<String, dynamic>.from(cfg.loginData));
      }
    } catch (e) {
      debugPrint('Seller boot error: $e');
    }
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        backgroundColor: kMkGreen,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    final loggedIn = context.watch<ConfigModel>().isLoggedIn;
    return loggedIn ? const SellerHomePage() : const SellerLoginPage();
  }
}

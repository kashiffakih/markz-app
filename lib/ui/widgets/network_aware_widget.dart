import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:aadab/core/services/connectivity_service.dart';
import 'package:aadab/ui/views/network/no_network_page.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class NetworkAwareWidget extends StatefulWidget {
  final Widget child;
  
  const NetworkAwareWidget({Key? key, required this.child}) : super(key: key);

  @override
  _NetworkAwareWidgetState createState() => _NetworkAwareWidgetState();
}

class _NetworkAwareWidgetState extends State<NetworkAwareWidget> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool? _hasConnection;
  bool _isChecking = true;
  StreamSubscription<bool>? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }
  
  @override
  void dispose() {
    _connectionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeConnectivity() async {
    // Show loading while checking initial connection
    setState(() {
      _isChecking = true;
    });

    // Small delay to ensure service is ready
    await Future.delayed(Duration(milliseconds: 200));

    // Check initial connection with retries
    bool hasConnection = false;
    int retries = 0;
    
    while (retries < 3 && !hasConnection) {
      hasConnection = await _connectivityService.checkConnection();
      if (!hasConnection) {
        await Future.delayed(Duration(milliseconds: 500));
        retries++;
      }
    }
    
    if (mounted) {
      setState(() {
        _hasConnection = hasConnection;
        _isChecking = false;
      });
    }

    // Listen for connection changes
    _connectionSubscription = _connectivityService.connectionStream.listen((hasConnection) {
      debugPrint('NetworkAwareWidget: Connection status changed to $hasConnection');
      if (mounted) {
        setState(() {
          _hasConnection = hasConnection;
        });
      }
    });
  }

  Future<void> _retry() async {
    setState(() {
      _isChecking = true;
    });
    
    final hasConnection = await _connectivityService.checkConnection();
    
    if (mounted) {
      setState(() {
        _hasConnection = hasConnection;
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator during initial check
    if (_isChecking) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Checking connection...',
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // Show no network page if no connection
    if (_hasConnection == false) {
      return NoNetworkPage(
        onRetry: _retry,
      );
    }
    
    // Show the app content if connected
    return widget.child;
  }
}
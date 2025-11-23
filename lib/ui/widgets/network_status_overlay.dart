import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:aadab/core/services/connectivity_service.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class NetworkStatusOverlay extends StatefulWidget {
  final Widget child;
  
  const NetworkStatusOverlay({Key? key, required this.child}) : super(key: key);

  @override
  _NetworkStatusOverlayState createState() => _NetworkStatusOverlayState();
}

class _NetworkStatusOverlayState extends State<NetworkStatusOverlay> with SingleTickerProviderStateMixin {
  final ConnectivityService _connectivityService = ConnectivityService();
  StreamSubscription<bool>? _connectionSubscription;
  bool _hasConnection = true;
  bool _showBanner = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _initializeConnectivity();
  }

  void _initializeConnectivity() {
    // Listen for connection changes
    _connectionSubscription = _connectivityService.connectionStream.listen((hasConnection) {
      if (mounted) {
        setState(() {
          _hasConnection = hasConnection;
          
          if (!hasConnection) {
            _showBanner = true;
            _animationController.forward();
            _hideTimer?.cancel();
          } else if (_showBanner) {
            // Show "Connection restored" briefly
            _hideTimer = Timer(Duration(seconds: 2), () {
              if (mounted) {
                _animationController.reverse().then((_) {
                  if (mounted) {
                    setState(() {
                      _showBanner = false;
                    });
                  }
                });
              }
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    _animationController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showBanner)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -50 + (_animation.value * 50)),
                    child: Opacity(
                      opacity: _animation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _hasConnection ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _hasConnection ? Icons.wifi : Icons.wifi_off,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _hasConnection 
                            ? 'Connection restored' 
                            : 'No internet connection',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
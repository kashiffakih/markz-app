import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamController<bool> connectionStatusController = StreamController<bool>.broadcast();
  
  Stream<bool> get connectionStream => connectionStatusController.stream;
  
  bool _hasConnection = true;
  bool get hasConnection => _hasConnection;
  
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _periodicCheckTimer;

  // Initialize connectivity monitoring
  Future<void> initialize() async {
    debugPrint('Initializing connectivity service...');
    
    // Cancel any existing subscriptions
    await _connectivitySubscription?.cancel();
    _periodicCheckTimer?.cancel();
    
    // Check initial connection
    await checkConnection();
    
    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    
    // Start periodic checks every 10 seconds for better reliability
    _periodicCheckTimer = Timer.periodic(Duration(seconds: 10), (_) {
      _performPeriodicCheck();
    });
  }

  // Check current connection status
  Future<bool> checkConnection() async {
    try {
      debugPrint('Checking connectivity...');
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      
      debugPrint('Connectivity results: $results');
      
      if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        debugPrint('No connectivity detected');
        _hasConnection = false;
      } else {
        // Double check with actual internet connectivity
        debugPrint('Checking internet connection...');
        _hasConnection = await _checkInternetConnection();
        debugPrint('Internet connection: $_hasConnection');
      }
      
      connectionStatusController.add(_hasConnection);
      return _hasConnection;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      _hasConnection = false;
      connectionStatusController.add(_hasConnection);
      return false;
    }
  }

  // Update connection status when connectivity changes
  void _updateConnectionStatus(List<ConnectivityResult> results) async {
    debugPrint('Connectivity changed: $results');
    
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      _hasConnection = false;
    } else {
      // Double check with actual internet connectivity
      _hasConnection = await _checkInternetConnection();
    }
    
    debugPrint('Connection status updated: $_hasConnection');
    connectionStatusController.add(_hasConnection);
  }

  // Check actual internet connection by pinging a reliable server
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(Duration(seconds: 5), onTimeout: () {
        throw SocketException('Timeout');
      });
      
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (e) {
      debugPrint('Socket exception: $e');
      return false;
    } catch (e) {
      debugPrint('Error checking internet connection: $e');
      return false;
    }
  }

  // Perform periodic connectivity check
  Future<void> _performPeriodicCheck() async {
    debugPrint('Performing periodic connectivity check...');
    
    // Only check internet connection if we think we're connected
    if (_hasConnection) {
      final actuallyConnected = await _checkInternetConnection();
      
      if (!actuallyConnected && _hasConnection) {
        debugPrint('Lost internet connection detected by periodic check');
        _hasConnection = false;
        connectionStatusController.add(_hasConnection);
      }
    } else {
      // If we think we're disconnected, try to check connectivity
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      
      if (results.isNotEmpty && !results.contains(ConnectivityResult.none)) {
        final actuallyConnected = await _checkInternetConnection();
        
        if (actuallyConnected && !_hasConnection) {
          debugPrint('Internet connection restored detected by periodic check');
          _hasConnection = true;
          connectionStatusController.add(_hasConnection);
        }
      }
    }
  }

  // Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _periodicCheckTimer?.cancel();
    connectionStatusController.close();
  }
}
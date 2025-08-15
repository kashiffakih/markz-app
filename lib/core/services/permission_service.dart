import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  // Define required permissions for the app
  List<Permission> get _requiredPermissions {
    final permissions = <Permission>[
      Permission.camera,
      Permission.notification,
    ];
    
    return permissions;
  }

  // Get all required permissions with their details
  List<PermissionInfo> get requiredPermissions => _requiredPermissions
      .map((permission) => PermissionInfo(
            permission: permission,
            name: _getPermissionName(permission),
            description: _getPermissionDescription(permission),
            icon: _getPermissionIcon(permission),
          ))
      .toList();

  // Check status of all permissions
  Future<Map<Permission, PermissionStatus>> checkAllPermissions() async {
    final Map<Permission, PermissionStatus> statuses = {};
    
    for (final permission in _requiredPermissions) {
      final status = await permission.status;
      statuses[permission] = status;
    }
    
    return statuses;
  }

  // Request a single permission
  Future<PermissionStatus> requestPermission(Permission permission) async {
    print('PermissionService: Requesting permission - $permission');
    
    // Check current status first
    final currentStatus = await permission.status;
    print('PermissionService: Current status - $currentStatus');
    
    // If already granted, return
    if (currentStatus.isGranted) {
      print('PermissionService: Permission already granted');
      return currentStatus;
    }
    
    // If permanently denied, can't request again
    if (currentStatus.isPermanentlyDenied) {
      print('PermissionService: Permission permanently denied, open settings');
      return currentStatus;
    }
    
    // Request the permission
    try {
      final status = await permission.request();
      print('PermissionService: New status after request - $status');
      return status;
    } catch (e) {
      print('PermissionService: Error requesting permission - $e');
      return currentStatus;
    }
  }

  // Request multiple permissions
  Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
      List<Permission> permissions) async {
    final statuses = await permissions.request();
    return statuses;
  }

  // Check if a specific permission is granted
  Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  // Check if all required permissions are granted
  Future<bool> areAllPermissionsGranted() async {
    for (final permission in _requiredPermissions) {
      final status = await permission.status;
      if (!status.isGranted) {
        return false;
      }
    }
    return true;
  }

  // Open app settings
  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  // Get permission name for display
  String _getPermissionName(Permission permission) {
    if (permission == Permission.camera) {
      return 'Camera';
    } else if (permission == Permission.notification) {
      return 'Notifications';
    } else {
      return 'Unknown Permission';
    }
  }

  // Get permission description for display
  String _getPermissionDescription(Permission permission) {
    if (permission == Permission.camera) {
      return 'Required for taking daily photos and attendance selfies';
    } else if (permission == Permission.notification) {
      return 'Required to receive important updates and alerts';
    } else {
      return 'This permission is required for app functionality';
    }
  }

  // Get permission icon
  String _getPermissionIcon(Permission permission) {
    if (permission == Permission.camera) {
      return '📷';
    } else if (permission == Permission.notification) {
      return '🔔';
    } else {
      return '⚙️';
    }
  }
}

// Permission info model
class PermissionInfo {
  final Permission permission;
  final String name;
  final String description;
  final String icon;

  PermissionInfo({
    required this.permission,
    required this.name,
    required this.description,
    required this.icon,
  });
}
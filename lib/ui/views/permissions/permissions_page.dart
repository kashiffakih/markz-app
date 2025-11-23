import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/services/permission_service.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({Key? key}) : super(key: key);

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  final PermissionService _permissionService = PermissionService();
  Map<Permission, PermissionStatus> _permissionStatuses = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    setState(() => _isLoading = true);
    final statuses = await _permissionService.checkAllPermissions();
    setState(() {
      _permissionStatuses = statuses;
      _isLoading = false;
    });
  }

  Future<void> _requestPermission(Permission permission) async {
    print('Requesting permission: $permission');
    final status = await _permissionService.requestPermission(permission);
    print('Permission status: $status');

    setState(() {
      _permissionStatuses[permission] = status;
    });

    if (status.isPermanentlyDenied) {
      _showSettingsDialog();
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'This permission has been permanently denied. Please enable it in the app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _permissionService.openSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PermissionStatus? status) {
    if (status == null) return Colors.grey;
    if (status.isGranted) return Colors.green;
    if (status.isDenied) return Colors.orange;
    if (status.isPermanentlyDenied) return Colors.red;
    return Colors.grey;
  }

  String _getStatusText(PermissionStatus? status) {
    if (status == null) return 'Unknown';
    if (status.isGranted) return 'Granted';
    if (status.isDenied) return 'Denied';
    if (status.isPermanentlyDenied) return 'Permanently Denied';
    if (status.isRestricted) return 'Restricted';
    return 'Unknown';
  }

  Widget _buildPermissionTile(PermissionInfo permissionInfo) {
    final status = _permissionStatuses[permissionInfo.permission];
    final isGranted = status?.isGranted ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              permissionInfo.icon,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
        title: Text(
          permissionInfo.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              permissionInfo.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isGranted ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: _getStatusColor(status),
                ),
                const SizedBox(width: 4),
                Text(
                  _getStatusText(status),
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: !isGranted
            ? ElevatedButton(
                onPressed: () async {
                  print('Grant button pressed for: ${permissionInfo.name}');
                  await _requestPermission(permissionInfo.permission);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    const Text('Grant', style: TextStyle(color: Colors.white)),
              )
            : const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 32,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Permissions'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _checkPermissions,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Column(
                      children: [
                        Icon(
                          Icons.security,
                          size: 48,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Required Permissions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This app needs the following permissions to function properly',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      children: _permissionService.requiredPermissions
                          .map(_buildPermissionTile)
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final allGranted = await _permissionService
                              .areAllPermissionsGranted();
                          if (allGranted) {
                            Navigator.of(context).pop(true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please grant all required permissions'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

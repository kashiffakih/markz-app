import 'package:aadab/core/models/user.dart';

String _getDisplayName(User? user) {
  if (user == null) return 'Guest';

  // For Distributors, prioritize Business/Trade Name
  if (user.roles?.any((r) => r.name == 'Distributor') ?? false) {
    if (user.businessName != null && user.businessName!.isNotEmpty) {
      return user.businessName!;
    }
    if (user.tradeName != null && user.tradeName!.isNotEmpty) {
      return user.tradeName!;
    }
  }

  // Fallback to First Name + Last Name
  String name = user.firstName ?? '';
  if (user.lastName != null && user.lastName!.isNotEmpty) {
    name += ' ${user.lastName}';
  }

  return name.isNotEmpty ? name : 'Guest';
}

import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavouriteWholesalerService {
  final ConfigModel _configModel = locator<ConfigModel>();

  Future<List<Map<String, dynamic>>> getDiscounts(int userId) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    try {
      final response = await http.get(
        Uri.parse('${_apiConfig['baseURL']}/users/$userId/discounts'),
        headers: _apiConfig['headers'],
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
    } catch (e) {
      print('Error fetching discounts: $e');
    }
    return [];
  }
}

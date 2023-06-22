import 'package:flutter/foundation.dart';
import 'package:sales_app/core/models/product.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService {
  final ConfigModel _configModel = locator<ConfigModel>();

  List<Product> _products = [];
  getProducts() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/products?newArrivals=newArrivals'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _products = [];
      _responseData['data'].forEach((data) {
        _products.add(Product.fromJson(data));
      });
    }

    return _products;
  }

  List<dynamic>? categories;

  getCategories() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/categories?cityId=1'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      categories = _responseData['data'];
    }
    return categories;
  }

  List<Product> _categoryWiseproducts = [];

  getCategoryWiseProducts(categoryId) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/products?categoryId=$categoryId'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _categoryWiseproducts = [];
      _responseData['data'].forEach((data) {
        _categoryWiseproducts.add(Product.fromJson(data));
      });
    }

    return _categoryWiseproducts;
  }
}

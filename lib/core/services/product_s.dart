import 'package:aadab/core/models/product.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService {
  final ConfigModel _configModel = locator<ConfigModel>();

  List<Product> _products = [];
  getProducts() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/products?newArrivals=true'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    // print('New Arrivals');
    // print(_responseData);
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

  getCategoryWiseProducts(categoryId, search) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    http.Response _response = await http.get(
      Uri.parse(
          '${_apiConfig['baseURL']}/products?categoryId=$categoryId&searchAll=$search'),
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

  List<Product> _allProducts = [];

  getAllProducts({String? search}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    if (search == null) {
      search = '';
    } else {
      search = search;
    }
    print('Api hit for product list with $search');
    print(search);
    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/products?searchAll=$search'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    print(_responseData);
    if (_responseData['success']) {
      _allProducts = [];
      _responseData['data'].forEach((data) {
        _allProducts.add(Product.fromJson(data));
      });
    }

    return _allProducts;
  }

  Map<String, dynamic>? _banners;

  getBanners() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/settings/1'),
      headers: _apiConfig['headers'],
    );
    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _banners = _responseData['data'];
    }
    return _banners;
  }

  // Get product by ID with full details including packs
  Future<Product?> getProductById(int productId) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;
    try {
      http.Response _response = await http.get(
        Uri.parse('${_apiConfig['baseURL']}/products/$productId'),
        headers: _apiConfig['headers'],
      );

      if (_response.statusCode == 200) {
        Map<String, dynamic> _responseData = json.decode(_response.body);
        if (_responseData['success'] && _responseData['data'] != null) {
          return Product.fromJson(_responseData['data']);
        }
      }
    } catch (e) {
      print('Error fetching product by ID: $e');
    }
    return null;
  }
}

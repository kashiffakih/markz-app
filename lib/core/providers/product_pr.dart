import 'package:flutter/material.dart';
import 'package:aadab/core/models/product.dart';
import 'package:aadab/core/services/product_s.dart';
import 'package:aadab/locator.dart';

class ProductModel with ChangeNotifier {
  final ProductService _productService = locator<ProductService>();

  // Product loader
  bool productsLoader = true;
  bool categoryWiseproductsLoader = true;

  // List of products
  List<Product>? _products;

  set products(List<Product>? newProduct) {
    _products = newProduct;
    productsLoader = false;
    notifyListeners();
  }

  List<Product>? get products => _products;

  getProduct() async {
    products = await _productService.getProducts();
  }

  List<dynamic>? categories = [];
  getCategories() async {
    categories = await _productService.getCategories();
    notifyListeners();
  }

// List of products
  List<Product>? _categoryWiseproducts;

  set categoryWiseproducts(List<Product>? newProduct) {
    _categoryWiseproducts = newProduct;
    categoryWiseproductsLoader = false;
    notifyListeners();
  }

  List<Product>? get categoryWiseproducts => _categoryWiseproducts;

  getCategoryWiseProduct(categoryId, search) async {
    categoryWiseproducts = [];
    categoryWiseproducts =
        await _productService.getCategoryWiseProducts(categoryId, search);
  }

// List of products
  List<Product>? _allProducts;

  set allProducts(List<Product>? newProduct) {
    _allProducts = newProduct;
    productsLoader = false;
    notifyListeners();
  }

  List<Product>? get allProducts => _allProducts;
  getAllProducts(String? search) async {
    allProducts = await _productService.getAllProducts(search: search);
  }

// List of products
  Map<String, dynamic>? _banners;

  set banners(Map<String, dynamic>? newProduct) {
    _banners = newProduct;
    productsLoader = false;
    notifyListeners();
  }

  Map<String, dynamic>? get banners => _banners;
  getBanners() async {
    banners = await _productService.getBanners();
  }

  List<Tags>? _tags;
  set tags(List<Tags>? newTags) {
    _tags = newTags;
    notifyListeners();
  }

  List<Tags>? get tags => _tags;

  getTags() async {
    tags = await _productService.getTags();
  }

  List<Product>? _randomProducts;
  set randomProducts(List<Product>? newProducts) {
    _randomProducts = newProducts;
    notifyListeners();
  }

  List<Product>? get randomProducts => _randomProducts;

  getRandomProducts() async {
    randomProducts = await _productService.getRandomProducts();
    // print("random ${randomProducts![0].productPrices![0].toJson()}");
  }
}

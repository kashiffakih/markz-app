import 'package:flutter/material.dart';
import 'package:sales_app/core/models/product.dart';
import 'package:sales_app/core/services/product_s.dart';
import 'package:sales_app/locator.dart';

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

  getCategoryWiseProduct(categoryId) async {
    categoryWiseproducts =
        await _productService.getCategoryWiseProducts(categoryId);
  }
}

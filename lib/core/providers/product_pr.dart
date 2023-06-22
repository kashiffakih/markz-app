import 'package:flutter/material.dart';
import 'package:sales_app/core/models/product.dart';
import 'package:sales_app/core/services/product_s.dart';
import 'package:sales_app/locator.dart';

class ProductModel with ChangeNotifier {
  final ProductService _productService = locator<ProductService>();

  // Product loader
  bool productsLoader = true;

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
}

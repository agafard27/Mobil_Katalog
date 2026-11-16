import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

class CatalogRepository {
  const CatalogRepository();

  Future<List<Product>> loadProducts() async {
    final source = await rootBundle.loadString('assets/data/products.json');
    final items = jsonDecode(source) as List<dynamic>;
    return items
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

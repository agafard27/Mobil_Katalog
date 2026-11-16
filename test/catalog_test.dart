import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/state/cart_controller.dart';
import 'package:mini_katalog/utils/catalog_filter.dart';

void main() {
  final products =
      (jsonDecode(File('assets/data/products.json').readAsStringSync()) as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

  test('20 benzersiz ürün, yerel görseller ve JSON dönüşümü', () {
    expect(products.length, 20);
    expect(products.map((p) => p.id).toSet().length, 20);
    for (final product in products) {
      expect(File(product.image).existsSync(), isTrue);
      expect(product.price, greaterThan(0));
      expect(Product.fromJson(product.toJson()).toJson(), product.toJson());
    }
  });

  test('arama, kategori ve sıralama birlikte çalışır', () {
    expect(
      filterProducts(products, query: '  iphone ', category: 'Telefon').length,
      5,
    );
    expect(filterProducts(products, query: 'olmayan ürün'), isEmpty);
    expect(filterProducts(products, query: 'BİLGİSAYAR').length, 5);
    final sorted = filterProducts(
      products,
      category: 'Ses',
      sort: CatalogSort.priceLow,
    );
    expect(sorted.first.name, 'HomePod Mini');
    expect(
      filterProducts(products, sort: CatalogSort.priceHigh).first.name,
      'Apple Vision Pro',
    );
  });

  test('sepet adet, toplam, son adet silme ve temizleme', () {
    final cart = CartController();
    addTearDown(cart.dispose);
    var changes = 0;
    cart.addListener(() => changes++);
    cart.add(products.first);
    cart.add(products.first);
    cart.add(products.last);
    expect(cart.count, 3);
    expect(cart.lines.length, 2);
    expect(cart.total, products.first.price * 2 + products.last.price);
    cart.decrease(products.first);
    expect(cart.lines.first.quantity, 1);
    cart.decrease(products.first);
    expect(cart.lines.length, 1);
    cart.remove(products.last);
    expect(cart.count, 0);
    expect(cart.total, 0);
    cart.add(products.first);
    cart.clear();
    expect(cart.lines, isEmpty);
    expect(changes, 8);
  });

  test('USD tutarı Türkçe sayı biçimiyle gösterilir', () {
    expect(formatPrice(2499), '\$2.499,00');
    expect(formatPrice(99.5), '\$99,50');
  });
}

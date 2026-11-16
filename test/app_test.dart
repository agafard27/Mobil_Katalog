// Yönerge, SDK içindeki material.dart kullanımını ve ek paketsiz çözümü ister.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/app.dart';
import 'dart:convert';
import 'dart:io';
import 'package:mini_katalog/models/product.dart';

void main() {
  final products =
      (jsonDecode(File('assets/data/products.json').readAsStringSync()) as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
  Future<List<Product>> loadProducts() async => products;
  testWidgets('katalogdan detay, sepete ekleme, geri dönüş ve demo onayı', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MiniKatalogApp(loadProducts: loadProducts));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Katalog'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('catalog-search')),
      'HomePod Mini',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('HomePod Mini').last);
    await tester.pumpAndSettle();
    expect(find.text('Yakından keşfet'), findsOneWidget);
    await tester.tap(find.byKey(const Key('add-to-cart')));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Sepetim'));
    await tester.pumpAndSettle();
    expect(find.text('Sepetim (1)'), findsOneWidget);
    await tester.tap(find.byTooltip('HomePod Mini adedi artır'));
    await tester.pumpAndSettle();
    expect(find.text('Sepetim (2)'), findsOneWidget);
    expect(find.text('\$198,00'), findsNWidgets(2));
    await tester.tap(find.byKey(const Key('checkout')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();
    expect(find.text('Sepetim (2)'), findsOneWidget);
    await tester.tap(find.byKey(const Key('checkout')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simülasyonu tamamla'));
    await tester.pumpAndSettle();
    expect(find.text('Güzel şeylere yer var.'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Yakından keşfet'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('catalog-search')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('boş arama sonucu, filtre sıfırlama ve liste görünümü', (
    tester,
  ) async {
    await tester.pumpWidget(MiniKatalogApp(loadProducts: loadProducts));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Katalog'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('catalog-search')), 'xyz123');
    await tester.pumpAndSettle();
    expect(find.text('Aradığını bulamadık'), findsOneWidget);
    await tester.ensureVisible(find.text('Filtreleri temizle'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Filtreleri temizle'));
    await tester.pumpAndSettle();
    expect(find.text('20 ürün'), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('Liste görünümü'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Liste görünümü'));
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

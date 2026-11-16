import '../models/product.dart';

enum CatalogSort { recommended, priceLow, priceHigh, name }

String normalizeSearch(String value) =>
    value.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();

List<Product> filterProducts(
  List<Product> products, {
  String query = '',
  String category = 'Tümü',
  CatalogSort sort = CatalogSort.recommended,
}) {
  final search = normalizeSearch(query.trim());
  final result = products
      .where(
        (product) =>
            (category == 'Tümü' || product.category == category) &&
            normalizeSearch(
              '${product.name} ${product.category} ${product.tagline}',
            ).contains(search),
      )
      .toList();
  switch (sort) {
    case CatalogSort.recommended:
      result.sort(
        (a, b) => (b.featured ? 1 : 0).compareTo(a.featured ? 1 : 0) != 0
            ? (b.featured ? 1 : 0).compareTo(a.featured ? 1 : 0)
            : a.id.compareTo(b.id),
      );
    case CatalogSort.priceLow:
      result.sort((a, b) => a.price.compareTo(b.price));
    case CatalogSort.priceHigh:
      result.sort((a, b) => b.price.compareTo(a.price));
    case CatalogSort.name:
      result.sort((a, b) => a.name.compareTo(b.name));
  }
  return result;
}

String formatPrice(double amount) {
  final parts = amount.toStringAsFixed(2).split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return '\$$whole,${parts[1]}';
}

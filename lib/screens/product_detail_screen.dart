// Yönerge, SDK içindeki material.dart kullanımını ve ek paketsiz çözümü ister.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/cart_controller.dart';
import '../theme/app_theme.dart';
import '../utils/catalog_filter.dart';
import '../widgets/catalog_widgets.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.cart,
  });
  final Product product;
  final CartController cart;

  String _specLabel(String key) =>
      const {
        'chip': 'İşlemci',
        'material': 'Malzeme',
        'camera': 'Kamera',
        'display': 'Ekran',
        'storage': 'Depolama',
        'battery': 'Pil',
        'audio': 'Ses',
        'size': 'Boyut',
        'weight': 'Ağırlık',
        'connectivity': 'Bağlantı',
        'color': 'Renk',
        'features': 'Özellikler',
        'water_resistance': 'Suya dayanıklılık',
        'charging': 'Şarj',
      }[key] ??
      key.replaceAll('_', ' ');

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Yakından keşfet'),
      actions: [CartButton(cart: cart)],
    ),
    body: ContentWidth(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Container(
            height: 300,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFFE9EDE2),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Hero(
              tag: 'product-${product.id}',
              child: ProductImage(product: product),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            product.category.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 2,
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(
            product.tagline,
            style: const TextStyle(fontSize: 15, color: Color(0xFF68786D)),
          ),
          const SizedBox(height: 16),
          Text(
            formatPrice(product.price),
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'USD · Demo katalog fiyatı',
            style: TextStyle(fontSize: 11, color: Color(0xFF68786D)),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 14),
          Text(
            'Küçük detaylar, büyük farklar.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Text(
            'Teknik özellikler',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          ...product.specs.entries.map(
            (entry) => Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE1E5DD))),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      _specLabel(entry.key),
                      style: const TextStyle(color: Color(0xFF68786D)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        color: paper,
        child: ContentWidth(
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              key: const Key('add-to-cart'),
              onPressed: () => addToCart(context, cart, product),
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Sepete ekle'),
            ),
          ),
        ),
      ),
    ),
  );
}

// Yönerge, SDK içindeki material.dart kullanımını ve ek paketsiz çözümü ister.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/cart_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/catalog_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.products, required this.cart});
  final List<Product> products;
  final CartController cart;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.widgets_rounded, color: accent),
          SizedBox(width: 10),
          Text(
            'mini katalog',
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.7),
          ),
        ],
      ),
      actions: [CartButton(cart: cart)],
    ),
    body: ContentWidth(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          const Text(
            'AZ ŞEY. ÇOK İLHAM.',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 2.4,
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Gününe iyi gelen\nteknolojiyi keşfet.',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          const Text(
            'İşine, keyfine ve hayatına eşlik edecek\nseçili ürünler, tek bir yerde.',
            style: TextStyle(color: Color(0xFF68786D), height: 1.6),
          ),
          const SizedBox(height: 24),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFFE1EAD7),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 2118 / 474,
                  child: Image.asset(
                    'assets/images/banner.png',
                    fit: BoxFit.cover,
                    semanticLabel: 'Katalog koleksiyonu',
                    errorBuilder: (context, error, stack) => const Center(
                      child: Icon(Icons.auto_awesome, size: 52, color: accent),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'KÜÇÜK BİR KEŞİF MOLASI',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700,
                          color: accent,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Yeni favorin burada.',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/catalog'),
                        label: const Text('Koleksiyonu keşfet'),
                        icon: const Icon(Icons.arrow_forward, size: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Sana ilham olsun',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/catalog'),
                child: const Text('Tümünü gör'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ProductGrid(
            products: products
                .where((product) => product.featured)
                .take(4)
                .toList(),
            cart: cart,
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school_outlined, size: 16, color: Color(0xFF68786D)),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Öğrenmek için tasarlandı. Keşfetmek için hazır.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF68786D)),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (index) {
        if (index == 1) Navigator.pushNamed(context, '/catalog');
        if (index == 2) Navigator.pushNamed(context, '/cart');
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: 'Keşfet',
        ),
        NavigationDestination(
          icon: Icon(Icons.grid_view_outlined),
          label: 'Katalog',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'Sepetim',
        ),
      ],
    ),
  );
}

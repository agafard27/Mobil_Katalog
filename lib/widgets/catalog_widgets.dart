// Yönerge, SDK içindeki material.dart kullanımını ve ek paketsiz çözümü ister.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/cart_controller.dart';
import '../theme/app_theme.dart';
import '../utils/catalog_filter.dart';

class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    heightFactor: 1,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1080),
      child: child,
    ),
  );
}

class CartButton extends StatelessWidget {
  const CartButton({super.key, required this.cart});
  final CartController cart;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: cart,
    builder: (context, _) => Padding(
      padding: const EdgeInsets.only(right: 12),
      child: IconButton(
        tooltip: 'Sepetim',
        onPressed: () => Navigator.pushNamed(context, '/cart'),
        icon: Badge(
          isLabelVisible: cart.count > 0,
          label: Text('${cart.count}'),
          backgroundColor: accent,
          child: const Icon(Icons.shopping_bag_outlined),
        ),
      ),
    ),
  );
}

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.product, this.height});
  final Product product;
  final double? height;
  @override
  Widget build(BuildContext context) => Image.asset(
    product.image,
    height: height,
    width: double.infinity,
    fit: BoxFit.contain,
    semanticLabel: product.name,
    errorBuilder: (context, error, stack) => SizedBox(
      height: height ?? 120,
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined, size: 40),
      ),
    ),
  );
}

void addToCart(BuildContext context, CartController cart, Product product) {
  cart.add(product);
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${product.name} sepete eklendi.'),
      action: SnackBarAction(
        label: 'Sepeti aç',
        onPressed: () => Navigator.pushNamed(context, '/cart'),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.cart});
  final Product product;
  final CartController cart;
  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    elevation: 0,
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
      side: const BorderSide(color: Color(0xFFE7EAE2)),
    ),
    child: InkWell(
      onTap: () => Navigator.pushNamed(context, '/product', arguments: product),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F5EF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: 'product-${product.id}',
                child: ProductImage(product: product),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
            child: Text(
              product.category,
              style: const TextStyle(
                fontSize: 11,
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 3, 14, 0),
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                height: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 4, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    formatPrice(product.price),
                    style: const TextStyle(
                      fontSize: 13,
                      color: accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: '${product.name} sepete ekle',
                  onPressed: () => addToCart(context, cart, product),
                  icon: const Icon(Icons.add_circle, color: accent, size: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.products, required this.cart});
  final List<Product> products;
  final CartController cart;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 850
          ? 4
          : constraints.maxWidth >= 600
          ? 3
          : 2;
      final scale = MediaQuery.textScalerOf(context).scale(1);
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          mainAxisExtent: 264 + (scale > 1 ? (scale - 1) * 110 : 0),
        ),
        itemBuilder: (context, index) =>
            ProductCard(product: products[index], cart: cart),
      );
    },
  );
}

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });
  final IconData icon;
  final String title, message;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFFE6EDE2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 42, color: accent),
        ),
        const SizedBox(height: 22),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Text(message, textAlign: TextAlign.center),
        if (action != null) ...[const SizedBox(height: 24), action!],
      ],
    ),
  );
}

// Yönerge, SDK içindeki material.dart kullanımını ve ek paketsiz çözümü ister.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import '../state/cart_controller.dart';
import '../theme/app_theme.dart';
import '../utils/catalog_filter.dart';
import '../widgets/catalog_widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.cart});
  final CartController cart;

  Future<void> _checkout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Denemeyi tamamla'),
        content: Text(
          '${cart.count} ürün · ${formatPrice(cart.total)}\n\nBu bir eğitim simülasyonudur. Ödeme alınmaz ve gerçek sipariş oluşturulmaz. Onayladığında demo sepetin temizlenir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Simülasyonu tamamla'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    cart.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo tamamlandı. Gerçek sipariş oluşturulmadı.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: cart,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: Text('Sepetim${cart.count > 0 ? ' (${cart.count})' : ''}'),
      ),
      body: ContentWidth(
        child: cart.lines.isEmpty
            ? SingleChildScrollView(
                child: EmptyMessage(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Güzel şeylere yer var.',
                  message:
                      'Sepetin şu an boş.\nKoleksiyonda sana eşlik edecek bir şey bul.',
                  action: FilledButton.icon(
                    onPressed: () =>
                        Navigator.popAndPushNamed(context, '/catalog'),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Kataloğu keşfet'),
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  Text(
                    'Seçimlerin bir arada.',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Biraz teknoloji, biraz mutluluk.',
                    style: TextStyle(color: Color(0xFF68786D)),
                  ),
                  const SizedBox(height: 24),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.lines.length,
                    itemBuilder: (context, index) {
                      final line = cart.lines[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/product',
                                    arguments: line.product,
                                  ),
                                  child: Container(
                                    width: 72,
                                    height: 80,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F3EC),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ProductImage(product: line.product),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        line.product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        line.product.category,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF68786D),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        formatPrice(line.total),
                                        style: const TextStyle(
                                          color: accent,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  tooltip: '${line.product.name} kaldır',
                                  onPressed: () => cart.remove(line.product),
                                  icon: const Icon(Icons.close, size: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  tooltip: '${line.product.name} adedi azalt',
                                  onPressed: () => cart.decrease(line.product),
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Semantics(
                                  label: 'Adet: ${line.quantity}',
                                  child: Text(
                                    '${line.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: '${line.product.name} adedi artır',
                                  onPressed: () => cart.add(line.product),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6EDE2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, size: 18, color: accent),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Bu sepet bir eğitim simülasyonudur. Ödeme alınmaz. Ürünler uygulama kapatılana kadar saklanır.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: cart.lines.isEmpty
          ? null
          : SafeArea(
              top: false,
              child: ContentWidth(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Toplam (USD)'),
                          Text(
                            formatPrice(cart.total),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: ink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          key: const Key('checkout'),
                          onPressed: () => _checkout(context),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Demo alışverişi tamamla'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    ),
  );
}

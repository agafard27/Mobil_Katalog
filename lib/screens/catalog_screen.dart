// Yönerge, SDK içindeki material.dart kullanımını ve ek paketsiz çözümü ister.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/cart_controller.dart';
import '../theme/app_theme.dart';
import '../utils/catalog_filter.dart';
import '../widgets/catalog_widgets.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key, required this.products, required this.cart});
  final List<Product> products;
  final CartController cart;
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _search = TextEditingController();
  String _category = 'Tümü';
  CatalogSort _sort = CatalogSort.recommended;
  bool _listView = false;
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reset() => setState(() {
    _search.clear();
    _category = 'Tümü';
    _sort = CatalogSort.recommended;
  });

  @override
  Widget build(BuildContext context) {
    final products = filterProducts(
      widget.products,
      query: _search.text,
      category: _category,
      sort: _sort,
    );
    final categories = [
      'Tümü',
      ...widget.products.map((product) => product.category).toSet(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksiyon'),
        actions: [CartButton(cart: widget.cart)],
      ),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Text(
              'Biraz merak,\nbir sürü seçenek.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 18),
            TextField(
              key: const Key('catalog-search'),
              controller: _search,
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Ürün veya kategori ara',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Aramayı temizle',
                        onPressed: () => setState(_search.clear),
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories
                    .map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: _category == category,
                          onSelected: (_) =>
                              setState(() => _category = category),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Text(
                  '${products.length} ürün',
                  style: const TextStyle(color: Color(0xFF68786D)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<CatalogSort>(
                      value: _sort,
                      underline: const SizedBox(),
                      style: const TextStyle(fontSize: 13, color: ink),
                      onChanged: (value) => setState(() => _sort = value!),
                      items: const [
                        DropdownMenuItem(
                          value: CatalogSort.recommended,
                          child: Text('Önerilenler'),
                        ),
                        DropdownMenuItem(
                          value: CatalogSort.priceLow,
                          child: Text('Fiyat: artan'),
                        ),
                        DropdownMenuItem(
                          value: CatalogSort.priceHigh,
                          child: Text('Fiyat: azalan'),
                        ),
                        DropdownMenuItem(
                          value: CatalogSort.name,
                          child: Text('Ürün adı: A–Z'),
                        ),
                      ],
                    ),
                    IconButton(
                      tooltip: _listView ? 'Izgara görünümü' : 'Liste görünümü',
                      onPressed: () => setState(() => _listView = !_listView),
                      icon: Icon(
                        _listView ? Icons.grid_view : Icons.view_list_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (products.isEmpty)
              EmptyMessage(
                icon: Icons.search_off,
                title: 'Aradığını bulamadık',
                message: 'Başka bir kelime dene veya filtreleri temizle.',
                action: FilledButton(
                  onPressed: _reset,
                  child: const Text('Filtreleri temizle'),
                ),
              )
            else if (!_listView)
              ProductGrid(products: products, cart: widget.cart)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: SizedBox(
                        width: 60,
                        child: ProductImage(product: product),
                      ),
                      title: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        '${product.category} · ${formatPrice(product.price)}',
                      ),
                      trailing: IconButton(
                        tooltip: '${product.name} sepete ekle',
                        onPressed: () =>
                            addToCart(context, widget.cart, product),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/product',
                        arguments: product,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

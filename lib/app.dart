// Yönerge, SDK içindeki material.dart kullanımını ve ek paketsiz çözümü ister.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'data/catalog_repository.dart';
import 'models/product.dart';
import 'screens/cart_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'state/cart_controller.dart';
import 'theme/app_theme.dart';
import 'widgets/catalog_widgets.dart';

class MiniKatalogApp extends StatefulWidget {
  const MiniKatalogApp({super.key, this.loadProducts});
  final Future<List<Product>> Function()? loadProducts;
  @override
  State<MiniKatalogApp> createState() => _MiniKatalogAppState();
}

class _MiniKatalogAppState extends State<MiniKatalogApp> {
  final _cart = CartController();
  late Future<List<Product>> _products;
  @override
  void initState() {
    super.initState();
    _products = _load();
  }

  Future<List<Product>> _load() =>
      widget.loadProducts?.call() ?? const CatalogRepository().loadProducts();

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  Route<dynamic> _route(RouteSettings settings, List<Product> products) {
    FocusManager.instance.primaryFocus?.unfocus();
    final Widget screen;
    switch (settings.name) {
      case '/':
        screen = HomeScreen(products: products, cart: _cart);
      case '/catalog':
        screen = CatalogScreen(products: products, cart: _cart);
      case '/cart':
        screen = CartScreen(cart: _cart);
      case '/product':
        final argument = settings.arguments;
        screen = argument is Product
            ? ProductDetailScreen(product: argument, cart: _cart)
            : const Scaffold(
                body: SafeArea(
                  child: EmptyMessage(
                    icon: Icons.error_outline,
                    title: 'Ürün bulunamadı',
                    message: 'Geri dönerek katalogdan bir ürün seçin.',
                  ),
                ),
              );
      default:
        screen = HomeScreen(products: products, cart: _cart);
    }
    return MaterialPageRoute<void>(settings: settings, builder: (_) => screen);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Product>>(
    future: _products,
    builder: (context, snapshot) => MaterialApp(
      title: 'Mini Katalog',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: snapshot.hasError
          ? Scaffold(
              body: Center(
                child: EmptyMessage(
                  icon: Icons.cloud_off_outlined,
                  title: 'Katalog yüklenemedi',
                  message:
                      'Yerel ürün verisi okunamadı. Yeniden deneyebilirsin.',
                  action: FilledButton(
                    onPressed: () => setState(() => _products = _load()),
                    child: const Text('Yeniden dene'),
                  ),
                ),
              ),
            )
          : snapshot.hasData
          ? HomeScreen(products: snapshot.data!, cart: _cart)
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
      // RouteSettings.arguments ürün detayına aynı tipli modeli taşır.
      onGenerateRoute: (settings) =>
          snapshot.hasData ? _route(settings, snapshot.data!) : null,
    ),
  );
}

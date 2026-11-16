import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartLine {
  const CartLine(this.product, this.quantity);
  final Product product;
  final int quantity;
  double get total => product.price * quantity;
}

// Uygulama oturumu boyunca paylaşılır; gerçek sipariş veya kalıcılık içermez.
class CartController extends ChangeNotifier {
  final Map<int, CartLine> _lines = {};
  List<CartLine> get lines => List.unmodifiable(_lines.values);
  int get count => _lines.values.fold(0, (sum, line) => sum + line.quantity);
  double get total => _lines.values.fold(0, (sum, line) => sum + line.total);

  void add(Product product) {
    final quantity = (_lines[product.id]?.quantity ?? 0) + 1;
    _lines[product.id] = CartLine(product, quantity);
    notifyListeners();
  }

  void decrease(Product product) {
    final line = _lines[product.id];
    if (line == null) return;
    if (line.quantity == 1) {
      _lines.remove(product.id);
    } else {
      _lines[product.id] = CartLine(product, line.quantity - 1);
    }
    notifyListeners();
  }

  void remove(Product product) {
    if (_lines.remove(product.id) != null) notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}

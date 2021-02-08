import 'package:flutter/foundation.dart';

import '../providers/product.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.product,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;

    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });

    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (existingItem) => CartItem(
        id: existingItem.id,
        product: existingItem.product,
        quantity: existingItem.quantity + 1,
      ));
    } else {
      _items.putIfAbsent(product.id, 
        () => CartItem(
          id: DateTime.now().toString(),
          product: product,
          quantity: 1
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

}
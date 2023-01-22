import 'package:flutter/widgets.dart';

class CartItem {
  final String id;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, CartItem> _items = {};

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingValue) => CartItem(
                id: existingValue.id,
                price: existingValue.price,
                quantity: existingValue.quantity + 1,
                title: existingValue.title,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                price: price,
                quantity: 1,
                title: title,
              ));
    }
  }

  Map<String, CartItem> get items {
    return {..._items};
  }
}

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
    notifyListeners();
  }

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, cartItem) { 
      total += cartItem.quantity * cartItem.price;
    });
    return total;
  }

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get totalItems {
    return _items.length;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if(!_items.containsKey(productId)) {
      return;
    }
    if(_items[productId]!.quantity > 1) {
      _items.update(productId, (existingProduct) => CartItem(
        id: existingProduct.id,
        price: existingProduct.price,
        quantity: existingProduct.quantity - 1,
        title: existingProduct.title,
      ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  //write a function to clear _items
  void clear() {
    _items = {};
    notifyListeners();
  }
  
}

import 'package:flutter/widgets.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  void toggleFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }

  bool isEmpty() {
    if(id.isEmpty || title.isEmpty || description.isEmpty || price.toString() == '' || imageUrl.isEmpty) {
      return true;
    }
    return false;
  }
}
